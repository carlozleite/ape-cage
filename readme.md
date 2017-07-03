![logo](https://github.com/carlozleite/ape-cage/raw/a482e8b2ed07542e74e70b952e2f13e47432a695/ape-cage/lib/img/ape-cage-logo-1.png)

Simple chaos monkey tests with http api .

Basic useful feature list:

 * Command Line interface
 * HTTP API Interface to launch monkeys remote inside container.
 * Use supervisord to control monkey execution.
 * Send Logs to remote logstash server.


Monkeys avaliable:

 * Loss - Generate packet loss
 * Latency - Generate network delay.
 * Corrupt - Corrupt network packets.
 * Kill - kill process by name.
 
### RUN Container:

```bash
docker run  -i -d --cap-add=NET_ADMIN \
--name ape-cage-v2 \
-p 6666:8081 \
-e LOGSTASH_SERVER='<LOGSTASH-IP-ADDR>' \
-e LOGSTASH_PORT='6666' \
-e LOGSTASH_PROTO='tcp' \
-e APE_AUTH=<BASE64 user:pass> \
carlozleite/ape-cage
```

### DEMO

![win1](https://github.com/carlozleite/ape-cage/raw/master/ape-cage/lib/img/ape-11.gif)

![win2](https://github.com/carlozleite/ape-cage/raw/master/ape-cage/lib/img/ape-22.gif)

https://vimeo.com/222723708

### TEST:

### Generate packet loss:

```bash
curl -H "Authorization: Basic <Base64-Basic-Auth>" http://127.0.0.1:6666/chaos/loss
```

#### Parameters:

```bash
curl -H "Authorization: Basic <Base64-Basic-Auth>" http://127.0.0.1:6666/chaos/loss?ape_config=JOB_ID:TEST_19282752,TMOUT:20,LMIN:30,LMAX:50
```

##### JOB_ID: <String>

Monkey test ID.

##### TMOUT: <Integer> 

Timeout in seconds

##### IFACE: <String> 

Network Interface name - Default eth0

##### LMIN: <Integer>

Minimum percentage of packet loss

##### LMAX: <Integer> 

Maximum percentage of packet loss

#### Generate Network Latency:

```bash
curl -H "Authorization: Basic <Base64-Basic-Auth>" http://127.0.0.1:6666/chaos/latency
```

## Parameters:

```bash
curl -H "Authorization: Basic <Base64-Basic-Auth>" http://127.0.0.1:6666/chaos/latency?ape_config=JOB_ID:TEST_19282752,TMOUT:20,DMIN:30,DMAX:50,IFACE:eth0
```


##### JOB_ID: <String>

Monkey test ID.

##### TMOUT: <Integer> 

Timeout in seconds

##### IFACE: <String> 

Network Interface name - Default eth0

##### DMIN: <Integer>

Minimum delay in milliseconds

##### DMAX: <Integer> 

Maximum delay in milliseconds

### Generate Network Corruption:

```bash
curl -H "Authorization: Basic <Base64-Basic-Auth>" http://127.0.0.1:6666/chaos/corrupt
```

#### Parameters:

```bash
curl -H "Authorization: Basic <Base64-Basic-Auth>" http://127.0.0.1:6666/chaos/corrupt?ape_config=JOB_ID:TEST_19282752,TMOUT:20,CPERC:50,IFACE:eth0
```

##### JOB_ID: <String>

Monkey test ID.

##### TMOUT: <Integer> 

Timeout in seconds

##### IFACE: <String> 

Network Interface name - Default eth0

##### CPERC: <integer>

Percentage of network corruption.


### Kill process by Name:

```bash
curl -H "Authorization: Basic <Base64-Basic-Auth>" http://127.0.0.1:6666/chaos/kill
```

#### Parameters:

```bash
curl -H "Authorization: Basic <Base64-Basic-Auth>" http://127.0.0.1:6666/chaos/kill?ape_config=JOB_ID:TEST_19282752,PROC:java
```

##### JOB_ID: <String>

Monkey test ID.

##### PROC: <string>

Process name to kill.



# COMMAND-LINE 

```bash
docker exec -it <container> /ape-cage/apectl
```

![cmd](https://preview.ibb.co/m0wZsk/ape_cage1.png)

## TODO:

* Set HTTP authentication. - OK
* Improve background process control - OK
* Add mora monkeys
