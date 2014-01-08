part of elastic_search_client;

/**
 * Represents [settings](http://www.elasticsearch.org/guide/reference/api/admin-indices-update-settings/) used for index building and put settings on for a 
 */
abstract class IndexSettings {

  /// The number of shard each index has.
  int number_of_shards;
  
  /// The number of replicas each shard has.
  int number_of_replicas;
  
  /// The async refresh interval of a shard. Timestring like 1s 500ms or -1 to 
  /// for disable.
  String refresh_interval;
  
  /// The Lucene index term interval. Only applies to newly created docs. 
  /// Timestring like 1s 500ms or -1 to for disable.
  String term_index_interval;
  
  /// The Lucene reader term index divisor.
  int term_index_divisor;
  
  /// Default to 8.
  int index_concurrency;
  
  /// Codec (direct, memory, bloom, pulsing or default).
  /// 
  /// @todo codex part for creating an index 
  String codec;
  
  /// Default to true.
  int fail_on_merge_failure;
  
  /// Set to an actual value (like 0-all) or false to disable it.
  String auto_expand_replicas;
  
  /// Time when removed documents are removed from the  Timestring like 
  /// 1s 500ms or -1 to for disable.
  int gc_deletes;
  
  /// Should the compound file format be used (boolean setting).
  bool compound_format;
  
  /// Controls how aggressively merges that reclaim more deletions are favored. 
  /// Higher values favor selecting merges that reclaim deletions. A value of 
  /// 0.0 means deletions don’t impact merge selection. Defaults to 2.0.
  double reclaim_deletes_weight;
  
  /// Blocks settings.
  BlocksSettings blocks;
  
  /// Gateway settings
  GatewaySettings gateway;
  
  /// Indices settings.
  IndicesSettings indices;
  
  /// Merge settings
  MergeSettings merge;

  /// Recovery settings
  RecoverySettings recovery;
  
  /// routing settings.
  RoutingSettings routing;
  
  /// Search settings.
  SearchSettings search;
  
  /// Store settings.
  StoreSettings store;
  
  /// Search settings.
  TranslogSettings translog;
  
  /// TTL settings.
  TTLSettings ttl;
  
  /// Warmer settings.
  WarmerSettings warmer;
  
  factory IndexSettings() => new _IndexSettings();
}

abstract class TTLSettings {
  /// ttl.disable_purge Disables temporarily the purge of expired docs.
  String disable_purge;  
  
  factory TTLSettings() => new _TTLSettings();
}

abstract class RecoverySettings {
  /// recovery.initial_shards When using local gateway a particular shard is 
  /// recovered only if there can be allocated quorum shards in the cluster. 
  /// It can be set to quorum (default), quorum-1 (or half), full and full-1. 
  /// Number values are also supported, e.g. 1.
  String initial_shards;  
  
  factory RecoverySettings() => new _RecoverySettings();
}

abstract class GatewaySettings {
  /// gateway.snapshot_interval The gateway snapshot interval (only applies to 
  /// shared gateways). Default to 10s.
  String snapshot_interval;  
  
  factory GatewaySettings() => new _GatewaySettings();
}

abstract class WarmerSettings {
  /// warmer.enabled, See admin indices warmers. Default to true.
  bool enabled;  
  
  factory WarmerSettings() => new _WarmerSettings();
}

abstract class StoreSettings {
  /// store.type simplefs niofs mmapfs memory
  String type;  

  CompressSettings compress;  
  
  factory StoreSettings() => new _StoreSettings();
}

abstract class CompressSettings {
  /// compress.stored true or false In the mapping, one can configure the 
  /// _source field to be compressed. The problem with it is the fact that 
  /// small documents don’t end up compressing well, as several documents 
  /// compressed in a single compression “block” will provide a considerable 
  /// better compression ratio. This version introduces the ability to compress 
  /// stored fields using the store.compress.stored setting, as well as term 
  /// vector using the store.compress.tv setting.
  bool stored;

  /// compress.tv true or false
  bool tv;
  
  factory CompressSettings() => new _CompressSettings();
}

abstract class MergeSettings {
  PolicySettings policy;  

  SchedulerSettings scheduler;  
  
  factory MergeSettings() => new _MergeSettings();
}

abstract class PolicySettings {
  /// policy.expunge_deletes_allowed  When expungeDeletes is called, we only 
  /// merge away a segment if its delete percentage is over this threshold. 
  /// Default is 10.
  int expunge_deletes_allowed;
  
  /// policy.floor_segment Segments smaller than this are “rounded up” to this 
  /// size, i.e. treated as equal (floor) size for merge selection. This is to 
  /// prevent frequent flushing of tiny segments from allowing a long tail in 
  /// the  Default is 2mb.
  String floor_segment;
  
