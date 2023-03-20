/// All rights reserved for Mopilani Team, Acanxa Team, NexaPros Team
/// NexaPros 2021
/// Under Non Public license
@Info('0.1', '0.4+25-Master', '11/14/2021')

part of 'cacher.dart';

main(List<String> args) async {
  await Test();
  TestSync();
}

Future Test() async {
  print('Async Oprations Test');
  var instance = await InternalPersister(
          instanceID: 'internalPersister-0.4-Test', dirPath: currentDirPath)
      .init();
  var range = await instance.persist('Hello From Persister Test'.codeUnits);
  print(range);

  instance = await InternalPersister.fromJson(instance.toString());
  var bytes = await instance.retrieve(_Range.fromString(range));
  print('Retrived Then Utf8-Decoded Data:\n${utf8.decode(bytes)}');

  print('Removing Data...');
  instance = await InternalPersister.fromJson(instance.toString());
  await instance.remove(_Range.fromString(range));

  print('Empting Cache File...');
  instance = await InternalPersister.fromJson(instance.toString());
  await instance.emptyCacheFile();
}

TestSync() {
  print('Sync Oprations Test');
  var instance = InternalPersister(
          instanceID: 'internalPersister-0.4-SyncTest', dirPath: currentDirPath)
      .initSync();
  var range = instance.persistSync('Hello From Persister Sync Test'.codeUnits);
  print(range);

  instance = InternalPersister.fromJson(instance.toString());
  var bytes = instance.retrieveSync(_Range.fromString(range));
  print('Retrived Then Utf8-Decoded Data:\n${utf8.decode(bytes)}');

  print('Removing Data...');
  instance = InternalPersister.fromJson(instance.toString());
  instance.removeSync(_Range.fromString(range));

  print('Empting Cache File...');
  instance = InternalPersister.fromJson(instance.toString());
  instance.emptyCacheFileSync();
}

@Info('0.1', '1.3-Master', '11/12/2021')
class _InternalPersister implements InternalPersister {
  _InternalPersister({
    required instanceID,
    required dirPath,
  }) {
    _instanceID = instanceID;
    _dirPath = dirPath;
    dir = Directory('${_dirPath}/.sbcacher');
    _dirPath = dir.path;
    persistFile = File('$_dirPath/.p-$_instanceID');
  }

  /// An internal constractor used by [fromJson] method
  /// to generate new instances
  _InternalPersister._();

