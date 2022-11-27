#!/bin/bash
USERNAME="ubuntu"
HOME="/home/$USERNAME"

variables() {
  APP="$HOME"/app1
  APP_FILENAME="simple.py"
  PODMAN_TARBALL="podman-linux-amd64.tar.gz"
}

# Create app directory and copy $APP_FILENAME to the directory
create() {
  mkdir -p "$APP"
  cd "$APP" || exit
  find $HOME -name $APP_FILENAME -not -path "$APP/*" -exec cp {} $APP \;
  chown -R "$(id $USERNAME -u):$(id $USERNAME -g)" $HOME
}

# Create Dockerfile and image
dockerfile() {
  tee "$APP/Dockerfile" > /dev/null <<EOT
  FROM docker.io/library/python:3
  ADD $APP_FILENAME /
  CMD [ "python", "./$APP_FILENAME"]
EOT
}

# Download and install podman
install_podman() {
  curl -fsSL -o $PODMAN_TARBALL https://github.com/mgoltzsche/podman-static/releases/latest/download/$PODMAN_TARBALL
  tar -xf $PODMAN_TARBALL
  sudo cp -r podman-linux-amd64/{usr,etc} /
}

# Install the registry and extract the ClusterIP
registryIP() {
  export KUBECONFIG=/etc/kubernetes/admin.conf # Allow cluster administration by the root user
  find $HOME -name easyregistry.yaml -exec kubectl create -f {} \;
  IPADDR=$(kubectl get service/registry -o jsonpath='{.spec.clusterIP}')
  PORT=$(kubectl get service/registry -o jsonpath='{.spec.ports[0].port}')
  repo=$IPADDR:$PORT
  REPO_ENDPOINT="http://$repo"
  REPO_QUOTED=\"$repo\"
  REPO_ENDPOINT_QUOTED=\"$REPO_ENDPOINT\"
}

# Configure local repository on the control plane
registryCP() {
  sudo mkdir -p /etc/containers/registries.conf.d/
  sudo tee /etc/containers/registries.conf.d/registry.conf > /dev/null <<EOT
  [[registry]]
  location = $REPO_QUOTED
  insecure = true
EOT

  sudo sed -i '/plugins."io.containerd.grpc.v1.cri".registry.mirrors/a \
  \
        \[plugins."io.containerd.grpc.v1.cri".registry.mirrors."*"\]\
          endpoint = \['"$REPO_ENDPOINT_QUOTED"'\]\
  ' /etc/containerd/config.toml

  sudo systemctl restart containerd
}

# Configure the local registry on the worker node
registryWorker() {
  ssh -o "StrictHostKeyChecking=no" $USERNAME@${WORKER_NODE} "sudo mkdir -p /etc/containers/registries.conf.d/"
  sudo rsync --rsync-path="sudo rsync" /etc/containers/registries.conf.d/registry.conf $USERNAME@${WORKER_NODE}:/etc/containers/registries.conf.d/registry.conf -e "ssh -o StrictHostKeyChecking=no"
  sudo rsync --rsync-path="sudo rsync" /etc/containerd/config.toml $USERNAME@${WORKER_NODE}:/etc/containerd/config.toml -e "ssh -o StrictHostKeyChecking=no"
  ssh -o "StrictHostKeyChecking=no" $USERNAME@${WORKER_NODE} "sudo systemctl restart containerd"
  ssh -o "StrictHostKeyChecking=no" $USERNAME@${WORKER_NODE} 'sudo crictl config --set runtime-endpoint=unix:///run/containerd/containerd.sock --set image-endpoint=unix:///run/containerd/containerd.sock'
}

# Export repo variable into ~/.bashrc
# Execute this function before the app() function, so configs can transfer even if the push to the repository fails.
bashrc() {
  echo "export repo=$repo" >> $HOME/.bashrc
  sudo ssh -o "StrictHostKeyChecking=no" $USERNAME@${WORKER_NODE} "echo export repo=$repo >> $HOME/.bashrc"
}

# Build, tag, and push simpleapp to local registry
app() {
  # Wait for the Nginx and Registry Deployments to complete
  kubectl wait --for=condition=available deployment/registry deployment/nginx --timeout=10m

  sudo podman build -t simpleapp .
  sudo podman tag simpleapp $repo/simpleapp
  sudo podman push $repo/simpleapp
  curl $repo/v2/_catalog --connect-timeout 15
}

# Reboot
reboot_nodes() {
  sudo ssh -o "StrictHostKeyChecking=no" $USERNAME@${WORKER_NODE} 'sudo reboot'
  sudo reboot
}

main() {
  variables &&
  create &&
  dockerfile &&
  install_podman &&
  registryIP &&
  registryCP &&
  registryWorker &&
  bashrc &&
  app
#  reboot_nodes
}

main