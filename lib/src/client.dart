part of elastic_search_client;

// Logger for the whole lib
final _logger_library = new Logger('elastic_search_client');

/**
 * A [Channel] is the way how the client will communicate with the 
 * elasticsearch server. If you wanna use the clinet from the cmmand line you 
 * have to use a channel based on the io lib from google. If you wanna use a 
 * elastic search from the web clinet use a channel including tthe http clinet 
 * from google. 
 * 
 * A channel also defines which data format is used for transactions. Currently 
 * only json strings are used and supported.
 */
abstract class Channel {  
  Future<String> open(String method, Uri uri, [String data = '']);
}

/**
 * [IndexClient] repesents the basic interface for executing requests against 
 * elastic search. The most simple implementation will try a request once. 
 * Maybe there will be more complex clinets in the future which use multiple 
 * elasticsearch server for more gracefullness or something else.
 */
abstract class IndexClient {
  
  /**
   * Calls new [_IndexClient] and use the [channel] for communication and the 
   * [host] as elasticsearch server. The [indices] are used for search. If no 
   * index is given all indices on the server are used.
   */
  factory IndexClient(
      Channel channel,
      String host,
      {
        List<String> indices : const []
      }
  ) => new _IndexClient(channel, host, indices : indices);
  
  /**
   * Creates a [Future] for executing teh given request. The result of the 
   * excution will always be a [Response] bsed on the elasticsearch 
   * specifications for actions.
   */
  Future<Response> _run(_Request request);
 
  /**
   * Creates a create index request object which creates a index with the given 
   * name. The [CreateIndex] is defined [here](http://www.elasticsearch.org/guide/reference/api/admin-indices-create-index/). 
   */
  CreateIndex createIndex(String index);
 
  /**
   * Creates a delete index request object which deletes all given indices. 
   * name. The [DeleteIndex] is defined [here](http://www.elasticsearch.org/guide/reference/api/admin-indices-delete-index/). 
   */
  DeleteIndex deleteIndex([ List<String> indices = const [] ]);
  
  /**
   * Creates a status request object which is executed againt the given 
   * [indices]. If no index is given the global configuration is used. The 
   * [Status] is defined [here](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/indices-status.html/). 
   */
  Status status([ List<String> indices = const [] ]);
  
  /**
   * Creates a stats request object which is executed againt the given 
   * [indices]. If no index is given the global configuration is used. The 
   * [Stats] is defined [here](http://www.elasticsearch.org/guide/reference/api/admin-indices-stats/). 
   */
  Stats stats([ List<String> indices = const [] ]);
}

/**
 * Simple basi [IndexClient] 
 */
class _IndexClient implements IndexClient {
  
  /// The [Channel] used for the communication.
  final Channel channel;
  
  /// The url where the elasticsearch server can be found.
  final String host;
  
  /// The basic list of indices which is used for actions.
  final List<String> indices;

  /**
   * Creates a index client use the [channel] for communication and the 
   * [host] as elasticsearch server. The [indices] are used for search. If no 
   * index is given all indices on the server are used.
   */
  _IndexClient(this.channel, this.host, { this.indices });

  /**
   * Creates a create index request object which creates a index with the given 
   * name. The [CreateIndex] is defined [here](http://www.elasticsearch.org/guide/reference/api/admin-indices-create-index/). 
   */
  CreateIndex createIndex(String index) 
      => new CreateIndex(this._createClientForIndices([index]));
  
  /**
   * Creates a delete index request object which deletes all given indices. 
   * name. The [DeleteIndex] is defined [here](http://www.elasticsearch.org/guide/reference/api/admin-indices-delete-index/). 
   */
  DeleteIndex deleteIndex([ List<String> indices = const [] ]) 
      => new DeleteIndex(this._createClientForIndices(indices));

  /**
   * Creates a status request object which is executed againt the given 
   * [indices]. If no index is given the global configuration is used. The 
   * [Status] is defined [here](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/indices-status.html/). 
   */
  Status status([ List<String> indices = const [] ]) 
      => new Status(this._createClientForIndices(indices));
  
  /**
   * Creates a stats request object which is executed againt the given 
   * [indices]. If no index is given the global configuration is used. The 
   * [Stats] is defined [here](http://www.elasticsearch.org/guide/reference/api/admin-indices-stats/). 
   */
  Stats stats([ List<String> indices = const [] ]) 
      => new Stats(this._createClientForIndices(indices));
  
  /**
   * Create a new index clinet using the [indices] for queries. If no [indices] 
   * are given use the configuration for this client.
   */
  IndexClient _createClientForIndices(List<String> indices) {
    return new _IndexClient(
        this.channel,
        this.host,
        indices : indices.isNotEmpty ? indices : this.indices
    );
  }
 
  /**
   * Creates a [Future] for executing teh given request. The result of the 
   * excution will always be a [Response] bsed on the elasticsearch 
   * specifications for actions.
   */
  Future<Response> _run(_Request request) {
    return this.channel.open(
      request.method, 
      this._createUri(request),
      request.data
    ).then((jsonString) => new _Response.fromJsonString(jsonString))
     .catchError((e) => _handleExecutionError(e));
  }
    
  /**
   * Create an [ErrorResponse] from the given [error].
   */
  ErrorResponse _handleExecutionError(error) {
    String message = error.toString();
    _logger_library.severe(message, error);
    
    return new ErrorResponse('Error while connecting the search cluster.');
  }
  
  /**
   * Create the uri used for the communication with elasticsearch. The result 
   * is based on all parameters of the [request].
   */
  Uri _createUri(_Request request) {
     var path = this.indices.fold(
         '', 
         (result, index) => result.isEmpty ? index : result + ',' + index
     );

     path += '/';
     if (request.action.isNotEmpty) {
       path += request.action;  
     }
     
     var parameter = new Map<String, String>();
     request.parameter.forEach(
         (key, object) => parameter[key] = object.toString()
     );

     var uri = new Uri.http(this.host, path, parameter);
     _logger_library.finest('Create request uri: ' + uri.toString());
     
     return uri;
  }
}

class _ExtendedJsonObject extends JsonObject {
  noSuchMethod(Invocation mirror) {
    int positionalArgs = 0;
    if (mirror.positionalArguments != null) positionalArgs = mirror.positionalArguments.length;

    var property = _getSymbolString(mirror.memberName);
    
    if (mirror.isGetter && (positionalArgs == 0)) {
      // if no object is set. Set it dynamically
      if (!this.containsKey(property)) {
        var instance = this._createProperty(mirror.memberName);
        if (null != instance) {
          this[property] = instance; 
        }
      }
    }
    
    return super.noSuchMethod(mirror);
  }
    
  Object _createProperty(Symbol memberName) {
    ClassMirror classMirror = reflectClass(this.runtimeType);
    List classesToCheck = [classMirror];
    classesToCheck.addAll(classMirror.superinterfaces);
    
    ClassMirror parentClass = classesToCheck.firstWhere(
      (parent) => parent.members.containsKey(memberName)
    );
    
    var instance = null;
    if (null != parentClass) {
      var propertyMember = parentClass.members[memberName];
      if (propertyMember is VariableMirror) {
        ClassMirror propertyClass = propertyMember.type;
        instance = propertyClass.newInstance(const Symbol(''), []).reflectee;
      }
    }
    
    return instance;
  }
  
  String _getSymbolString(value) {
    if (value is Symbol) {
      return MirrorSystem.getName(value);
    }
    else {
      return value.toString();
    }
  }
}