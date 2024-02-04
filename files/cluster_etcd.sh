# Update HOST0, HOST1, and HOST2 with the IPs or resolvable names of your hosts
export HOST0=master_ip
export HOST1=master2_ip
export HOST2=master3_ip

# Create temp directories to store files that will end up on other hosts.
mkdir -p /tmp/${HOST0}/ /tmp/${HOST1}/ /tmp/${HOST2}/

ETCDHOSTS=(${HOST0} ${HOST1} ${HOST2})
NAMES=("master_host_name" "master2_hostname" "master3_hostname")

for i in "${!ETCDHOSTS[@]}"; do
HOST=${ETCDHOSTS[$i]}
NAME=${NAMES[$i]}

if [ $i == 0 ]; then
cat << EOF > /tmp/${HOST}/etcd-config.yaml
etcd:
  local:
    imageTag: "3.5.6-0"
    serverCertSANs:
    - "${NAME}"
    - "${HOST}"
    peerCertSANs:
    - "${NAME}"
    - "${HOST}"
    extraArgs:
      initial-cluster: ${NAMES[0]}=https://${ETCDHOSTS[0]}:2380
#      initial-cluster-state: new
#      name: ${NAME}
      listen-peer-urls: https://${HOST}:2380
      listen-metrics-urls: http://0.0.0.0:2381
      listen-client-urls: https://127.0.0.1:2379,https://${HOST}:2379
      advertise-client-urls: https://${HOST}:2379
      initial-advertise-peer-urls: https://${HOST}:2380
      election-timeout: "10000"
EOF
fi

if [ $i == 1 ]; then
cat << EOF > /tmp/${HOST}/etcd-config.yaml
etcd:
  local:
    imageTag: "3.5.6-0"
    serverCertSANs:
    - "${NAME}"
    - "${HOST}"
    peerCertSANs:
    - "${NAME}"
    - "${HOST}"
    extraArgs:
      initial-cluster: ${NAMES[0]}=https://${ETCDHOSTS[0]}:2380,${NAMES[1]}=https://${ETCDHOSTS[1]}:2380
      initial-cluster-state: existing
#      name: ${NAME}
      listen-peer-urls: https://${HOST}:2380
      listen-metrics-urls: http://0.0.0.0:2381
      listen-client-urls: https://127.0.0.1:2379,https://${HOST}:2379
      advertise-client-urls: https://${HOST}:2379
      initial-advertise-peer-urls: https://${HOST}:2380
      election-timeout: "10000"
EOF
fi

if [ $i == 2 ]; then
cat << EOF > /tmp/${HOST}/etcd-config.yaml
etcd:
  local:
    imageTag: "3.5.6-0"
    serverCertSANs:
    - "${NAME}"
    - "${HOST}"
    peerCertSANs:
    - "${NAME}"
    - "${HOST}"
    extraArgs:
      initial-cluster: ${NAMES[0]}=https://${ETCDHOSTS[0]}:2380,${NAMES[1]}=https://${ETCDHOSTS[1]}:2380,${NAMES[2]}=https://${ETCDHOSTS[2]}:2380
      initial-cluster-state: existing
#      name: ${NAME}
      listen-peer-urls: https://${HOST}:2380
      listen-metrics-urls: http://0.0.0.0:2381
      listen-client-urls: https://127.0.0.1:2379,https://${HOST}:2379
      advertise-client-urls: https://${HOST}:2379
      initial-advertise-peer-urls: https://${HOST}:2380
      election-timeout: "10000"
EOF
fi

done
