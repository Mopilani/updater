/// All rights reserved for Mopilani Team, Acanxa Team, NexaPros Team
/// NexaPros 2021
/// Under Non Public license
@Info('0.1', '0.2+52-Master', '11/22/2021')

part of 'cacher.dart';

class PersisterController extends _InternalCache {
  PersisterController({
    required this.instanceID,
    required this.dirPath,
    this.fileSizeLimit = 500001000,
  }) {
    cid = _newCID('aaaa');
    _createNewPresistsr();
  }

  /// Current ID is the last presister id
  late String cid;

  /// The file size limit in bytes
  late int fileSizeLimit;

  /// The current empty space in the file
  int? emptySpace;

  /// The current instance id
  late String instanceID;

  /// The current instance id
  late String dirPath;

  /// If there an avalible space in the current persister
  // bool thereAnEmptySpace = true;

  late InternalPersister currentPersister;
  List<_Range> emptyRanges = <_Range>[];

  /// This constractor used to make a new instance from the controller
  /// to be revived by calling [fromJson] method
  PersisterController._load();

  void _loadEmptyRanges(List<String> freezedRanges) {
    freezedRanges.forEach((rangeStr) {
      emptyRanges.add(_Range.fromString(rangeStr));
    });
  }

  void _loadPreviousPersister() {
    var previousPersisterData = _getPersisterData(cid);
    currentPersister = InternalPersister.fromJson(previousPersisterData['p']);
    emptySpace = previousPersisterData['es'];
    fileSizeLimit = previousPersisterData['fsl'];
    // thereAnEmptySpace = previousPersisterData['taes'];
    _loadEmptyRanges(previousPersisterData['fer']);
  }

  List<String> _freezeEmptyRanges(List<_Range> emptyRanges) {
    List<String> freezedRanges = [];
    emptyRanges.forEach((range) {
      freezedRanges.add(range.toString());
    });
    return freezedRanges;
  }

  /// ## From Json String
  ///
  /// Revive an instance from a string that was taken from
  /// old persister instance by calling it's [toString]
  PersisterController fromJson(String pcMapStr) {
    Map pcMap = json.decode(pcMapStr);
    cid = pcMap['cid'];
    dirPath = pcMap['dp'];
    instanceID = pcMap['iid'];
    fileSizeLimit = pcMap['fsl'];
    _loadPreviousPersister();
    return this;
  }

  /// Converts [this] to json string
  ///
  /// so other time the same instance can be revived
  /// by calling the [fromJson] method with the given
  /// json string
  @override
  String toString([bool _json = true]) {
    _savePersister(currentPersister);
    if (_json) {
      return json.encode({
        'cid': cid,
        'fsl': fileSizeLimit,
        'dp': dirPath,
        'cp': currentPersister.toString(),
        'iid': instanceID,
      });
    } else {
      return this.toString();
    }
  }

  /// Persister the given data to the persist file
  ///
  /// returns a list of 2 strings, the first one is
  /// the current id that is the cache file id, the
  /// seconde one is the [saveRange] that contains
  /// the saved data
  Future<List<String>> persist(List<int> data) async {
    /// if the new data can be persisted in the current file
    /// then will be persisted, else a new persister instance
    /// will be maked
    var result = _checkForATicket(data.length);
    if (!result[0]) {
      _savePersister(currentPersister);
      _createNewPresistsr();
    }
    result = _checkForATicket(data.length);
    if (!result[0]) {
      _savePersister(currentPersister);
      _createNewPresistsr();
    }
    var saveRange;
    saveRange = await currentPersister.persistInRange(data, result[1]);
    ELogger.log('Persisted in range: $saveRange');
    emptyRanges.add(
        _Range(_Range.fromString(saveRange).end, (result[1] as _Range).end));
    print(emptyRanges);
    return [cid, saveRange];
  }

  /// Persister synchronously the given data to the persist file
  ///
  /// returns a list of 2 strings, the first one is
  /// the current id that is the cache file id, the
  /// seconde one is the [saveRange] that contains
  /// the saved data
  List<String> persistSync(List<int> data) {
    /// if the new data can be persisted in the current file
    /// then will be persisted, else a new persister instance
    /// will be maked
    var result = _checkForATicket(data.length);
    if (!result[0]) {
      _savePersister(currentPersister);
      _createNewPresistsr();
    }
    result = _checkForATicket(data.length);
    if (!result[0]) {
      _savePersister(currentPersister);
      _createNewPresistsr();
    }
    var saveRange;
    saveRange = currentPersister.persistInRangeSync(data, result[1].toString());
    ELogger.log(
        'Persisted_in_range: $saveRange, Recommended_Range: ${result[1].toString()}, Data_Length: ${data.length}');
    emptyRanges.add(
        _Range(_Range.fromString(saveRange).end, (result[1] as _Range).end));
    emptyRanges.remove(result[1]);
    print(emptyRanges);
    return [cid, saveRange];
  }

