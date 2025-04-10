
# etcd cluster
install-etcd-cluster:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	helm repo add bitnami https://charts.bitnami.com/bitnami && \
	helm repo update && \
	helm upgrade --install etcd --namespace etcd-cluster --create-namespace bitnami/etcd \
	  --set replicaCount=1 \
	  --set auth.rbac.enabled=true \
	  --set auth.rbac.rootPassword=root1234

uninstall-etcd-cluster:
	@helm uninstall etcd --namespace etcd-cluster

install-etcd-client:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	kubectl run etcd-client --restart='Never' --image docker.io/bitnami/etcd \
	  --env ROOT_PASSWORD=root1234 \
	  --env ETCDCTL_ENDPOINTS="etcd.etcd-cluster.svc.cluster.local:2379" \
	  --namespace etcd-cluster \
	  --command -- sleep infinity
	@echo "Pod已就绪，可以使用以下命令连接："
	@echo "kubectl exec -it etcd-client -n etcd-cluster -- bash"
	@echo "在Pod内部可以使用以下命令操作etcd："
	@echo "etcdctl --user root:root1234 put /message Hello"
	@echo "etcdctl --user root:root1234 get /message"

uninstall-etcd-client:
	@kubectl delete pod etcd-client --namespace etcd-cluster

install-etcd-ui:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	kubectl create deployment etcdkeeper --image=evildecay/etcdkeeper:latest --namespace etcd-cluster && \
	kubectl expose deployment etcdkeeper --port=8080 --namespace etcd-cluster
	@echo "etcdkeeper已部署，使用以下命令访问Web界面："
	@echo "kubectl port-forward svc/etcdkeeper 8080:8080 -n etcd-cluster"
	@echo "然后在浏览器中访问：http://localhost:8080"
	@echo "连接地址：http://etcd.etcd-cluster.svc.cluster.local:2379"
	@echo "用户名：root，密码：root1234"

uninstall-etcd-ui:
	@kubectl delete deployment etcdkeeper --namespace etcd-cluster
	@kubectl delete service etcdkeeper --namespace etcd-cluster

# mysql cluster
install-mysql-cluster:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	helm repo add bitnami https://charts.bitnami.com/bitnami && \
	helm repo update && \
	helm upgrade --install mysql --namespace mysql-cluster --create-namespace bitnami/mysql \
	  --set architecture=replication \
	  --set auth.rootPassword=root1234 \
	  --set auth.database=iknow \
	  --set secondary.replicaCount=1

uninstall-mysql-cluster:
	@helm uninstall mysql --namespace mysql-cluster

install-mysql-client:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	kubectl run mysql-client --restart='Never' --image docker.io/bitnami/mysql \
	  --env MYSQL_ROOT_PASSWORD=root1234 \
	  --namespace mysql-cluster \
	  --command -- sleep infinity
	@echo "Pod已就绪，可以使用以下命令连接："
	@echo "kubectl exec -it mysql-client -n mysql-cluster -- bash"
	@echo "在Pod内部可以使用以下命令连接MySQL："
	@echo "mysql -h mysql-primary -uroot -proot1234 iknow"
	@echo "或连接只读副本："
	@echo "mysql -h mysql-secondary -uroot -proot1234 iknow"

uninstall-mysql-client:
	@kubectl delete pod mysql-client --namespace mysql-cluster

install-mysql-ui:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	kubectl create deployment phpmyadmin --image=phpmyadmin/phpmyadmin:5 --namespace mysql-cluster && \
	kubectl set env deployment/phpmyadmin PMA_HOST=mysql-primary.mysql-cluster.svc.cluster.local PMA_PORT=3306 PMA_USER=root PMA_PASSWORD=root1234 --namespace mysql-cluster && \
	kubectl expose deployment phpmyadmin --port=80 --namespace mysql-cluster
	@echo "phpMyAdmin已部署，使用以下命令访问Web界面："
	@echo "kubectl port-forward svc/phpmyadmin 8081:80 -n mysql-cluster"
	@echo "然后在浏览器中访问：http://localhost:8081"
	@echo "用户名：root，密码：root1234"

