require "solr"
config = Solr.configure do |config|
  config.zookeeper_url = ["zoo1:2181", "zoo2:2181", "zoo3:2181"]
end

puts "=========================================="
p config
puts "=========================================="
#collections = ["ch08_solrcloud_cluster"]
#Solr.enable_solr_cloud!(collections: collections)
