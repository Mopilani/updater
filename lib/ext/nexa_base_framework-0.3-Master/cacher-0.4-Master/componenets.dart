part of 'cacher.dart';

/// ## _Cache State
/// An internal class used to transfer cache state between objects
/// takes a `size` that is the cache size and the zeros booleasn means
/// the cache is full filled with zeros to be cleared
@Info('0.1', '0.2', '8/21/2021')
class _CacheStat {
  _CacheStat(this.size, [this.zeros = false]);
  late int size;
  late bool zeros;

  _CacheStat.fromJson(String jsonStr) {
    var d = json.decode(jsonStr);
    size = d['siz'];
    zeros = d['zrs'];
  }

  @override
  String toString() => json.encode({'siz': size, 'zrs': zeros});
}

/// ## Range
/// Class is used to define the start and end of the wanted data
@Info('0.1', '0.2', '8/21/2021')
class _Range {
  _Range(this.start, this.end);
  late int start;
  late int end;

  _Range.fromString(String rangeStr) {
    var rngls = rangeStr.split('-');
    start = int.parse(rngls.first);
    end = int.parse(rngls.last);
  }

  @override
  toString([j = false]) {
    if (j) {
      return json.encode({'strt': start, 'end': end});
    } else {
      return '$start-$end';
    }
  }
}

/// ## Cache Event
/// Used by the cache event stream and takes the `persistedElements`
/// and the `size` of the cache
@Info('0.1', '0.2', '8/21/2021')
class CacheEvent {
  CacheEvent(this.persistedElements, this.size);
  int persistedElements;
  int size;
  @override
  String toString() {
    return 'Size: $size, Elements: $persistedElements';
  }
}

/// The cacher protocole tags
@Info('0.1', '0.2', '8/21/2021')
class _CacherTags {
  static const String cachedByControle = 'cbc';
  static const String elementsNumber = 'elnm';
  static const String importance = 'ipts';
  static const String cacheStat = 'stat';
  static const String ramCached = 'ram';
  static const String romCached = 'rom';
  static const String position = 'pos';
  static const String range = 'rng';
  static const String size = 'siz';
  static const String type = 'typ';

  /// Persisters Cache
  // static const String p = 'p';

  /// Instance Info Cache
  static const String iic = 'iic';

  /// Data Info Cache
  static const String dic = 'dic';

  /// Data Cache
  static const String dc = 'dc';

  /// For Modified Data, when it's been marked as modified will
  /// be recached another time if it's still int the cache
  // static const String modified = 'mdfid';
}

/// Cache importance for the data
@Info('0.1', '0.2', '8/21/2021')
class CacheImportance {
  /// ## lvl1
  /// Persist the value for ever
  /// (until the application shutdown)
  static const String lvl1 = 'lv1';

  /// ## lvl2
  /// Persist the value and transfering it to storage if value
  /// size overpass 50% of the [Cacher.clearOn] parameter and
  /// clearing it from the ram cache.
  static const String lvl2 = 'lv2';

  /// ## lvl3
  /// Persist the value and transfering it to storage if value
  /// size overpass 10% of the [Cacher.clearOn] parameter and
  /// clearing it from the ram cache.
  static const String lvl3 = 'lv3';

  /// ## lvl4
  /// Clear if application overpass `clearOn` value
  static const String lvl4 = 'lv4';
}
