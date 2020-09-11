#!/bin/bash

db_host="prod-speed-db.chunabzh2gmi.eu-west-1.rds.amazonaws.com"
db_port="5432"
db_name="speed_db"
db_user="dba_admin"
db_pass="dba_admin"
db_schema="public"

echo "input_release: 2020.06.006"
echo "input_countries: DEU,POL"

export PGPASSWORD=$db_pass

echo "-------------------------------------"
echo "ISO,SPimportId,PSPimportId"
IFS=',' 
read -ra COUNTRY <<< "DEU,POL"
for iso in "${COUNTRY[@]}"; do
    
    sql_psp="SELECT id FROM public.import_run WHERE zone = '${iso}' AND sourcetype = 'psp' AND release = '2020.06.006' limit 1";
	sql_sp="SELECT id FROM public.import_run WHERE zone = '${iso}' AND sourcetype = 'sp' AND release = '2020.06.006' limit 1";

	psp_import_id=$(psql -qtAX -U $db_user -h $db_host -p $db_port -d $db_name -c "$sql_psp")
	sp_import_id=$(psql -qtAX -U $db_user -h $db_host -p $db_port -d $db_name -c "$sql_sp")
    
    echo "$iso,$sp_import_id,$psp_import_id"
done
echo "-------------------------------------"
