FROM ubuntu
RUN apt-get update
RUN apt-get install -y gdal-bin curl unrar jq less
WORKDIR /src
# RUN sh /src/download-all.sh
# ENTRYPOINT ["sh", "/src/setup-all.sh"]
CMD ["sh", "/src/setup-all.sh"]
# CMD ["tail", "-f", "/dev/null"]
