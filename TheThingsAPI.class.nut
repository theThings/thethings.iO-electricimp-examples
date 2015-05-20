// Copyright (c) 2015 TheThings.iO
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT

class TheThingsAPI {
    static URLROOT="https://api.thethings.io/v2/things/";
    static HEADERS_WRITE={"Accept": "application/json", "Content-Type": "application/json"};
    static HEADERS_READ={"Accept": "application/json"};
    static HEADERS_ACT={"Accept": "application/json", "Content-Type": "application/json"};
    
    _token      = "";
    _urlWrite   = "";
    _urlRead    = "";
    _urlAct     = "";
    
    _data = "";
    
    // Create a new thing passing it's existing token as an argument 
    // or leave it empty to activate it later using "activate" function.
    constructor(token = null) {
        _initData(token);
    }
    
    // Activate a new thing. This is only necessary if you don't have
    // it's token. An activation code is required.
    function activate(activationCode) {
        _data = @"{""activationCode"" : """ + activationCode + @"""}";
        
        local request = http.post(_urlAct, HEADERS_ACT, _data);
        local response = request.sendsync();
        local respObj = http.jsondecode(response.body);
        
        if (respObj.status != "created") {
            server.log("Error creating thing: " + activationCode);
        } else {
            server.log("Thing: " + activationCode + " activated sucessfully");
            _initData(respObj.thingToken);
        }
        
        _data = "";
    }
    
    // Return thing's token
    function getToken() {
        return _token;
    }
    
    // To write a variable into the theThings.iO cloud, call this function with
    // the value to write. This function can be called any times to add more 
    // variables to be sent. Finally, call the "send" function to actually write
    // the values.
    //
    // key: string
    // value: number or string
    function addVar(key, value) {
        if ( _data == "" ) {
            _data=@"{""values"":[{""key"": """ + key + @""",""value"": " + value + "}"
        } else {
            _data = _data + @",{""key"": """ + key + @""",""value"": " + value + "}";
        }
        
    }
    
    // Actually send the values to theThings.iO. See function "addVar".
    function send() {
        //local data = @"{""values"":[{""key"": """ + variable + @""",""value"": " + value + "}]}";
        _data = _data + "]}"
        local request = http.post(_urlWrite, HEADERS_WRITE, _data);
        local response = request.sendsync();
        _data = "";
        return response;
    }
    
    // Read a variable from the theThings.iO. If only the argument
    // "key" is specified, the last value will be returned. This function will 
    // return "limit" number of values of the variable inside an array.
    //
    // key: name of the variable
    // limit: max number of values to return.
    // startDate and endDate format: YYYYMMDDHHmmss
    function read(key, limit = null, startDate = null, endDate = null) {
        local getUrl = _urlRead + key + "/";

        if (limit != null) {
            getUrl += "?limit=" + limit;
        }
        if (startDate != null) {
            getUrl += "&startDate=" + startDate;
        }
        if (endDate != null) {
            getUrl += "&endDate=" + endDate;
        }
        
        local request = http.get(getUrl, HEADERS_READ);
        local response = request.sendsync();
        local dataArray = http.jsondecode(response.body);
        return dataArray;
    }
    
    
    // Private functions
    function _initData(token) {
        _token = token;
        _urlWrite = URLROOT + _token;
        _urlRead = URLROOT + _token + "/resources/";
        _urlAct = URLROOT;
    }
}
