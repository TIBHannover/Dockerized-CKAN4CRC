#!/bin/bash

# activate the python venv for ckan
source bin/activate

# initiate the ckan DB
ckan -c /usr/lib/ckan/default/config/ckan.ini db init

# add admin user
ckan -c /usr/lib/ckan/default/config/ckan.ini user add admin email=admin@example.com name=admin password=11111111

ckan -c /usr/lib/ckan/default/config/ckan.ini sysadmin add admin
# create search index
ckan -c /usr/lib/ckan/default/config/ckan.ini search-index rebuild

#### Installing the needed extensions ###
cd /usr/lib/ckan/default/src/

# ckanext-multiuploader
git clone https://github.com/TIBHannover/ckanext-multiuploader.git
cd ckanext-multiuploader/
git checkout main
pip install -r requirements.txt
python setup.py develop
ckan config-tool /usr/lib/ckan/default/config/ckan.ini ckan.plugins='image_view text_view multiuploader'
cd /usr/lib/ckan/default/src


# ckanext-Dataset-Reference
git clone https://github.com/TIBHannover/ckanext-Dataset-Reference.git
cd ckanext-Dataset-Reference/
git checkout main
pip install -r requirements.txt
python setup.py develop
ckan config-tool /usr/lib/ckan/default/config/ckan.ini ckan.plugins='image_view text_view multiuploader dataset_reference'
ckan -c /usr/lib/ckan/default/config/ckan.ini db upgrade -p 'dataset_reference'
cd /usr/lib/ckan/default/src

# ckanext-tif-imageview
git clone https://github.com/TIBHannover/ckanext-tif-imageview.git
cd ckanext-tif-imageview/
git checkout main
pip install -r requirements.txt
python setup.py develop
ckan config-tool /usr/lib/ckan/default/config/ckan.ini ckan.plugins='image_view text_view multiuploader dataset_reference tif_imageview'
ckan config-tool /usr/lib/ckan/default/config/ckan.ini ckan.views.default_views = 'image_view text_view recline_view pdf_view tif_imageview video_view'
cd /usr/lib/ckan/default/src



# change storage permission
chown ckan:root -R /usr/lib/ckan/default/data/
chmod g=rwx -R /usr/lib/ckan/default/data/

# start ckan wsgi
service supervisor start

# this keeps the container running
tail -f /dev/null


