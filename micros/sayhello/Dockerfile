FROM k8s.orb.local:30002/iknow/alpine:3

RUN apk update --no-cache && apk add --no-cache tzdata

ENV TZ=Asia/Shanghai

WORKDIR /app
COPY sayhello-rpc /app/sayhello-rpc
COPY etc /app/etc

EXPOSE 8080

CMD ["./sayhello-rpc", "-f", "etc/sayhello.yaml"]