  @override
  Future<InternalPersister> init() async {
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }
    if (!(await persistFile.exists())) {
      await persistFile.create();
    } else {
      await persistFile.delete();
    }
    return this;
  }

  @override
  InternalPersister initSync() {
    if (!(dir.existsSync())) {
      dir.createSync(recursive: true);
    }
    persistFile = File('$_dirPath/.p-$_instanceID');
    if (!(persistFile.existsSync())) {
      persistFile.createSync();
    } else {
      persistFile.deleteSync();
    }
    return this;
  }

  static InternalPersister fromJson(String pData) {
    var data = json.decode(pData);
    return _InternalPersister._()
      .._dirPath = data['dp']
      .._instanceID = data['iid']
      ..lastPosition = data['lp']
      ..state = _CacheStat.fromJson(data['st'])
      ..persistFile = File('${data['dp']}/.p-${data['iid']}');
  }

  @override
  String toString([_json = true]) {
    if (!_json) {
      return '_InternalPersister(dirPath: $_dirPath, '
          'InstanceID: $_instanceID, lastPosition: $lastPosition), dir: ${dir.toString()}, '
          '_state: ${state.toString()}';
    } else {
      return json.encode({
        'dp': _dirPath,
        'iid': _instanceID,
        'lp': lastPosition,
        'st': state.toString()
      });
    }
  }

  /// The Current used file for cacheing
  @override
  late File persistFile;

  /// The cache files wil be saved in it
  @override
  late Directory dir;

  @override
  late String _dirPath;

  /// This is instance identifier for signing all the cache files with it
  @override
  late dynamic _instanceID;

  /// The last position that the last data ends in it
  @override
  late int lastPosition = 0;

  @override
  _CacheStat state = _CacheStat(0);

  @override
  Future<String> persist(List<int> data) async {
    var newRange = _Range(lastPosition, 0);
    var raf = await (await persistFile.open(mode: FileMode.append))
        .setPosition(lastPosition);
    await raf.writeFrom(data);
    state.size = await raf.length();
    lastPosition = state.size;
    await raf.close();
    return (newRange..end = lastPosition).toString();
  }

  @override
  Future<String> persistInRange(List<int> data, String _range) async {
    var range = _Range.fromString(_range);
    var raf = await (await persistFile.open(mode: FileMode.append))
        .setPosition(range.start);
    await raf.writeFrom(data);
    state.size = await raf.length();
    range..end = await raf.position();
    // lastPosition = state.size;
    await raf.close();
    return (range).toString();
  }

  @override
  String persistInRangeSync(List<int> data, String _range) {
    var range = _Range.fromString(_range);
    var raf = persistFile.openSync(mode: FileMode.append);
    raf.setPositionSync(range.start);
    raf.writeFromSync(data);
    state.size = raf.lengthSync();
    range..end = raf.positionSync();
    // lastPosition = state.size;
    raf.closeSync();
    return (range).toString();
  }

  @override
  Future<List<int>> retrieve(_Range range,
      [bool removeWhenRetrieved = false]) async {
    // Generating a buffer with the wanted bytes length
    // (from start file to the end of wanted bytes)
    var bytesBuffer = List.generate(
      range.end - range.start,
      (index) => 0,
    );
    var raf = await (await persistFile.open()).setPosition(range.start);
    // Reading the bytes and loading it to the bytes buffer
    await raf.readInto(bytesBuffer);
    await raf.close();
    if (removeWhenRetrieved) {
      await remove(range);
    }
    return bytesBuffer;
  }

  @override
  Future<int> readSingleByte(int position) async {
    var raf = await (await persistFile.open()).setPosition(position);
    var byte = await raf.readByte();
    await raf.close();
    return byte;
  }

  @override
  int readSingleByteSync(int position) {
    var raf = (persistFile.openSync());
    raf.setPositionSync(position);
    var byte = raf.readByteSync();
    raf.closeSync();
    return byte;
  }

  @override
  Future<void> remove(_Range range) async {
    var raf = await (await persistFile.open(mode: FileMode.append))
        .setPosition(range.start);
    await raf.writeFrom(List.generate(range.end - range.start, (_) => 0));
    state.size = await raf.length();
    lastPosition = state.size;
    await raf.close();
  }

  @override
  Future<void> emptyCacheFile() async {
    print('Cache file deleted');
    if (await persistFile.exists()) {
      await persistFile.delete();
      state.size = 0;
    }
  }

  @override
  String persistSync(List<int> data) {
    var newRange = _Range(lastPosition, 0);
    var raf = persistFile.openSync(mode: FileMode.append);
    raf.setPositionSync(lastPosition);
    raf.writeFromSync(data);
    state.size = raf.lengthSync();
    lastPosition = state.size;
    raf.closeSync();
    return (newRange..end = lastPosition).toString();
  }

  @override
  List<int> retrieveSync(_Range range, [bool removeWhenRetrieved = false]) {
    // Generating a buffer with the wanted bytes length
    // (from start file to the end of wanted bytes)
    var bytesBuffer = List.generate(
      range.end - range.start,
      (index) => 0,
    );
    var raf = persistFile.openSync();
    raf.setPositionSync(range.start);
    // Reading the bytes and loading it to the bytes buffer
    raf.readIntoSync(bytesBuffer);
    raf.closeSync();
    if (removeWhenRetrieved) {
      removeSync(range);
    }
    return bytesBuffer;
  }

  @override
  void removeSync(_Range range) {
    var raf = persistFile.openSync(mode: FileMode.append);
    raf.setPositionSync(range.start);
    raf.writeFromSync(List.generate(range.end - range.start, (_) => 0));
    state.size = raf.lengthSync();
    lastPosition = state.size;
    raf.closeSync();
  }

  @override
  void emptyCacheFileSync() {
    print('Cache file deleted');
    if (persistFile.existsSync()) {
      persistFile.deleteSync();
      state.size = 0;
    }
  }

  @override
  Future<void> truncate(int length) async {
    var raf = await persistFile.open(mode: FileMode.append);
    await raf.truncate(length);
    await raf.close();
  }

  @override
  void truncateSync(int length) {
    var raf = persistFile.openSync(mode: FileMode.append);
    raf.truncateSync(length);
    raf.closeSync();
  }
}

