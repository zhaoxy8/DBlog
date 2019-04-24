#!/bin/bash

set -e

checkPass=0
env=bixby-cndev

dockerImageTag=` cat pipeline-init.json | jq -r .dockerImageTag ` version
dockerRepoUrl=` cat pipeline-init.json | jq -r .dockerRepoUrl `oneblog
dockerImageId=` cat pipeline-init.json | jq -r .dockerImageId `
dockerport=` cat pipeline-init.json | jq -r .dockerport `
username=shuigjdocker

sleep 60

echo;echo;echo "===================== [STEP 1-3] container test =====================";echo;echo
if [[ $dockerRepoUrl =~ "baidu" ]]
then
    http_code=`curl -I -m 10 -o /dev/null -s -w %{http_code}  http://localhost:8080/viv/healthcheck`
	echo "http_code:" ${http_code}
	if [ ${http_code} -ne 200 ]; then
		checkPass=1
	fi
elif [[ $dockerRepoUrl =~ "jd" ]]
then
    http_code=`curl -I -m 10 -o /dev/null -s -w %{http_code}  http://localhost:5060/bixby/healthcheck`
	echo "http_code:" ${http_code}
	if [ ${http_code} -ne 200 ]; then
		checkPass=1
	fi
elif [[ $dockerRepoUrl =~ "blog" ]]
then
    http_code=`curl -I -m 10 -o /dev/null -s -w %{http_code}  http://localhost:8443`
	echo "http_code:" ${http_code}
	if [ ${http_code} -ne 200 ]; then
		checkPass=1
	fi
else
    echo "Don't have"${dockerRepoUrl}
fi

if [ ${checkPass} -ne 0 ]; 
then
	echo "${dockerImageId} have some bug issue"
    docker stop $dockerImageId
	docker rm -f $dockerImageId
	exit 1
else
    echo "${dockerImageId} test is ok!"
    docker stop $dockerImageId
	docker rm -f $dockerImageId
fi

echo;echo;echo "===================== [STEP 1-4] push image to dockerhub =====================";echo;echo
docker tag xy1219.zhao/$dockerRepoUrl:latest $username/$dockerRepoUrl:$dockerImageTag
docker push $username/$dockerRepoUrl:$dockerImageTag
