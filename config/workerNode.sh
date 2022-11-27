#!/bin/bash
USERNAME="ubuntu"
HOME="/home/$USERNAME"

# Deploy a Worker Node
worker() {
  wget ${URL} --user=${USER} --password=${PASSWORD} -O "$HOME/LFD259_SOLUTIONS.tar.xz" &&
  tar -xvf "$HOME/LFD259_SOLUTIONS.tar.xz" -C $HOME &&
  bash "$(find / -name k8sWorker.sh 2>/dev/null)" | tee "$HOME/worker.out"
}

worker