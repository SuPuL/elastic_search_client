part of elastic_search_client;

/**
 * Represents request for a [delete index action](http://www.elasticsearch.org/guide/reference/api/admin-indices-delete-index/).
 * 
 */
class DeleteIndex extends _Request {
    
  DeleteIndex(client) : super(
      client, 
      _Request.METHOD_DELETE
  );
}