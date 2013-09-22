part of elastic_search_client;

/**
 * A [_Request] is a basic action againts an elasticsearch server. New actions 
 * can use this class a base.
 */
abstract class _Request {
  
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
  
  /// Data taht is send to in the request.
  Object data;
    
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
  Future<JsonObject> execute() {
    return this._client._execute(this);
  }

  /**
   * Set a parameter value for the request.
   */
  set(String key, Object value) {
    this.parameter[key] = value;
    
    return this;
  }
}