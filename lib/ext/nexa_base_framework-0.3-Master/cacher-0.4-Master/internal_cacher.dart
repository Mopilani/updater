/// All rights reserved for Mopilani Team, Acanxa Team, NexaPros Team
/// NexaPros 2021
/// Under Non Public license
@Info('0.1', '1.1+5-Master', '11/13/2021')

part of 'cacher.dart';

@Info('0.1', '1.2-Master', '11/13/2021')
class _InternalCache extends InternalCache {
  _getPersisterData(String pid) => InternalCache._instanceInfoCache['p'][pid];

  _getPersister(String pid) {
    try {
      return InternalCache._instanceInfoCache['p'][pid]['p'];
    } catch (e) {
      // If there an err, expected to be a pob "Tried calling: []("p")"
      return null;
    }
  }

  _getAllPersisters() => InternalCache._instanceInfoCache['p'];

  _delPersisterData(String pid) =>
      InternalCache._instanceInfoCache['p'].remove(pid);

  _setPersisterData(String pid, Map data) =>
      InternalCache._instanceInfoCache['p'][pid] = data;

  @override
  void _set(String key, value) => InternalCache._instanceInfoCache[key] = value;

  @override
  _get(String key) => InternalCache._instanceInfoCache[key];

  @override
  // ignore: unused_element
  _del(String key) => InternalCache._instanceInfoCache.remove(key);

  @override
  void _clearCache() => InternalCache._instanceInfoCache.clear();

  @override
  void _FACDel(String key) => InternalCache._dataInfoCache.remove(key);

  @override
  _FACGet(String key) => InternalCache._dataInfoCache[key];

  @override
  void _FACSet(String key, value) => InternalCache._dataInfoCache[key] = value;

  @override
  void _SACDel(String key) => InternalCache._dataCache.remove(key);

  @override
  _SACGet(String key) => InternalCache._dataCache[key];

  @override
  void _SACSet(String key, value) => InternalCache._dataCache[key] = value;

  @override
  void _clearFAC() => InternalCache._dataInfoCache.clear();

  @override
  void _clearSAC() => InternalCache._dataCache.clear();

  void _reloadFAC(Map<String, dynamic> data) =>
      InternalCache._dataInfoCache.addAll(data);

  void _reloadIC(Map<String, dynamic> data) =>
      InternalCache._instanceInfoCache.addAll(data);

  // This method will be used to segmenting importances
  void _FACSetToList(String listKey, String ObjectKey) {
    (InternalCache._dataInfoCache[_CacherTags.importance][listKey] as List)
        .add(ObjectKey);
  }

  List _FACGetList(String listKey) {
    return (InternalCache._dataInfoCache[_CacherTags.importance][listKey]
        as List);
  }

  void _FACDelFromList(String listKey, String ObjectKey) =>
      (InternalCache._dataInfoCache[_CacherTags.importance][listKey] as List)
          .remove(ObjectKey);

  void _FACUpdate(String key, Map<String, dynamic> newValues) =>
      _FACSet(key, {..._FACGet(key), ...newValues});
}

@Info('0.1', '1.1-Master', '11/12/2021')
abstract class InternalCache {
  /// The internal cache
  static Map<String, dynamic> _instanceInfoCache = <String, dynamic>{};

  /// Dedicated for saving big objects
  static Map<String, dynamic> _dataInfoCache = <String, dynamic>{};

  /// Dedicated for saving big objects
  static Map<String, dynamic> _dataCache = <String, dynamic>{};

  /// The application internal cache
  static Map<String, dynamic> _internalApplicationCache = <String, dynamic>{};

  /// ### Set
  ///
  /// By setting a [value] to the cache will be seved,
  /// the key is the way to retrive the value
  // ignore: unused_element
  void _set(String key, dynamic value);

  /// ### Get
  /// Gets the data from internal cache
  // ignore: unused_element
  dynamic _get(String key);

  /// ### Delete
  /// Delete the data from internal cache
  // ignore: unused_element
  void _del(String key);

  /// ### Slow Access Cache Set
  /// Saves the object key and value
  // ignore: unused_element
  void _SACSet(String key, dynamic value);

  /// ### Fast Access Cache Set
  /// Saves the object key without value, dedicated for persistent store
  // ignore: unused_element
  void _FACSet(String key, dynamic value);

  /// ### Slow Access Cache Get
  /// Gets the data from slow access cache
  // ignore: unused_element
  dynamic _SACGet(String key);

  /// ### Fast Access Cache Get
  /// Gets the data from fast access cache
  // ignore: unused_element
  dynamic _FACGet(String key);

  /// ### Slow Access Cache Delete
  /// Removes the data from slow access cache
  // ignore: unused_element
  void _SACDel(String key);

  /// ### Fast Access Cache Delete
  /// Removes the data from fast access cache
  // ignore: unused_element
  void _FACDel(String key);

  /// ### Clear Cache
  /// Clears the internal cache data
  // ignore: unused_element
  void _clearCache();

  /// ### Clear SLow Access Cache
  /// Clears the SLow Access Cache data
  // ignore: unused_element
  void _clearSAC();

  /// ### Clear Fast Access Cache
  /// Clears the Fast Access Cache data
  // ignore: unused_element
  void _clearFAC();
}
