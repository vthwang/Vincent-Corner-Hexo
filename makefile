update:
	git add .
	git commit -s -m "Site Updated: $(shell date +"%Y-%m-%d %T")"
	git push

TAG ?= $(shell git rev-parse --short ${GITHUB_SHA})$(and $(shell git status -s),latest)

docker-build:
	docker build -f Dockerfile -t $(IMAGE) .

docker-tag: docker-build
	docker tag $(IMAGE) $(IMAGE):${TAG}

docker-push: docker-tag
	docker push $(IMAGE):latest
	docker push $(IMAGE):$(TAG)

deploy:
	helm upgrade vincent-corner-hexo ./hexo-blog --set tag=$(TAG) --install --atomic
