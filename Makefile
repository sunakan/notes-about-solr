DC  = sudo docker-compose

build:
	$(DC) build

clean: chown
	rm -rf tmp/*

# make bash
up: clean
	$(DC) up -d
	#$(DC) up -d --scale solr=2
	#$(DC) run --rm -p 8983:8983 solr bash -c "/opt/solr/bin/solr start -h 0.0.0.0 -force && bash"

start-solr:
	${SOLR}/server/scripts/cloud-scripts/zkcli.sh -zkhost zoo1:2181 -cmd makepath /solr
	${SOLR}/server/scripts/cloud-scripts/zkcli.sh -zkhost zoo2:2181 -cmd makepath /solr
	${SOLR}/server/scripts/cloud-scripts/zkcli.sh -zkhost zoo3:2181 -cmd makepath /solr
	${SOLR}/bin/solr start -h 0.0.0.0 -p 8983 -d ${SOLR}/server -z zoo1:2181/solr,zoo2:2181/solr,zoo3:2181/solr -s ${SOLR}/server/solr_8_5_node
#	cp -rf ${SOLR}/server/solr_8_5_node ${SOLR}/server/solr_8_5_node_1
#	cp -rf ${SOLR}/server/solr_8_5_node ${SOLR}/server/solr_8_5_node_2
#	cp -rf ${SOLR}/server/solr_8_5_node ${SOLR}/server/solr_8_5_node_3
#	cp -rf ${SOLR}/server/solr_8_5_node ${SOLR}/server/solr_8_5_node_4
#	${SOLR}/bin/solr start -h 0.0.0.0 -p 8985 -d ${SOLR}/server -z zk1:2181/solr -s ${SOLR}/server/solr_8_5_node_2
#	${SOLR}/bin/solr start -h 0.0.0.0 -p 8987 -d ${SOLR}/server -z zk1:2181/solr -s ${SOLR}/server/solr_8_5_node_3
#	${SOLR}/bin/solr start -h 0.0.0.0 -p 8989 -d ${SOLR}/server -z zk1:2181/solr -s ${SOLR}/server/solr_8_5_node_4
#	${SOLR}/bin/solr start -h 0.0.0.0 -p 8983 -d ${SOLR}/server -z zk1:2181/solr -s ${SOLR}/server/solr_8_5_node
#	${SOLR}/bin/solr start -h 0.0.0.0 -p 8983 -d ${SOLR}/server -z zk1:2181/solr,zk2:2181/solr,zk3:2181/solr -s ${SOLR}/server/solr_8_5_node

init-zk:
	${SOLR}/server/scripts/cloud-scripts/zkcli.sh -zkhost zk1:2181 -cmd makepath /solr
#	${SOLR}/server/scripts/cloud-scripts/zkcli.sh -zkhost zk2:2181 -cmd makepath /solr
#	${SOLR}/server/scripts/cloud-scripts/zkcli.sh -zkhost zk3:2181 -cmd makepath /solr
#	${SOLR}/server/scripts/cloud-scripts/zkcli.sh -zkhost zk1:2181/solr -cmd upconfig -confdir /home/solr/conf -confname ch08_solrcloud_configs
#	${SOLR}/server/scripts/cloud-scripts/zkcli.sh -zkhost zk2:2181/solr -cmd upconfig -confdir /home/solr/conf -confname ch08_solrcloud_configs
#	${SOLR}/server/scripts/cloud-scripts/zkcli.sh -zkhost zk3:2181/solr -cmd upconfig -confdir /home/solr/conf -confname ch08_solrcloud_configs

index-1:
	${SOLR}/bin/post -host 0.0.0.0 -p 8983 -c ch08_solrcloud_cluster ${SOLR}/example/exampledocs/[a-m]*.xml

down:
	$(DC) down

chown:
	sudo chown -R ${USER}:${USER} .
