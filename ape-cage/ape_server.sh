#!/bin/bash

ACHOME=$(dirname "$0")

if [ ! -z ${APE_AUTH} ] ; then

	AUTH=`printf ${APE_AUTH} | base64 -d`
else


	PASS=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c10`
	AUTH=chaos:${PASS}
	AUTH64=`printf ${AUTH} | base64`
fi


function start(){

IPADDR=$(dig ${HOSTNAME} +short)

/bin/consul-cli service register --consul ${CONSUL} --id=${IPADDR}:${SERVICE_NAME} --tag=chaos-ready --tag=${AUTH64} --check="http:10s:http://${IPADDR}:8081/health" ${SERVICE_NAME}


${ACHOME}/bin/shell2http -port 8081 -basic-auth ${AUTH} -form /chaos/loss "${ACHOME}/apectl loss \$v_ape_config" \
	 /chaos/latency "${ACHOME}/apectl latency \$v_ape_config" \
	 /chaos/corrupt "${ACHOME}/apectl corrupt \$v_ape_config" \
	 /chaos/kill "${ACHOME}/apectl kill \$v_ape_config" \
	/health "${ACHOME}/apectl health"


}

start
