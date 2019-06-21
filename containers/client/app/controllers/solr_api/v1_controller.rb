# frozen_string_literal: true

class SolrApi::V1Controller < ApplicationController
  def select
    url        = "#{target_node}/ch08_solrcloud_cluster/select"
    solr_query = params.permit!.to_h.except(:action, :controller)
    response = JSON.parse(Faraday.get(url, solr_query).body)
    render json: response
  end

  private

  def target_node
    collection_name = 'ch08_solrcloud_cluster'
    nodes       = Solr.active_nodes_for(collection: collection_name)
    shards      = Solr.shards_for(collection: collection_name)
    leaders     = shards.map { |shard| Solr.leader_replica_node_for(collection: collection_name, shard: shard) }
    non_leaders = nodes.select { |node| leaders.exclude?(node) }
    target_node = non_leaders.sample || leaders.sample
  end
end
