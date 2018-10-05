set ns [ new Simulator ]
set tf [ open 3.ethernetLAN.tr w ]
$ns trace-all $tf
set nf [ open 3.ethernetLAN.nam w ]
$ns namtrace-all $nf
proc finish { } {
	global tf nf ns
	$ns flush-trace
	exec nam 3.ethernetLAN.nam &
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
$n0 label "Source0"
$n1 label "Destination0"
$n2 label "Source1"
$n3 label "Destination1"

#defining LAN link
$ns make-lan "$n0 $n1 $n2 $n3" 100Mb 10ms LL Queue/DropTail Mac/802_3

#Creating two tcp Agent and two ftp apts to use them
set tcp0 [ new Agent/TCP ]
set tcp2 [ new Agent/TCP ]
set ftp0 [ new Application/FTP ]
set ftp2 [ new Application/FTP ]
set sink1 [ new Agent/TCPSink ]
set sink3 [ new Agent/TCPSink ]

#attach each node to their respective tcpAgents.
$ns attach-agent $n0 $tcp0 
$ns attach-agent $n2 $tcp2
$ns attach-agent $n1 $sink1 
$ns attach-agent $n3 $sink3
#attach each ftpapp to use a particular updAgent
$ftp0 attach-agent $tcp0
$ftp2 attach-agent $tcp2

#tell each udpAgent where to deliver packets
$ns connect $tcp0 $sink3
$ns connect $tcp2 $sink1

#--------Totally optional---------

#aliasing color 0 for red and 1 for blue 
$ns color 0 "red"
$ns color 1 "blue"
#assigning packetcolor for each udpAgent 
$tcp0 set class_ 0
$tcp2 set class_ 1
#setting packet size
$ftp0 set packetSize_ 1000
$ftp2 set packetSize_ 1000

#--------Totally optional---------

set file1 [ open file1.tr w ]
$tcp0 attach $file1
$tcp0 trace cwnd_
$tcp0 set maxcwnd_ 10


set file2 [ open file2.tr w ]
$tcp2 attach $file2
$tcp2 trace cwnd_

#stating the Applications
$ns at 0.1 "$ftp0 start"
$ns at 2.0 "$ftp0 stop"
$ns at 2.5 "$ftp0 start"
$ns at 4.0 "$ftp0 stop"

$ns at 0.2 "$ftp2 start"
$ns at 2.0 "$ftp2 stop"
$ns at 2.5 "$ftp2 start"
$ns at 4.5 "$ftp2 stop"

#ending simualtion
$ns at 5.0 "finish"
$ns run
