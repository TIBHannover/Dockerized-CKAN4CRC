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



# Enable and configure all plugins
ckan config-tool /usr/lib/ckan/default/config/ckan.ini 'ckan.plugins=image_view text_view multiuploader dataset_reference tif_imageview organization_group cancel_dataset_creation custom_dataset_type feature_image dataset_metadata_automation'
ckan config-tool /usr/lib/ckan/default/config/ckan.ini 'ckan.views.default_views=image_view text_view recline_view pdf_view tif_imageview video_view'
ckan -c /usr/lib/ckan/default/config/ckan.ini db upgrade -p 'dataset_reference'


# change storage permission
chown ckan:root -R /usr/lib/ckan/default/data/
chmod g=rwx -R /usr/lib/ckan/default/data/

# start ckan wsgi
/etc/init.d/supervisor start

# this keeps the container running
tail -f /dev/null


