set ns [ new Simulator ]
set tf [ open 2.ping6nodes.tr w ]
$ns trace-all $tf
set nf [ open 2.ping6nodes.nam w ]
$ns namtrace-all $nf
proc finish { } {
	global tf nf ns
	$ns flush-trace
	exec nam 2.ping6nodes.nam &
	close $tf
	close $nf
	exit 0
}

#defining nodes
set n0 [ $ns node ]
set n1 [ $ns node ]
set n2 [ $ns node ]
set n3 [ $ns node ]
set n4 [ $ns node ]
set n5 [ $ns node ]
set n6 [ $ns node ]

#providing labels to each node
$n0 label "Source1"
$n1 label "dummynode1"
$n6 label "destination2"
$n2 label "Router"
$n3 label "dummynode2"
$n4 label "destination1"
$n5 label "source2"

#defining dubplex link between required nodes as per layout
$ns duplex-link $n0 $n2 10Mb 5ms DropTail
$ns duplex-link $n2 $n4 10Mb 5ms DropTail
$ns duplex-link $n5 $n2 10Mb 5ms DropTail
$ns duplex-link $n2 $n6 10Mb 5ms DropTail
$ns duplex-link $n1 $n2 10Mb 5ms DropTail
$ns duplex-link $n2 $n3 10Mb 5ms DropTail

#Setting queue size on sources and destinations
$ns queue-limit $n0 $n2 10
$ns queue-limit $n2 $n4 1 
$ns queue-limit $n5 $n2 10
$ns queue-limit $n2 $n6 1

#defining ping agent for n0 and n5
set ping0 [ new Agent/Ping]
set ping4 [ new Agent/Ping]
set ping5 [ new Agent/Ping]
set ping6 [ new Agent/Ping]
$ns attach-agent $n0 $ping0
$ns attach-agent $n4 $ping4
$ns attach-agent $n5 $ping5
$ns attach-agent $n6 $ping6


#pinging from sources to destination
$ns connect $ping0 $ping4
$ns connect $ping5 $ping6

#defining unique color for packets of each source node
$ns color 1 "red"
$ns color 2 "blue"

#setting unique color for packets of each source node
$ping0 set class_ 1
$ping5 set class_ 2

Agent/Ping instproc recv { from rtt } {
$self instvar node_
puts " The node [ $node_ id ] received reply from $from with the rtt of $rtt"
}

proc SendPingPacket { } {
global ns ping0 ping5
set timeInterval 0.005
set now [ $ns now ]
$ns at [ expr $now + $timeInterval ] " $ping0 send" 
$ns at [ expr $now + $timeInterval ] " $ping5 send" 
$ns at [ expr $now + $timeInterval ] "SendPingPacket"
}

$ns at 0.01 "SendPingPacket"
#ending simulation
$ns at 5.0 "finish"
$ns run
