combined=/data/combined.bulk
files=$(ls /data/*.bulk)
# mappingfile=/data/mapping
#
# if [ ! -f $mappingfile ]; then
#     echo "Cannot find index mapping under $mappingfile"
#     exit
# fi
#
# mapping=`cat $mappingfile`


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


for file in $files
do
    echo "sending $file"
    curl -sS -X POST "elasticsearch:9200/_bulk" -H 'Content-Type: application/json' --data-binary '@'$file > /dev/null
done
