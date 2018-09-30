urls="
    http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=50&fname=kaldimen.rar&access=private
    http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=53&fname=kalperen.rar&access=private
    http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=47&fname=kalapokd.rar&access=private
    http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=52&fname=kalper.rar&access=private
    http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=49&fname=kaldim.rar&access=private
    http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=51&fname=kalgeoen.rar&access=private
"

lines="
    http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=48&fname=kalbnd.rar&access=private
"

for url in $urls
do
    sh /data/download.sh $url
done