uninstall-mysql-ui:
	@kubectl delete deployment phpmyadmin --namespace mysql-cluster
	@kubectl delete service phpmyadmin --namespace mysql-cluster

# redis cluster
install-redis-cluster:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	helm repo add bitnami https://charts.bitnami.com/bitnami && \
	helm repo update && \
	helm upgrade --install redis --namespace redis-cluster --create-namespace bitnami/redis:7 \
	  --set cluster.enabled=true \
	  --set auth.password=root1234 \
	  --set cluster.slaveCount=2

uninstall-redis-cluster:
	@helm uninstall redis --namespace redis-cluster

install-redis-client:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	kubectl run redis-client --restart='Never' --image docker.io/bitnami/redis:7 \
	  --env REDIS_PASSWORD=root1234 \
	  --namespace redis-cluster \
	  --command -- sleep infinity
	@echo "Pod已就绪，可以使用以下命令连接："
	@echo "kubectl exec -it redis-client -n redis-cluster -- bash"
	@echo "在Pod内部可以使用以下命令连接Redis："
	@echo "redis-cli -h redis-master -a root1234"
	@echo "或连接只读副本："
	@echo "redis-cli -h redis-replicas -a root1234"

uninstall-redis-client:
	@kubectl delete pod redis-client --namespace redis-cluster

install-redis-ui:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	kubectl create deployment redisinsight --image=redislabs/redisinsight:latest --namespace redis-cluster && \
	kubectl expose deployment redisinsight --port=8001 --namespace redis-cluster
	@echo "RedisInsight已部署，使用以下命令访问Web界面："
	@echo "kubectl port-forward svc/redisinsight 8082:8001 -n redis-cluster"
	@echo "然后在浏览器中访问：http://localhost:8082"
	@echo "在界面中添加Redis连接："
	@echo "主节点地址：redis-master.redis-cluster.svc.cluster.local"
	@echo "端口：6379，密码：root1234"

uninstall-redis-ui:
	@kubectl delete deployment redisinsight --namespace redis-cluster
	@kubectl delete service redisinsight --namespace redis-cluster

# kafka cluster
install-kafka-cluster:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	helm repo add bitnami https://charts.bitnami.com/bitnami && \
	helm repo update && \
	helm upgrade --install kafka --namespace kafka-cluster --create-namespace bitnami/kafka:3 \
	  --set replicaCount=3 \
	  --set auth.clientProtocol=sasl \
	  --set auth.sasl.jaas.clientUsers[0]=user \
	  --set auth.sasl.jaas.clientPasswords[0]=root1234

uninstall-kafka-cluster:
	@helm uninstall kafka --namespace kafka-cluster

install-kafka-client:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	kubectl run kafka-client --restart='Never' --image docker.io/bitnami/kafka:3 \
	  --env KAFKA_OPTS="-Djava.security.auth.login.config=/opt/bitnami/kafka/config/kafka_jaas.conf" \
	  --namespace kafka-cluster \
	  --command -- sleep infinity
	@echo "Pod已就绪，可以使用以下命令连接："
	@echo "kubectl exec -it kafka-client -n kafka-cluster -- bash"
	@echo "在Pod内部可以使用以下命令操作Kafka："
	@echo "创建主题：kafka-topics.sh --bootstrap-server kafka.kafka-cluster.svc.cluster.local:9092 --create --topic test --partitions 3 --replication-factor 2 --command-config /opt/bitnami/kafka/config/consumer.properties"
	@echo "生产消息：kafka-console-producer.sh --bootstrap-server kafka.kafka-cluster.svc.cluster.local:9092 --topic test --producer.config /opt/bitnami/kafka/config/producer.properties"
	@echo "消费消息：kafka-console-consumer.sh --bootstrap-server kafka.kafka-cluster.svc.cluster.local:9092 --topic test --from-beginning --consumer.config /opt/bitnami/kafka/config/consumer.properties"
	@kubectl exec -it kafka-client -n kafka-cluster -- bash -c "mkdir -p /opt/bitnami/kafka/config && echo 'sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username=\"user\" password=\"root1234\";' > /opt/bitnami/kafka/config/producer.properties && echo 'security.protocol=SASL_PLAINTEXT' >> /opt/bitnami/kafka/config/producer.properties && echo 'sasl.mechanism=PLAIN' >> /opt/bitnami/kafka/config/producer.properties && cp /opt/bitnami/kafka/config/producer.properties /opt/bitnami/kafka/config/consumer.properties && echo 'KafkaClient {\n  org.apache.kafka.common.security.plain.PlainLoginModule required\n  username=\"user\"\n  password=\"root1234\";\n};' > /opt/bitnami/kafka/config/kafka_jaas.conf"

