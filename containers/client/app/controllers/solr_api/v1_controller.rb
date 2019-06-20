class SolrApi::V1Controller < ApplicationController
# Solr::Cloud::HelperMethods
# - cloud_active_nodes_for
# - leader_replica_node_for
# - shards_for
# - cloud_enabled?
# - enable_solr_cloud?
# - enable_solr_cloud!

  def select
    collection_name  = "ch08_solrcloud_cluster"
    #collection_state = Solr.get_collection_state(collection_name)
    puts "====================="
    pp Solr.cloud_enabled?
    puts "====================="
    pp Solr.configuration.cloud_configuration
    puts "====================="
    render json: {a: "ok"}
  end

#  private
#  def zk
#    require "solr"
#    zookeeper_url = "zoo1:2181,zoo2:2181,zoo3:2181/solr"
#    @@zk ||= Solr::Cloud::ZookeeperConnection.new(zookeeper_url: zookeeper_url)
#  end
end
