#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -x

echo "Executing User_Data In dev"

# Update and install Java
yum update -y
yum install java-11-amazon-corretto -y

# Create log directory
mkdir -p /var/log/app/
chown ec2-user:ec2-user /var/log/app/

cd /home/ec2-user

# Download Spring Boot application JAR from S3
aws s3 cp s3://cfp-be-app-bkt/datastore-0.0.7.jar .

# Set proper permissions on the JAR
chmod 755 datastore-0.0.7.jar

# Define environment variables and start the app
MYSQL_HOST=jdbc:mysql://cfp-rds-db.cyxucgq0ecx9.us-east-1.rds.amazonaws.com:3306/datastore?createDatabaseIfNotExist=true \
MYSQL_USERNAME=admin \
MYSQL_PASSWORD=Adminpassword123 \
LOG_FILE_PATH=/var/log/app/datastore.log \
nohup java -jar /home/ec2-user/datastore-0.0.7.jar > /var/log/app/nohup.out 2>&1 &

# Install CloudWatch Agent
yum install -y amazon-cloudwatch-agent

# Create CloudWatch Agent configuration file (logs + metrics)
cat << EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "agent": {

    "metrics_collection_interval": 60,

    "run_as_user": "root"

  },

  "metrics": {

    "namespace": "DatastoreBEAppMetrics",

    "metrics_collected": {

      "cpu": {

        "measurement": [

          "cpu_usage_idle",

          "cpu_usage_system",

          "cpu_usage_user"

        ],

        "resources": ["*"],

        "total": false

      },

      "mem": {

        "measurement": [

          "mem_used_percent",

          "mem_available_percent"

        ]

      },

      "disk": {

        "measurement": [

          "disk_used_percent",

          "disk_inodes_free"

        ],

        "resources": ["/"]

      },

      "netstat": {

        "measurement": [

          "tcp_established",

          "tcp_time_wait"

        ]

      }

    }

  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/app/datastore.log",
            "log_group_name": "/datastore/app",
            "log_stream_name": "{instance_id}",
            "timestamp_format": "%Y-%m-%d %H:%M:%S"
          }
        ]
      }
    }
  }
}
EOF

# Start CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s