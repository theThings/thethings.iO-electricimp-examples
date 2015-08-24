#require "TheThingsAPI.class.nut:1.0.0"


// Callback functions 
function tempHum(data) {
    thing.addVar("humidity", data.rh);
    thing.addVar("temp", data.temp, {
        "geo": {
            "lat": data.geo.lat,
            "long": data.geo.long
        }
    });
    
    thing.write(function(err, resp, data) {
        if (err) {
            server.error(err);
            return;
        }
        server.log("Success!");
    });
}

function tilt(data) {
    thing.addVar("tilt", data);
    thing.write(function(err, resp, data) {
        if (err) {
            server.error(err);
            return;
        }
        server.log("tilt Success!");
    });
}


// Create global object to connect to TheThings.iO
thing <- TheThingsAPI("youTokenHere");

// Register callback functions from the device
device.on("tempHum", tempHum)
device.on("tilt", tilt)

