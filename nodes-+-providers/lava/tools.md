# Useful Tools

*   [Webmin](https://webmin.com/download/) is a web-based system administration tool for Unix-like servers, and services that can used to configure operating system internals, such as users, disk quotas, services or configuration files, as well as modify, and control open-source apps, such as BIND DNS Server, Apache HTTP Server, PHP, MySQL, and many more.\


    ```
    curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
    sudo sh setup-repos.sh
    # follow next prompt to install
    ```
*   [NCDU](https://ostechnix.com/check-disk-space-usage-linux-using-ncdu/) is a simple and fast disk usage analyzer which is used to find which directories or files are taking up more space either on a local or remote systems.\


    ```
    sudo apt install ncdu

    # replace / = path you want to check
    ncdu -x /
    ```
* [Prometheus](https://prometheus.io/docs/introduction/overview/) is an open-source systems monitoring and alerting toolkit with an active ecosystem. It is the only system directly supported by Kubernetes and the de facto standard across the cloud native ecosystem.