  /// policy.max_merge_at_once Maximum number of segments to be merged at a 
  /// time during “normal” merging. Default is 10.
  int max_merge_at_once;
  
  /// policy.max_merge_at_once_explicit; Maximum number of segments to be 
  /// merged at a time, during optimize or expungeDeletes. Default is 30.
  int max_merge_at_once_explicit;
  
  /// policy.max_merged_segment, Maximum sized segment to produce during normal 
  /// merging (not explicit optimize). This setting is approximate: the 
  /// estimate of the merged segment size is made by summing sizes of 
  /// to-be-merged segments (compensating for percent deleted docs). 
  /// Default is 5gb.
  String max_merged_segment;
  
  /// policy.segments_per_tier; Sets the allowed number of segments per tier. 
  /// Smaller values mean more merging but fewer segments. Default is 10. Note, 
  /// this value needs to be >= then the max_merge_at_once_ otherwise you’ll 
  /// force too many merges to occur.
  int segments_per_tier;
  
  /// policy.merge_factor Determines how often segment indices are merged by 
  /// index operation. With smaller values, less RAM is used while indexing, 
  /// and searches on unoptimized indices are faster, but indexing speed is 
  /// slower. With larger values, more RAM is used during indexing, and while 
  /// searches on unoptimized indices are slower, indexing is faster. Thus 
  /// larger values (greater than 10) are best for batch index creation, and 
  /// smaller values (lower than 10) for indices that are interactively 
  /// maintained. Defaults to 10.
  int merge_factor;
  
  /// policy.min_merge_size A size setting type which sets the minimum size 
  /// for the lowest level segments. Any segments below this size are 
  /// considered to be on the same level (even if they vary drastically in 
  /// size) and will be merged whenever there are mergeFactor of them. This 
  /// effectively truncates the “long tail” of small segments that would 
  /// otherwise be created into a single level. If you set this too large, 
  /// it could greatly increase the merging cost during indexing (if you 
  /// flush many small segments). Defaults to 1.6mb
  String min_merge_size;
  
  /// policy.max_merge_size, A size setting type which sets the largest 
  /// segment (measured by total byte size of the segment’s files) that may be 
  /// merged with other segments. Defaults to unbounded.
  String max_merge_size;
  
  /// policy.max_merge_docs Determines the largest segment (measured by 
  /// document count) that may be merged with other segments. 
  /// Defaults to unbounded.
  String max_merge_docs;
    
  /// policy.min_merge_docs Sets the minimum size for the lowest level 
  /// segments. Any segments below this size are considered to be on the same 
  /// level (even if they vary drastically in size) and will be merged whenever 
  /// there are mergeFactor of them. This effectively truncates the 
  /// “long tail” of small segments that would otherwise be created into a 
  /// single level. If you set this too large, it could greatly increase the 
  /// merging cost during indexing (if you flush many small segments). 
  /// Defaults to 1000.
  int min_merge_docs;
    
  factory PolicySettings() => new _PolicySettings();
}

abstract class SchedulerSettings {
  /// scheduler.max_thread_count; The maximum number of threads to perform 
  /// the merge operation. Defaults to 
  /// Math.max(1, Math.min(3, Runtime.getRuntime().availableProcessors() / 2)).
  int max_thread_count;  
  
  factory SchedulerSettings() => new _SchedulerSettings();
}

abstract class BlocksSettings {
  /// Set to true to have the index read only. false to allow writes and 
  /// metadata changes.
  bool read_only;  

  /// Set to true to disable read operations against the 
  bool read; 

  // Set to true to disable write operations against the 
  bool write;  

  ///  Set to true to disable metadata operations against the 
  bool metadata;
  
  factory BlocksSettings() => new _BlocksSettings();
}

abstract class CacheSettings {
  FilterSettings filter;
  
  factory CacheSettings() => new _CacheSettings();
}

abstract class FilterSettings {
  /// cache.filter.max_size The maximum size of filter Filter (per segment in 
  /// shard). Set to -1 to disable.
  int max_size;
  
  /// cache.filter.expire The expire after access time for filter Filter. Set to 
  /// -1 to disable.
  String expire;
  
  factory FilterSettings() => new _FilterSettings();
}

abstract class IndicesSettings {
  /// Settings for index throttle
  ThrottleSettings throttle;  
  
  factory IndicesSettings() => new _IndicesSettings();
}

abstract class ThrottleSettings {
  /// indices.store.throttle.type node, none, merge, and all
  String type; 
  
  /// indices.store.throttle.max_bytes_per_sec 0..1mb
  String max_bytes_per_sec; 
  
