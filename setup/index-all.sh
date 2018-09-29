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
combined=/downloads/combined.bulk

echo 'Deleting old combined index...'

curl -sS -X DELETE "elasticsearch:9200/combined" > /dev/null
echo 'Creating new combined index...'

curl -sS -X PUT "elasticsearch:9200/combined" -H 'Content-Type: application/json' -d '
{
  "mappings" : {
    "combined" : {
      "_source": {
        "excludes": [
           "geometry"
        ]
      },
      "properties" : {
        "geometry" : { "type" : "geo_shape" }
      }
    }
  }
}
' > /dev/null

if [ ! -f $combined ]; then
    rm $combined
fi

for url in $urls
do
    sh /src/index.sh $url
done
