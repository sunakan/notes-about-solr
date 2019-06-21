# frozen_string_literal: true

require 'zk'
require 'solr'

zookeeper_url = 'zoo1:2181,zoo2:2181,zoo3:2181/solr'

collection_name = 'ch08_solrcloud_cluster'

puts '====='
p zk_connection    = Solr::Cloud::ZookeeperConnection.new(zookeeper_url: zookeeper_url)
p collection_state = zk_connection.get_collection_state(collection_name)
puts '====='

puts '=========='
zk_connection.watch_collection_state(collection_name) do |state|
  p state['shards']['shard1']['replicas'].values.select { |v| v['leader'] }.first['base_url']
end
puts '=========='

# 謎
# ZKのインスタンスに対してregisterしてる
# RubyのZKについて学ぶ必要があるかどうか、一旦NativeJavaの方も見てみる

# p collection_state_manager = Solr::Cloud::CollectionsStateManager
