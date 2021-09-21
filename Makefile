BOOTSTRAP=1
SECRETS=~/values-secret.yaml
NAME=$(shell basename `pwd`)
TARGET_REPO=$(shell git remote show origin | grep Push | sed -e 's/.*URL://' -e 's%:%/%' -e 's%git@%https://%')
TARGET_BRANCH=$(shell git branch --show-current)

show:
	helm template install/ --name-template $(NAME) -f $(SECRETS) --set main.git.repoURL="$(TARGET_REPO)" --set main.git.revision=$(TARGET_BRANCH) --set main.options.bootstrap=$(BOOTSTRAP)

init:
	git submodule update --init --recursive

deploy:
	helm install $(NAME) install/ -f $(SECRETS) --set main.git.repoURL="$(TARGET_REPO)" --set main.git.revision=$(TARGET_BRANCH) --set main.options.bootstrap=$(BOOTSTRAP)
ifeq ($(BOOTSTRAP),1)
	bash util/argocd-secret.sh
endif

upgrade:
	helm upgrade $(NAME) install/ -f $(SECRETS) --set main.git.repoURL="$(TARGET_REPO)" --set main.git.revision=$(TARGET_BRANCH) --set main.options.bootstrap=$(BOOTSTRAP)
ifeq ($(BOOTSTRAP),1)
	bash util/argocd-secret.sh
endif

uninstall:
	helm uninstall $(NAME) 

.phony: install
