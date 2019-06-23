# frozen_string_literal: true
require 'solr'

if ENV['ZOOKEEPER_URL'] && ENV['COLLECTION_NAME']
  Solr.configure do |config|
    config.zookeeper_url = ENV['ZOOKEEPER_URL']
  end
  collection_name = ENV['COLLECTION_NAME']
  Solr.configuration.cloud_configuration.enable_solr_cloud!([collection_name])
end
