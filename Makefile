TAG=$(shell git rev-parse --short ${GITHUB_SHA})
IMAGE = fishboneapps/hexo-vincent-corner

update:
	git add .
	git commit -s -m "Site Updated: $(shell date +"%Y-%m-%d %T")"
	git push

docker-build:
	docker buildx build --platform linux/amd64 -f Dockerfile -t $(IMAGE) .

docker-tag: docker-build
	docker tag $(IMAGE) $(IMAGE):$(TAG)

docker-push: docker-tag
	docker push $(IMAGE):latest
	docker push $(IMAGE):$(TAG)

deploy:
	helm upgrade hexo-vincent-corner ./hexo-blog --set image=$(IMAGE),tag=$(TAG) --install --atomic