uninstall-kafka-client:
	@kubectl delete pod kafka-client --namespace kafka-cluster

install-kafka-ui:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	kubectl create deployment kafka-ui --image=provectuslabs/kafka-ui:latest --namespace kafka-cluster && \
	kubectl set env deployment/kafka-ui KAFKA_CLUSTERS_0_NAME=kafka-cluster KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=kafka.kafka-cluster.svc.cluster.local:9092 KAFKA_CLUSTERS_0_PROPERTIES_SECURITY_PROTOCOL=SASL_PLAINTEXT KAFKA_CLUSTERS_0_PROPERTIES_SASL_MECHANISM=PLAIN KAFKA_CLUSTERS_0_PROPERTIES_SASL_JAAS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username='user' password='root1234';" --namespace kafka-cluster && \
	kubectl expose deployment kafka-ui --port=8080 --namespace kafka-cluster
	@echo "Kafka UI已部署，使用以下命令访问Web界面："
	@echo "kubectl port-forward svc/kafka-ui 8083:8080 -n kafka-cluster"
	@echo "然后在浏览器中访问：http://localhost:8083"

uninstall-kafka-ui:
	@kubectl delete deployment kafka-ui --namespace kafka-cluster
	@kubectl delete service kafka-ui --namespace kafka-cluster

# elasticsearch cluster
install-elasticsearch-cluster:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	helm repo add bitnami https://charts.bitnami.com/bitnami && \
	helm repo update && \
	helm upgrade --install elasticsearch --namespace elasticsearch-cluster --create-namespace bitnami/elasticsearch:8 \
	  --set master.replicaCount=3 \
	  --set data.replicaCount=2 \
	  --set security.enabled=true \
	  --set security.elasticPassword=root1234

uninstall-elasticsearch-cluster:
	@helm uninstall elasticsearch --namespace elasticsearch-cluster

install-elasticsearch-client:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	kubectl run elasticsearch-client --restart='Never' --image docker.io/bitnami/elasticsearch:8 \
	  --env ELASTICSEARCH_PASSWORD=root1234 \
	  --namespace elasticsearch-cluster \
	  --command -- sleep infinity
	@echo "Pod已就绪，可以使用以下命令连接："
	@echo "kubectl exec -it elasticsearch-client -n elasticsearch-cluster -- bash"
	@echo "在Pod内部可以使用以下命令操作ElasticSearch："
	@echo "curl -u elastic:root1234 https://elasticsearch.elasticsearch-cluster.svc.cluster.local:9200 -k"
	@echo "curl -u elastic:root1234 https://elasticsearch.elasticsearch-cluster.svc.cluster.local:9200/_cat/indices -k"
	@echo "curl -u elastic:root1234 -X PUT https://elasticsearch.elasticsearch-cluster.svc.cluster.local:9200/test-index -k"

uninstall-elasticsearch-client:
	@kubectl delete pod elasticsearch-client --namespace elasticsearch-cluster

