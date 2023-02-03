#!/bin/bash

# Run the prerun script to init CKAN and create the default admin user
sudo -u ckan -EH python3 prerun.py

# Run any startup scripts provided by images extending this one
if [[ -d "/docker-entrypoint.d" ]]
then
    for f in /docker-entrypoint.d/*; do
        case "$f" in
            *.sh)     echo "$0: Running init file $f"; . "$f" ;;
            *.py)     echo "$0: Running init file $f"; python3 "$f"; echo ;;
            *)        echo "$0: Ignoring $f (not an sh or py file)" ;;
        esac
        echo
    done
fi

# Set the common uwsgi options
UWSGI_OPTS="--plugins http,python \
            --socket /tmp/uwsgi.sock \
            --wsgi-file /srv/app/wsgi.py \
            --module wsgi:application \
            --uid 92 --gid 92 \
            --http 0.0.0.0:5000 \
            --master --enable-threads \
            --lazy-apps \
            -p 2 -L -b 32768 --vacuum \
            --harakiri $UWSGI_HARAKIRI"

if [ $? -eq 0 ]
then
    # Start supervisord
    supervisord --configuration /etc/supervisord.conf &
    # Start uwsgi
    sudo -u ckan -EH uwsgi $UWSGI_OPTS
else
  echo "[prerun] failed...not starting CKAN."
fi


#### Installing the needed extensions ###
cd /usr/lib/ckan/default/src/

# ckanext-multiuploader
git clone https://github.com/TIBHannover/ckanext-multiuploader.git
cd ckanext-multiuploader/
git checkout master
pip install -r requirements.txt
python setup.py develop
cd /usr/lib/ckan/default/src


# ckanext-Dataset-Reference
git clone https://github.com/TIBHannover/ckanext-Dataset-Reference.git
cd ckanext-Dataset-Reference/
git checkout main
pip install -r requirements.txt
python setup.py develop
cd /usr/lib/ckan/default/src


# ckanext-tif-imageview
git clone https://github.com/TIBHannover/ckanext-tif-imageview.git
cd ckanext-tif-imageview/
git checkout main
pip install -r requirements.txt
python setup.py develop
cd /usr/lib/ckan/default/src


# ckanext-organization-group
git clone https://github.com/TIBHannover/ckanext-organization-group.git
cd ckanext-organization-group/
git checkout main
pip install -r requirements.txt
python setup.py develop
cd /usr/lib/ckan/default/src


# ckanext-Cancel-Dataset-Creation
git clone https://github.com/TIBHannover/Ckanext-Cancel-Dataset-Creation.git
cd Ckanext-Cancel-Dataset-Creation/
git checkout master
pip install -r requirements.txt
python setup.py develop
cd /usr/lib/ckan/default/src


# ckanext-custom-dataset-metadata
git clone https://github.com/TIBHannover/ckanext-custom-dataset-metadata.git
cd ckanext-custom-dataset-metadata/
git checkout main
pip install -r requirements.txt
python setup.py develop
cd /usr/lib/ckan/default/src


# ckanext-feature-image
git clone https://github.com/TIBHannover/ckanext-feature-image.git
cd ckanext-feature-image/
git checkout main
pip install -r requirements.txt
python setup.py develop
mkdir -p /usr/lib/ckan/default/data/storage/uploads/admin 
cd /usr/lib/ckan/default/src


# ckanext-dataset-metadata-automation
git clone https://github.com/TIBHannover/ckanext-dataset-metadata-automation.git
cd ckanext-dataset-metadata-automation/
git checkout main
pip install -r requirements.txt
python setup.py develop
cd /usr/lib/ckan/default/src


# ckanext-close-for-guests
git clone https://github.com/TIBHannover/ckanext-close-for-guests.git
cd ckanext-close-for-guests/
git checkout main
pip install -r requirements.txt
python setup.py develop
cd /usr/lib/ckan/default/src


# Enable and configure all plugins
ckan config-tool /usr/lib/ckan/default/config/ckan.ini 'ckan.plugins=image_view text_view multiuploader dataset_reference tif_imageview organization_group cancel_dataset_creation custom_dataset_type feature_image dataset_metadata_automation close_for_guests'
ckan config-tool /usr/lib/ckan/default/config/ckan.ini 'ckan.views.default_views=image_view text_view recline_view pdf_view tif_imageview video_view'
ckan -c /usr/lib/ckan/default/config/ckan.ini db upgrade -p 'dataset_reference'

