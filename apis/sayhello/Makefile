ImageName=k8s.orb.local:30002/iknow/sayhello-api
STABLE_VERSION := v1.0.0  # 固定版本号
BUILD_TIME := $(shell date +%Y%m%d%H%M%S)  # 构建时间戳

build-bin:
	@GOOS=linux GOARCH=amd64 go build -o sayhello-api sayhello.go

build-image: build-bin
	@docker build -t $(ImageName):$(STABLE_VERSION) -t $(ImageName):$(BUILD_TIME) .

push-image: build-image
	@docker push $(ImageName):$(STABLE_VERSION)
	@docker push $(ImageName):$(BUILD_TIME)

deploy: push-image
	@helm upgrade --install sayhello-api --namespace iknow --create-namespace \
	  ../../devops/helms/sayhello-api \
	  --set image.repository=$(ImageName) \
	  --set image.tag=$(STABLE_VERSION)

undeploy:
	@helm uninstall sayhello-api --namespace iknow
