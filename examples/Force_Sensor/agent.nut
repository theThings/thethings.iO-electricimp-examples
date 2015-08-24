#require "TheThingsAPI.class.nut:1.0.0"

function glove(data) {
    // Log the received data
    server.log("left: " + data.left+"\t\t" + "right: " + data.right +
        "\t\t"+ "mean: " + data.mean);
    // Add variables to be sent to thethings.iO 
    thing.addVar("left",data.left).addVar("right",data.right);
    thing.addVar("mean",(data.left+data.right)/2);
    // Actually send the data
    thing.write();
}

// Register "glove" function
device.on("glove", glove);

// Create a thethings.iO object to communicate with the thethings.iO cloud
thing <- TheThingsAPI("hX8NKildILix3Saik4m-U-UINmFF587vsi9W1fWqraE");
