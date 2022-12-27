# پروژه درس شبکه 
### امیررضا الستی - 9812762485


#### 1. کانفیگ اولیه پروژه

ابتدا در خط 1 تا 10 یک سری کار های اولیه انجام میدهیم برای ایجاد شدن فایل های out.nam , out.tr
و رنگ ابی را نیز برای ارسال پیام ها تعریف میکنیم

    set ns [new Simulator]
    set nf [open out.nam w]
    set tf [open out.tr w]
    $ns namtrace-all $nf
    $ns trace-all $tf
    $ns color blue

#### 2. تعریف نود ها

در خط 16 تا 25 <br />
10 نود تعریف میکنیم که از 0 تا 9 هستند و هر کدام یک از آنها یک نود میباشد

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

میتوانستیم از حلقه هم به شکل زیر استفاده کنیم

    for {set i 0} {$i < 10} {incr i} {
        set n$i [$ns node]
    }

#### 3. تعریف لینک ها

در خط 27 تا 43 <br />
10 لینک تعریف میکنیم که از 0 تا 9 هستند و هر کدام یک از آنها یک لینک میباشد

    $ns duplex-link $n0 $n4 10Mb 2ms DropTail orient right
    $ns duplex-link $n1 $n4 10Mb 2ms DropTail orient right
    $ns duplex-link $n2 $n4 10Mb 2ms DropTail orient right
    $ns duplex-link $n3 $n4 10Mb 2ms DropTail orient right
    $ns simplex-link $n4 $n5 300Kbps 100ms DropTail right
    $ns simplex-link $n5 $n4 300Kbps 100ms DropTail left
    $ns duplex-link $n5 $n6 500Kbps 40ms DropTail orient left
    $ns duplex-link $n5 $n9 500Kbps 40ms DropTail orient left
    $ns duplex-link $n6 $n7 500Kbps 40ms DropTail orient left
    $ns duplex-link $n7 $n8 500Kbps 40ms DropTail orient left
    $ns duplex-link $n8 $n9 500Kbps 40ms DropTail orient left


لینک های duplex-link یک لینک دو طرفه هستند که از یک نود به نود دیگر متصل میشوند

لینک های simplex-link یک لینک یک طرفه هستند که از یک نود به نود دیگر متصل میشوند

همچنین ترافیک هر لینک را میتوان با استفاده از یک مقدار بر حسب بیت در ثانیه تعریف کرد

و مکان ند ها در صفحه نیز با استفاده از left right orient تعریف میشوند

مکان ها ثابت نیستند و همیشه یکسان نمیشوند


#### 4. کانفیگ tcp

در خط 45 تا 54 <br />

یک tcp agent ایجاد میکنیم و ان را به نود n1 متصل میکنیم

    set tcp0 [new Agent/TCP/Reno]
    $ns attach-agent $n1 $tcp0

سپس یک tcp sink ایجاد میکنیم و ان را به نود n9 متصل میکنیم

    set sink0 [new Agent/TCPSink]
    $ns attach-agent $n9 $sink0

سپس یک tcp connection ایجاد میکنیم و ان را بین tcp agent و tcp sink متصل میکنیم
    
        $ns connect $tcp0 $sink0

#### 5. کانفیگ ftp

در خط 56 تا 57 <br />

ابتدا یک ftp agent ایجاد میکنیم و سپس ان را به tcp agent متصل میکنیم

    set ftp0 [new Application/FTP]
    $ftp0 attach-agent $tcp0

همانطور که میدانیم پروتوکول ftp برای ارسال فایل ها از پروتوکول tcp استفاده میکند


#### 6. کانفیگ زمانی

مطابق خواست پروژه ارتباط بین گره n7 , n8 
از ثانیه 2 تا 4 قطع میشود

    $ns rtmodel-at 2.0 down $n7 $n8
    $ns rtmodel-at 4.0 up $n8 $n7
و همینطور ftp از ثانیه 0.3 تا 10.0 اجرا میشود

    $ns at 0.3 "$ftp start"
    $ns at 10.0 "$ftp stop"
    
#### 7. اجرای مدل

با دستوارت زیر مدل را اجرا میکنیم

    $ns run