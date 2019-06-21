# frozen_string_literal: true

require 'solr'
Solr.configure do |config|
  config.zookeeper_url = 'zoo1:2181,zoo2:2181,zoo3:2181/solr'
end
collection_name = 'ch08_solrcloud_cluster'
Solr.configuration.cloud_configuration.enable_solr_cloud!([collection_name])
