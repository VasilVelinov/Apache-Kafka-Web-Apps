# Install Docker dependencies
docker-deps:
  pkg.installed:
    - pkgs:
      - yum-utils
      - device-mapper-persistent-data
      - lvm2

# Add Docker repository
docker-repo:
  cmd.run:
    - name: yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker
docker:
  pkg.installed:
    - name: docker-ce
    - require:
      - pkg: docker-deps
      - cmd: docker-repo

# Enable and start Docker service
docker-service:
  service.running:
    - name: docker
    - enable: True
    - require:
      - pkg: docker

# Add user to docker group
docker-group:
  cmd.run:
    - name: sudo usermod -aG docker vagrant