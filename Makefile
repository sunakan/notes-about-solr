DC  = sudo docker-compose

build:
	@$(DC) build

# make bash
bash:
	@$(DC) run --rm -p 8983:8983 solr bash

chown:
	sudo chown -R ${USER}:${USER} .
