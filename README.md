# Dockerized CKAN4SFB

The dockerized CKAN for the SFB project. 


### current status:
- CKAN is ruuning without problem 

### Run

To run the application stack:

    > sudo docker-compose build
    > sudo docker-compose up -d  

To check the running services:

    > sudo docker ps

Example output:
![docker ps screenshot](/home/pooya/Pictures/ckan/ckan-docker-ps.png)


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
