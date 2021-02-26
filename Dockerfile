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

##########  asdf  ###########

FROM alpine:3.13 as asdf
ENV PATH=/root/.asdf/bin:$PATH

RUN apk update && apk add git curl bash
RUN git clone https://github.com/asdf-vm/asdf.git /root/.asdf --branch v0.8.0
COPY ./asdf-tool-versions /root/.tool-versions
RUN asdf plugin add helm
RUN cat /root/.tool-versions
RUN asdf install

########## gcloud ###########

FROM google/cloud-sdk:alpine
ENV PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH \
	SHELL=/bin/bash
ENV USER root

# for Homebrew stuff to work
# check here to be up-to-date https://github.com/Linuxbrew/docker/blob/master/alpine/Dockerfile#L5-L6
RUN apk update \
	&& apk --no-cache add bash curl file g++ git libc6-compat make ruby ruby-bigdecimal ruby-etc ruby-irb ruby-json ruby-test-unit

RUN gcloud components install alpha beta kubectl

RUN apk add make

COPY --from=brew /home/linuxbrew/.linuxbrew /home/linuxbrew/.linuxbrew
COPY --from=asdf /root/.asdf /root/.asdf
