#require "TheThingsAPI.class.nut:1.0.0"

function button(state) {
    server.log("button!");
    numClicks++;
    thing.addVar("button", numClicks);
    thing.write(function(err, resp, data) {
        if (err) {
            server.error(err);
            return;
        }
        server.log("Success!");
    });
}


function loop() {
    imp.wakeup(5, loop);
    
    // Get the last 100 samples collected in the last 24 hours for 'button'
    //local yesterday = time() - 86400; // 86400 seconds in a day
    //thing.read("button", { "limit": 100, "startDate": yesterday }, 
    //function(err, resp, data) {
    //    if (err) {
    //        server.error(err);
    //        return;
    //    }
    //
    //    foreach(sample in data) {
    //        server.log(sample.datetime + ": " + sample.value);
    //    }
    //});    
    
    // Read last value of the variable button
    thing.read("button", null, function(err, resp, data) {
        if (err) {
            server.error(err);
            return;
        }
        // Get the sample
        local result = data[0];
        server.log(result.value);
        // If the number of clicks is multiple of 2, turn on the led.
        // if not, turn it off.
        if (result.value%2 == 0) {
            device.send("ledReadOnOff", 1)
        } else {
            device.send("ledReadOnOff", 0)
        }
    });
}


// Option 1: Use a thing already activated (we have the token)
thing <- TheThingsAPI("<-- YOUR_TOKEN_HERE -->");

// Option 2: activate a new thing (we don't have the token).
// Create a thing object
//thing <- TheThingsAPI();
//
// Activate a thing with a token from your Dev Console
//thing.activate("<-- ACTIVATION_TOKEN -->", function(err, resp, data) {
//    // If it failed - log an error message
//    if (err) {
//        server.error("Failed to activate Thing: " + err);
//        return;
//    }
//    server.log("Success! Activated Thing!");
//    local token = thing.getToken();
//    server.log ( "Thing token: " + token );
//});

// Initialize number of clicks.
numClicks <- 0;
// Register "button" function.
device.on("button", button);

loop();

