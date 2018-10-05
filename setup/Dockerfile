FROM ubuntu
RUN apt-get update
RUN apt-get install -y gdal-bin curl unrar jq less

RUN mkdir -p /data

COPY download.sh /data/download.sh
COPY download-all.sh /data/download-all.sh
COPY prepare-all.sh /data/prepare-all.sh

RUN sh /data/download-all.sh
RUN sh /data/prepare-all.sh

WORKDIR /src
# RUN sh /src/download-all.sh
# ENTRYPOINT ["sh", "/src/setup-all.sh"]
CMD ["sh", "/src/index-all.sh"]
# CMD ["tail", "-f", "/dev/null"]
