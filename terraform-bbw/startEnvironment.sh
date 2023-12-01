#!/bin/bash

# Parsing the JSON outputs
DATABASE_ENDPOINT=$(jq -r '.database_endpoint.value' outputs.json)
DATABASE_PORT=$(jq -r '.database_port.value' outputs.json)
WEB_PUBLIC_IP=$(jq -r '.web_public_ip.value' outputs.json)

#modify the hosts file to add the new public ip of the ec-2 instance
echo "[ec-2]" > ansible/hosts
echo "jokesHost   ansible_host=$WEB_PUBLIC_IP   ansible_user=ubuntu" >> ansible/hosts

#modfiy the application.properties which is used by the jokes db


echo "## MariaDB settings
spring.datasource.url=\${DB_URL:jdbc:mariadb://$DATABASE_ENDPOINT:3306/mariadb}
spring.datasource.username=\${DB_USERNAME:admin}
spring.datasource.password=\${DB_PASSWORD:mypassword}
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
spring.datasource.driver-class-name=org.mariadb.jdbc.Driver

# Initialization of database data
spring.sql.init.mode=always" > ansible/application.properties


# Running the Ansible playbook with extracted variables
ansible-playbook -i hosts ansible/main.yml --extra-vars "database_endpoint=$DATABASE_ENDPOINT database_port=$DATABASE_PORT web_public_ip=$WEB_PUBLIC_IP"
