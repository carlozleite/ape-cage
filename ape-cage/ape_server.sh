#!/bin/bash

ACHOME=$(dirname "$0")


function start(){


${ACHOME}/bin/shell2http -form /chaos/loss "${ACHOME}/apes.sh loss \$v_ape_config" \
	 /chaos/latency "${ACHOME}/apes.sh latency \$v_ape_config" \
	 /chaos/corrupt "${ACHOME}/apes.sh corrupt \$v_ape_config" \
	 /chaos/delgw "${ACHOME}/apes.sh delgw \$v_ape_config" \
	/chaos/nullroute "${ACHOME}/apes.sh nullroute \$v_ape_config"


}

start
