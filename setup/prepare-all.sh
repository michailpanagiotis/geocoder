files=$(ls /data/*-docs.json)
mappingfile=/data/mapping
tmpmappingfile=/data/mapping.tmp

rm /data/*.bulk

if [ -f $mappingfile ]; then
    rm $mappingfile
fi

if [ -f $tmpmappingfile ]; then
    rm $tmpmappingfile
fi

for file in $files
do
    name=$(echo $file | sed 's/\/data\///g' | sed 's/-docs\.json//g')
    bulkjson=/data/$name.bulk
    echo "Preparing file $file..."
    cat $file | sed 's/"_id"/"_index": "combined", "_type": "combined", "_id"/g' > $bulkjson

    echo '"'$name'" : { "_source": { "excludes": [ "geometry" ] }, "properties" : { "geometry" : { "type" : "geo_shape" } } }' >> $tmpmappingfile
done

body=`cat $tmpmappingfile | sed -e "$ ! s/$/,/"`

echo '{ "mappings" : { '$body' } }' | jq '.' > $mappingfile

