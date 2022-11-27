#!/bin/bash
USERNAME="ubuntu"
HOME="/home/$USERNAME"

# Deploy a Control Plane node
control() {
  wget "${URL}" --user="${USER}" --password="${PASSWORD}" -O "$HOME/LFD259_SOLUTIONS.tar.xz" &&
  tar -xvf "$HOME/LFD259_SOLUTIONS.tar.xz" -C $HOME &&
  find $HOME -name k8scp.sh -exec cp {} $HOME \; &&
  bash "$HOME/k8scp.sh" | tee "$HOME/cp.out"
}

# Join the worker node to the cluster
worker() {
  grep -A1 "kubeadm join" "$HOME/cp.out" > "$HOME/join.txt" &&
  ssh -o "StrictHostKeyChecking=no" $USERNAME@${WORKER_NODE} 'sudo bash -s' < "$HOME/join.txt"
}

# Configure the non-root user to use kubectl
kctl() {
  mkdir -p "$HOME/.kube" &&
  cp -i /etc/kubernetes/admin.conf "$HOME/.kube/config" &&
  chown "$(id $USERNAME -u):$(id $USERNAME -g)" "$HOME/.kube/config" &&
  echo "source <(kubectl completion bash)" >> "$HOME/.bashrc"
}

# Allow containers to be deployed on the control plane
taint() {
  kubectl taint nodes --all node-role.kubernetes.io/control-plane- &&
  kubectl taint nodes --all node-role.kubernetes.io/master-
}

main() {
  control
  worker
  kctl
  taint
}

main