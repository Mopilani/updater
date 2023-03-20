/// All rights reserved for Mopilani Team, Acanxa Team, NexaPros Team
/// NexaPros 2021
/// Under Non Public license
@Info('0.1', '0.4+15-Master', '11/13/2021')

part of 'cacher.dart';

/// ### Type Inspector
/// Figures the actual size of specific objects, or returns the `object.toString().length`
List _typeCalculator(dynamic object) {
  var actualSize;
  var encoded;
  var type;
  if (object is String) {
    encoded = json.encode(object).codeUnits;
    actualSize = encoded.length;
    type = 'String';
  } else if (object is int) {
    encoded = json.encode(object).codeUnits;
    actualSize = encoded.length;
    type = 'int';
  } else if (object is Uint8List) {
    encoded = object;
    actualSize = object.length;
    print('Unit8List');
    type = 'Uint8List';
  } else if (object is List) {
    try {
      encoded = json.encode(object).codeUnits;
    } catch (e) {
      throw '$e | List must be a <dynamic> based and it is branches'
          ' (branch can be List<dynamic>) to be persisted';
    }
    actualSize = encoded.length;
    print('List');
    type = 'List';
  } else if (object is Map) {
    try {
      encoded = json.encode(object).codeUnits;
    } catch (e) {
      throw '$e | Map must be a <String, dynamic> based and it is branches'
          ' (branch can be List<dynamic>) to be persisted';
    }
    actualSize = encoded.length;
    type = 'Map';
  } else {
    encoded = object.toString();
    actualSize = encoded.length;
    type = 'Object';
  }
  return [actualSize, type, encoded];
}

/// # Cacher
///
/// ### The main class of this library that controles the low level classes
/// and useable by users
class Cacher extends _InternalCache {
  factory Cacher([ins, path]) =>
      (InternalCache._internalApplicationCache[ins ?? 'cacher'] == null
          ? () {
              print(
                  'No cacher instance exists, creating new default "sbcacher1"');
              InternalCache._internalApplicationCache[ins ?? 'cacher'] =
                  Cacher.init(
                instanceID: ins ?? 'sbcacher1',
                workDirPath: path ?? Directory.current.path,
              );
              return InternalCache._internalApplicationCache[ins ?? 'cacher'];
            }
          : InternalCache._internalApplicationCache['cacher']);

  /// ## Cacher Custom Initializer
  Cacher.init({
    required this.instanceID,
    this.newInstance = true,
    this.cacheControle = true,
    this.clearOn = 50000000,
    this.fileSizeLimit = 50000000,
    required this.workDirPath,
  }) {
    if (cacheControle) {
      print('Cache controle Enabled');
    }
    workDir = Directory(workDirPath + '/' + instanceID);
    ELogger.init(instanceID,
        printLogs: true, saveLogsToFile: true, workDir: workDir.path);
    if (newInstance) {
      log('Generating a new instance');
      if (workDir.existsSync()) {
        try {
          // Stoped For Test
          // workDir.deleteSync(recursive: true);
        } catch (e) {
          logE(e);
        }
        // Stoped For Test
        // workDir.createSync(recursive: true);
      } else {
        workDir.createSync(recursive: true);
      }
      _resetStat();
      _resetPersistersPartition();
      setFACPartitions();
      logS('Generating a new instance');
      // cid = _newCID('aaaa');
    } else {
      _resetStat();
      _resetPersistersPartition();
      setFACPartitions();
      _load();
      logS('Old Instance Ready');
    }
    InternalCache._internalApplicationCache[instanceID] = this;
    persisterController = PersisterController(
      instanceID: instanceID,
      dirPath: workDirPath,
      fileSizeLimit: fileSizeLimit,
    );
  }

  Cacher init() {
    if (cacheControle) {
      print('Cache controle Enabled');
    }
    workDir = Directory(workDirPath + '/' + instanceID);
    ELogger.init('SB-lyz&Cache',
        printLogs: true, saveLogsToFile: true, workDir: workDir.path);
    if (newInstance) {
      log('Generating a new instance');
      if (workDir.existsSync()) {
      } else {
        workDir.createSync(recursive: true);
      }
      _resetStat();
      _resetPersistersPartition();
      setFACPartitions();
      logS('Generating a new instance');
    } else {
      _resetStat();
      _resetPersistersPartition();
      setFACPartitions();
      _load();
      logS('Old Instance Ready');
    }
    InternalCache._internalApplicationCache[instanceID] = this;
    persisterController = PersisterController(
      instanceID: instanceID,
      dirPath: workDirPath,
      fileSizeLimit: fileSizeLimit,
    );
    return this;
  }

