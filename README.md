The infrastructure is fully automated. Using the command vagrant up we get everything working. For Configuration Management’s I have chosen Salt for Docker Machine and Ansible for Web and Db machines. For middleware I have chosen Apache Kafka. Let’s take a look of the file structure provided with the zip file.
 
Containers Machine
The Containers Machine is provisioned with two shell scripts, with which Salt Master and Minion are installed. Scripts are located in zip file in folder bash_scripts.


After Salt is installed, the corresponding docker.sls and terraform.sls files are called in the setup_salt_master.sh file. Docker.sls installs Docker and all needed dependencies and adds vagrant user to the docker group.

Terraform.sls file installs Terraform on the Docker machine and then runs terraform , which creates all needed containers for Apache Kafka-Server, Zookeeper, Kafka-Discoverer and Kafka-Observer . Also it spins up container for Prometheus and Grafana. 

Now Lets dive into the terraform structure itself, file by file.

Main.tf  -> Creates a private network for the container to work with. Pulls the images for Zookeeper and Kafka. Creates the container. Here I have added a slam resource time_sleep, because Kafka need a few seconds to spin up after the container is up and running.

Kafka-app.tf -> Pulls images for Kafka-Discoverer and Kafka-Observer, than creates the containers.

Kafka-exporter.tf -> Pulls  image for Kafka-exporter and runs the container.

Monitoring.tf -> Pulls the images for Prometheus and Grafana and runs the containers. Here the Prometheus container has a volume that gets a config file for configuring the jobs for monitoring. File is located in zip file in terraform/config folder.

Grafana container also uses a volume for configuring the data source. File is located in the same folder.

After Salt is ready, all that is left is to make a simple dashboard in Grafana. To do this simply go to dashboard panel, click on the drop-down menu, select Import. Upload the dashboard.json file located in terraform/config folder of the zip. Click import and the dashboards with a simple visualization will appear.


After the containers are up and running we can see that, the discoverer and observer are working as follows. 
For discoverer , we can check the container logs. Using the command docker logs kafka-discoverer (Don’t forget to log to the containers machine first, using vagrant ssh containers)

For observer , we  can log on http://192.168.56.100:80 and wee see the job.

Web and Db Machines

For this part, we have two machines. The Db machine is CentOS and the web machine is Debian-11. Vagrant will only create the Db machine. Ansible is installed on the Web machine, using a bash script located at bash_scripts/setup_ansible.sh folder in the zip file.

In folder ansible we have all the necessary files for our playbook.

main.yml → Decides what to install on which machine based on the os_family. Also adds the IP of the Web and Db Machine to the etc/hosts file , so that the machines can reach each other by name.

redhat.yml → On the Db Machine that is CentOS. Installs MariaDb and creates the Db tables for our two apps.

debian.yml → On the Web Machine that is Debian-11 based. Installs apache2 – PhP – git. Sets up all necessary configurations for the two apps. 


After ansible is ready, we can see our apps on the following addresses : 

App2 → http://192.168.56.101:8001

App4 → http://192.168.56.101:8002

