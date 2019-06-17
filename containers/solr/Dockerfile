FROM solr:6.6.6-slim

USER "root"
RUN apt-get update \
  && apt-get install -y tree vim wget jq make

ARG SOLR=/opt/solr
USER "solr"
COPY ./ch08/solr/server/solr ${SOLR}/server/solr_8_5_node
COPY ./configsets/ch08_solrcloud_configs/conf /home/solr/conf
