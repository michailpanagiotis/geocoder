if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit
fi


url=$1
id=$(echo $url | grep -Po 'id=(([^&]*))' | sed 's/id=//g')
name=$(echo $url | grep -Po 'fname=(([^&]*))' | sed 's/fname=//g' | sed 's/.rar//g')
upper=$(echo $name | awk '{print toupper($0)}')
archive=$name.rar
bulkjson=/downloads/$name.json

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

curl -sS -X POST "elasticsearch:9200/_bulk" -H 'Content-Type: application/json' --data-binary '@'$bulkjson > /dev/null

echo 'Copying to combined...'

curl -sS -X POST "elasticsearch:9200/_reindex" -H 'Content-Type: application/json' -d '
{
  "source": {
    "index" : "'$name'"
  },
  "dest": {
    "index" : "combined",
    "version_type": "external"
  }
}
'