  /// An instance of the internal persister
  // var persister;

  String workDirPath;
  late PersisterController persisterController;
  String instanceID;
  bool? useElogger;
  final bool newInstance;
  late Directory workDir;
  bool cacheControle;
  int clearOn;
  late int fileSizeLimit;

  /// An tag used when sending a controle request to the controller
  /// This tag means there an controlling opration running now
  bool clearingNow = false;
  bool _flushFromInternal = false;

  /// ### Cache
  /// Cache importance is lvl1 by default for the types
  void cache(
    dynamic key,
    dynamic value, {
    bool replace = false,
    String importance = CacheImportance.lvl3,
  }) {
    logSt('Caching');
    _doIt() {
      importance = (value is Type ? CacheImportance.lvl1 : importance);
      // The persister to string length is not the actualy size of it
      var elementData = _typeCalculator(value);
      int elementSize = elementData[0];
      var elementType = elementData[1];
      _SACSet(key, elementData[2]);
      // The importance is the list key
      _FACSet(key, {
        _CacherTags.size: elementSize,
        _CacherTags.importance:
            (value is Type ? CacheImportance.lvl1 : importance),
        _CacherTags.cachedByControle: false,
        _CacherTags.ramCached: true,
        _CacherTags.romCached: false,
        _CacherTags.type: elementType,
      });
      _FACSetToList(importance, key);
      Map _cacheStat = cacheStat;
      var _SACSize = _cacheStat[_CacherTags.dc][_CacherTags.size] as int;
      var _SACElementsNumber =
          _cacheStat[_CacherTags.dc][_CacherTags.elementsNumber] as int;
      var _FACElementsNumber =
          _cacheStat[_CacherTags.dic][_CacherTags.elementsNumber] as int;
      var _allCachesSize = _cacheStat[_CacherTags.size] as int;
      var _allElementsNumber = _cacheStat[_CacherTags.elementsNumber] as int;
      _SACSize += elementSize;
      _allCachesSize += elementSize;
      _SACElementsNumber += 1;
      _FACElementsNumber += 1;
      _allElementsNumber += 2;
      _cacheStat[_CacherTags.dc][_CacherTags.size] = _SACSize;
      _cacheStat[_CacherTags.size] = _allCachesSize;
      _cacheStat[_CacherTags.dc][_CacherTags.elementsNumber] =
          _SACElementsNumber;
      _cacheStat[_CacherTags.dic][_CacherTags.elementsNumber] =
          _FACElementsNumber;
      _cacheStat[_CacherTags.elementsNumber] = _allElementsNumber;
      _set(_CacherTags.cacheStat, _cacheStat);
      logEn('Caching');
    }

    // splitedPrint(InternalCache._fastAccessCache);
    if (_FACGet(key) != null) {
      if (replace) {
        removeSync(key);
        log('Replace');
        _doIt();
      } else {
        log('Found Corresponding Key: $key');
        log('No Replace');
        return;
      }
    } else {
      _doIt();
    }
    if (cacheControle && !clearingNow) {
      _controlCacheSync();
    }
  }

  /// ### Cache
  /// Cache importance is lvl1 by default for the types
  void _internalRecache(dynamic key, dynamic value) {
    log('Caching');
    () {
      var elementData = _FACGet(key);
      int elementSize = elementData[_CacherTags.size];
      _SACSet(key, value);
      _FACUpdate(key, {
        _CacherTags.ramCached: true,
      });
      _FACSetToList(elementData[_CacherTags.importance], key);
      Map _cacheStat = cacheStat;
      var _SACSize = _cacheStat[_CacherTags.dc][_CacherTags.size] as int;
      var _SACElementsNumber =
          _cacheStat[_CacherTags.dc][_CacherTags.elementsNumber] as int;
      var _FACElementsNumber =
          _cacheStat[_CacherTags.dic][_CacherTags.elementsNumber] as int;
      var _allCachesSize = _cacheStat[_CacherTags.size] as int;
      var _allElementsNumber = _cacheStat[_CacherTags.elementsNumber] as int;
      _SACSize += elementSize;
      _allCachesSize += elementSize;
      _SACElementsNumber += 1;
      _FACElementsNumber += 1;
      _allElementsNumber += 2;
      _cacheStat[_CacherTags.dc][_CacherTags.size] = _SACSize;
      _cacheStat[_CacherTags.size] = _allCachesSize;
      _cacheStat[_CacherTags.dc][_CacherTags.elementsNumber] =
          _SACElementsNumber;
      _cacheStat[_CacherTags.dic][_CacherTags.elementsNumber] =
          _FACElementsNumber;
      _cacheStat[_CacherTags.elementsNumber] = _allElementsNumber;
      _set(_CacherTags.cacheStat, _cacheStat);
      logS('Caching');
    }.call();
    if (cacheControle && !clearingNow) {
      _controlCacheSync();
    }
  }

