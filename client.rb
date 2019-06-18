require "zk"
require "rsolr/cloud"

zoopeepers = [
  "zoo1:2181",
  "zoo2:2181",
  "zoo3:2181",
]

zk = ZK.new(zookeepers.join(","))
cloud_connection = RSolr::Cloud::Connection.new(zk)
solr_client  = RSolr::Client.new(cloud_connection)

# 必ずcollectionを指定する必要あり
response = solr_client.get("select", collection: "collection1", params: {q: "*:*"})
puts "==="
p response
puts "==="
