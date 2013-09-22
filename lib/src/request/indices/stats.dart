part of elastic_search_client;

/**
 * Represents request for a [stats query](http://www.elasticsearch.org/guide/reference/api/admin-indices-stats/).
 * 
 */
class Stats extends _Request {
  
  /**
   * The name of the action that is executed.
   */
  static const ACTION = '_stats';
    
  /**
   * Should the the number of docs / deleted docs (docs not yet merged out) be 
   * returned. Note, affected by refreshing the index.
   */
  Stats docs(bool value) => this.set(_Flags.DOCS, value);
  
  /**
   * The size of the index.
   */
  Stats store(bool value) => this.set(_Flags.STORE, value);
  
  /**
   * Indexing statistics, can be combined with a comma separated list of types 
   * to provide document type level stats.
   */
  Stats indexing(bool value) => this.set(_Flags.INDEXING, value);
  
  /**
   * Get statistics, including missing stats.
   */
  Stats getStat(bool value) => this.set(_Flags.GET, value);
  
  /**
   * Search statistics, including custom grouping using the groups parameter 
   * (search operations can be associated with one or more groups).
   */
  Stats search(bool value) => this.set(_Flags.SEARCH, value);
  
  /**
   * Warmer statistics.
   */
  Stats warmer(bool value) => this.set(_Flags.WARMER, value);
  
  /**
   * Merge stats.
   */
  Stats merge(bool value) => this.set(_Flags.MERGE, value);
  
  /**
   * Flush stats.
   */
  Stats flush(bool value) => this.set(_Flags.FLUSH, value);
  
  /**
   * Refresh stats.
   */
  Stats refresh(bool value) => this.set(_Flags.REFRESH, value);
   
  /**
   * Clears all the flags (first).
   */
  Stats clear(bool value) => this.set(_Flags.CLEAR, value);

  /**
   * The document types that should be used.
   */
  Stats types(List<String> types) 
      => this.set(_Flags.TYPES, types.join(','));
  
  /**
   * Custom grouping using the groups parameter for the search stats.
   */
  Stats groups(List<String> groups) 
      => this.set(_Flags.GROUPS, groups.join(','));
    
  Stats(client) : super(
      client, 
      _Request.METHOD_GET, 
      Stats.ACTION,
      _Flags.defaultParameter
  );
}

class _Flags {
  static const String DOCS = 'docs';
  static const String STORE = 'store';
  static const String INDEXING = 'indexing';
  static const String GET = 'get';
  static const String SEARCH = 'search';
  static const String WARMER = 'warmer';
  static const String MERGE = 'merge'; 
  static const String FLUSH = 'flush';  
  static const String REFRESH = 'refresh'; 
  static const String CLEAR = 'clear';
  static const String TYPES = 'types';
  static const String GROUPS = 'groups';
  
  static const Map<String, Object> defaultParameter = const {
    _Flags.STORE : true,
    _Flags.INDEXING : true,
    _Flags.GET : true,
    _Flags.SEARCH : true,
    _Flags.DOCS : true
  };
}