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
    nano \
    gcc \
    make \
    g++ \
    autoconf \
    automake \
    libtool \
    && \
    apt-get -q clean 

ENV CKAN_CONFIG=ckan.ini
ENV SRC_DIR=/usr/lib/ckan/default/src 
ENV ckan-pip=/usr/lib/ckan/default/bin/pip
ENV CKAN_CONFIG_PATH=/usr/lib/ckan/default/config/ckan.ini
ENV CKAN_GIT=https://github.com/ckan/ckan.git
ENV CKAN_VERSION=ckan-2.9.0
ENV CKAN__PLUGINS='image_view text_view recline'
ENV CKAN_SQLALCHEMY_URL=postgresql://ckan:1234@db/ckan
ENV CKAN_SOLR_URL=http://solr:8983/solr/ckan


ARG APP_DIR
ARG CKAN_Site_Url
ARG DB_PATH
ARG SOLR_URL
ARG CKAN_MAX_RESOURCE_SIZE
ARG CKAN_MAX_IMAGE_SIZE
ARG ALLOW_COLLABORATION
ARG CKAN_SITE_ID
ARG REDIS_URL

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
    ckan config-tool ${CKAN_CONFIG_PATH} sqlalchemy.url=${DB_PATH} && \
    ckan config-tool ${CKAN_CONFIG_PATH} solr_url=${SOLR_URL} && \ 
    ckan config-tool ${CKAN_CONFIG_PATH} ckan.max_resource_size=${CKAN_MAX_RESOURCE_SIZE} && \
    ckan config-tool ${CKAN_CONFIG_PATH} ckan.auth.allow_dataset_collaborators=${ALLOW_COLLABORATION} && \
    ckan config-tool ${CKAN_CONFIG_PATH} ckan.site_id=${CKAN_SITE_ID} && \
    ckan config-tool ${CKAN_CONFIG_PATH} ckan.max_image_size=${CKAN_MAX_IMAGE_SIZE} && \
    ckan config-tool ${CKAN_CONFIG_PATH} ckan.storage_path=${APP_DIR}/data && \
    ckan config-tool ${CKAN_CONFIG_PATH} ckan.webassets.path=${APP_DIR}/webassets && \
    ckan config-tool ${CKAN_CONFIG_PATH} ckan.redis.url=${REDIS_URL}
 


# Copy all setup files
COPY ./setup ${APP_DIR}/config

# create the debian user for ckan
RUN groupadd ckan && \
    useradd -g ckan ckan

# Create local storage folder
RUN mkdir -p ${APP_DIR}/data 

# Create webassets folder
RUN mkdir -p ${APP_DIR}/webassets

# Create entrypoint directory for children image scripts
ONBUILD RUN mkdir /docker-entrypoint.d

RUN chown ckan -R ${APP_DIR}
RUN chmod -R u=rwx,g=rwx ${APP_DIR}

# WSGI port
EXPOSE 8080  

RUN service supervisor restart
COPY ./setup/ckan-uwsgi.conf /etc/supervisor/conf.d/

ENTRYPOINT ["/usr/lib/ckan/default/config/start_ckan.sh"]