  Future retrieve(
    String pid,
    _Range range, [
    bool removeWhenRetrieved = false,
    bool encode = false,
    Encoding encoding = utf8,
  ]) async {
    var persisterInstanceData;
    InternalPersister persisterInstance;
    try {
      persisterInstanceData = _getPersister(pid);
      persisterInstance = InternalPersister.fromJson(persisterInstanceData);
    } catch (e) {
      persisterInstance = currentPersister;
    }
    // if this tag is true then the range will be added to the empty ranges list
    if (removeWhenRetrieved) {
      emptyRanges.add(range);
    }
    if (encode) {
      return encoding.decode(
        persisterInstance.retrieveSync(
          range,
          removeWhenRetrieved,
        ),
      );
    } else {
      return await persisterInstance.retrieve(
        range,
        removeWhenRetrieved,
      );
    }
  }

  retrieveSync(
    String pid,
    _Range range, {
    bool removeWhenRetrieved = false,
    bool encode = false,
    Encoding encoding = utf8,
  }) {
    ELogger.log('Retriveing in range: $range');
    var persisterInstanceData;
    InternalPersister persisterInstance;
    try {
      persisterInstanceData = _getPersister(pid);
      persisterInstance = InternalPersister.fromJson(persisterInstanceData);
    } catch (e) {
      persisterInstance = currentPersister;
    }
    // if this tag is true then the range will be added to the empty ranges list
    if (removeWhenRetrieved) {
      emptyRanges.add(range);
    }
    if (encode) {
      var r = encoding.decode(persisterInstance.retrieveSync(
        range,
        removeWhenRetrieved,
      ));
      print('-----------');
      print(r);
      print(r.length);
      print('-----------');
      return r;
    } else {
      return persisterInstance.retrieveSync(
        range,
        removeWhenRetrieved,
      );
    }
  }

  Future<void> remove(String pid, _Range range) async {
    /// When removing from the persister
    emptyRanges.add(range);
    var persisterInstanceData;
    InternalPersister persisterInstance;
    try {
      persisterInstanceData = _getPersister(pid);
      persisterInstance = InternalPersister.fromJson(persisterInstanceData);
    } catch (e) {
      persisterInstance = currentPersister;
    }
    await persisterInstance.remove(range);
    _managePersister(cid);
  }

  void removeSync(String pid, _Range range) {
    emptyRanges.add(range);
    var persisterInstanceData;
    InternalPersister persisterInstance;
    try {
      persisterInstanceData = _getPersister(pid);
      persisterInstance = InternalPersister.fromJson(persisterInstanceData);
    } catch (e) {
      persisterInstance = currentPersister;
    }
    persisterInstance.removeSync(range);
    log('Now empty ranges B: $emptyRanges');
    _managePersister(cid);
    log('Now empty ranges A: $emptyRanges');
  }

  /// This function expected to manage the saved persisters
  /// when a persister has been fully of 0s then it can be removed
  /// and attempting to find an avalible space in the current one
  /// then remerging the small sectors for avalible persisters
  ///
  /// this funtion can be called when a new data has been added
  _managePersisters() {
    Map persisters = _getAllPersisters();
    persisters.keys.forEach((pKey) {
      _managePersister(pKey);
    });
  }

  /// Manages a single persister
  void _managePersister(String pid) {
    var pData;
    try {
      pData = PersisterData.fromMap(_getPersisterData(pid));
    } catch (e) {
      // If the persister is not in cache
      pData = PersisterData.fromMap({
        'p': currentPersister.toString(),
        'fsl': fileSizeLimit,
        'es': emptySpace,
        'fer': _freezeEmptyRanges(emptyRanges),
      });
    }
    var revived = _reviveEmptyRanges(pData.freezedRangesStrs);
    revived = _merger(revived);
    pData.freezedRangesStrs = _freezeEmptyRanges(revived);
    if (pid == cid) {
      _loadPersister(pData);
    } else {
      _setPersisterData(pid, pData.toMap());
    }
  }

  _merger(List<_Range> revived) {
    for (var range1 in revived) {
      for (var range2 in revived) {
        if (range1.end == range2.start) {
          revived.remove(range1);
          revived.remove(range2);
          revived.add(_Range(range1.start, range2.end));
          return _merger(revived);
        }
      }
    }
    return revived;
  }

  void _loadPersister(PersisterData data) {
    currentPersister = data.persister;
    emptySpace = data.emptySpace;
    fileSizeLimit = data.fileSizeLimit;
    emptyRanges = _reviveEmptyRanges(data.freezedRangesStrs);
  }

