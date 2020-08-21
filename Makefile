dcrun := docker-compose run
cpconf := cp ~/.kube/config cloud-kubeconfig
cl-info := kubectl cluster-info

shell:
	$(dcrun) gcloud
cloud-shell:
	$(dcrun) gcloud make shell
build:
	docker-compose build
sink-conf:
	@$(dcrun) gcloud /bin/bash -c "kubectx && $(cl-info) && $(cpconf)"
