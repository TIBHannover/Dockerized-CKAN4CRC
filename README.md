# Dockerized CKAN4CRC

The dockerized CKAN for the CRC (SFB) project. 


### Docker installation (ubuntu)

- docker engine: https://docs.docker.com/engine/install/ubuntu/

- docker compose: https://docs.docker.com/compose/install/

### Run

To run the application stack (inside the application root directory): 

    > sudo docker-compose build
    > sudo docker-compose up -d  

--> **After that open**: http://localhost:8001


**To check the running services:**

    > sudo docker ps

Example output:
![ckan-docker-ps](/uploads/473c813deb7ac501e9f5aa370091c67d/ckan-docker-ps.png)


**To access to the ckan servive bash:**
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

- install the needed plugin

- enable datapusher service

### References

- https://github.com/ckan/ckan-docker

- https://github.com/SDM-TIB/TIB_Data_Manager/tree/master/docker
