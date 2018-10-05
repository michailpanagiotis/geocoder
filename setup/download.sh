if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit
fi


url=$1
id=$(echo $url | grep -Po 'id=(([^&]*))' | sed 's/id=//g')
name=$(echo $url | grep -Po 'fname=(([^&]*))' | sed 's/fname=//g' | sed 's/.rar//g')
upper=$(echo $name | awk '{print toupper($0)}')
archive=/data/$name.rar
filename=$name.rar
geojson=/data/$name.geojson
docjson=/data/$name-docs.json
bulkjson=/data/$name.bulk
shapedir=/data/$name/
shapefile=$shapedir$name.shp
combined=/data/combined.json

echo "Downloading $name to $archive"

if [ ! -f $archive ]; then
  echo "File $archive not found, need to download"
  echo "Downloading $url..."
  curl -sS -o $archive "http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=$id&fname=$filename&access=private"
fi


if [ ! -d $shapedir ]; then
  echo "Unpacking..."
  unrar e -y $archive $shapedir > /dev/null
fi

if [ ! -f "$geojson" ]; then
  # ogrinfo -al -so $name/$name.shp
  echo "Converting to GeoJSON '$geojson'..."

  SHAPE_ENCODING="ISO-8859-7" ogr2ogr -f GeoJSON -t_srs crs:84 $geojson -sql "select ST_UNION(GEOMETRY), * from $name group by $upper" -dialect SQLITE $shapefile
fi

if [ ! -f "$docjson" ]; then
  echo "Splitting to features in '$docjson'..."
  jq -c '.features[] | {index: {"_id": (.properties.'$upper' | @text | "'$name'_" + .) } }, {"ktype": "'$name'", properties, geometry}' $geojson > $docjson
fi

if [ ! -f "$bulkjson" ]; then
    echo "Preparing file $file..."
    cat $docjson | sed 's/"_id"/"_index": "combined", "_type": "combined", "_id"/g' > $bulkjson
fi

echo "Done"
