part of elastic_search_client_io;

// Logger for the whole lib
final _io_logger = new Logger('elastic_search_client.io');

class HttpChannel extends Channel {
  
  HttpClient _client;
  
  Future<String> open(String method, Uri uri, [String data = '']) {
    return this._getClient().openUrl(method, uri).then(
      (request) => _onRequest(request, data)
    ).then(
      (response) => _onResponse(response)    
    );
  }
  
  HttpClient _getClient() {
    if (null == this._client) {
      this._client = new HttpClient();
    }
    
    return this._client;
  }

  Future<HttpClientResponse> _onRequest(
      HttpClientRequest request, 
      [String data = '']
  ) {
    request.headers.contentType = new ContentType(
      'application', 
      'json', 
      charset : UTF8.name
    );
    
    var message = 'Send json-' + request.method + ' request to: ' + 
        request.uri.toString();
    _io_logger.finer(message);
    _io_logger.finest(
        'HTTP chunking: ' + request.headers.chunkedTransferEncoding.toString()
    );
    
    if (data.isNotEmpty) {
      _io_logger.finer('Use data: ' + data);
      request.contentLength = data.length;
      request.write(data);
    } else {
      request.contentLength = 0;
    }

    return request.close();
  }
  
  Future<String> _onResponse(HttpClientResponse response) {
    var message = 'Transform response to json. Status: ' + 
        response.statusCode.toString();
    _io_logger.finer(message);
    
    return response.transform(new Utf8Decoder()).join('');
  }
}