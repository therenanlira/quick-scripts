#!/bin/bash

clusters=$(kubectx | cat)
host="10.114.8.145"

echo -e "\n### Procurando o host $host ###\n"
for cluster in $clusters; do
    kubectx $cluster >> /dev/null
    echo -e "\nCluster: $cluster"
    kubectl get ingress -A | grep $host
done
