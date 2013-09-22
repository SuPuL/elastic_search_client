part of elastic_search_client;

/**
 * Represents request for a [create index action](http://www.elasticsearch.org/guide/reference/api/admin-indices-delete-index/).
 * 
 */
class CreateIndex extends _Request {
    
  CreateIndex(client) : super(
      client, 
      _Request.METHOD_PUT
  );
}