part of elastic_search_client;

/**
 * A [Response] is a basic response for all elasticsearch actions. Always 
 * includes a status.
 */
abstract class Response {
  
}

/**
 * Simple response with basic json data.
 */
class _Response extends JsonObject implements Response  {
  
  /**
   * Basic constructor for factory method.
   */
  _Response();
      
  /**
   * Create object based on Json string.
   */
  factory _Response.fromJsonString(String jsonString) {
    _Response response = new JsonObject.fromJsonString(jsonString, new _Response());
    if (response.containsKey('error')) {
      response = new JsonObject.fromJsonString(jsonString, new _ErrorResponse());
    } 
    
    return response;
  }
}

/**
 * A [ErrorResponse] is a response representing an error during action 
 * execution.
 */
abstract class ErrorResponse extends Response {
  
  static const ERROR = 400;
  
  /// string of the response
  String error; 
  
  /// string of the response
  String status;
  
  /**
   * Create an [ErrorResponse] with the given error [message].
   */
  factory ErrorResponse(message) {
    return new _ErrorResponse.withMessage(message);
  }
}

/**
 * Needs no implementation because of JsonObjects magic getter and setter.
 */
class _ErrorResponse extends _Response implements ErrorResponse  {
  
  /**
   * Basic constructor for factory method.
   */
  _ErrorResponse();
      
  /**
   * 
   */
  factory _ErrorResponse.withMessage(error) {
    JsonObject base = new JsonObject.fromMap(
        {'status' : ErrorResponse.ERROR, 'error' : error}
    );
    
    return JsonObject.toTypedJsonObject(base, new _ErrorResponse());
  }
}