install-elasticsearch-ui:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	helm repo add bitnami https://charts.bitnami.com/bitnami && \
	helm repo update && \
	helm upgrade --install kibana --namespace elasticsearch-cluster bitnami/kibana:8 \
	  --set elasticsearch.hosts[0]=elasticsearch.elasticsearch-cluster.svc.cluster.local \
	  --set elasticsearch.port=9200 \
	  --set elasticsearch.security.auth.enabled=true \
	  --set elasticsearch.security.auth.kibanaPassword=root1234 \
	  --set elasticsearch.security.auth.user=elastic \
	  --set elasticsearch.security.auth.password=root1234 \
	  --set replicaCount=1
	@echo "Kibana已部署，使用以下命令访问Web界面："
	@echo "kubectl port-forward svc/kibana 5601:5601 -n elasticsearch-cluster"
	@echo "然后在浏览器中访问：http://localhost:5601"
	@echo "用户名：elastic，密码：root1234"

uninstall-elasticsearch-ui:
	@helm uninstall kibana --namespace elasticsearch-cluster

# mongodb cluster
install-mongodb-cluster:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	helm repo add bitnami https://charts.bitnami.com/bitnami && \
	helm repo update && \
	helm upgrade --install mongodb --namespace mongodb-cluster --create-namespace bitnami/mongodb:6 \
	  --set architecture=replicaset \
	  --set auth.rootPassword=root1234 \
	  --set auth.database=iknow \
	  --set replicaCount=3

uninstall-mongodb-cluster:
	@helm uninstall mongodb --namespace mongodb-cluster

install-mongodb-client:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	kubectl run mongodb-client --restart='Never' --image docker.io/bitnami/mongodb:6 \
	  --env MONGODB_ROOT_PASSWORD=root1234 \
	  --namespace mongodb-cluster \
	  --command -- sleep infinity
	@echo "Pod已就绪，可以使用以下命令连接："
	@echo "kubectl exec -it mongodb-client -n mongodb-cluster -- bash"
	@echo "在Pod内部可以使用以下命令连接MongoDB："
	@echo "mongo --host mongodb-0.mongodb-headless.mongodb-cluster.svc.cluster.local -u root -p root1234 --authenticationDatabase admin iknow"
	@echo "或连接副本集："
	@echo "mongo 'mongodb://root:root1234@mongodb-0.mongodb-headless.mongodb-cluster.svc.cluster.local,mongodb-1.mongodb-headless.mongodb-cluster.svc.cluster.local,mongodb-2.mongodb-headless.mongodb-cluster.svc.cluster.local/iknow?replicaSet=rs0&authSource=admin'"

uninstall-mongodb-client:
	@kubectl delete pod mongodb-client --namespace mongodb-cluster

install-mongodb-ui:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	kubectl create deployment mongo-express --image=mongo-express:latest --namespace mongodb-cluster && \
	kubectl set env deployment/mongo-express ME_CONFIG_MONGODB_SERVER=mongodb-0.mongodb-headless.mongodb-cluster.svc.cluster.local ME_CONFIG_MONGODB_ADMINUSERNAME=root ME_CONFIG_MONGODB_ADMINPASSWORD=root1234 ME_CONFIG_MONGODB_URL="mongodb://root:root1234@mongodb-0.mongodb-headless.mongodb-cluster.svc.cluster.local:27017/admin" --namespace mongodb-cluster && \
	kubectl expose deployment mongo-express --port=8081 --namespace mongodb-cluster
	@echo "Mongo Express已部署，使用以下命令访问Web界面："
	@echo "kubectl port-forward svc/mongo-express 8084:8081 -n mongodb-cluster"
	@echo "然后在浏览器中访问：http://localhost:8084"
	@echo "用户名：root，密码：root1234"

uninstall-mongodb-ui:
	@kubectl delete deployment mongo-express --namespace mongodb-cluster
	@kubectl delete service mongo-express --namespace mongodb-cluster

