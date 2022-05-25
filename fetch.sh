unset token
token=''
counter=0
res=''
echo "EmailAddress, LastUpdateTime, Reason" > list.csv

while true; do
	if [[  -z $token ]]
	then
		args=(sesv2 list-suppressed-destinations)
		res=$( aws "${args[@]}" )
	else
		args=(sesv2 list-suppressed-destinations --next-token ${token} )
		res=$( aws "${args[@]}" )
	fi

	batch=$( echo $res | dasel -r json .SuppressedDestinationSummaries -n )
	token=$( echo $res | dasel -r json .NextToken -n )
	temp="${token%\"}"
	temp="${temp#\"}"
	token=$temp


	if [[  $batch == 'null' ]]
	then
		echo "Some Error Happened. The batch returned null."
        break
	else
		echo $batch | dasel -p json -m --format '{{ select ".EmailAddress" }},{{ select ".LastUpdateTime" }},{{ select ".Reason" }}' '.[*]'  >> list.csv
		echo "Batch $((counter + 1)) Processed"
	fi

	if [[  $token == 'null' ]]
    then
        echo "The token is null. Should be the end of the list."
        break
    fi
	((counter += 1))
done