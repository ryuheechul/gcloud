########## brew ###########

FROM linuxbrew/brew as brew

RUN brew install perl
RUN brew install starship
# for Homebrew stuff to work
COPY ./Brewfile.dep ./Brewfile.dep
RUN brew bundle --file Brewfile.dep

# install stuff I want
COPY ./Brewfile ./Brewfile
RUN brew bundle

# cleanup stuff (not very sure if this is very necessary at the moment)
RUN brew cleanup -s --prune-prefix
RUN rm -rf "$(brew --cache)"

# remove unnecessary brew stuff before copying to
WORKDIR /home/linuxbrew/.linuxbrew
RUN rm -rf ./Homebrew
RUN rm -rf ./var

########## gcloud ###########

FROM google/cloud-sdk:alpine
ENV PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH \
	SHELL=/bin/bash
ENV USER root

ENV HELM_VERSION="2.15.1"
ENV HELM_3_VERSION="3.2.3"

RUN curl -o /tmp/helm.tgz \
      https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
      && tar -zxvf /tmp/helm.tgz -C /tmp \
      && chmod +x /tmp/linux-amd64/helm \
      && mv /tmp/linux-amd64/helm /usr/local/bin/helm \
      && rm -rf /tmp/*

RUN curl -o /tmp/helm.tgz \
      https://get.helm.sh/helm-v${HELM_3_VERSION}-linux-amd64.tar.gz \
      && tar -zxvf /tmp/helm.tgz -C /tmp \
      && chmod +x /tmp/linux-amd64/helm \
      && mv /tmp/linux-amd64/helm /usr/local/bin/helm3 \
      && rm -rf /tmp/*

# for Homebrew stuff to work
# check here to be up-to-date https://github.com/Linuxbrew/docker/blob/master/alpine/Dockerfile#L5-L6
RUN apk update \
	&& apk --no-cache add bash curl file g++ git libc6-compat make ruby ruby-bigdecimal ruby-etc ruby-irb ruby-json ruby-test-unit

RUN gcloud components install alpha beta kubectl

RUN apk add make

COPY --from=brew /home/linuxbrew/.linuxbrew \
            /home/linuxbrew/.linuxbrew
