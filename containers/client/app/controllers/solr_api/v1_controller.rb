# frozen_string_literal: true

class SolrApi::V1Controller < ApplicationController
  def select
    url        = "#{target_node}/#{collection_name}/select"
    puts url
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

  def collection_name
    ENV['COLLECTION_NAME']
  end
end
