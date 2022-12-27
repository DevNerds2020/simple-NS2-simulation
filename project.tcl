#amirreza alasti 9812762485
set ns [ new Simulator ]

set tracefile [open out.tr w]

$ns trace-all $tracefile

set namfile [open out.nam w]

$ns namtrace-all $namfile

#define diffrent colors for data flows
$ns color 0 blue
$ns color 1 red

#create 10 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]

#create duplex link both sides between (n0 and n4, n1 and n4, n2 and n4, n3 and n4) with 10Mbps bandwidth and 2ms delay
$ns duplex-link $n0 $n4 10Mb 2ms DropTail orient right
$ns duplex-link $n1 $n4 10Mb 2ms DropTail orient right
$ns duplex-link $n2 $n4 10Mb 2ms DropTail orient right
$ns duplex-link $n3 $n4 10Mb 2ms DropTail orient right

#create a one-way link from (n4 to n5, n5 to n4) with 300Kbps bandwidth and 100ms delay
$ns simplex-link $n4 $n5 300Kbps 100ms DropTail right
$ns simplex-link $n5 $n4 300Kbps 100ms DropTail left

#create a two-way link between (n5 and n6, n5 and n9) with 500Kbps bandwidth and 40ms delay
$ns duplex-link $n5 $n6 500Kbps 40ms DropTail orient left
$ns duplex-link $n5 $n9 500Kbps 40ms DropTail orient left
#create a two-way link between (n6 and n7, n7 and n8, n8 and n9) with 500Kbps bandwidth and 40ms delay
$ns duplex-link $n6 $n7 500Kbps 40ms DropTail orient left
$ns duplex-link $n7 $n8 500Kbps 40ms DropTail orient left
$ns duplex-link $n8 $n9 500Kbps 40ms DropTail orient left


#TCP_Config
set tcp0 [new Agent/TCP/Reno]
$ns attach-agent $n1 $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n9 $sink0

$ns connect $tcp0 $sink0

#now run FTP application between n1 and n9
set ftp [new Application/FTP]
$ftp attach-agent $tcp0

$ns rtmodel-at 2.0 down $n7 $n8
$ns rtmodel-at 4.0 up $n8 $n7

$ns at 0.3 "$ftp start"

$ns at 10.0 "$ftp stop"

proc finish {} {
    global ns tracefile namfile
    exec nam out.nam &
    exit 0
}

$ns run