---
description: >-
  Here’s a complete step-by-step guide to installing Docker and Docker Compose
  on Ubuntu 22.04
---

# Docker and Docker Compose Setup



Step 1: Update the Package Index

Open your terminal and run the following command to update your package index:

```bash
sudo apt update
```

#### Step 2: Install Required Packages

Install the necessary packages that allow `apt` to use packages over HTTPS:

```bash
sudo apt install apt-transport-https ca-certificates curl software-properties-common
```

#### Step 3: Add Docker’s Official GPG Key

Download and add Docker’s GPG key using the recommended method:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/docker.gpg > /dev/null
```

#### Step 4: Add the Docker Repository

Add the Docker repository to your system:

```bash
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

#### Step 5: Update the Package Index Again

After adding the Docker repository, update the package index again:

```bash
sudo apt update
```

#### Step 6: Install Docker

Now, install Docker:

```bash
sudo apt install docker-ce
```

#### Step 7: Start and Enable Docker

Start the Docker service and enable it to run on startup:

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

#### Step 8: Verify Docker Installation

Check if Docker is installed correctly by running:

```bash
sudo docker --version
```

You should see the installed version of Docker.

#### Step 9: Install Docker Compose

1.  **Download the Latest Version of Docker Compose**:

    Find the latest version from the [Docker Compose GitHub releases page](https://github.com/docker/compose/releases). As of now, you can use the following command (replace `v2.14.2` with the latest version if needed):

    ```bash
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.14.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    ```
2.  **Apply Executable Permissions**:

    Make the Docker Compose binary executable:

    ```bash
    sudo chmod +x /usr/local/bin/docker-compose
    ```
3.  **Verify Docker Compose Installation**:

    Check if Docker Compose is installed correctly by running:

    ```bash
    docker-compose --version
    ```

You should see the installed version of Docker Compose.

#### Step 10: Manage Docker as a Non-root User (Optional)

If you want to run Docker commands without `sudo`, you can add your user to the `docker` group:

1.  **Add Your User to the Docker Group**:

    Replace `username` with your actual username if you're specifying it:

    ```bash
    sudo usermod -aG docker $USER
    ```
2.  **Log Out and Back In**:

    Log out of your current session and back in to apply the group change. Alternatively, you can run:

    ```bash
    newgrp docker
    ```

####
