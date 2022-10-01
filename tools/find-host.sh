#!/bin/bash

clusters="adanalytics b2b bonificacao chatbothubi cupom-omni hubparceiros mdm pricing vaivia viastore"
host="10.114.8.145"
env="prd"

echo -e "\n### Procurando o host $host nos clusters de $env ###\n"
for cluster in $clusters; do
    kubectx akspriv-$cluster-$env-admin >> /dev/null
    echo -e "\nCluster: akspriv-$cluster-$env"
    kubectl get ingress -A | grep $host
done
