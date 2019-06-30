# frozen_string_literal: true

class SolrApi::V1Controller < ApplicationController
  def select
    puts "======zookeeper"
    p target_node
    p get_zookeeper.watcher
    puts "======zk"
    url        = "#{target_node}/#{collection_name}/select"
    solr_query = params.permit!.to_h.except(:action, :controller)
    response   = JSON.parse(Faraday.get(url, solr_query).body)
    render json: response
  end

  private

  def target_node
    nodes       = Solr.active_nodes_for(collection: collection_name)
    shards      = Solr.shards_for(collection: collection_name)
    leaders     = shards.map { |shard| Solr.leader_replica_node_for(collection: collection_name, shard: shard) }
    non_leaders = nodes.select { |node| leaders.exclude?(node) }
    target_node = non_leaders.sample || leaders.sample
  end

  def get_zookeeper
    Solr.configuration.cloud_configuration.collections_state_manager.zookeeper.zookeeper_connection
  end

  def collection_name
    ENV['COLLECTION_NAME']
  end
end
