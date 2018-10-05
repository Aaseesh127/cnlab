set ns [ new Simulator ]
set tf [ open 1.nodes.tr w ]
$ns trace-all $tf
set nf [ open 1.nodes.nam w ]
$ns namtrace-all $nf
proc finish { } {
	global tf nf ns
	$ns flush-trace
	exec nam 1.nodes.nam &
	close $tf
	close $nf
	exit 0
}

#defining nodes
set n0 [ $ns node ]
set n1 [ $ns node ]
set n2 [ $ns node ]
set n3 [ $ns node ]

#providing labels to each node
$n0 label "Source1"
$n1 label "Source2"
$n2 label "Router"
$n3 label "Destination"

#connecting nodes
$ns duplex-link $n0 $n2 10Mb 5ms DropTail
$ns duplex-link $n1 $n2 10Mb 5ms DropTail
$ns duplex-link $n2 $n3 0.5Mb 5ms DropTail
# $ns duplex-link $n2 $n3 20Mb 5ms DropTail

#defining queue-limit
$ns queue-limit $n0 $n2 10
$ns queue-limit $n1 $n2 10
$ns queue-limit $n2 $n3 20 
# $ns queue-limit $n2 $n3 1

#Here in this case, packets drop is occuring due to weak-output-duplex-linx 
#If we consider the case in comments, then packets drop will occur due to insufficient queue-limit

#Here output queue-limit-size should be atleast 20 theoretically for trasmission without packet drop due to insufficient buffer size of router at max case
#But then if you increase output queue-limit bandwidth more than 1000 times then it won't let packet to drop even due to weak output duplex-link but .why??
#But no matter how much you increase your destination duplex-link bandwidth, if distination queue-limit buffer is smaller to at least 5% (1/20 in this case) than in sum of bandwidth of inputs, Packet dropping will keep continuing.
#So As conclusion, 
# 1) packet drops mainly depends on output queue-limit.
# 2) packet drops due to weak output dublex-link can be fixed by abnormally increasing queue-limit-size but packet drops due to insufficient router-buffer-size (queue-limit) cannot be fixed even if you increase duplex-link bandwidth to abnormally high.

#Creating two udpAgents and assigning them to upd0, upd1 and nulludp2 respectively for n0 and n1 nodes.
set udp0 [ new Agent/UDP ]
set udp1 [ new Agent/UDP ]
set null [ new Agent/Null ]
#creating two Applications and assigning them to app0 and app1 resepectively for n0 and n1 nodes. 
set app0 [ new Application/Traffic/CBR ]
set app1 [ new Application/Traffic/CBR ]
#Now attach each node and app created to their respective udpAgent

#attach each node to their respective udpAgents.
$ns attach-agent $n0 $udp0 
$ns attach-agent $n1 $udp1
$ns attach-agent $n3 $null
#attach each app to use a particular updAgent
$app0 attach-agent $udp0
$app1 attach-agent $udp1


#tell each udpAgent where to deliver packets
$ns connect $udp0 $null
$ns connect $udp1 $null

#--------Totally optional---------

#aliasing color 0 for red and 1 for blue 
$ns color 0 "red"
$ns color 1 "blue"
#assigning packetcolor for each udpAgent 
$udp0 set class_ 0
$udp1 set class_ 1
#setting packet size
$app0 set packetSize_ 1000
$app1 set packetSize_ 1000

#--------Totally optional---------


#stating the Applications
$ns at 0.1 "$app0 start"
$ns at 0.1 "$app1 start"
#ending simualtion
$ns at 5.0 "finish"
$ns run
