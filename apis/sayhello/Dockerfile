FROM k8s.orb.local:30002/iknow/alpine:3

RUN apk update --no-cache && apk add --no-cache tzdata

ENV TZ=Asia/Shanghai

WORKDIR /app
COPY sayhello-api /app/sayhello-api
COPY etc /app/etc

EXPOSE 8888

CMD ["./sayhello-api", "-f", "etc/sayhello-api.yaml"]
