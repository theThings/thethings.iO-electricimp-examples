#DHT11 and tilt sensors combined with Electric Imp and TheThings.iO

This example uses a DHT11 and a tilt sensors to report temperature, humidity and tilt data to thethings.iO. The class TheThingsAPI is used to access the write service

Retrieve the data from the DHT11 sensor using Electric Imp could be quite tricky. For this reason we have used [this](https://github.com/electricimp/reference/tree/master/hardware/DHT11) function that uses the SPI bus to read the sensor's internal protocol.

##Schematics

##Code
The device (Electric Imp board) will retrieve data from the DHT11 every 5 seconds and will send the values to the agent. The board will monitor the pin attached to the tilt sensor and will trigger a function everytime it detects a change. The triggered function will warn the agent of the change. 

Only the agent will talk directly with TheThings.iO services. This is how Electric Imp wants to centralize communications with the web.
###Device code
The device first configures the pins and the SPI:

  // DHT11 configuration
  spi         <- hardware.spi257;
  clkspeed    <- spi.configure(MSB_FIRST, SPICLK);
  dht11 <- DHT11(spi, clkspeed);
  // Tilt sensor configuration
  hardware.pin9.configure(DIGITAL_IN, tiltChanged);

The tilt sensor's callback function simply notifies the changes to the agent:

  // Read titl sensor and send to agent
  function tiltChanged() {
      local data = hardware.pin9.read();
      agent.send("tilt", data);
  }

The DHT11 data is read inside a loop that triggers every 5 seconds. The humidity and temperature values are obtained by calling dh11.read() function.

  // Main loop, read DHT11 and send to agent
  function loop() {
      imp.wakeup(INTERVAL, loop);
      local data = dht11.read();
      agent.send("tempHum", data);
  }

###Agent code

The agent declares the 
