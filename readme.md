[logo](https://image.ibb.co/hWHEtQ/ape_cage_logo_1.png)

Simple chaos monkey tests with http api.

Basic useful feature list:

 * Command Line interface
 * HTTP API Interface to launch monkeys remote inside container.
 * JSON Output


Monkeys avaliable:

 * Loss - Generate packet loss
 * Latency - Generate network delay.
 * Corrupt - Corrupt network packets.
 
### RUN Container:

```bash
docker run -d -i --cap-add=NET_ADMIN -p 6666:8080 carlozleite/ape-cage
```


### TEST:

### Generate packet loss:

```bash
curl http://127.0.0.1:6666/chaos/loss
```

#### Parameters:

```bash
curl http://127.0.0.1:6666/chaos/loss?ape_config=TMOUT:20,LMIN:30,LMAX:50
```

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
curl http://127.0.0.1:6666/chaos/latency
```

## Parameters:

```bash
curl http://127.0.0.1:6666/chaos/latency?ape_config=TMOUT:20,DMIN:30,DMAX:50,IFACE:eth0
```


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
curl http://127.0.0.1:6666/chaos/corrupt
```

#### Parameters:

```bash
curl http://127.0.0.1:6666/chaos/corrupt?ape_config=TMOUT:20,CPERC:50,IFACE:eth0
```

##### TMOUT: <Integer> 

Timeout in seconds

##### IFACE: <String> 

Network Interface name - Default eth0

##### CPERC: <integer>

Percentage of network corruption.

# COMMAND-LINE 

```bash
docker exec -it <container> /ape-cage/apes.sh
```

![cmd](https://preview.ibb.co/m0wZsk/ape_cage1.png)