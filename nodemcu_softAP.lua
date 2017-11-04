--By Vishvendra Singh on 05/11/2017 in lua
--This creates soft access point named AccessPoint with nodemcu and let the devices connect with this AP (Access Point)
--GPIO Define
function initGPIO()
--1,2EN 	D1 GPIO5
--3,4EN 	D2 GPIO4
--1A  ~2A   D3 GPIO0
--3A  ~4A   D4 GPIO2

led1 = 1
led2 = 2
led3 = 3
led4 = 4
gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)
gpio.mode(led3, gpio.OUTPUT)
gpio.mode(led4, gpio.OUTPUT)

end

function setupAPMode()
print("Ready to start soft ap")
	
cfg={}
cfg.ssid="AccessPoint";
cfg.pwd="12345678"
wifi.ap.config(cfg)

cfg={}
cfg.ip="192.168.1.1";
cfg.netmask="255.255.255.0";
cfg.gateway="192.168.1.1";
wifi.ap.setip(cfg);
wifi.setmode(wifi.SOFTAP)

str=nil;
ssidTemp=nil;
collectgarbage();

print("Soft AP started")
end

--Set up AP
setupAPMode();

print("Start DoitRobo Control");
initGPIO();

--Setup tcp server at port 9003
s=net.createServer(net.TCP,60);
s:listen(9003,function(c) 
    c:on("receive",function(c,d) 
      print("TCPSrv:"..d)
      if string.sub(d,1,1)=="0" then --stop
		gpio.write(led1, gpio.LOW);
		gpio.write(led2, gpio.LOW);
		gpio.write(led3, gpio.LOW);
		gpio.write(led4, gpio.LOW);
		stopFlag = true;
        c:send("ok\r\n");
	  elseif string.sub(d,1,1)=="1" then --forward
		gpio.write(led1, gpio.HIGH);
        gpio.write(led2, gpio.LOW);
        gpio.write(led3, gpio.HIGH);
        gpio.write(led4, gpio.LOW);
		stopFlag = false;
		c:send("ok\r\n");
	  elseif string.sub(d,1,1)=="2" then --backward
		gpio.write(led1, gpio.LOW);
		gpio.write(led2, gpio.HIGH);
		gpio.write(led3, gpio.LOW);
		gpio.write(led4, gpio.HIGH);
		stopFlag = false;
		c:send("ok\r\n");
	  elseif string.sub(d,1,1)=="3" then --left
		gpio.write(led1, gpio.HIGH);
		gpio.write(led2, gpio.LOW);
		gpio.write(led3, gpio.LOW);
		gpio.write(led4, gpio.HIGH);
		stopFlag = false;
		c:send("ok\r\n");
	  elseif string.sub(d,1,1)=="4" then --right
		gpio.write(led1, gpio.LOW);
		gpio.write(led2, gpio.HIGH);
		gpio.write(led3, gpio.HIGH);
		gpio.write(led4, gpio.LOW);
		stopFlag = false;
		c:send("ok\r\n");
      else  print("Invalid Command:"..d);c:send("Invalid CMD\r\n");end;
	  collectgarbage();
    end) --end c:on receive

    c:on("disconnection",function(c) 
		gpio.write(led1, gpio.LOW);
		gpio.write(led2, gpio.LOW);
		gpio.write(led3, gpio.LOW);
		gpio.write(led4, gpio.LOW);
		stopFlag = true;
		print("TCPSrv:Client disconnet");
		collectgarbage();
    end) 
    print("TCPSrv:Client connected")
    gpio.write(led1, gpio.LOW);
	gpio.write(led2, gpio.LOW);
	gpio.write(led3, gpio.LOW);
	gpio.write(led4, gpio.LOW);
	stopFlag = true;
end)
