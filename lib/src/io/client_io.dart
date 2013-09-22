part of elastic_search_client_io;

class HttpChannel extends Channel {
  Future<JsonObject> open(String method, Uri uri, [Object postData]) {   
    return this._getClient().openUrl(method, uri).then(
      (request) => _onRequest(request, postData)
    ).then(
      (response) => _onResponse(response)    
    );
  }
  
  HttpClient _getClient() {
    return new HttpClient();
  }

  Future<HttpClientResponse> _onRequest(HttpClientRequest request, [Object postData]) {    
    request.headers.contentType = new ContentType(
      'application', 
      'json', 
      charset : Encoding.UTF_8.name
    );
    
    var message = 'Send json- ' + request.method + ' request to: ' + 
        request.uri.toString();
    Logger.root.finer(message);
    
    if (postData != null) {
//      var jsonData = JSON.stringify(postData);
//      Logger.root.finer('Use data: ' + jsonData);
//      request.contentLength = jsonData.length;
//      request.write(jsonData);
    }
    else {
      request.contentLength = 0;
    }
    

    
    return request.close();
  }
  
  Future<JsonObject> _onResponse(HttpClientResponse response) {
    var message = 'Transform response to json. Status: ' + 
        response.statusCode.toString();
    Logger.root.finer(message);
    
    return response.transform(new convert.Utf8Decoder()).join('').then(
        (jsonString) => new JsonObject.fromJsonString(jsonString)
    );
  }
}