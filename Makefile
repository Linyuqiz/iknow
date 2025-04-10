
# etcd cluster
# install-etcd-cluster:
# 	@export HTTPS_PROXY=http://127.0.0.1:7890 && \
# 	helm repo add bitnami https://charts.bitnami.com/bitnami && \
# 	helm repo update && \
# 	helm upgrade --install etcd --namespace etcd-cluster --create-namespace bitnami/etcd:3 \
# 	  --set replicaCount=3 \
# 	  --set auth.rbac.enabled=true \
# 	  --set auth.rbac.rootPassword=root1234

# uninstall-etcd-cluster:
# 	@helm uninstall etcd --namespace etcd-cluster
