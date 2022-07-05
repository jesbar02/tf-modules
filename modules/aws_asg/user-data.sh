#!/bin/bash

# Install SSM Agent
yum -y upgrade
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

# Set Nickname to the prompt
echo "export NICKNAME=${ecs_cluster_name}-node" > /etc/profile.d/prompt.sh

# Create and Configure Sudo Users
echo '%wheel  ALL=(ALL)       NOPASSWD: ALL' >> /etc/sudoers
ADMINS="${ec2_admin_users}"
for ADMIN in $ADMINS
do
  adduser $ADMIN
  usermod -aG docker $ADMIN
  usermod -aG wheel $ADMIN
  sudo -u $ADMIN mkdir /home/$ADMIN/.ssh
  chmod 700 /home/$ADMIN/.ssh
  curl -s https://github.com/$ADMIN.keys >> /home/$ADMIN/.ssh/authorized_keys
  echo 'export PS1="[\u@\$NICKNAME \W]\\$ "' > /home/$ADMIN/.bashrc
done

# Create a non-sudo user for developers
adduser developer
usermod -aG docker developer

DEVS="${ec2_dev_users}"
for DEV in $DEVS
do
  adduser $DEV
  usermod -aG docker $DEV
  sudo -u $DEV mkdir /home/$DEV/.ssh
  chmod 700 /home/$DEV/.ssh
  curl -s https://github.com/$DEV.keys >> /home/$DEV/.ssh/authorized_keys
  echo 'export PS1="[\u@\$NICKNAME \W]\\$ "' > /home/$DEV/.bashrc
done

# ECS Optimization Config
echo "ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=1h" >> /etc/ecs/ecs.config
echo "ECS_IMAGE_CLEANUP_INTERVAL=30m" >> /etc/ecs/ecs.config
echo "ECS_IMAGE_MINIMUM_CLEANUP_AGE=30m" >> /etc/ecs/ecs.config
echo "ECS_NUM_IMAGES_DELETE_PER_CYCLE=10" >> /etc/ecs/ecs.config
echo "ECS_RESERVED_MEMORY=512" >> /etc/ecs/ecs.config
echo "ECS_CLUSTER=${ecs_cluster_name}" >> /etc/ecs/ecs.config

# CloudWatch Agent Installation and Configuration
curl https://s3.${aws_region}.amazonaws.com/amazoncloudwatch-agent-${aws_region}/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm -o /tmp/amazon-cloudwatch-agent.rpm
rpm -U /tmp/amazon-cloudwatch-agent.rpm

cat > /opt/aws/amazon-cloudwatch-agent/bin/config.json <<EOL
{
        "agent": {
                "metrics_collection_interval": 60,
                "run_as_user": "cwagent"
        },
        "metrics": {
                "append_dimensions": {
                        "AutoScalingGroupName": "\$${aws:AutoScalingGroupName}",
                        "ImageId": "\$${aws:ImageId}",
                        "InstanceId": "\$${aws:InstanceId}",
                        "InstanceType": "\$${aws:InstanceType}"
                },
                "metrics_collected": {
                        "mem": {
                                "measurement": [
                                        "mem_used_percent"
                                ],
                                "metrics_collection_interval": 60
                        },
                        "swap": {
                                "measurement": [
                                        "swap_used_percent"
                                ],
                                "metrics_collection_interval": 60
                        }
                }
        }
}
EOL
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
