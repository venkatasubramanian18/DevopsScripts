#First, you need to add Elastic’s signing key so that the downloaded package can be verified 
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

#For Debian, we need to then install the apt-transport-https package:
sudo apt-get update
sudo apt-get install apt-transport-https

#The next step is to add the repository definition to your system
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

#All that’s left to do is to update your repositories and install Elasticsearch:
sudo apt-get update && sudo apt-get install elasticsearch

#Elasticsearch configurations are done using a configuration file (On Linux: /etc/elasticsearch/elasticsearch.yml)that allows you to configure general settings (e.g. node name), as well as network settings (e.g. host and port), where data is stored, memory, log files, and more.
sudo su
vim /etc/elasticsearch/elasticsearch.yml

#Since we are installing Elasticsearch on Azure, we will bind Elasticsearch to localhost. Also, we need to define the private IP of our Azure VM (you can get this IP from the VMs page in the console) as a master-eligible node:
network.host: "localhost"
http.port:9200
cluster.initial_master_nodes: ["<PrivateIP"]

#Save the file and run Elasticsearch with:
sudo service elasticsearch start

#for allowing port access
sudo ufw allow from external_IP to any port 9200

#to check the status of ELK
service elasticsearch status

#For restarting
sudo systemctl restart elasticsearch.service

#For starting
sudo systemctl start elasticsearch.service

#For stopping
sudo systemctl stop elasticsearch.service

#Installing Logstash
#Logstash requires Java 8 or Java 11 to run so we will start the process of setting up Logstash with:
sudo apt-get install default-jre

#Since we already defined the repository in the system, all we have to do to install Logstash is run:
sudo apt-get install logstash

#Installing Kibana
#As before, we will use a simple apt command to install Kibana:
sudo apt-get install kibana

#Open up the Kibana configuration file at: /etc/kibana/kibana.yml, and make sure you have the following configurations defined:
server.port: 5601
elasticsearch.url: "http://localhost:9200"

#Now, start Kibana with:
sudo service kibana start

#to see the logs
journalctl -u kibana.service

#to clear the logs
journalctl --vacuum-time=1s

