#!/bin/bash
# set -x

# Setup for Openshift to support the ovn-cni plugin
#
# This script runs on the ovn-master node on the cluster
# since it sets up a configmap with information on how
# to access the ovn-master.
#
# This script is run as part of installation after the cluster is
# up and before the ovn daemonsets are created.

health=$(kubectl get --raw /healthz/ready)
if [ $health != 'ok' ]
then
  echo " cluster not ready"
  exit 1
fi


# get api server
api=$(kubectl get po -n kube-system -o wide | gawk '/master-api/{ print $7 }')
apiserver=https://${api}:8443

# get the network cidr (master-config.yaml clusterNetworkCIDR)
net_cidr=10.128.0.0/14

# get the service subnet cidr (master-config.yaml servicesSubnet)
svc_cidr=172.30.0.0/16

# get the ovn master's ip address
host_ip=$(host $(hostname) | gawk '{ print $4 }' )

# Currently using tcp, may move to ssl
OvnNorth="tcp://${host_ip}:6641"
OvnSouth="tcp://${host_ip}:6642"

# build the ovn.master file
echo apiserver $apiserver
echo net_cidr $net_cidr
echo svc_cidr $svc_cidr
echo OvnNorth $OvnNorth
echo OvnSouth $OvnSouth

# if the config map exists, delete it.
kubectl get configmap ovn-config > /dev/null 2>&1
if [[ $? = 0 ]]
then
  kubectl delete configmap ovn-config
fi

# create the ovn-config configmap
cat << EOF | kubectl create -f - > /dev/null 2>&1
kind: ConfigMap
apiVersion: v1
metadata:
  name: ovn-config
  namespace: ovn-kubernetes
data:
  k8s_apiserver: $apiserver
  net_cidr:      $net_cidr
  svc_cidr:      $svc_cidr
  OvnNorth:      $OvnNorth
  OvnSouth:      $OvnSouth
EOF
echo "kind: ConfigMap ovn-config -- $?"

# debug="-o yaml"
echo ""
echo "project ovn-kubernetes"
kubectl get project ovn-kubernetes ${debug}
echo ""
echo "ServiceAccount ovn -n ovn-kubernetes"
kubectl get sa ovn -n ovn-kubernetes ${debug}
echo ""
echo "kind: ClusterRole system:ovn-reader -- $?"
kubectl get ClusterRole system:ovn-reader ${debug}
echo ""
echo "ClusterRoleBinding ovn-cluster-reader"
kubectl get ClusterRoleBinding ovn-cluster-reader ${debug}
echo ""
echo "ClusterRoleBinding ovn-reader"
kubectl get ClusterRoleBinding ovn-reader ${debug}
echo ""
echo "ClusterRoleBinding cluster-admin-0"
kubectl get ClusterRoleBinding cluster-admin-0 ${debug}
echo ""
echo "SecurityContextConstraints anyuid"
kubectl get SecurityContextConstraints anyuid ${debug}
echo ""
echo "ConfigMap ovn-config -n ovn-kubernetes"
kubectl get ConfigMap ovn-config -n ovn-kubernetes ${debug}

exit 0
