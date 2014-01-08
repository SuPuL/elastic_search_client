part of elastic_search_client;

/**
 * Represents request for a [create index action](http://www.elasticsearch.org/guide/reference/api/admin-indices-delete-index/).
 * 
 */
class CreateIndex extends _Request<CreateIndex, CreateIndexData, _Response> {
  
  CreateIndex(client) : super(client, _Request.METHOD_PUT);
  
  CreateIndex settings(IndexSettings settings) {
    this._data = new _CreateIndexData.withSettings(settings);
    
    return this;
  }
}

abstract class CreateIndexData extends _RequestData {
  
  IndexSettings index;
  
}

class _CreateIndexData extends JsonObject implements CreateIndexData {
  /**
   * Basic constructor for factory method.
   */
  _CreateIndexData();
      
  factory _CreateIndexData.withSettings(IndexSettings settings) {
    JsonObject base = new JsonObject.fromMap(
        {'index' : settings}
    );
    
    return JsonObject.toTypedJsonObject(base, new _CreateIndexData());
  }
}