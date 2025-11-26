# Use Amazon Linux 2 (stable for AWS CLI v2)
FROM amazonlinux:2

# Install dependencies and AWS CLI v2
RUN yum update -y && \
    yum install -y unzip curl less groff python3 && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
    unzip /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/aws /tmp/awscliv2.zip && \
    yum clean all

# Create directory for shared volume
RUN mkdir -p /data

WORKDIR /data

# Inline entrypoint with aws s3 cp
ENTRYPOINT ["/bin/bash", "-c", "\
if [ -z \"$AWS_ACCESS_KEY_ID\" ] || [ -z \"$AWS_SECRET_ACCESS_KEY\" ] || [ -z \"$S3_BUCKET_NAME\" ]; then \
  echo 'Error: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY or S3_BUCKET_NAME not set.'; \
  exit 1; \
fi; \
echo 'Starting S3 copy...'; \
aws s3 cp s3://$S3_BUCKET_NAME /data --recursive; \
echo 'S3 copy completed successfully.'; \
"]