  _cacheID([String? id]) {
    if (id != null) {
      if (id.length == 19) {
        log('Cache ID Check true');
        return true;
      } else {
        log('Cache ID Check false');
        return false;
      }
    } else {
      log('Cache ID Generate');
      return ncore.IDG().lv1();
    }
  }

  retrieveSync(dynamic key, [bool removeWhenRetrieved = true]) {
    log('Retrieve');
    var elementData = _FACGet(key);
    if (elementData != null) {
      var value;
      if (elementData[_CacherTags.cachedByControle] == true &&
          elementData[_CacherTags.romCached] == true &&
          elementData[_CacherTags.ramCached] == false) {
        value = retrieveFromPersistenceCacheSync(key, removeWhenRetrieved);
        if (!removeWhenRetrieved) {
          _internalRecache(key, value);
        }
      } else {
        value = _SACGet(key);
        if (removeWhenRetrieved) {
          removeSync(key);
        }
      }
      logS('Retrieve');
      return value;
    } else {
      // print('No Element in the SAC Called $key');
      log('No Element in the FAC Called $key');
      return;
    }
  }

  _removeFromSacJust(String key) {
    logSt('_removing From SAC Just');
    var elementData = _FACGet(key);
    if (elementData != null) {
      int elementSize = elementData[_CacherTags.size];
      _FACDelFromList(elementData[_CacherTags.importance], key);
      _SACDel(key);
      _FACUpdate(key, {_CacherTags.ramCached: false});

      var _cacheStat = cacheStat;
      var _SACSize = _cacheStat[_CacherTags.dc][_CacherTags.size] as int;
      var _elementsNumber =
          _cacheStat[_CacherTags.dc][_CacherTags.elementsNumber] as int;
      var _allCachesSize = _cacheStat[_CacherTags.size] as int;
      var _allElementsNumber = _cacheStat[_CacherTags.elementsNumber] as int;
      // The persister to string length is not the actualy size of it
      // int elementSize = key + element.length;
      _SACSize -= elementSize;
      _allCachesSize -= elementSize;
      _elementsNumber -= 1;
      _allElementsNumber -= 1;
      _cacheStat[_CacherTags.dc][_CacherTags.size] = _SACSize;
      _cacheStat[_CacherTags.dc][_CacherTags.elementsNumber] = _elementsNumber;
      _cacheStat[_CacherTags.size] = _allCachesSize;
      _cacheStat[_CacherTags.elementsNumber] = _allElementsNumber;
      _set(_CacherTags.cacheStat, _cacheStat);
      logS('_removing From SAC Just');
    } else {
      logEn('No Element in the SAC Called ');
      return;
    }
  }

