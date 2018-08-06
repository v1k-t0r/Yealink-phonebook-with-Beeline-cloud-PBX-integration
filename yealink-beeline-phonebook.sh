#!/bin/bash

# Export departments to file
echo "0....Exporting departments"
curl -s -X GET --header 'X-MPBX-API-AUTH-TOKEN: $YOUR_TOKEN_THERE' 'https://cloudpbx.beeline.ru/apis/portal/abonents' | jq -r 'unique_by(.department)|.[]|.department' > /tmp/dep1
# Make array
cat /tmp/dep1 | tr '\n' ',' > /tmp/dep2
t=$(cat /tmp/dep2)
a=($(echo "$t" | tr ' ' '_' | tr ',' '\n'))

# Export data to file 
echo "1....Exporting data"
curl -s -X GET --header 'X-MPBX-API-AUTH-TOKEN: $YOUR_TOKEN_THERE' 'https://cloudpbx.beeline.ru/apis/portal/abonents' | jq -c '.[] | {ext: .extension, dep: .department, ln: .lastName, fn: .firstName}' > /tmp/exp1
echo "2....Tidying up content"
# Remove all garbage
sed -e 's/\"//g; s/{//g; s/}//g; s/ext://g; s/dep://g; s/ln://g; s/fn://g' /tmp/exp1 > /tmp/exp2

echo "3....Generating XML"
file_in="/tmp/exp2"
file_out="/tmp/exp.xml"
echo '<?xml version="1.0"?>' > $file_out
echo '<YealinkIPPhoneBook>' >> $file_out
echo '<Title>Yealink</Title>' >> $file_out
for element in "${a[@]}"
do
#replace _ with space
b=$(echo "$element" | tr '_' ' ')
if [[ $b != null ]]; then
	echo '  <Menu Name="'$b'">' >> $file_out
fi
while IFS=$',' read -r -a arry
do
if [[ $b = ${arry[1]} && $b != null ]]; then
	#check for emty firstName
	if [[ ${arry[3]} == null ]]; then
		ln=''
		else ln=${arry[3]}
	fi
	#check for extensions < 444
	if [[ ${arry[0]} < 444 ]]; then
		echo '    <Unit Name="'${arry[2]} $ln'" Phone1="'${arry[0]}'"/>' >> $file_out
	fi
fi
done < $file_in
if [[ $b != null ]]; then
	echo '  </Menu>' >> $file_out
fi
done
echo '</YealinkIPPhoneBook>' >> $file_out

echo "4....Copying phonebook to /var/www/html/phonebook.xml"
cp /tmp/exp.xml /var/www/html/phonebook.xml
echo "5....Fixing permissions"
chmod 644 /var/www/html/phonebook.xml

echo "6....Tidying up"
# tidying up
#rm /tmp/exp* -f

echo ""
echo ""
echo "    Export complete!!"