  factory ThrottleSettings() => new _ThrottleSettings();
}

abstract class SearchSettings {
  /// Threshold for search logging
  ThresholdSettings threshold;  
  
  factory SearchSettings() => new _SearchSettings();
}

abstract class ThresholdSettings {
  /// Log settings related to queries
  LogSettings query;  

  /// Log settings related to fetching
  LogSettings fetch;  
  
  factory ThresholdSettings() => new _ThresholdSettings();
}

abstract class LogSettings {
  /// Log level warning, all time strings and -1 to disable
  bool warn;  

  /// Log level info, all time strings and -1 to disable
  bool info;  

  /// Log level debug, all time strings and -1 to disable
  bool debug;  

  /// Log level trace, all time strings and -1 to disable
  bool trace;  
  
  factory LogSettings() => new _LogSettings();
}

abstract class TranslogSettings {
  /// translog.flush_threshold_ops, When to flush based on operations.
  String flush_threshold_ops;
  
  /// translog.flush_threshold_size, When to flush based on translog (bytes) 
  /// size.
  String flush_threshold_size;
  
  /// translog.flush_threshold_period, When to flush based on a period of not 
  /// flushing.
  String flush_threshold_period;
  
  /// translog.disable_flush, Disables flushing. Note, should be set for a 
  /// short interval and then enabled.
  bool disable_flush;
  
  /// fs settings
  FsSettings fs;
  
  factory TranslogSettings() => new _TranslogSettings();
}

abstract class FsSettings {
  /// fs.type  Either simple or buffered (default).
  String type;
  
  factory FsSettings() => new _FsSettings();
}

abstract class RoutingSettings {
  AllocationSettings allocation;
  
  factory RoutingSettings() => new _RoutingSettings();
}

abstract class AllocationSettings {
  /// routing.allocation.include.*  A node matching any rule will be allowed to host shards from the 
  List<String> include;
  
  /// routing.allocation.exclude.*  A node matching any rule will NOT be allowed to host shards from the 
  List<String> exclude;
  
  /// routing.allocation.require.*  Only nodes matching all rules will be allowed to host shards from the 
  List<String> require;
  
  /// routing.allocation.disable_allocation Disable allocation. 
  /// Defaults to false.
  bool disable_allocation;
  
  /// routing.allocation.disable_new_allocation Disable new allocation. 
  /// Defaults to false.
  bool disable_new_allocation;
  
  /// routing.allocation.disable_replica_allocation Disable replica allocation. 
  /// Defaults to false.
  bool disable_replica_allocation;
  
  /// routing.allocation.total_shards_per_node Controls the total number of 
  /// shards allowed to be allocated on a single node. Defaults to 
  /// unbounded (-1).
  int total_shards_per_node;  
  
  factory AllocationSettings() => new _AllocationSettings();
}

class _AllocationSettings extends _ExtendedJsonObject implements AllocationSettings {}
class _BlocksSettings extends _ExtendedJsonObject implements BlocksSettings {}
class _CacheSettings extends _ExtendedJsonObject implements CacheSettings {}
class _CompressSettings extends _ExtendedJsonObject implements CompressSettings {}
class _FilterSettings extends _ExtendedJsonObject implements FilterSettings {}
class _FsSettings extends _ExtendedJsonObject implements FsSettings {}
class _GatewaySettings extends _ExtendedJsonObject implements GatewaySettings {}
class _IndexSettings extends _ExtendedJsonObject implements IndexSettings {}
class _IndicesSettings extends _ExtendedJsonObject implements IndicesSettings {}
class _LogSettings extends _ExtendedJsonObject implements LogSettings {}
class _MergeSettings extends _ExtendedJsonObject implements MergeSettings {}
class _PolicySettings extends _ExtendedJsonObject implements PolicySettings {}
class _RecoverySettings extends _ExtendedJsonObject implements RecoverySettings {}
class _RoutingSettings extends _ExtendedJsonObject implements RoutingSettings {}
class _SearchSettings extends _ExtendedJsonObject implements SearchSettings {}
class _SchedulerSettings extends _ExtendedJsonObject implements SchedulerSettings {}
class _ThresholdSettings extends _ExtendedJsonObject implements ThresholdSettings {}
class _ThrottleSettings extends _ExtendedJsonObject implements ThrottleSettings {}
class _TranslogSettings extends _ExtendedJsonObject implements TranslogSettings {}
class _StoreSettings extends _ExtendedJsonObject implements StoreSettings {}
class _TTLSettings extends _ExtendedJsonObject implements TTLSettings {}
class _WarmerSettings extends _ExtendedJsonObject implements WarmerSettings {}