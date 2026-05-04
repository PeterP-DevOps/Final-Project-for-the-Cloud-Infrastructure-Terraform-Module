#cloud-config
users:
  - name: ${vm_user}
    groups: sudo,docker
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ${ssh_key}

package_update: true
package_upgrade: true

packages:
  - ca-certificates
  - curl
  - gnupg
  - lsb-release
  - git

write_files:
  - path: /opt/app/docker-compose.yml
    permissions: '0644'
    content: |
      version: "3.9"
      services:
        web:
          image: cr.yandex/crpeb81362mie6aq907d/webapp:latest
          container_name: webapp
          restart: unless-stopped
          ports:
            - "80:3000"
          environment:
            DB_HOST: ${mysql_host}
            DB_PORT: "${mysql_port}"
            DB_NAME: ${mysql_db}
            DB_USER: ${mysql_user}
            DB_PASSWORD: ${mysql_password}

runcmd:
  - install -m 0755 -d /etc/apt/keyrings
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  - chmod a+r /etc/apt/keyrings/docker.asc
  - echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu jammy stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  - apt-get update
  - apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  - systemctl enable docker
  - systemctl start docker
  - usermod -aG docker ${vm_user}
  - cd /opt/app && docker compose up -d
