// Alias pin 2 and 5 as fl and fr
fl <- hardware.pin2;
fr <- hardware.pin5;
 
// Configure the pin for analog input
fl.configure(ANALOG_IN);
fr.configure(ANALOG_IN);
 
// Define a function to poll the pin every 0.1 seconds
function poll() {
    // Read the pins. max value 65535, min 0.
    local right = fr.read();
    local left = fl.read();
    
    // Invert the values
    right = math.abs(right - 65535);
    left = math.abs(left - 65535);
    local mean = (right + left)/2;
    
    // Send data if a force is detected
    if (mean > 10000) {
        local data;
        data = {"left" : left, "right" : right, "mean" : mean};
        agent.send("glove", data);
    }
    
    // Wake up in 0.1 seconds and do it again
    imp.wakeup(0.2, poll);
}
 
 
// Start the loop by calling the poll() function
poll();
