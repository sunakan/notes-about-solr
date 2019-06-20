class SolrApi::V1Controller < ApplicationController
  def select
    collection_name  = "ch08_solrcloud_cluster"
    collection_state = zk.get_collection_state(collection_name)
    puts "====================="
    pp collection_state
    puts "====================="
    render json: {a: "ok"}
  end

  private
  def zk
    require "solr"
    zookeeper_url = "zoo1:2181,zoo2:2181,zoo3:2181/solr"
    @@zk ||= Solr::Cloud::ZookeeperConnection.new(zookeeper_url: zookeeper_url)
  end
end
