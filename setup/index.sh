if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit
fi


docsjson=$1
name=$(echo $1 | sed 's/\/data\///g' | sed 's/\.json//g')
bulkjson=/data/$name.bulk
bulkcombined=/data/combined.bulk

echo "Indexing $name"

echo 'Deleting old index...'

curl -sS -X DELETE "elasticsearch:9200/$name" > /dev/null

echo 'Creating index...'

curl -sS -X PUT "elasticsearch:9200/$name" -H 'Content-Type: application/json' -d '
{
  "mappings" : {
    "'$name'" : {
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


echo 'Indexing...'
curl -sS -X POST "elasticsearch:9200/_bulk" -H 'Content-Type: application/json' --data-binary '@'$bulkjson
