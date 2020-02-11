#!/bin/bash

while getopts d: option
do
  case "${option}"
    in
    d) DESC=${OPTARG};;
  esac
done

backupInstances(){
  TODAY=`date +%m-%d-%Y`
  for yml in /home/xophz/aws/ec2/* 
  do
    NAME="$(yml2json $yml '.name')-${TODAY}"
    ID="$(yml2json $yml '.id')"
    createImage "${ID}" "${NAME}" "${DESC}"
  done;
}

# PARSE YML, ECHO FILTERED JSON OBJECT
yml2json(){
  json=$(ruby -ryaml -rjson -e 'puts JSON.pretty_generate(YAML.load(ARGF))' "$1" | jq "$2")
  echo $json | tr -d '"'
}

# CREATE AWS EC2 IMAGE
createImage(){
  aws ec2 create-image --instance-id "${1}" --name "${2}" --description "'${3}'" 
}

if [[ $DESC = "" ]]
then
  echo "Please add a description (-d)"
else
  backupInstances
fi

