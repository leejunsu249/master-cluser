#!/bin/bash

core_config='{"Corefile": ".:53 {\n    errors\n    health {\n       lameduck 5s\n    }\n    ready\n    kubernetes cluster.local in-addr.arpa ip6.arpa {\n       pods insecure\n       fallthrough in-addr.arpa ip6.arpa\n       ttl 30\n    }\n    prometheus :9153\n    forward . /etc/resolv.conf {\n       max_concurrent 1000\n    }\n    cache 30\n    reload\n    loadbalance\n}\n"}'

kubectl get cm coredns -n kube-system -o json | jq --argjson core_config "$core_config" '.data = $core_config' | kubectl apply -f -

kubectl get pods -n kube-system -oname | grep coredns | xargs kubectl delete -n kube-system