  List<_Range> _reviveEmptyRanges(List<String> freezedRanges) {
    var emptyRanges = <_Range>[];
    freezedRanges.forEach((rangeStr) {
      emptyRanges.add(_Range.fromString(rangeStr));
    });
    return emptyRanges;
  }

  void _createNewPresistsr() {
    ELogger.log('Creating new persister');
    cid = _newCID(cid);
    currentPersister = InternalPersister(dirPath: dirPath, instanceID: cid);
    emptyRanges.add(_Range(0, fileSizeLimit));
    emptySpace = fileSizeLimit;
    ELogger.logS('Creating new persister');
  }

  /// ### Check For A Ticket
  ///
  /// checks whether there a free range to be persisted to
  /// then returns a list contains a [true, _range] if the
  /// data can be persisted in this file, else [false]
  List _checkForATicket(int dataLength) {
    for (_Range range in emptyRanges) {
      if (dataLength < (range.end - range.start)) {
        // thereAnEmptySpace = true;
        return [true, range];
      }
    }
    // thereAnEmptySpace = false;
    return [false];
  }

  String _newCID(String lastOne) => ncore.IDG().clv1s(lastOne)[1];

  void _savePersister(InternalPersister persister) {
    ELogger.log('Saving persister');
    // if there is no persister takes that key save persister data
    if (_getPersister(cid) == null) {
      _setPersisterData(cid, {
        'p': persister.toString(),
        'fsl': fileSizeLimit,
        'es': emptySpace,
        // 'taes': thereAnEmptySpace,
        'fer': _freezeEmptyRanges(emptyRanges),
      });
    } else {
      // ELogger.logE(Exception(
      //     'There an instance of persister takes the same id, $currentPin'));
      ELogger.logE(
          Exception('There an instance of persister takes the same id, $cid'));
      return;
    }
    // var _cacheStat = Cacher().cacheStat;
    // var _ICSize = _cacheStat[_CacherTags.ic][_CacherTags.size] as int;
    // var _elementsNumber = _cacheStat['p'][_CacherTags.elementsNumber] as int;
    // var _allCachesSize = _cacheStat[_CacherTags.size] as int;
    // var _allElementsNumber = _cacheStat[_CacherTags.elementsNumber] as int;
    // _elementsNumber += 1;
    // _allElementsNumber += 1;
    // _cacheStat['p'][_CacherTags.elementsNumber] = _elementsNumber;
    // _cacheStat[_CacherTags.elementsNumber] = _allElementsNumber;

    // // The persister to string length is not the actualy size of it
    // int elementSize = currentPin;
    // _ICSize += elementSize;
    // _allCachesSize += elementSize;
    // _cacheStat[_CacherTags.ic][_CacherTags.size] = _ICSize;
    // _cacheStat[_CacherTags.size] = _allCachesSize;
    // _set(_CacherTags.cacheStat, _cacheStat);
    ELogger.logS('Saving persister');
  }

  void emptyAllDataSync() {
    for (var pDataMap in (_getAllPersisters() as Map).values) {
      var pData = PersisterData.fromMap(pDataMap);
      pData.persister.emptyCacheFileSync();
    }
  }

  Future<void> emptyAllData() async {
    for (var pDataMap in (_getAllPersisters() as Map).values) {
      var pData = PersisterData.fromMap(pDataMap);
      await pData.persister.emptyCacheFile();
    }
  }
}

/// ## Place
///
/// used to pointing to data in some place in the cache files
///
/// takes a range and pid for initial and can be converted to
/// string by callig the reqular [toString] method and revived
/// in a new [Place] instance by calling [Place.fromString]
class Place {
  Place(this.range, this.pid);
  late _Range range;
  late String pid;

  Place.fromString(String placeJsonString) {
    var placeMap = json.decode(placeJsonString);
    range = placeMap['rng'];
    pid = placeMap['pid'];
  }

  /// returns a json string contains the instance data
  @override
  String toString() => json.encode({
        'pid': pid,
        'rng': range,
      });
}

class PersisterData {
  PersisterData.fromMap(Map map) {
    persisterData = map;
    persisterStr = map['p'];
    emptySpace = map['es'];
    // thereAnEmptySpace = map['taes'];
    freezedRangesStrs = persisterData['fer'];
    fileSizeLimit = map['fsl'];
  }

  late Map persisterData;
  // late bool thereAnEmptySpace;
  late String persisterStr;
  late int fileSizeLimit;
  late int emptySpace;
  late List<String> freezedRangesStrs;

  InternalPersister get persister =>
      InternalPersister.fromJson(persisterData['p']);

  toMap() => {
        'p': persisterStr,
        'es': emptySpace,
        // 'taes': thereAnEmptySpace,
        'fer': freezedRangesStrs,
        'fsl': fileSizeLimit,
      };
}