  void removeSync(dynamic key, [bool all = true]) {
    logSt('Removing');
    var elementData = _FACGet(key);
    if (elementData != null) {
      int elementSize = elementData[_CacherTags.size];
      if (elementData[_CacherTags.cachedByControle] == true &&
          elementData[_CacherTags.romCached] == true) {
        // Removing the element that is cached by controle from the rom cache
        removeFromPersistentCacheSync(key);
        // Then checking if it's loaded bydefault to the ram cache
        if (elementData[_CacherTags.ramCached] == true) {
          removeSync(key);
        }
      } else {
        _FACDelFromList(elementData[_CacherTags.importance], key);
        _SACDel(key);
        if (all) {
          _FACDel(key);
          removeFromPersistentCacheSync(key);
        } else {
          _FACUpdate(key, {_CacherTags.ramCached: false});
        }
        var _cacheStat = cacheStat;
        var _SACSize = _cacheStat[_CacherTags.dc][_CacherTags.size] as int;
        var _SACElementsNumber =
            _cacheStat[_CacherTags.dc][_CacherTags.elementsNumber] as int;
        var _FACElementsNumber =
            _cacheStat[_CacherTags.dic][_CacherTags.elementsNumber] as int;
        var _allCachesSize = _cacheStat[_CacherTags.size] as int;
        var _allElementsNumber = _cacheStat[_CacherTags.elementsNumber] as int;
        // The persister to string length is not the actualy size of it
        // int elementSize = key + element.length;
        _SACSize -= elementSize;
        _allCachesSize -= elementSize;
        _SACElementsNumber -= 1;
        _FACElementsNumber -= 1;
        _allElementsNumber -= 2;
        _cacheStat[_CacherTags.dc][_CacherTags.size] = _SACSize;
        _cacheStat[_CacherTags.dc][_CacherTags.elementsNumber] =
            _SACElementsNumber;
        _cacheStat[_CacherTags.dic][_CacherTags.elementsNumber] =
            _FACElementsNumber;
        _cacheStat[_CacherTags.size] = _allCachesSize;
        _cacheStat[_CacherTags.elementsNumber] = _allElementsNumber;
        _set(_CacherTags.cacheStat, _cacheStat);
      }
    } else {
      // print('No Element in the SAC Called $key');
      log('No Element in the SAC Called $key');
      return;
    }
    logEn('Removing');
  }

  /// ### Clear Cache
  /// Flushing the slow access cache by saving the data in the storage
  clearCache() {
    logSt('Clearing Cache');
    if (!cacheControle || _flushFromInternal) {
      // A one way key 😉 to clear the SAC from Internal
      _flushFromInternal = false;

      /// Clearing the high loaded cache
      _clearSAC();
      var _cacheStat = cacheStat;
      var _SACSize = _cacheStat[_CacherTags.dc][_CacherTags.size] as int;
      var _elementsNumber =
          _cacheStat[_CacherTags.dc][_CacherTags.elementsNumber] as int;
      var _allCachesSize = _cacheStat[_CacherTags.size] as int;
      var _allElementsNumber = _cacheStat[_CacherTags.elementsNumber] as int;

      // The persister to string length is not the actualy size of it
      // int elementSize = currentPin + persister.toString().length;
      _allCachesSize -= _SACSize;
      _allElementsNumber -= _elementsNumber;
      _elementsNumber = 0;
      _SACSize = 0;
      _cacheStat[_CacherTags.dc][_CacherTags.size] = _SACSize;
      _cacheStat[_CacherTags.dc][_CacherTags.elementsNumber] = _elementsNumber;
      _cacheStat[_CacherTags.size] = _allCachesSize;
      _cacheStat[_CacherTags.elementsNumber] = _allElementsNumber;
      _set(_CacherTags.cacheStat, _cacheStat);
    } else {
      // print(Exception(
      //     'Manual cache flush is disabled when Auto Cache Controle is enebled'));
      logE(Exception(
          'Manual cache flush is disabled when Auto Cache Controle is enebled'));
      return;
    }
    logEn('Clearing Cache');
  }

  /// ### Cache and persist Synchronously
  /// Caches the data in sac and fac and freezing it
  ///
  /// the cache size indicates the wanted size to cache this value, if it's
  /// to big, a new cache will be setted for it
  void cacheAndPersistSync(dynamic key, dynamic value,
      {bool replace = false, String importance = CacheImportance.lvl3}) {
    logSt('Caching And Persisting');
    cache(key, value, importance: importance, replace: replace);
    persistSync(key, value, importance: importance, replace: replace);
    logEn('Caching And Persisting');
  }

