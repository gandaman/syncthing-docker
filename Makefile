default: 
	@echo "make [clean|build|run|logs|shell|kill]"

clean:
	@echo "docker rm syncthing"
	@docker rm syncthing 2>/dev/null || echo "Container removed already"
	@echo docker rmi gunnarx/my_syncthing:latest 
	@docker rmi gunnarx/my_syncthing:latest 2>/dev/null || echo "Image removed already"

build:
	docker build --tag=gunnarx/my_syncthing:latest .

run:
	docker run -d --name=syncthing gunnarx/my_syncthing:latest
	echo TODO set up persistent volume

logs:
	docker logs -f syncthing

shell:
	docker exec -it syncthing /bin/bash

kill:
	echo docker kill syncthing

