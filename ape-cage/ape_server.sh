#!/bin/bash

ACHOME=$(dirname "$0")

if [ ! -z ${APE_AUTH} ] ; then

	AUTH=`printf ${APE_AUTH} | base64 -d`
else

	AUTH=chaos:monkey
fi


function start(){


${ACHOME}/bin/shell2http -port 8081 -basic-auth ${AUTH} -form /chaos/loss "${ACHOME}/apectl loss \$v_ape_config" \
	 /chaos/latency "${ACHOME}/apectl latency \$v_ape_config" \
	 /chaos/corrupt "${ACHOME}/apectl corrupt \$v_ape_config" \
	 /chaos/kill "${ACHOME}/apectl kill \$v_ape_config"


}

start
