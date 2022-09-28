#!/bin/bash

clusters="adanalytics b2b bonificacao chatbothubi cupom-omni hubparceiros mdm pricing vaivia viastore"
expiration="2022"
env="prd"

echo -e "\n### O certificado dos hosts em $env abaixo expiram em $expiration ###\n"
for cluster in $clusters; do
    kubectx akspriv-$cluster-$env-admin >> /dev/null
    echo -e "\nCluster: akspriv-$cluster-$env"
    hosts=$(kubectl get ing -A | awk -F" " '{ print $4 }' | sed -e s"/,/\n/" | awk '(NR>1)' | grep viavarejo.com.br)
    for host in $hosts; do
        stderr=$(curl https://$host -vI --stderr - | grep "expire date")
        if [[ $stderr =~ $expiration ]]; then
            namespace=$(kubectl get ing -A | grep $host | awk 'NR==1{print $1}')
            echo -e "  host: $host"
            # echo "$stderr"
            # echo "  namespace: $namespace"
        fi
    done
done
