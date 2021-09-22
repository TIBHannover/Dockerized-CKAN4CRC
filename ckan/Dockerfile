FROM debian:buster

# get required packages for ckan
RUN apt-get -q -y update && apt-get -q -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get -q -y install \ 
    python3.7-dev \
    python3-pip \
    python3-venv \
    git-core \
    supervisor \
    libpq-dev \
    libxml2-dev \
    libxslt-dev \
    gcc \
    make \
    g++ \
    autoconf \
    automake \
    libtool \
    && \
    apt-get -q clean 

ENV APP_DIR=/usr/lib/ckan/default
ENV CKAN_CONFIG=ckan.ini
ENV CKAN_STORAGE_PATH=/var/lib/ckan
ENV SRC_DIR=/usr/lib/ckan/default/src 
ENV ckan-pip=/usr/lib/ckan/default/bin/pip
ENV CKAN_CONFIG_PATH=/usr/lib/ckan/default/config/ckan.ini
ENV CKAN_GIT=https://github.com/ckan/ckan.git
ENV CKAN_VERSION=ckan-2.9.0
ENV CKAN_Site_Url="http://localhost"

# ARG SOLR_PATH
ARG DB_PATH


WORKDIR ${APP_DIR}

# create ckan core and config directories 
RUN mkdir -p ${APP_DIR} 
RUN mkdir -p ${APP_DIR}/config

# install and activate virtual env for ckan
RUN  cd ${APP_DIR} && \ 
    python3 -m venv ${APP_DIR} && \
    . ${APP_DIR}/bin/activate

# remember the venv for next runs
ENV PATH=${APP_DIR}/bin:${PATH}   

# upgrade venv pip and install setuptools
RUN cd ${APP_DIR} && \
    ${ckan-pip} install setuptools==44.1.0 && \
    ${ckan-pip} install --upgrade pip && \
    ${ckan-pip} install  lxml==4.6.3 && \
    ${ckan-pip} install  zope.interface==4.3.2
    
RUN which ${ckan-pip}

# Get CKAN + install the libraries 
RUN cd ${APP_DIR} && \  
    ${ckan-pip} install -e git+${CKAN_GIT}@${CKAN_VERSION}#egg=ckan && \ 
    ${ckan-pip} install uwsgi && \
    cd ${SRC_DIR}/ckan && \
    cp who.ini ${APP_DIR}/config && \
    ${ckan-pip} install -r  requirements.txt 


# Create the configuration
RUN cd ${APP_DIR} && \
    ckan generate config ${APP_DIR}/config/${CKAN_CONFIG} && \
    ckan config-tool ${CKAN_CONFIG_PATH} "ckan.site_url = ${CKAN_Site_Url}" && \
    ckan config-tool ${CKAN_CONFIG_PATH} sqlalchemy.url=postgresql://ckan:1234@db/ckan && \
    ckan config-tool ${CKAN_CONFIG_PATH} solr_url=http://solr:8983/solr/ckan && \ 
    ckan config-tool ${CKAN_CONFIG_PATH} ckan.max_resource_size=2000 && \
    ckan config-tool ${CKAN_CONFIG_PATH} ckan.auth.allow_dataset_collaborators=true && \
    ckan config-tool ${CKAN_CONFIG_PATH} ckan.site_id=default && \
    ckan config-tool ${CKAN_CONFIG_PATH} ckan.max_image_size=100 && \
    ckan config-tool ${CKAN_CONFIG_PATH} ckan.storage_path=${APP_DIR}/data && \
    ckan config-tool ${CKAN_CONFIG_PATH} ckan.webassets.path=${APP_DIR}/webassets && \
    ckan config-tool ${CKAN_CONFIG_PATH} ckan.redis.url=redis://redis:6379
 


# Copy all setup files
COPY ./setup ${APP_DIR}/config

# create the debian user for ckan
RUN groupadd ckan && \
    useradd -g ckan ckan

# Create local storage folder
RUN mkdir -p $CKAN_STORAGE_PATH && \
    chown -R ckan:ckan $CKAN_STORAGE_PATH

# Create entrypoint directory for children image scripts
ONBUILD RUN mkdir /docker-entrypoint.d

RUN chown ckan -R ${APP_DIR}
RUN chmod -R u=rwx,g=rwx ${APP_DIR}

# WSGI port
EXPOSE 8080  

RUN service supervisor restart
COPY ./setup/ckan-uwsgi.conf /etc/supervisor/conf.d/
RUN service supervisor start

# CMD ["service","supervisor", "start"]