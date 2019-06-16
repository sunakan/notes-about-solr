DC  = sudo docker-compose

build:
	$(DC) build

# make bash
bash:
	$(DC) run --rm -p 8983:8983 node-1 bash
	#$(DC) run --rm -p 8983:8983 solr bash -c "/opt/solr/bin/solr start -h 0.0.0.0 -force && bash"

down:
	$(DC) down

chown:
	sudo chown -R ${USER}:${USER} .
