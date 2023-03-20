import 'dart:convert';

import '../resolver.dart';
import 'cacher.dart';

main(List<String> args) {
  var cacher =
      Cacher.init(instanceID: 'cacher-0.4.M-T', workDirPath: currentDirPath);
  cacher.persistSync('1', 'Hello In cacher 0.4 Master Test Package, ROM1');
  cacher.persistSync('2', 'Hello In cacher 0.4 Master Test Package, ROM2');
  cacher.cache('3', 'Hello In cacher 0.4 Master Test Package, RAM1');
  var r = cacher.retrieveFromPersistenceCacheSync('1');
  print(r);
  r = cacher.retrieveFromPersistenceCacheSync('2');
  print(r);
  r = cacher.retrieveSync('3');
  print(utf8.decode(r));
  cacher.persistSync('4', 'Hello In cacher 0.4 Master Test Package, ROM4');
  r = cacher.retrieveFromPersistenceCacheSync('4');
  print(r);
  cacher.persistSync('1', 'And yo my name is aradon and iam good, ROM1');
  cacher.persistSync('2', 'And yo my name is aradon and iam good, ROM2');
  cacher.cache('3', 'And yo my name is aradon and iam good, RAM1');
  r = cacher.retrieveFromPersistenceCacheSync('1');
  print(r);
  r = cacher.retrieveFromPersistenceCacheSync('2');
  print(r);
  r = cacher.retrieveSync('3');
  print(utf8.decode(r));
  cacher.persistSync('4', 'And yo my name is aradon and iam good, ROM4');
  r = cacher.retrieveFromPersistenceCacheSync('4');
  print(r);
  cacher.persistSync('1', 'The forth exame, ROM1');
  cacher.persistSync('2', 'The forth exame, ROM2');
  cacher.cache('3', 'The forth exame, RAM1');
  r = cacher.retrieveFromPersistenceCacheSync('1');
  print(r);
  r = cacher.retrieveFromPersistenceCacheSync('2');
  print(r);
  r = cacher.retrieveSync('3');
  print(utf8.decode(r));
  cacher.persistSync('4', 'The forth exame, ROM4');
  r = cacher.retrieveFromPersistenceCacheSync('4');
  print(r);
  // print(r);
  // print(r2);
  // cacher.removeSync('key');
}