  void persistSync(
    dynamic key,
    dynamic value, {
    bool replace = false,
    String importance = CacheImportance.lvl3,
  }) {
    logSt('Persisting');
    if (value is Type) {
      // print(Exception("Types can be cached but not persisted"));
      logE(Exception("Types can be cached but not persisted"));
      return;
    }
    late int elementSize;
    var _value = _FACGet(key);
    if (_value != null) {
      if (_value[_CacherTags.ramCached] && !_value[_CacherTags.romCached]) {
        var elementData = _typeCalculator(value);
        elementSize = elementData[0];
        var rangeAndCid = persisterController.persistSync(elementData[2]);
        _FACDelFromList(_value[_CacherTags.importance], key);
        _value.addAll(<String, Object>{
          _CacherTags.romCached: true,
          _CacherTags.position: rangeAndCid[0],
          _CacherTags.range: rangeAndCid[1],
        });
        // _FACSet(key, _value);
      } else {
        if (replace) {
          removeFromPersistentCacheSync(key, true);
          persistSync(key, value);
          log('Replacing an exiting element On Rom');
          return;
        } else {
          log('No Replace On Rom');
          return;
        }
      }
    } else {
      var elementData = _typeCalculator(value);
      elementSize = elementData[0];
      var elementType = elementData[1];
      var rangeAndCid = persisterController.persistSync(elementData[2]);
      _value = <String, Object>{
        _CacherTags.cachedByControle: false,
        _CacherTags.importance: importance,
        _CacherTags.size: elementSize,
        _CacherTags.type: elementType,
        _CacherTags.ramCached: false,
        _CacherTags.romCached: true,
        _CacherTags.position: rangeAndCid[0],
        _CacherTags.range: rangeAndCid[1],
      };
    }
    // _savePersister(persister);
    _FACSet(key, _value);

    var _cacheStat = cacheStat;
    // persisters cache size
    var _PCS = _cacheStat['p'][_CacherTags.size] as int;
    var _elementsNumber = _cacheStat['p'][_CacherTags.elementsNumber] as int;
    var _allCachesSize = _cacheStat[_CacherTags.size] as int;
    var _allElementsNumber = _cacheStat[_CacherTags.elementsNumber] as int;

    // The persister to string length is not the actualy size of it
    _PCS += elementSize;
    _allCachesSize += elementSize;
    _elementsNumber += 1;
    _allElementsNumber += 1;
    _cacheStat['p'][_CacherTags.size] = _PCS;
    _cacheStat['p'][_CacherTags.elementsNumber] = _elementsNumber;
    _cacheStat[_CacherTags.size] = _allCachesSize;
    _cacheStat[_CacherTags.elementsNumber] = _allElementsNumber;
    _set(_CacherTags.cacheStat, _cacheStat);
    logS('Persisting');
  }

  _retriveAndReviveElement(piid, range, type) {
    switch (type) {
      case 'String':
        return json.decode(
          persisterController.retrieveSync(
            piid,
            _Range.fromString(range),
            encode: true,
          ),
        );
      case 'int':
        return json.decode(
          persisterController.retrieveSync(
            piid,
            _Range.fromString(range),
            encode: true,
          ),
        );
      case 'Uint8List':
        return persisterController.retrieveSync(piid, _Range.fromString(range),
            encode: false);
      case 'List':
        return json.decode(
          persisterController.retrieveSync(
            piid,
            _Range.fromString(range),
            encode: true,
          ),
        );
      case 'Map':
        return json.decode(
          persisterController.retrieveSync(
            piid,
            _Range.fromString(range),
            encode: true,
          ),
        );
      default:
        throw 'Element Type Unsupported';
    }
  }

  /// Retrieve From Persistent Cache
  /// Retrives an element form the persistent cache with the given key
  dynamic retrieveFromPersistenceCacheSync(key,
      [bool removeWhenRetrieved = true]) {
    log('Retrieving From Persistent Cache');
    var elementData = _FACGet(key);
    if (elementData != null) {
      var piid = elementData[_CacherTags.position];
      var range = elementData[_CacherTags.range];
      var element =
          _retriveAndReviveElement(piid, range, elementData[_CacherTags.type]);
      _FACUpdate(key, {_CacherTags.cachedByControle: false});
      if (removeWhenRetrieved) {
        removeFromPersistentCacheSync(key, true);
      }
      logS('Retrieving From Persistent Cache');
      return element;
    } else {
      // print('No Element in the SAC Called $key');
      log('No Element in the SAC Called $key');
      return;
    }
  }

