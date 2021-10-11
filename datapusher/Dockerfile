FROM debian:buster

RUN apt-get -q -y update && apt-get -q -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get -q -y install \ 
    python3 \
    curl \
    gcc \
    make \
    g++ \
    autoconf \
    automake \
    libtool \
    git \
    musl-dev \
    python3-dev \
    libffi-dev \
    openssl-dev \
    libxml2-dev \
    libxslt1-dev \
    rust \
    cargo \
    build-essential \
    python3-pip


ENV SRC_DIR=/srv/app/src
ENV GIT_BRANCH=0.0.17

WORKDIR ${SRC_DIR}

RUN mkdir -p ${SRC_DIR}

RUN cd ${SRC_DIR} && \
    git clone -b ${GIT_BRANCH} https://github.com/ckan/datapusher.git

RUN cd ${SRC_DIR}/datapusher/  && \
    pip3 install -r requirements.txt && \
    python3 setup.py develop

RUN pip3 install uwsgi

RUN groupadd www-data && \
    useradd -g www-data www-data

