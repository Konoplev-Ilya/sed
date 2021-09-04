first=$(curl -s -u $1:$2  -d "_search=false&nd=1630308756315&rows=10000&page=1&sidx=regdt&sord=asc&dateFilterTo=01.08.2021&search=true" -X POST "http://198.19.0.6/csp/$3/json.pcrec.cls")
docs_id_on_page=$(echo $first | jq .rows[].id | sed -e "s/^.//;s/.$//")
for a in $docs_id_on_page
do
curl -s -u $1:$2 -d "oper=viewed&id=$a" -X GET http://198.19.0.6/csp/$3/json.pcrec.cls
echo ''