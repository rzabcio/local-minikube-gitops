.PHONY: start

# minikube profile
profile := gitops
cpus := 3
memory := 6g
cluster_status := $(lastword $(shell minikube status -p $(profile); echo $$?))

start:
ifneq ($(cluster_status),0)
	@minikube start -p $(profile) --cpus $(cpus) --memory $(memory)
	@minikube profile $(profile)
	@minikube addons enable ingress
endif

install-requirements:
	@helm repo add argo-cd https://argoproj.github.io/argo-helm
	@helm dependency build charts/argo-cd

update:
	@helm upgrade --install argo-cd -n argo-cd --create-namespace charts/argo-cd

password:
	@kubectl -n argo-cd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

test:
ifneq ($(status),0)
		$(info "status is not zero...")
else
		$(info "status is zero...")
endif

stop:
	@minikube stop -p $(profile)

delete:
	@minikube delete -p $(profile)