  /// ### Remove From Persistent Cache
  /// Deletes an element from the persistent cache with the given key
  void removeFromPersistentCacheSync(key, [bool all = true]) {
    logSt('Removing From Persistant Cache');
    var value1 = _FACGet(key);
    if (value1 != null) {
      var piid = value1[_CacherTags.position];
      var range = value1[_CacherTags.range];
      persisterController.removeSync(piid, _Range.fromString(range));
      if (all) {
        _FACDel(key);
        removeSync(key, true);
      } else {
        _FACUpdate(key, {_CacherTags.romCached: false});
      }
      int elementSize = value1[_CacherTags.size];
      var _cacheStat = cacheStat;
      // persisters cache size
      var _PCS = _cacheStat['p'][_CacherTags.size] as int;
      var _elementsNumber = _cacheStat['p'][_CacherTags.elementsNumber] as int;
      var _allCachesSize = _cacheStat[_CacherTags.size] as int;
      var _allElementsNumber = _cacheStat[_CacherTags.elementsNumber] as int;

      // The persister to string length is not the actualy size of it
      _PCS -= elementSize;
      _allCachesSize -= elementSize;
      _elementsNumber -= 1;
      _allElementsNumber -= 1;
      _cacheStat['p'][_CacherTags.size] = _PCS;
      _cacheStat['p'][_CacherTags.elementsNumber] = _elementsNumber;
      _cacheStat[_CacherTags.size] = _allCachesSize;
      _cacheStat[_CacherTags.elementsNumber] = _allElementsNumber;
      _set(_CacherTags.cacheStat, _cacheStat);
      // var _cacheStat = cacheStat;
      // var _FACSize =
      //     _cacheStat[_CacherTags.dataInfo][_CacherTags.size] as int;
      // var _FACElementsNumber =
      //     _cacheStat[_CacherTags.dataInfo][_CacherTags.elementsNumber] as int;
      // var _allCachesSize = _cacheStat[_CacherTags.size] as int;
      // var _allElementsNumber = _cacheStat[_CacherTags.elementsNumber] as int;

      // The persister to string length is not the actualy size of it
      // int elementSize = value1[_CacherTags.size];
      // _FACSize -= elementSize;
      // _allCachesSize -= elementSize;
      // _FACElementsNumber -= 1;
      // _allElementsNumber -= 1;
      // _cacheStat[_CacherTags.romCached][_CacherTags.size] = _FACSize;
      // _cacheStat[_CacherTags.romCached][_CacherTags.elementsNumber] =
      //     _FACElementsNumber;
      // _cacheStat[_CacherTags.size] = _allCachesSize;
      // _cacheStat[_CacherTags.elementsNumber] = _allElementsNumber;
      // _set(_CacherTags.cacheStat, _cacheStat);
    } else {
      log('No Element in the SAC Called $key');
    }
    logEn('Removing From Persistant Cache');
  }

  /// ### Empty Cache
  /// Clears all caches and cache files
  void emptyCacheSync() {
    log('Emtping Cache');
    _clearSAC();
    _clearFAC();
    persisterController.emptyAllDataSync();
    // here removing the not-instance-of [_InternalPersister]
    _clearCache();
    _resetStat();
    _resetPersistersPartition();
    setFACPartitions();
    // cid = _newCID(cid);
    logS('Emtping Cache');
  }

  /// ### Reset Statics
  /// Internal function used when the cache is empty
  void _resetStat() => _set(_CacherTags.cacheStat, {
        _CacherTags.iic: {
          _CacherTags.size: 0,
          _CacherTags.elementsNumber: 0,
        },
        _CacherTags.dic: {
          _CacherTags.size: 0,
          _CacherTags.elementsNumber: 0,
        },
        _CacherTags.dc: {
          _CacherTags.size: 0,
          _CacherTags.elementsNumber: 0,
        },
        'p': {
          _CacherTags.size: 0,
          _CacherTags.elementsNumber: 0,
        },
        _CacherTags.size: 0,
        _CacherTags.elementsNumber: 0,
      });

  void _resetPersistersPartition() => _set('p', <String, dynamic>{});

  void setFACPartitions() => InternalCache._dataInfoCache = <String, dynamic>{
        _CacherTags.importance: <String, List<String>>{
          CacheImportance.lvl1: <String>[],
          CacheImportance.lvl2: <String>[],
          CacheImportance.lvl3: <String>[],
          CacheImportance.lvl4: <String>[],
        }
      };

  Map<String, dynamic> get cacheStat => _get(_CacherTags.cacheStat);

