part of elastic_search_client;

// Logger for the whole lib
final _logger_request = new Logger('elastic_search_client.request');

abstract class Request<responseType extends Response> {
  /**
   * Executes the request.
   */
  Future<responseType> run();
}

/**
 * A [_Request] is a basic action againts an elasticsearch server. New actions 
 * can use this class a base.
 */
abstract class _Request<
    implType extends _Request, 
    dataType extends _RequestData, 
    responseType extends Response
  > implements Request<responseType> {
  
  /// Use delete method for the request.
  static const METHOD_PUT = 'put';
  
  /// Use delete method for the request.
  static const METHOD_DELETE = 'delete';
  
  /// Use get method for the request.
  static const METHOD_GET = 'get';
  
  /// Use a post method for the request.
  static const METHOD_POST = 'post';
  
  /// The [IndexClient] used for execution.
  final IndexClient _client;
  
  /// The request method which is used for the current request.
  final String method;
  
  /// The name of the action that is executed.
  final String action;
  
  /// A map of additional parameters that are send in the request.
  final Map<String, Object> parameter = new Map();
  
  /// post and pu data.
  dataType _data;
  
  String get data => this._data != null ? this._data.toString() : '';
  
  /**
   * Create a new request which is send to [_client] with [method] as http 
   * method. The [action] identifies the elasticsearch action that is executed
   * (like stats...).
   * 
   * The given [parameter] are appended to the http request. 
   */
  _Request(
      this._client, 
      this.method,
      [ 
        this.action = '', 
        Map<String, Object> parameter = const {}
      ]
  ) {
    if(parameter.isNotEmpty) {
      this.parameter.addAll(parameter);
    }
  }
  
  /**
   * Executes the request.
   */
  Future<responseType> run() => this._client._run(this);

  /**
   * Set a parameter value for the request.
   */
  set(String key, Object value) {
    this.parameter[key] = value;
    
    return this;
  }
    
  /**
   * The JSON returned in the request will be pretty formatted (use it for 
   * debugging only!).
   */
  implType pretty(bool value) => this.set(_RequestFlags.PRETTY, value);
  
  /**
   * Statistics are returned in a format suitable for humans (eg "exists_time":
   * "1h" or "size": "1kb") and for computers (eg "exists_time_in_millis": 
   * 3600000` or "size_in_bytes": 1024).
   */
  implType human(bool value) => this.set(_RequestFlags.HUMAN, value);

  /**
   * You can pass the request body as the source query string parameter 
   * instead for non-Post requests.
   */
  implType source(String value) {
    if (value.isNotEmpty && ![METHOD_POST, METHOD_PUT].contains(this.method)) { 
      this.set(_RequestFlags.SOURCE, value);
    }
    
    return this;
  }
  
  /**
   * All field names in the result will be returned in camel casing, otherwise, 
   * underscore casing will be used. Note, this does not apply to the source 
   * document indexed.
   */
  implType camelCase(bool value) => this.set(
      _RequestFlags.CASE, 
      value ? 'camelCase' : 'underscore' 
  );
  
  /**
   * Basi to srting method.
   */
  String toString() {
    Map<String, Object> result = {
      'method' : this.method,                            
      'action' : this.action,                            
      'parameter' : this.parameter,
      'data' : this._data,
    };
    
    return new JsonObject.fromMap(result).toString();
  }
}

class _RequestFlags {
  static const String PRETTY = 'pretty';
  static const String HUMAN = 'human';
  static const String CASE = 'case';
  static const String SOURCE = 'source';
  
  static const Map<String, Object> defaultParameter = const {
  };
}

abstract class _RequestData {
  
}