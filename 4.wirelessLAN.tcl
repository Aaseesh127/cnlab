set ns [new Simulator]
set tf [open 4.wirelessLAN.tr w]
$ns trace-all $tf
set topo [new Topography]
$topo load_flatgrid 1000 1000
set nf [open 4.wirelessLAN.nam w]
$ns namtrace-all-wireless $nf 1000 1000
proc finish { } {
	global tf nf ns
	$ns flush-trace
	exec nam 4.wirelessLAN.nam &
	close $tf
	close $nf
	exit 0
}


$ns node-config -adhocRouting DSDV \
		-llType LL \
		-macType Mac/802_11 \
		-ifqType Queue/DropTail \
		-ifqLen 50 \
		-phyType Phy/WirelessPhy \
		-channelType Channel/WirelessChannel \
		-propType Propagation/TwoRayGround \
		-antType Antenna/OmniAntenna \
		-topoInstance $topo \
		-agentTrace ON \
		-routerTrace ON

create-god 3
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$n0 set X_ 50
$n0 set Y_ 50
$n0 set Z_ 0


$n1 set X_ 100
$n1 set Y_ 100
$n1 set Z_ 0


$n2 set X_ 400
$n2 set Y_ 400
$n2 set Z_ 0



#providing labels to each node
$n0 label "ftp0"
$n1 label "ftp1AndSink1"
$n2 label "Sink2"


set tcp0 [new Agent/TCP ]
set tcp1 [ new Agent/TCP ]
set ftp0 [ new Application/FTP ]
set ftp1 [ new Application/FTP ]
set sink1 [ new Agent/TCPSink ]
set sink2 [ new Agent/TCPSink ]

$ns attach-agent $n0 $tcp0
$ns attach-agent $n1 $tcp1
$ns attach-agent $n1 $sink1 
$ns attach-agent $n2 $sink2

$ftp0 attach-agent $tcp0
$ftp1 attach-agent $tcp1

$ns connect $tcp0 $sink1
$ns connect $tcp1 $sink2


#defining unique color for packets of each source node
$ns color 1 "red"
$ns color 2 "blue"

#setting unique color for packets of each source node
$tcp0 set class_ 1
$tcp1 set class_ 2


$ns at 0.1 "$n0 setdest 50 50 15"
$ns at 0.1 "$n1 setdest 100 100 15"
$ns at 0.1 "$n2 setdest 400 400 15"

#stating the Applications
$ns at 0.1 "$ftp0 start"
$ns at 0.1 "$ftp1 start"

$ns at 190 "$n1 setdest 200 200 10"
$ns at 200 "$n2 setdest 300 300 10"


$ns at 300 "finish"
$ns run
