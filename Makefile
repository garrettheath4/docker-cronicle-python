prepare:
	mkdir $$HOME/.cronicle

build:
	docker buildx create --use --name builder || true
	docker buildx build \
	  --platform linux/amd64 \
	  -t garrettheath4/cronicle-python:latest \
	  -t garrettheath4/cronicle-python:1.13.5-py3 \
	  --push .

push:
	docker push --all-tags garrettheath4/cronicle-python

run:
	docker run \
		-v /etc/localtime:/etc/localtime:ro \
		-v /etc/timezone:/etc/timezone:ro \
		-v $$HOME/.cronicle/data:/opt/cronicle/data:rw \
		-v $$HOME/.cronicle/logs:/opt/cronicle/logs:rw \
		-v $$HOME/.cronicle/plugins:/opt/cronicle/plugins:rw \
		-v $$HOME/.cronicle/scripts:/opt/cronicle/scripts:rw \
		-p 3012:3012 \
		-d \
		--restart unless-stopped \
		--name cronicle \
		cronicle-python
