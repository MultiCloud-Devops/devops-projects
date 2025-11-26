FROM amazonlinux
# MAINTAINER shiva
RUN yum update -y
RUN yum -y install python3-pip
RUN pip3 install boto3
RUN pip3 install requests
RUN yum install unzip -y
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
ENV GOLD_API_ACCESS_TOKEN = goldapi-fu8usmhqfsw05-io
# ARG GOLD_API_ACCESS_TOKEN
# ENV GOLD_API_ACCESS_TOKEN=${GOLD_API_ACCESS_TOKEN}
COPY config /root/.aws/
COPY credentials /root/.aws/

COPY code.py .
CMD ["python3","code.py"]