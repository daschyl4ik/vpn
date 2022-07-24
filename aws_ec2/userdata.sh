#!/bin/bash

#defining variables
user=vpn_admin
public_key=ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDErqz+hnUynRjFx8DALVAPVMAba361pFt1JtGGZo4kO6wO6BK8FPxcNx2gqZ9nesAnGB2QlNLBQNPrCFZulmzT+1Vaf5RaCiq14IBElYMkU96dlv8ZoKYdQ6z+sWJha+JpjLU5nSdMDNwQYjgApMZhCRyeESZd+j5OvVyi4t5QGA3eShkl9PtkLD3QxS94qn267pZL6RIaT0MQ/IJUvqBSBrG7K7ryNanTeiNcifkSD3seMP4hSdNQW5aFbw3Dw0n2fI8xPPcIsMqS43iMQs9l5boP3m8/zdhCNMIjQjeM9HmpuUNvpkFzja/P3z7bp5TlrHUsAD85XNZWoT2LGjDYRz1LwncQ7Z4tpMuTX1IAlw0NWu46ntQSYniY3Dp0cLlkSeQNe+aPt6eZfr9RkKycT+qr2mfhHjDqaq6IEldruhBhu9abBs+ZZgyo+gO0JJZxBjpOh4+0fdNKe+RvxphoThUladEoLLPSQkPa4eIkC8M+TFadZa1R+rhrrEDC/X8= root@DESKTOP-5FJLCSV
# Add user to wheel/sudo group
useradd -G wheel ${user} || useradd -G sudo ${user}
# Add public key and set up the user
mkdir -p /home/${user}/.ssh
cat <<EOF > /home/${user}/.ssh/authorized_keys
${public_key}
EOF
chown -R ${user}:${user} /home/${user}
echo "${user} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/100-ansible-users
chmod 0440 /etc/sudoers.d/100-ansible-users