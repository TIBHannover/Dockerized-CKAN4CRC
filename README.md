# Dockerized CKAN4CRC

The dockerized CKAN for the CRC (SFB) project. 

**Included CKAN Plugins**

- `multiuploader`: 
https://github.com/TIBHannover/ckanext-multiuploader

- `tif_imageview`:
https://github.com/TIBHannover/ckanext-tif-imageview

- `dataset_reference`:
https://github.com/TIBHannover/ckanext-Dataset-Reference

- `user_manual`
https://github.com/TIBHannover/ckanext-sfb-layout

- `feature_image`
https://github.com/TIBHannover/ckanext-sfb-layout

- `cancel_dataset_creation`
https://github.com/TIBHannover/Ckanext-Cancel-Dataset-Creation

- `organization_group`
https://github.com/TIBHannover/ckanext-organization-group


### Docker installation (ubuntu)

- docker engine: https://docs.docker.com/engine/install/ubuntu/

- docker compose: https://docs.docker.com/compose/install/

### Run

To run the application stack (inside the application root directory): 

    > sudo docker-compose build
    > sudo docker-compose up -d  

--> **After that open**: http://localhost:8001

**Note** It may takes some time before the ckan become fully functional. You may need to refresh the ckan page a couple of times. This is a time that ckan needs to install plugins and for configuration. 


**To check the running services:**

    > sudo docker ps

Example output:
![ckan-docker-ps](/uploads/473c813deb7ac501e9f5aa370091c67d/ckan-docker-ps.png)


**To access to the ckan service bash:**
(for using the ckan CLI commands)

    > sudo docker exec -it ckan bash

Example CLI:

    container:APP_DIR> source bin/activate
    # create test data
    container:APP_DIR> ckan -c config/ckan.ini seed basic


**To stop (Keep the volumes):**

    > sudo docker-compose down

**To stop (Delete the volumes):**

    > sudo docker-compose down -v


### To-do

- setup the worker

- enable datapusher service

### References

- https://github.com/ckan/ckan-docker

- https://github.com/SDM-TIB/TIB_Data_Manager/tree/master/docker
