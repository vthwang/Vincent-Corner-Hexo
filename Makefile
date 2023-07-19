TAG=$(shell git rev-parse --short ${GITHUB_SHA})
IMAGE = fishboneapps/hexo-vincent-corner

update:
	git add .
	git commit -s -m "Site Updated: $(shell date +"%Y-%m-%d %T")"
	git push

build:
	docker buildx build --platform linux/amd64 -f Dockerfile -t $(IMAGE) .

tag: build
	docker tag $(IMAGE) $(IMAGE):$(TAG)

push: tag
	docker push $(IMAGE):latest
	docker push $(IMAGE):$(TAG)

deploy:
	helm upgrade hexo-vincent-corner ./hexo-blog --set image=$(IMAGE),tag=$(TAG) --install --atomic