/// Internal Persister Interface
///
/// An internal content cacher, caches the contents in a files
///
/// it's just a performer for the write and read oprations
abstract class InternalPersister {
  factory InternalPersister({
    required instanceID,
    required dirPath,
  }) =>
      _InternalPersister(
        dirPath: dirPath,
        instanceID: instanceID,
      );

  /// Initialaizes the new instance of [InternalPersister]
  ///
  /// make sure you make an instance of the [InternalPersister]
  Future<InternalPersister> init();

  /// Initialaizes the new instance of [InternalPersister] Synchronously
  ///
  /// make sure you make an instance of the [InternalPersister]
  InternalPersister initSync();

  /// ## Revive Internal Persister From Json
  ///
  /// This constructor is for load the previosly instance/s
  /// of the internal persister from json String
  static InternalPersister fromJson(String pData) =>
      _InternalPersister.fromJson(pData);

  /// This override makes the dedicated to collect all the instance data
  /// and provided it as string or json string, so then in another time
  /// the same instance can be revived from it's jsonString by calling
  /// [_InternalPersister.fromJson]
  @override
  String toString([j = true]);

  /// The Current used file for cacheing
  late File persistFile;

  /// The cache files wil be saved in it
  late Directory dir;

  // ignore: unused_field
  late String _dirPath;

  /// This instance identifier to sign all the cache files with it
  // ignore: unused_field
  late dynamic _instanceID;

  /// The last position that the last data ends in it
  late int lastPosition;

  /// The cache state indicates the size of it
  _CacheStat state = _CacheStat(0);

  /// ### Persist Synchronously
  ///
  /// save the data in the cache file
  ///
  /// returns a string contains a range can be revived in new [_Range] Object
  String persistSync(List<int> data);

  /// ### Persist
  ///
  /// save the data in the cache file
  ///
  /// returns a string contains a range can be revived in new [_Range] Object
  Future<String> persist(List<int> data);

  /// ### Persist In Range
  ///
  /// save the data in the cache file in the defined range
  ///
  /// returns a string contains a range can be revived in new [_Range] Object
  ///
  /// This function is danger when is used by a user
  /// cause it may corrupt the file, it's dedicated
  /// for controller
  Future<String> persistInRange(List<int> data, String range);

  /// ### Persist In Range Synchronously
  ///
  /// save the data in the cache file in the defined range
  ///
  /// returns a string contains a range can be revived in new [_Range] Object
  ///
  /// This function is danger when is used by a user
  /// cause it may corrupt the file, it's dedicated
  /// for controller
  String persistInRangeSync(List<int> data, String range);

  /// ## Retrieve Synchronously
  ///
  /// Retrieve a content from the cache file with the [range] given
  ///
  /// The file will be removed automaticly if the [removeWhenRetrieved] is true
  List<int> retrieveSync(_Range range, [bool removeWhenRetrieved = false]);

  /// ## Retrieve
  ///
  /// Retrieve a content from the cache file with the [range] given
  ///
  /// The file will be removed automaticly if the [removeWhenRetrieved] is true
  Future<List<int>> retrieve(_Range range, [bool removeWhenRetrieved = false]);

  /// ## Read Single Byte
  ///
  /// reads a single byte in the [position] that declared
  ///
  /// returns the byte
  Future<int> readSingleByte(int position);

  /// ## Read Single Byte Synchronously
  ///
  /// reads a single byte in the [position] that declared
  ///
  /// returns the byte
  int readSingleByteSync(int position);

  /// ## Remove Synchronously
  ///
  /// Remove a content in the cache file with the [range]
  void removeSync(_Range range);

  /// ## Remove
  ///
  /// Remove a content in the cache file with the [range]
  Future<void> remove(_Range range);

  /// ## Truncate Synchronously
  void truncateSync(int length);

  /// ## Truncate
  Future<void> truncate(int length);

  /// ## Empty Cache File Synchronously
  ///
  /// Deletes the cache file
  void emptyCacheFileSync();

  /// ## Empty Cache File Synchronously
  ///
  /// Deletes the cache file
  Future<void> emptyCacheFile();
}
