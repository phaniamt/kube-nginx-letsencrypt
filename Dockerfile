FROM ubuntu:18.04
RUN apt-get update -y && apt-get install certbot -y && apt-get install curl -y && apt-get clean all
COPY secret-patch-template.json /
COPY deployment-patch-template.json /
COPY entrypoint.sh /
CMD ["/entrypoint.sh"]
