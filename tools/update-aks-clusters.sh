#!/bin/bash

# Download contexts AKS
# Set unified config, azure cli will edit with the downloaded clusters configurations
# update Azure AKS clusters

AKS_clustersdir="${HOME}/.kube/azure"
KUBECONFIGAZURE="${AKS_clustersdir}/config"
AKS_lastupdated="${AKS_clustersdir}/.lastupdate"
AKS_UPDATE_CLUSTERS=false
SQUAD="b2b"

if [ -e "$AKS_lastupdated" ]; then
  AKS_timepassed=$(( $(date -u '+%s') - $(cat "$AKS_lastupdated") ))
  if [ "$AKS_timepassed" -ge "604800"  ]; then # update clusters every week
    AKS_UPDATE_CLUSTERS=true
  fi
else
  AKS_UPDATE_CLUSTERS=true
fi
if $AKS_UPDATE_CLUSTERS; then
  LOGIN=$(az account get-access-token &>/dev/null)
  if [ $? == 1 ]; then
    az login --scope https://management.core.windows.net//.default &>/dev/null
    if [ $? == 1 ]; then
      echo -e "✖️ Oh no! Could not login to Azure, please run:\n    az login --scope https://management.core.windows.net//.default"
      exit ; exit
    else
      echo -e "✔️ Now you are logged in Azure"
    fi
  else
    echo -e "✔️ Already logged in Azure"
  fi 
  rm ${HOME}/.kube/azure/config >> /dev/null 2>&1
  echo -e "\n⬇️  Downloading all AKS cluster configs"
  mkdir -p "$AKS_clustersdir"
  date -u '+%s' > "$AKS_lastupdated"
  touch "$KUBECONFIGAZURE"
  chmod 600 "$KUBECONFIGAZURE"
  subs=($( az account list  --query '[].id' -o tsv))
  for sub in "${subs[@]}"; do
    sub_name="$(az account show --subscription "$sub" --query 'name')"
    echo -e "\n⏳ Scanning Subscription "$sub_name""
    akss=($( az aks list --subscription "$sub"  --query "[?tags.sre == '$SQUAD'].{x: resourceGroup, y: name}" -o tsv))
    if [[ ! -z "$akss" ]]; then
      for aksnum in $( seq $((${#akss[@]}/2)) ); do
        n=$(($aksnum*2-2))
        nn=$(($aksnum*2-1))
        rg="${akss[$n]}"
        aks="${akss[$nn]}"
        aksfile="$AKS_clustersdir/$sub/$rg-$aks"
        # echo -e "$aks"
        AKSCONFIGURED=$(az aks get-credentials --subscription "$sub" -a -g "$rg" -n "$aks" -f "$KUBECONFIGAZURE" &>/dev/null)
        if [ $? == 0 ]; then
          echo -e "✅ $aks"
        fi
      done
    else
      echo -e "✓ No SRE "$SQUAD" cluster found"
    fi
  done
  echo -e "\n\n😃 AKS cluster configs download done"
fi

export KUBECONFIG="$HOME/.kube/config:$KUBECONFIGAZURE"
