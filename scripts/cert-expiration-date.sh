#!/bin/bash

clusters=$(kubectx | cat)
expiration="2022"

echo -e "\n### O certificado dos hosts abaixo expiram em $expiration ###\n"
for cluster in $clusters; do
    kubectx $clusters >> /dev/null
    echo -e "\nCluster: $cluster"
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
