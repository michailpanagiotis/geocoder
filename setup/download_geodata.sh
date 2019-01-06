if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit
fi


id=$1
name=$id
filename=$name.rar
geojson=/data/$name.geojson
docjson=/data/$name-docs.json
bulkjson=/data/$name.bulk
shapedir=/data/$name/
shapefile=$shapedir$name.shp
combined=/data/combined.json
archive=/data/$id.zip
link="http://geodata.gov.gr/geoserver/wfs/?service=WFS&version=1.0.0&request=GetFeature&typeName=geodata.gov.gr:$id&outputFormat=SHAPE-ZIP&srsName=epsg:2100"

echo "Downloading $name to $archive"

if [ ! -f $archive ]; then
  echo "File $archive not found, need to download"
  echo "Downloading $link..."
  curl -sS -o $archive $link
fi


if [ ! -d $shapedir ]; then
  echo "Unpacking..."
  unzip $archive -d $shapedir > /dev/null
fi

identifier=""
identifiers="KWD_YPES ESYE_ID NAME NAME_LATIN"

for col in $identifiers
do
    found=$(ogrinfo -al -so $shapedir/$name.shp | grep "^$col:")
    if [ ! -z "$found" ]; then
        identifier=$col
        break
    fi
done

if [ -z "$identifier" ]; then
    echo "No known identifier found in shapefile"
    exit
fi

echo "Using $identifier as identifier"

if [ ! -f "$geojson" ]; then
  # ogrinfo -al -so $name/$name.shp
  echo "Converting to GeoJSON '$geojson'..."

  SHAPE_ENCODING="ISO-8859-7" ogr2ogr -f GeoJSON -t_srs crs:84 $geojson -sql "select ST_UNION(GEOMETRY), * from '$name' group by $identifier" -dialect SQLITE $shapefile
fi


if [ ! -f "$docjson" ]; then
  echo "Splitting to features in '$docjson'..."
  jq -c '.features[] | {index: {"_id": (.properties.'$identifier' | @text | "'$name'_" + .) } }, {"ktype": "'$name'", properties, geometry}' $geojson > $docjson
fi

if [ ! -f "$bulkjson" ]; then
    echo "Preparing file $file..."
    cat $docjson | sed 's/"_id"/"_index": "combined", "_type": "combined", "_id"/g' > $bulkjson
fi

echo "Done"
