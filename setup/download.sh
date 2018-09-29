if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit
fi


url=$1
id=$(echo $url | grep -Po 'id=(([^&]*))' | sed 's/id=//g')
name=$(echo $url | grep -Po 'fname=(([^&]*))' | sed 's/fname=//g' | sed 's/.rar//g')
upper=$(echo $name | awk '{print toupper($0)}')
archive=/downloads/$name.rar
filename=$name.rar
geojson=/downloads/$name.geojson
bulkjson=/downloads/$name.json
shapedir=/downloads/$name/
shapefile=$shapedir$name.shp
combined=/downloads/combined.json

echo "Downloading $name to $archive"

if [ ! -f $archive ]; then
  echo "File $archive not found, need to download"
  echo "Downloading $url..."
  curl -sS -o $archive "http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=$id&fname=$filename&access=private"
fi


if [ ! -d $shapedir ]; then
  echo "Unpacking..."
  unrar e -y $archive $shapedir
fi

if [ ! -f "$geojson" ]; then
  SHAPE_ENCODING="ISO-8859-7"

  # ogrinfo -al -so $name/$name.shp
  echo "Converting to GeoJSON '$geojson'..."

  ogr2ogr -f GeoJSON -t_srs crs:84 $geojson -sql "select ST_UNION(GEOMETRY), * from $name group by $upper" -dialect SQLITE $shapefile
fi

if [ ! -f "$bulkjson" ]; then
  echo 'Splitting to features...'
  jq -c '.features[] | {index: {"_id": .properties.'$upper' } }, {properties, geometry}' $geojson > $bulkjson
fi

echo "Done"
