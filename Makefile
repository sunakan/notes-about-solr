DC  = docker-compose

build:
	$(DC) build

bash-client:
	docker-compose run --rm -p 3001:3000 client bash

bash-solr1:
	docker exec -it `docker-compose ps -q solr1` bash
bash-solr2:
	docker exec -it `docker-compose ps -q solr2` bash
bash-solr3:
	docker exec -it `docker-compose ps -q solr3` bash
bash-solr4:
	docker exec -it `docker-compose ps -q solr4` bash

bash-zoo1:
	docker exec -it `docker-compose ps -q zoo1` bash
bash-zoo2:
	docker exec -it `docker-compose ps -q zoo2` bash
bash-zoo3:
	docker exec -it `docker-compose ps -q zoo3` bash

bash-solr-single:
	docker exec -it `docker-compose -f docker-compose.single.yml ps -q solr_single` bash

up:
	$(DC) up -d solr1
	#$(DC) run --rm -p 8983:8983 solr bash -c "/opt/solr/bin/solr start -h 0.0.0.0 -force && bash"

up-single: clean
	$(DC) -f docker-compose.single.yml up -d solr_single

start-solr:
	/opt/solr/bin/solr start -cloud -h `hostname` -p 8983 -d /opt/solr/server -z zoo1:2181,zoo2:2181,zoo3:2181/solr -s /opt/solr/server/solr_8_5_node -force

stop-solr:
	${SOLR}/bin/solr stop -all

init-zoo:
	/opt/solr/bin/solr zk mkroot /solr -z zoo1:2181,zoo2:2181,zoo3:2181

upconfig:
	chmod +x /opt/solr/server/scripts/cloud-scripts/zkcli.sh
	/opt/solr/server/scripts/cloud-scripts/zkcli.sh -zkhost zoo1:2181,zoo2:2181,zoo3:2181/solr -cmd upconfig -confdir /home/solr/conf -confname ch08_solrcloud_configs

index-1:
	/opt/solr/bin/post -host solr1 -p 8983 -c ch08_solrcloud_cluster /opt/solr/example/exampledocs/[a-m]*.xml

down:
	$(DC) down
	$(DC) -f docker-compose.single.yml down

chown:
	sudo chown -R ${USER}:${USER} .

clean: chown
	rm -rf tmp/*

search-1:
	curl -s "http://localhost:8983/solr/ch08_solrcloud_cluster/select?q=*:*&shards.info=true&indent=true&wt=json" | jq -r ".response.numFound"
search-2:
	curl -s "http://localhost:8984/solr/ch08_solrcloud_cluster/select?q=*:*&shards.info=true&indent=true&wt=json" | jq -r ".response.numFound"

create-collection:
	/opt/solr/bin/solr create -c ch08_solrcloud_cluster -n ch08_solrcloud_configs -d /home/solr/conf -shards 1 -replicationFactor 2 -force

delete-collection:
	/opt/solr/bin/solr delete -c ch08_solrcloud_cluster

zoo:
	docker-compose up -d zoo1
