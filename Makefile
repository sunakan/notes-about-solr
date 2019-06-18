DC  = docker-compose

build:
	$(DC) build

bash-solr1:
	docker exec -it `docker-compose ps -q solr1` bash
bash-solr2:
	docker exec -it `docker-compose ps -q solr2` bash

bash-zoo1:
	docker exec -it `docker-compose ps -q zoo1` bash
bash-zoo2:
	docker exec -it `docker-compose ps -q zoo2` bash
bash-zoo3:
	docker exec -it `docker-compose ps -q zoo3` bash

up: clean
	$(DC) up -d
	#$(DC) run --rm -p 8983:8983 solr bash -c "/opt/solr/bin/solr start -h 0.0.0.0 -force && bash"

start-solr:
	${SOLR}/bin/solr start -cloud -h `hostname` -p 8983 -d ${SOLR}/server -z zoo1:2181,zoo2:2181,zoo3:2181/solr -s ${SOLR}/server/solr_8_5_node -force

stop-solr:
	${SOLR}/bin/solr stop -all

init-zoo:
	${SOLR}/bin/solr zk mkroot /solr -z zoo1:2181,zoo2:2181,zoo3:2181

upconfig:
	chmod +x ${SOLR}/server/scripts/cloud-scripts/zkcli.sh
	${SOLR}/server/scripts/cloud-scripts/zkcli.sh -zkhost zoo1:2181,zoo2:2181,zoo3:2181/solr -cmd upconfig -confdir /home/solr/conf -confname ch08_solrcloud_configs

index-1:
	${SOLR}/bin/post -host solr1 -p 8983 -c ch08_solrcloud_cluster ${SOLR}/example/exampledocs/[a-m]*.xml

down:
	$(DC) down

chown:
	sudo chown -R ${USER}:${USER} .

clean: chown
	rm -rf tmp/*

search-1:
	curl -s "http://localhost:8983/solr/ch08_solrcloud_cluster/select?q=*:*&shards.info=true&indent=true&wt=json" | jq -r ".response.numFound"
search-2:
	curl -s "http://localhost:8984/solr/ch08_solrcloud_cluster/select?q=*:*&shards.info=true&indent=true&wt=json" | jq -r ".response.numFound"

create-collection:
	${SOLR}/bin/solr create -c ch08_solrcloud_cluster -n ch08_solrcloud_configs -d /home/solr/conf -shards 1 -replicationFactor 2 -force
	#${SOLR}/bin/solr create -c ch08_solrcloud_cluster -n ch08_solrcloud_configs -shards 1 -replicationFactor 2 -force

delete-collection:
	${SOLR}/bin/solr delete -c ch08_solrcloud_cluster
