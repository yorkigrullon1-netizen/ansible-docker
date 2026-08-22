FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    openssh-server \
    sudo \
    python3 && \
    mkdir /var/run/sshd

# Crear usuario ansible
RUN useradd -m -s /bin/bash ansible && \
    echo "ansible:ansible" | chpasswd && \
    usermod -aG sudo ansible && \
    echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Habilitar contraseña por SSH
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

COPY index.html /index.html
# Puertos SSH y Web
EXPOSE 22 10000

# Ejecutar SSH y servidor web
CMD ["sh", "-c", "python3 -m http.server 10000 --bind 0.0.0.0 & exec /usr/sbin/sshd -D"]