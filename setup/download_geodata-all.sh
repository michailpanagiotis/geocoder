urls="
    http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=50&fname=kaldimen.rar&access=private
    http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=53&fname=kalperen.rar&access=private
    http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=47&fname=kalapokd.rar&access=private
    http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=52&fname=kalper.rar&access=private
    http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=49&fname=kaldim.rar&access=private
    http://www1.okxe.gr/geonetwork/srv/en/resources.get?id=51&fname=kalgeoen.rar&access=private
"

ids="
    c7b5978b-aca9-4d74-b8a5-d3a48d02f6d0
    e81089cb-f48c-4c5b-ac77-aa3028fe31fb
    970c9267-5b4e-424b-9092-91bc919d4c8b
    63e36888-df02-42df-ae02-b6c0cc7aa093
    0adb0521-2223-43cd-96d3-d816ad7a193c
"

for id in $ids
do
    sh /data/download_geodata.sh $id
done
