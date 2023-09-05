#!/bin/bash

#parameters
aws_region=ap-southeast-1
aws_service=EC2

# Download IP address ranges from AWS
url=https://ip-ranges.amazonaws.com/ip-ranges.json

file_name=ip-ranges.json
cache_file_name=cache-ip-ranges.txt
new_cache_file_name=new-cache-ip-ranges.txt

curl $url --output $file_name

#define filters for jq to reduce to appropriate AWS region and service
filter='.prefixes[] | select(.region=="'${aws_region}'") | select(.service=="'${aws_service}'") | .ip_prefix'

#get the list of IP addresses
jq -r "$filter" < $file_name > $new_cache_file_name

#get IPs which are different between new and old file
diff=$(comm -3 $new_cache_file_name $cache_file_name)

if [ ! -z "$diff" ]; then
    echo "there are some changes in IP Address ranges"
    echo "$diff"
fi

#delete old file and rename new file
rm -rf $cache_file_name
mv $new_cache_file_name $cache_file_name





