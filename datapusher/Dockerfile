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
    libxml2-dev \
    libxslt1-dev \
    cargo \
    build-essential \
    python3-pip \
    supervisor \
    libpq-dev


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

RUN pip3 install psycopg2

COPY ./config ${SRC_DIR}/datapusher/deployment/

RUN chmod +x /srv/app/src/datapusher/deployment/start.sh

RUN service supervisor restart
COPY ./supervisor/datapusher-uwsgi.conf /etc/supervisor/conf.d/

ENTRYPOINT ["/srv/app/src/datapusher/deployment/start.sh"]
