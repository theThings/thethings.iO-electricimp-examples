// Class to communicate with TheThings.iO
class TTRest {
    static URLROOT="https://api.thethings.io/v2/things/";
    static HEADERS={"Accept": "application/json", "Content-Type": "application/json"};
    
    _token = "";
    _url = "";
    
    _data = "";
    
    constructor(token) {
        _token = token;
        _url = URLROOT + _token;
    }
    
    // Add variable name (string) and the value of the variable name (int, float)
    function addVar(variable, value) {
        if ( _data == "" ) {
            _data=@"{""values"":[{""key"": """ + variable + @""",""value"": " + value + "}"
        } else {
            _data = _data + @",{""key"": """ + variable + @""",""value"": " + value + "}";
        }
        
    }
    
    // Actually send the values to TheThings.iO
    function send() {
        //local data = @"{""values"":[{""key"": """ + variable + @""",""value"": " + value + "}]}";
        _data = _data + "]}"
        local request = http.post(_url, HEADERS, _data);
        local response = request.sendsync();
        _data = "";
        return response;
    }
}

// Callback functions 
function tempHum(data) {
    tt.addVar("humidity", data.rh);
    tt.addVar("temp", data.temp);
    
    local response = tt.send();
    server.log("Code: " + response.statuscode + ". Message: " + response.body);
}

function tilt(data) {
    tt.addVar("tilt", data);
    
    local response = tt.send();
    server.log("Code: " + response.statuscode + ". Message: " + response.body);
}


// Create global object to connect to TheThings.iO
tt <- TTRest("yourTokenHere");

// Register callback functions from the device
device.on("tempHum", tempHum)
device.on("tilt", tilt)
