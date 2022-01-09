# 基础镜像
FROM ubuntu:latest
RUN apt-get update && apt-get install wget -y
RUN wget --no-check-certificate https://raw.githubusercontent.com/cocoyunxyz/crack-soga/main/install.sh && chmod +x install.sh
RUN bash install.sh

ENTRYPOINT [ "/usr/local/soga/soga"]