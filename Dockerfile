ARG FROM=python:3.11-slim-bullseye
FROM ${FROM} as base

RUN set -xe \
	&& echo 'debconf debconf/frontend select noninteractive' | debconf-set-selections \
	&& apt-get update -qq \
	&& apt-get upgrade --yes -qq \
	&& apt-get install --fix-missing --no-install-recommends --no-install-suggests --yes -qq \
		git \
		tzdata \
	&& apt-get autoremove --yes --purge -qq \
	&& apt-get clean --yes -qq \
	&& rm -rf -- /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
		ansible==5.10.0 \
		ansible-core==2.12.10 \
		ansible-lint==6.13.1

COPY juniper /usr/share/ansible/collections/ansible_collections/juniper
