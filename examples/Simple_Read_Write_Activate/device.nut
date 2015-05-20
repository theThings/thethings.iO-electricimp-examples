#require "Button.class.nut:1.1.0"

// Turn on or off the led
function ledReadOnOff(status) {
    ledRead.write(status);
}


// Configure button and led
button <- Button(hardware.pin9, DIGITAL_IN, Button.NORMALLY_LOW);
ledRead <- hardware.pin7;

ledRead.configure(DIGITAL_OUT, 0);

// Callback function for button, just call agent.
button.onPress(function() {
    agent.send("button", true);
});

// Register agent's callback function to 
// turn on and off the led
agent.on("ledReadOnOff", ledReadOnOff)
