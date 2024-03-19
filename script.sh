#!/bin/bash
database() {
    read -p "Enter the application:" service
    status=$(systemctl is-active $service)
    if [ $status == "inactive" ]
then
    echo "your service is not installed"
    sudo dnf install $service -y
    sudo systemctl enable --now $service
    sudo firewall-cmd --add-port=80/tcp --permanent
    sudo firewall-cmd --reload
    sudo sed -i s/local/"all granted"/g /etc/httpd/conf.d/phpMyAdmin.conf
    sudo systemctl restart httpd
    sudo systemctl restart mysql-server
    sudo mysql -u root -p -e 'alter user "root"@"localhost" identified by "redhat";flush privileges;'
    sudo setenforce 0
    getenforce
    echo "done"
    fi    
}
database "httpd"
database "mysql-server"
database "phpmyadmin"