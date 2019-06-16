FROM solr:6.6.6-slim
USER "root"

RUN apt-get update \
  && apt-get install -y tree vim wget jq make
