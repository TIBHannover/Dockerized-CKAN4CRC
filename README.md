# Dockerized CKAN4SFB

The dockerized CKAN for the SFB project. 


### current status:
- CKAN is ruuning without problem 

### Docker installation (ubuntu)

- docker engine: https://docs.docker.com/engine/install/ubuntu/

- docker compose: https://docs.docker.com/compose/install/

### Run

To run the application stack:

    > sudo docker-compose build
    > sudo docker-compose up -d  

To check the running services:

    > sudo docker ps

Example output:
![ckan-docker-ps](/uploads/473c813deb7ac501e9f5aa370091c67d/ckan-docker-ps.png)


To stop (Keep the volumes):

    > sudo docker-compose down

To stop (Delete the volumes):

    > sudo docker-compose down -v


### To-do

- Check the docker warnings  related to the Solr service

- install the needed plugin

- enable datapusher service

### References

- https://github.com/ckan/ckan-docker

- https://github.com/SDM-TIB/TIB_Data_Manager/tree/master/docker
