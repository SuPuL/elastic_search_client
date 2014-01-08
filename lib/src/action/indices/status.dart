part of elastic_search_client;

/**
 * Represents request for a [status action](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/indices-status.html).
 * 
 */
class Status extends _Request<Status, _RequestData, _Response> {
  
  /**
   * The name of the action that is executed.
   */
  static const ACTION = '_status';
  
  /**
   * In order to see the recovery status of shards, pass recovery flag and set 
   * it to true.
   */
  Status recovery(bool value) => this.set(_StatusFlags.RECOVERY, value);
  
  /**
   * In order to see the snapshot status, pass the snapshot flag and set 
   * it to true.
   */
  Status snapshot(bool value) => this.set(_StatusFlags.SNAPSHOT, value);
      
  Status(client) : super(client, _Request.METHOD_GET, Status.ACTION);
}

class _StatusFlags {
  static const String RECOVERY = 'recovery';
  static const String SNAPSHOT = 'snapshot';
}