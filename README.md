# gcloud via docker

quickly use gcloud tools and other stuff in a container via docker

# run as a container
`$ make shell`

# run Cloud Shell
`$ make cloud-shell`

# build
> for example, when you updated Brewfile

`$ make build`

# sink-conf
`$ make sink-conf`

This will copy `~/.kube/config # container's perspective` to `./home/cloud-kubeconfig # outside's perspective`.
So that you can use it to connect your k8s container from outside when you wish.

> GKE's session with this copied config file will be only temporarily valid though
