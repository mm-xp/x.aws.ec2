#!/bin/bash

while getopts d: option
do
  case "${option}"
    in
    d) DESC=${OPTARG};;
  esac
done


yml2json(){
  json=$(ruby -ryaml -rjson -e 'puts JSON.pretty_generate(YAML.load(ARGF))' "$1" | jq "$2")
  echo $json | tr -d '"'
}

ec2Backup(){
  TODAY=`date +%m-%d-%Y`
  for yml in /home/xophz/aws/ec2/* 
  do
    NAME=$(yml2json "$yml" '.name')
    echo $NAME
    NAME="${NAME}-${TODAY}"
    ID="$(yml2json $yml '.id')"
     
    aws ec2 create-image --instance-id "${ID}" --name "${NAME}" --description "'${DESC}'" 
    # aws ec2 create-image --instance-id "${ID}" --name "${NAME}" --description "'${DESC}'" 
  done;
}

if [[ $DESC != "" ]]
then
  ec2Backup
else
  echo "Please add a description (-d)"
fi