# prometheus cluster
install-prometheus-cluster:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts && \
	helm repo update && \
	helm upgrade --install prometheus --namespace prometheus-cluster --create-namespace prometheus-community/kube-prometheus-stack:45 \
	  --set prometheus.prometheusSpec.replicas=3 \
	  --set prometheus.prometheusSpec.retention=15d \
	  --set alertmanager.alertmanagerSpec.replicas=3 \
	  --set grafana.adminPassword=root1234 \
	  --set grafana.replicas=2

uninstall-prometheus-cluster:
	@helm uninstall prometheus --namespace prometheus-cluster

install-prometheus-client:
	@echo "Prometheus和Grafana可以通过端口转发访问，无需单独的客户端Pod"
	@echo "使用以下命令访问Grafana界面："
	@echo "kubectl port-forward svc/prometheus-grafana 3000:80 -n prometheus-cluster"
	@echo "使用以下命令访问Prometheus界面："
	@echo "kubectl port-forward svc/prometheus-kube-prometheus 9090:9090 -n prometheus-cluster"

uninstall-prometheus-client:
	@echo "没有单独的Prometheus客户端Pod需要卸载"

# minio cluster
install-minio-cluster:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	helm repo add minio https://charts.min.io/ && \
	helm repo update && \
	helm upgrade --install minio --namespace minio-cluster --create-namespace minio/minio:5 \
	  --set rootUser=admin \
	  --set rootPassword=root1234 \
	  --set mode=distributed \
	  --set replicas=4

uninstall-minio-cluster:
	@helm uninstall minio --namespace minio-cluster

install-minio-client:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	kubectl run minio-client --restart='Never' --image docker.io/minio/mc:5 \
	  --namespace minio-cluster \
	  --command -- sleep infinity
	@echo "Pod已就绪，可以使用以下命令连接："
	@echo "kubectl exec -it minio-client -n minio-cluster -- bash"
	@echo "在Pod内部可以使用以下命令配置MinIO客户端："
	@echo "mc alias set myminio http://minio.minio-cluster.svc.cluster.local:9000 admin root1234"
	@echo "然后可以使用以下命令操作MinIO："
	@echo "mc ls myminio"
	@echo "mc mb myminio/mybucket"
	@echo "mc cp /tmp/file.txt myminio/mybucket/"

uninstall-minio-client:
	@kubectl delete pod minio-client --namespace minio-cluster

install-minio-ui:
	@echo "MinIO自带Web界面，使用以下命令访问："
	@echo "kubectl port-forward svc/minio 9001:9001 -n minio-cluster"
	@echo "然后在浏览器中访问：http://localhost:9001"
	@echo "用户名：admin，密码：root1234"

uninstall-minio-ui:
	@echo "MinIO的Web界面是内置的，无需单独卸载"

# jaeger cluster
install-jaeger-cluster:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	helm repo add jaegertracing https://jaegertracing.github.io/helm-charts && \
	helm repo update && \
	helm upgrade --install jaeger --namespace jaeger-cluster --create-namespace jaegertracing/jaeger:2 \
	  --set storage.type=elasticsearch \
	  --set storage.elasticsearch.host=elasticsearch-master.elasticsearch-cluster.svc.cluster.local \
	  --set storage.elasticsearch.user=elastic \
	  --set storage.elasticsearch.password=root1234 \
	  --set collector.replicaCount=2 \
	  --set query.replicaCount=2

uninstall-jaeger-cluster:
	@helm uninstall jaeger --namespace jaeger-cluster

install-jaeger-client:
	@echo "Jaeger UI可以通过端口转发访问，无需单独的客户端Pod"
	@echo "使用以下命令访问Jaeger UI界面："
	@echo "kubectl port-forward svc/jaeger-query 16686:16686 -n jaeger-cluster"
	@echo "然后在浏览器中访问：http://localhost:16686"
	@echo "在应用程序中集成Jaeger，需要配置以下环境变量："
	@echo "JAEGER_AGENT_HOST=jaeger-agent.jaeger-cluster.svc.cluster.local"
	@echo "JAEGER_AGENT_PORT=6831"

