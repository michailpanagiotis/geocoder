if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit
fi

curl -sS -X GET "elasticsearch:9200/$name/_search" -H 'Content-Type: application/json' --data-binary '
{
    "query":{
        "bool": {
            "must": {
                "match_all": {}
            },
            "filter": {
                "geo_shape": {
                    "geometry": {
                        "shape": {
                            "type": "point",
                            "coordinates" : ['$2', '$1']
                        },
                        "relation": "contains"
                    }
                }
            }
        }
    }
}' | jq .
