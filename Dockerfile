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

COPY requirements.txt galaxy-requirements.yml .
RUN set -xe \
	&& pip install --no-cache-dir -r requirements.txt \
	&& ansible-galaxy collection install --no-cache \
		--collections-path /usr/share/ansible/collections -r galaxy-requirements.yml \
	&& rm -rf /root /tmp

