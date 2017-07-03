curl -H "Authorization: Basic YWRtaW46dGVzdGU=" http://127.0.0.1:6666/chaos/kill?ape_config=JOB_ID:TESTE101002,PROC:java
sleep 10
curl -H "Authorization: Basic YWRtaW46dGVzdGU=" http://127.0.0.1:6666/chaos/latency?ape_config=JOB_ID:LATE_83737373,TMOUT:20,DMIN:1000,DMAX:5000
sleep 10
curl -H "Authorization: Basic YWRtaW46dGVzdGU=" http://127.0.0.1:6666/chaos/loss?ape_config=JOB_ID:LOSS_0007997,TMOUT:20,LMIN:70,LMAX:90
sleep 10
curl -H "Authorization: Basic YWRtaW46dGVzdGU=" http://127.0.0.1:6666/chaos/corrupt?ape_config=JOB_ID:CORR_0007997,TMOUT:20,CPERC:90
