#!/bin/bash

ACHOME=$(dirname "$0")

monkey=$1
IFACE=enp0s8


function parse_tc(){

	 TDATE=`date "+%d/%m/%Y %H:%M:%S"` 

	 TCOUT=`tc qdisc | grep netem | awk -F":" '{print $2}' | tr ' ' '#'`  


	if [ ! -z ${TCOUT} ] ; then

	 	echo "[${TDATE}], Job:${JOB_ID}, Monkey:${monkey}, Msg:Started - '${TCOUT}', Host:${HOSTNAME}, Timeout:${TMOUT}s " | tr '#' ' ' 
	else

		echo "[${TDATE}], Job:${JOB_ID}, Monkey:${monkey}, Msg:Finished - No netem rules active..., Host:${HOSTNAME}, Timeout:${TMOUT}s " 
	fi

}

function msg_still(){


		TDATE=`date "+%d/%m/%Y %H:%M:%S"`
                OUT2=`echo "${TCOUT}" | tr '#' ' '`
                echo "[${TDATE}], Job:${JOB_ID}, Monkey:${monkey}, Msg:'Netem still running. ${OUT2}', Host:${HOSTNAME}, Timeout:${TMOUT}s " 


}


function clear_all(){


		tc qdisc del dev ${IFACE} root


}

set_config(){


		source ${ACHOME}/etc/${monkey}.cfg

		if [ -f ${ACHOME}/var/${monkey}.tcfg ]; then 
			source ${ACHOME}/var/${monkey}.tcfg
		fi	

		if [ -z ${JOB_ID} ] ; then

			TDATE=`date "+%d/%m/%Y %H:%M:%S"`

			echo "[${TDATE}], Monkey:${monkey}, Msg:'Error. Please set JOB_ID !', Host:${HOSTNAME}, Timeout:0s"
			exit 1 
		fi
}

function net-loss(){

	set_config

	TCOUT=`tc qdisc | grep netem | awk -F":" '{print "oupput="$2""}' | tr ' ' '#'`


	 if [ -z ${TCOUT} ] ; then 

		tc qdisc add dev ${IFACE} root netem loss ${LMIN}% ${LMAX}%
		parse_tc
		sleep ${TMOUT} 
		tc qdisc del dev ${IFACE} root netem loss ${LMIN}% ${LMAX}% 
		parse_tc
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
                sleep ${TMOUT} 
		tc qdisc del dev ${IFACE} root netem corrupt ${CPERC}% 
		parse_tc 
         else

		msg_still

         fi 

}

function net-latency(){

	 set_config

         TCOUT=`tc qdisc | grep netem | awk -F":" '{print "oupput="$2""}' | tr ' ' '#'`

         if [ -z ${TCOUT} ] ; then
		
                tc qdisc add dev ${IFACE} root netem delay ${DMAX}ms ${DMIN}ms 
		parse_tc
                sleep ${TMOUT} 
		tc qdisc del dev ${IFACE} root netem delay ${DMAX}ms ${DMIN}ms 
		parse_tc 
         else

		msg_still

         fi


}

function proc-kill(){

	set_config

	pkill -9 ${PROC}
	TDATE=`date "+%d/%m/%Y %H:%M:%S"`                                                                                           
        echo "[${TDATE}], Job:${JOB_ID}, Monkey:${monkey}, Msg:Kill processs ${PROC}, Host:${HOSTNAME}, Timeout:${TMOUT}s" 
	sleep 5

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


kill)

	proc-kill

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


	echo "USAGE: apes.sh <loss|corrupt|latency|kill> [ape_config]"
	echo ""
	echo "loss config:  JOB_ID:<ID>,TMOUT:<VAL>,LMIN:<VAL>,LMAX:<VAL>,IFACE:<VAL>"
	echo "latency config:  JOB_ID:<ID>,TMOUT:<VAL>,DMIN:<VAL>,DMAX:<VAL>,IFACE:<VAL>"
	echo "corrupt config:  JOB_ID:<ID>,TMOUT:<VAL>,LPERC:<VAL>,IFACE:<VAL>"
	echo "kill config: JOB_ID:<ID>,PROC:<PROC_NAME>"
	echo ""

;;

esac

