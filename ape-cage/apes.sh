#!/bin/bash

ACHOME=$(dirname "$0")

monkey=$1
APE_CONFIG=$2
IFACE=enp0s8

function parse_tc(){

	 TDATE=`date "+%d/%m/%Y %H:%M:%S"` 

	 TCOUT=`tc qdisc | grep netem | awk -F":" '{print "oupput="$2""}' | tr ' ' '#'`  


	if [ ! -z ${TCOUT} ] ; then

	 	echo "'${TCOUT}' host=${HOSTNAME} monkey=${monkey} timeout=${TMOUT}s date='${TDATE}'" | tr '#' ' ' | xargs jo -p 
	else

		echo "output='Removed. No netem rules active...' host=${HOSTNAME} monkey=${monkey} timeout=${TMOUT}s date='${TDATE}'" | xargs jo -p
	fi

}

function msg_still(){


		TDATE=`date "+%d/%m/%Y %H:%M:%S"`
                OUT2=`echo "${TCOUT}" | tr '#' ' '`
                echo "output='Netem still running. ${OUT2}' host=${HOSTNAME} monkey=${monkey} timeout=${TMOUT}s date='${TDATE}'" | xargs jo -p


}


function clear_all(){


		tc qdisc del dev ${IFACE} root


}

set_config(){

        if [[ -z ${APE_CONFIG}  ]]; then

                source ${ACHOME}/etc/${monkey}.cfg

        else

		source ${ACHOME}/etc/${monkey}.cfg

                eval `echo "${APE_CONFIG}" | tr ':' '=' | tr ',' ' '`
        fi
}

function net-loss(){

	set_config

	TCOUT=`tc qdisc | grep netem | awk -F":" '{print "oupput="$2""}' | tr ' ' '#'`


	 if [ -z ${TCOUT} ] ; then 

		tc qdisc add dev ${IFACE} root netem loss ${LMIN}% ${LMAX}%
		parse_tc
		( nohup sleep ${TMOUT} && tc qdisc del dev ${IFACE} root netem loss ${LMIN}% ${LMAX}% && parse_tc & ) >/dev/null 2>&1
	 else

		msg_still		

	 fi

}

function net-corrupt(){

	set_config

	 TCOUT=`tc qdisc | grep netem | awk -F":" '{print "oupput="$2""}' | tr ' ' '#'`

         if [ -z ${TCOUT} ] ; then

                tc qdisc add dev ${IFACE} root netem corrupt ${CPERC}%
                parse_tc
                ( nohup sleep ${TMOUT} && tc qdisc del dev ${IFACE} root netem corrupt ${CPERC}% && parse_tc & ) >/dev/null 2>&1
         else

		msg_still

         fi 

}


#tc qdisc add dev eth0 root latency delay 1000ms 500ms


function net-latency(){

	 set_config

         TCOUT=`tc qdisc | grep netem | awk -F":" '{print "oupput="$2""}' | tr ' ' '#'`

         if [ -z ${TCOUT} ] ; then
		
		parse_tc
                tc qdisc add dev ${IFACE} root netem delay ${DMAX}ms ${DMIN}ms 
                ( nohup sleep ${TMOUT} && tc qdisc del dev ${IFACE} root netem delay ${DMAX}ms ${DMIN}ms && parse_tc & ) >/dev/null 2>&1
         else

		msg_still

         fi


}

function net-nullroute(){

	
	TDATE=`date "+%d/%m/%Y %H:%M:%S"`
	ip route add blackhole 10.0.0.0/8
	echo "output=ip route add blackhole 10.0.0.0/8 host=${HOSTNAME} monkey=${monkey} date=${TDATE}" | xargs jo -p
	( nohup sleep ${TMOUT} && route del blackhole 10.0.0.0/8 & ) >/dev/null 2>&1

}

function net-delgw(){

	TDATE=`date "+%d/%m/%Y %H:%M:%S"`
	GW=`route -n | awk '{print $2}' | grep [0-9] | grep -v 0.0.0.0`
	#route del default
	echo "output='route del default' host=${HOSTNAME} monkey=${monkey} date='${TDATE}'" | xargs jo -p
	#( nohup sleep ${TMOUT} && route add default ${GW} & ) >/dev/null 2>&1




}


case $1 in 

loss)

	net-loss

;;

corrupt)

	net-corrupt

;;

latency)

	net-latency

;;

nullroute)

	net-nullroute

;;

delgw)

	net-delgw

;;

*)


cat << "EOF" 
            __,__
   .--.  .-"     "-.  .--.
  / .. \/  .-. .-.  \/ .. \
 | |  '|  /   Y   \  |'  | |
 | \   \  \ 0 | 0 /  /   / |
  \ '- ,\.-"`` ``"-./, -' /
   `'-' /_   ^ ^   _\ '-'`
       |  \._   _./  |
       \   \ `~` /   /
        '._ '-=-' _.'
           '~---~' 

EOF


	echo "USAGE: apes.sh <loss|corrupt|latency|nullroute|delgw> [ape_config]"
	echo ""
	echo "loss config:  TMOUT:<VAL>,LMIN:<VAL>,LMAX:<VAL>,IFACE:<VAL>"
	echo "latency config:  TMOUT:<VAL>,DMIN:<VAL>,DMAX:<VAL>,IFACE:<VAL>"
	echo "corrupt config:  TMOUT:<VAL>,LPERC:<VAL>,IFACE:<VAL>"
	echo ""

;;

esac