  /// This function will does't work good if the SAC flushed
  void _controlCacheSync() {
    lvl2ControleSync(key) {
      var _FACValue = _FACGet(key);
      if (_FACValue[_CacherTags.size] > clearOn / 2) {
        var _SACValue = _SACGet(key);
        if (_SACValue == null) {
          throw Exception(
              'Object of the key "$key" not found in the, $_SACValue');
        }
        if (_SACValue is Type) {
          logE(Exception(
            'Type found by the cache controller, skiping it, it can not be persisted',
          ));
          return;
        }
        if (!_FACValue[_CacherTags.romCached]) {
          persistSync(key, _SACValue);
          _FACUpdate(key, {_CacherTags.cachedByControle: true});
          _removeFromSacJust(key);
        }
      }
    }

    lvl3ControleSync(key) {
      var _FACValue = _FACGet(key);
      if (_FACValue[_CacherTags.size] > clearOn / 10) {
        var _SACValue = _SACGet(key);
        if (_SACValue == null) {
          throw Exception(
              'Object of the key "$key" not found in the, $_SACValue');
        }
        if (_SACValue is Type) {
          logE(Exception(
            'Type found by the cache controller, skiping it, it can not be persisted',
          ));
          return;
        }
        if (!_FACValue[_CacherTags.romCached]) {
          persistSync(key, _SACValue);
          _FACUpdate(key, {_CacherTags.cachedByControle: true});
          _removeFromSacJust(key);
        }
      }
    }

    lvl4ControleSync(key) {
      var _SACValue = _SACGet(key);
      if (_SACValue == null) {
        throw Exception(
            'Object of the key "$key" not found in the, $_SACValue');
      }
      if (_SACValue is Type) {
        logE(Exception(
          'Type found by the cache controller, skiping it, it can not be persisted',
        ));
        return;
      }
      if (!_FACGet(key)[_CacherTags.romCached]) {
        persistSync(key, _SACValue);
        _FACUpdate(key, {_CacherTags.cachedByControle: true});
        _removeFromSacJust(key);
      }
    }

    // splitedPrint(InternalCache._fastAccessCache);
    var cacheSize = cacheStat[_CacherTags.size];
    if (cacheSize > clearOn) {
      log('Controlling Cache');
      clearingNow = true;
      () {
        List facEs = [..._FACGetList(CacheImportance.lvl2)];
        facEs.forEach((key) {
          lvl2ControleSync(key);
        });
      }.call();
      () {
        List facEs = [..._FACGetList(CacheImportance.lvl3)];
        facEs.forEach((key) {
          lvl3ControleSync(key);
        });
      }.call();
      () {
        List facEs = [..._FACGetList(CacheImportance.lvl4)];
        facEs.forEach((key) {
          lvl4ControleSync(key);
        });
      }.call();
      clearingNow = false;
      logS('Controlling Cache');
    }
  }

  bool _loadCacheDataFiles() {
    log('Loading Cache Data');

    /// First loading the data files
    _lvl3reviver(key) {
      var value = _FACGet(key);
      if (value != null) {
        cache(key, retrieveFromPersistenceCacheSync(key, false));
      } else {
        throw 'A value that does not exists in the FAC found in the FAC-sorted-importances';
      }
    }

    List<String> lvl3Elements = [..._FACGetList(CacheImportance.lvl3)];
    var cacheSize = cacheStat[_CacherTags.size];
    for (var i = 0; i < lvl3Elements.length; i++) {
      if (cacheSize > clearOn) {
        log('Relaoding Ram Cache Stopped Because Cache Size Overpass the limits');
        break;
      } else {
        _lvl3reviver(lvl3Elements[lvl3Elements.length - i - 1]);
      }
    }
    logS('Loading Cache Data');
    return true;
  }

  bool _loadCacheInfoFilesSync() {
    log('Loading Cache Info');
    if (workDir.existsSync()) {
      Map map = reader.readJsonFileSync(
          workDirPath + '/' + instanceID + '/.cacheData.json');
      // ignore: unnecessary_null_comparison
      if (map != null) {
        if (map['iid'] != instanceID) {
          throw 'The found instance id in the cache data does not same the currnet id';
        }
        if (!_cacheID(map['id'])) {
          throw 'CACHE FILE ID NOT VALID';
        }
        cacheControle = map['cctrl'];
        workDirPath = map['wdp'];
        instanceID = map['iid'];
        clearOn = map['con'];
        fileSizeLimit = map['con'];
        persisterController = PersisterController._load().fromJson(map['pc']);
        workDir = Directory(workDirPath);
        _reloadFAC(map[_CacherTags.dic]);
        _reloadIC(map[_CacherTags.iic]);
        // Aftre reloading the ic, the SAC statics will be stil in it and we
        // must call [flushCache] to flush all data of the SAC partition
        _flushFromInternal = true;
        // The value will be setted to false inside the function body
        clearCache();
        return true;
      } else {
        throw 'No Cache Data Found';
      }
    }

    logS('Loading Cache Info');
    return false;
  }

