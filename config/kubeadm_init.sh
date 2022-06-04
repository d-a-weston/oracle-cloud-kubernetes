#!/bin/sh

# Unblock all incoming traffic
iptables -I INPUT 1 -j ACCEPT

# Replace the Public IP placeholder in the kubeadm config
PUBLIC_IP=$(curl https://icanhazip.com/)
sed -i s/@@PUBLIC_IP@@/$PUBLIC_IP/ /etc/kubeadm_config.yaml

# Initialise kubeadm (Ignoring the 2 CPU minimum requirement)
kubeadm init --config=/etc/kubeadm_config.yaml --ignore-preflight-errors=NumCPU

# Initiliase Kubectl
export KUBECONFIG=/etc/kubernetes/admin.conf
mkdir -p /home/k8s/.kube
cp $KUBECONFIG /home/k8s/.kube/config
chown -R k8s:k8s /home/k8s/.kube

# Install CNI (Flannel)[https://gist.github.com/rkaramandi/44c7cea91501e735ea99e356e9ae7883]
kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