uninstall-jaeger-client:
	@echo "没有单独的Jaeger客户端Pod需要卸载"

# harbor cluster
install-harbor-cluster:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	helm repo add harbor https://helm.goharbor.io && \
	helm repo update && \
	helm upgrade --install harbor --namespace harbor-cluster --create-namespace harbor/harbor \
	  --set expose.type=nodePort \
	  --set expose.tls.enabled=false \
	  --set harborAdminPassword=admin1234 \
	  --set registry.replicas=1 \
	  --set core.replicas=1 \
	  --set portal.replicas=1 \
	  --set externalURL=http://k8s.orb.local:30002
	@echo "Harbor镜像仓库已部署，访问Web界面：http://k8s.orb.local:30002"
	@echo "用户名：admin，密码：admin1234"

uninstall-harbor-cluster:
	@helm uninstall harbor --namespace harbor-cluster

install-harbor-client:
	@echo "Harbor不需要单独的客户端Pod，可以通过以下方式使用："
	@echo "1. 使用OrbStack环境访问Harbor："
	@echo "   # 配置Docker允许不安全的注册表"
	@echo "   echo '{\"insecure-registries\":[\"0.0.0.0\/0\"]}' > ~/.docker/daemon.json"
	@echo "   # 在macOS上重启Docker Desktop"
	@echo "2. 登录Harbor："
	@echo "   docker login k8s.orb.local:30002 -u admin -p admin1234"
	@echo "3. 推送镜像示例："
	@echo "   docker tag nginx:latest k8s.orb.local:30002/library/nginx:latest"
	@echo "   docker push k8s.orb.local:30002/library/nginx:latest"

uninstall-harbor-client:
	@echo "Harbor不需要单独的客户端Pod，无需卸载"

# dtm cluster
install-dtm-cluster:
	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
	kubectl create namespace dtm-cluster && \
	kubectl create configmap dtm-config \
	  --from-literal=STORE_DRIVER=mysql \
	  --from-literal=STORE_HOST=mysql-primary.mysql-cluster.svc.cluster.local \
	  --from-literal=STORE_USER=root \
	  --from-literal=STORE_PASSWORD=root1234 \
	  -n dtm-cluster && \
	kubectl create deployment dtm --image=yedf/dtm:latest --namespace dtm-cluster --replicas=3 && \
	kubectl set env deployment/dtm --from=configmap/dtm-config -n dtm-cluster && \
	kubectl expose deployment dtm --port=36789 --target-port=36789 --name=dtm-server --namespace dtm-cluster
	@echo "DTM分布式事务管理器已部署为3副本的高可用集群"
	@echo "首次使用前，需要在MySQL中创建dtm数据库："
	@echo "kubectl exec -it -n mysql-cluster mysql-client -- mysql -h mysql-primary -u root -proot1234 -e 'CREATE DATABASE IF NOT EXISTS dtm;'"
	@echo "服务地址：dtm-server.dtm-cluster.svc.cluster.local:36789"
	@echo "使用以下命令转发HTTP接口："
	@echo "kubectl port-forward svc/dtm-server 36789:36789 -n dtm-cluster"

uninstall-dtm-cluster:
	@kubectl delete namespace dtm-cluster

install-dtm-client:
	@echo "DTM不需要单独的客户端Pod，可以通过以下方式在go-zero应用中使用："
	@echo "1. 添加DTM依赖："
	@echo "   go get -u github.com/dtm-labs/client"
	@echo "2. 在应用中配置DTM服务地址："
	@echo "   dtmServer := \"dtm-server.dtm-cluster.svc.cluster.local:36789\""
	@echo "3. 使用DTM的事务模式（如SAGA、TCC、XA等）进行分布式事务管理"
	@echo "4. 查看DTM文档获取更多信息：https://dtm.pub/"

uninstall-dtm-client:
	@echo "DTM不需要单独的客户端Pod，无需卸载"
