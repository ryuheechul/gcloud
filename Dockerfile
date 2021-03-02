##########  brew  ###########

FROM linuxbrew/brew:1.9.3 as brew

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
ENV PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH
ENV SHELL=/bin/bash

COPY --from=brew /home/linuxbrew/.linuxbrew /home/linuxbrew/.linuxbrew
# for Homebrew stuff to work
# check here to be up-to-date https://github.com/Linuxbrew/docker/blob/master/alpine/Dockerfile#L5-L6
RUN apk update && apk --no-cache add \
    build-base libffi-dev openssl-dev bzip2-dev zlib-dev readline-dev sqlite-dev \
    ruby ruby-bigdecimal ruby-etc ruby-irb ruby-json ruby-test-unit \
    bash curl file g++ git libc6-compat make

ENV CLOUDSDK_PYTHON=/usr/bin/python3
RUN gcloud components install alpha beta kubectl

RUN addgroup -S gcloud && adduser -S gcloud -G gcloud
RUN mkdir -p /asdf-home && chown gcloud /asdf-home
USER gcloud
WORKDIR /home/gcloud

ENV ASDF_DIR=/asdf-home/.asdf
ENV ASDF_DATA_DIR=/home/gcloud/.asdf

RUN git clone https://github.com/asdf-vm/asdf.git ${ASDF_DIR} --branch v0.8.0