  bool _load() {
    _loadCacheInfoFilesSync();
    _loadCacheDataFiles();
    return true;
  }

  /// ### Load Old Instance
  ///
  /// if there an old instance the method will return true,
  /// other wise false.
  bool LoadOldInstance() {
    try {
      return _load();
    } catch (e) {
      return false;
    }
  }

  appEndSync() => _saveCacheInfoFilesSync();

  _persistDataSync() {
    log('Persisting data for shutdown');
    shutterSync(key) {
      var value = _FACGet(key);
      if (value == null) {
        throw Exception('Object of the key "$key" not found, $value');
      }
      if (value is Type) {
        print(
            'Type found by the cache controller, skiping it, it can not be persisted');
        return;
      }
      // Rom cachin if the data is not rom Cached
      if (!value[_CacherTags.romCached]) {
        persistSync(key, _SACGet(key));
        _FACUpdate(key, {_CacherTags.cachedByControle: true});
        _removeFromSacJust(key);
      }
    }

    () {
      List lvl1Elements = [..._FACGetList(CacheImportance.lvl1)];
      lvl1Elements.forEach((key) {
        removeSync(key);
      });
    }.call();
    () {
      List lvl2Elements = [..._FACGetList(CacheImportance.lvl2)];
      lvl2Elements.forEach((key) {
        shutterSync(key);
      });
    }.call();
    () {
      List lvl3Elements = [..._FACGetList(CacheImportance.lvl3)];
      lvl3Elements.forEach((key) {
        shutterSync(key);
      });
    }.call();
    () {
      List lvl4Elements = [..._FACGetList(CacheImportance.lvl4)];
      lvl4Elements.forEach((key) {
        shutterSync(key);
      });
    }.call();
    logS('Persisting data for shutdown');
  }

  _saveCacheInfoFilesSync() {
    log('Saving Cache Info Files');
    if (workDir.existsSync()) {
      _persistDataSync();
      Map map = <String, dynamic>{
        'iid': instanceID,
        'cctrl': cacheControle,
        'con': clearOn,
        'wdp': workDirPath,
        'pc': persisterController.toString(),
        'id': _cacheID(),
        _CacherTags.dic: InternalCache._dataInfoCache,
        _CacherTags.iic: InternalCache._instanceInfoCache,
      };
      // writer.writeAsJsonToFileSync(
      //     workDirPath + '/' + instanceID + '/.cacheData', map);
      writer.writeAsJsonToFileSync(
          workDirPath + '/' + instanceID + '/.cacheData.json', map);
      // print(map);
      logS('Cache Data Saved Successfuly');
    }
    logS('Saving Cache Info Files');
  }

  @Deprecated('Used for testing, Will be removed in the future')
  void logStatToFileSync() {
    log('Log Stat To File');
    var statFile = File(
        '$workDirPath/STATFILES/STATFILE${resolver.dateTimeResolver()}.json');
    statFile.createSync(recursive: true);
    var jsonString = jsonEncode({
      'Cache State Generaly': '$cacheStat',
      'Slow Access Cache Contents': 'Contents Can not be viewed',
      'Data Info Cache Contents': '${InternalCache._dataInfoCache}',
      'Internal Cache Contents': '${InternalCache._instanceInfoCache}'
    });
    statFile.writeAsString(jsonString, mode: FileMode.writeOnlyAppend);
    logS('Log Stat To File');
  }

  /// ## Events Stream
  ///
  /// May be some errors still not revisioned til 0.2
  Stream<CacheEvent> eventsStream() {
    return Stream<CacheEvent>.periodic(
        Duration(
          seconds: 2,
        ), (v) {
      return CacheEvent(
          cacheStat[_CacherTags.elementsNumber], cacheStat[_CacherTags.size]);
    });
  }
}
