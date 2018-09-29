FROM ubuntu
RUN apt-get update
RUN apt-get install -y gdal-bin curl unrar jq less

ADD http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=50&fname=kaldimen.rar&access=private /data/kaldimen.rar
ADD http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=53&fname=kalperen.rar&access=private /data/kalperen.rar
ADD http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=47&fname=kalapokd.rar&access=private /data/kalapokd.rar
ADD http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=52&fname=kalper.rar&access=private /data/kalper.rar
ADD http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=49&fname=kaldim.rar&access=private /data/kaldim.rar
ADD http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=51&fname=kalgeoen.rar&access=private /data/kalgeoen.rar

WORKDIR /src
# RUN sh /src/download-all.sh
# ENTRYPOINT ["sh", "/src/setup-all.sh"]
# CMD ["sh", "/src/setup-all.sh"]
CMD ["tail", "-f", "/dev/null"]
