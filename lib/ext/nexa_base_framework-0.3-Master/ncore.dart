/// All rights reserved for Mopilani Team, Acanxa Team, NexaPros Team
/// NexaPros 2021
/// Under Non Public license
// ignore_for_file: unused_element

@Info('0.1', '0.4+3-Master', '11/14/2021')

library ncore;

import 'dart:convert';
import 'dart:math';

import 'annotations.dart';

/// ## NCore
/// Small Statics sumation functions writen used by the analyzer
/// applications an it's libraries, else used by all Nexa-Projects
class NCore {}

/// ### Middle
/// Gets you the middle of this list
/// ##### Work algorithm
/// ```
/// (a + b + n...) / 2
/// ```
/// #### Example:
/// ```
/// middle([5, 10, 20]) // 7.5
/// ```
double middle(List<num> listOfNumbers) {
  var _list = [...listOfNumbers];
  var total = 0.0;
  _list.forEach((e) {
    total += e;
  });
  return total / _list.length;
}

/// ### Middles
/// Gets you the middles that are between numbers
/// if `sort` is true the list will be sorted and then you can get
/// result sames to rate of change
/// ##### Work algorithm
/// ```
/// a + b / 2
/// ```
/// #### Example:
/// ```
/// middles([5, 10, 20]) // [7.5, 15]
/// ```
List<num> middles(List<num> listOfNumbers, {bool sort = false}) {
  var _list = [...listOfNumbers];
  var middles = <num>[0.0];
  List<num> sortedAZ;
  if (sort) {
    sortedAZ = sortZA(_list);
  } else {
    sortedAZ = _list;
  }
  var a = sortedAZ.first;
  var b;
  sortedAZ.skip(1).forEach((e) {
    b = e;
    middles.add((a + b) / 2);
    a = e;
  });
  return middles;
}

/// List Average Increase
/// Gets you the average increase between b and a in the list
///
/// ##### Work algorithm
/// ```
/// listOfNumbers.skip(1);
/// b - a;
/// ```
/// #### Example:
/// ```
/// listAverageIncrease([5, 10, 20]) // [5, 10]
/// ```
List<num> listAverageIncrease(List<num> listOfNumbers, {bool sort = false}) {
  var _list = [...listOfNumbers];
  var _averageIncreases = <num>[0.0];
  List<num> sortedAZ;
  if (sort) {
    sortedAZ = sortZA(_list);
  } else {
    sortedAZ = _list;
  }
  var a = sortedAZ.first;
  var b;
  sortedAZ.skip(1).forEach((e) {
    b = e;
    _averageIncreases.add(b - a);
    a = e;
  });
  return _averageIncreases;
}

/// ### Middle Rate Of Change
/// Gets you the middle rate of change of the given [listOfNumbers]
/// ##### Work algorithm
/// ```
/// listOfNumbers.skip(1);
/// b - a;
/// ```
/// ##### Example:
/// ```
/// middleRateOfChange([5, 10, 20]) // [5, 10]
/// ```
num middleRateOfChange<T>(List<num> listOfNumbers) {
  var _list = [...listOfNumbers];
  var _middles = listAverageIncrease(_list);
  if (T == int) {
    return middle(_middles).toInt();
  } else {
    return middle(_middles);
  }
}

/// ### Longest List
/// Finds the longest list in the `_lists` that provided
/// ##### Example:
/// ```
/// longestList([[1, 1, 2], [1, 2]]) // 3
/// ```
int longestListLength(List<List> _list) {
  var sortedList = <List>[];
  _list.forEach((l) => sortedList.add(l));
  sortedList.sort((a, b) => b.length.compareTo(a.length));
  return sortedList.first.length;
}

/// ### Biggest Number
/// Returns you the biggest number in the list
num biggest(List<num> numbers) {
  numbers.sort(((a, b) => b.compareTo(a)));
  return numbers.first;
}

/// ### Smallest Number
/// Returns you the smallest number in the list
num smallest(List<num> numbers) {
  numbers.sort(((a, b) => b.compareTo(a)));
  return numbers.last;
}

/// ### List Width
/// Finds the list width in the provided `list` by checking the longest
/// element of from elements in the list
/// ##### Example:
/// ```
/// listWidth([0.224, 1555, 1234.33]) // 7
/// ```
int listWidth(List list) {
  List _list = [...list];
  if (_list is List<String>) {
    _list.sort((a, b) {
      if (b.length > a.length) return 1;
      if (b.length < a.length) return -1;
      if (b.length == a.length) return 0;
      return 0;
    });
    return _list.first.toString().length;
  } else if (list is List<num>) {
    _list.sort((a, b) {
      if (b.toString().length > a.toString().length) return 1;
      if (b.toString().length < a.toString().length) return -1;
      if (b.toString().length == a.toString().length) return 0;
      return 0;
    });
    return _list.first.toString().length;
  } else {
    throw Exception('Unsupported list type ${list.runtimeType}');
  }
}

/// ### Largest Number
/// Gets the largest number in this list
/// ##### Example:
/// ```
/// largestNumber([224, 155, 1234]) // 1234
/// ```
num largestNumber(List<num> listOfNumbers) {
  var _list = [...listOfNumbers];
  _list.sort((a, b) => a.compareTo(b));
  return _list.first;
}

/// ### Smallest Number
/// Gets the smallest number in this list
/// ```
/// smallestNumber([224, 155, 1234]) // 155
/// ```
num smallestNumber(List<num> listOfNumbers) {
  var _list = [...listOfNumbers];
  _list.sort((a, b) => b.compareTo(a));
  return _list.first;
}

/// ### Sort From A To Z
/// Sorting a `List<String>` or `List<num>` from a to z
List<T> sortAZ<T>(List<T> list) {
  var _list = [...list];
  if (_list is List<String>) {
    (_list as List<String>).sort((a, b) => a.compareTo(b));
  } else if (_list is List<num>) {
    (_list as List<num>).sort((a, b) => a.compareTo(b));
  } else {
    throw 'List Type UnSupported ${_list.runtimeType}';
  }
  return _list;
}

/// ### Sort From Z To A
/// Sorting a `List<String>` or `List<num>` from z to a
List<T> sortZA<T>(List<T> list) {
  var _list = [...list];
  if (_list is List<String>) {
    (_list as List<String>).sort((a, b) => b.compareTo(a));
  } else if (_list is List<num>) {
    (_list as List<num>).sort((a, b) => b.compareTo(a));
  } else {
    throw Exception('List Type UnSupported ${_list.runtimeType}');
  }
  return _list;
}

enum IntParseType {
  intgr,
  dbol,
  pdbol,
}

const intgr = IntParseType.intgr;
const dbol = IntParseType.dbol;
const pdbol = IntParseType.pdbol;

enum Unit { b, B, Kb, KB, Mb, MB, Gb, GB, Tb, TB, Pb, PB, Yb, YB, Default }

const bitUnit = Unit.b;
const byteUnit = Unit.B;
const kiloBitUnit = Unit.Kb;
const kiloByteUnit = Unit.KB;
const megaBitUnit = Unit.Mb;
const megaByteUnit = Unit.MB;
const gigabitUnit = Unit.Gb;
const gigaByteUnit = Unit.GB;
const teraBitUnit = Unit.Tb;
const teraByteUnit = Unit.TB;
const petaBitUnit = Unit.Pb;
const petaByteUnit = Unit.PB;
const yotaBitUnit = Unit.Yb;
const yotaByteUnit = Unit.YB;

/// Increasable numbers
// const iB = 1; // the byte is known as `1` and it's not used
const ib = 8;
const iKb = 8192;
const iKB = 1024;
const iMb = 8388608;
const iMB = 1048576;
const iGb = 8589934592;
const iGB = 1073741824;
const iTb = 8796093022208;
const iTB = 1099511627776;
const iPb = 9007199254740992;
const iPB = 1125899906842624;
const iYb = 9223372036854775807; // The actual number is 9223372036854775808
const iYB = 1152921504606846976;

/// Standered Numbers
const b = 8;
const Kb = 8000;
const KB = 1000;
const Mb = 8000000;
const MB = 1000000;
const Gb = 8000000000;
const GB = 1000000000;
const Tb = 8000000000000;
const TB = 1000000000000;
const Pb = 8000000000000000;
const PB = 1000000000000000;
const Yb = 8000000000000000000;
const YB = 1000000000000000000;

dynamic bytesTranslater(int numberOfBytes,
    {IntParseType type = IntParseType.intgr,
    bool asStr = false,
    Unit from = Unit.B,
    Unit to = Unit.Default,
    int numberOfInts = 2,
    bool useIncreasableNumbers = false}) {
  switch (from) {
    case Unit.b:
      numberOfBytes = numberOfBytes * b;
      break;
    case Unit.B:
      numberOfBytes = numberOfBytes * 1;
      break;
    case Unit.Kb:
      numberOfBytes = numberOfBytes * Kb;
      break;
    case Unit.KB:
      numberOfBytes = numberOfBytes * KB;
      break;
    case Unit.Mb:
      numberOfBytes = numberOfBytes * Mb;
      break;
    case Unit.MB:
      numberOfBytes = numberOfBytes * MB;
      break;
    case Unit.Gb:
      numberOfBytes = numberOfBytes * Gb;
      break;
    case Unit.GB:
      numberOfBytes = numberOfBytes * GB;
      break;
    case Unit.Tb:
      numberOfBytes = numberOfBytes * Tb;
      break;
    case Unit.TB:
      numberOfBytes = numberOfBytes * TB;
      break;
    case Unit.Pb:
      numberOfBytes = numberOfBytes * Pb;
      break;
    case Unit.PB:
      numberOfBytes = numberOfBytes * PB;
      break;
    case Unit.Yb:
      numberOfBytes = numberOfBytes * Yb;
      break;
    case Unit.YB:
      numberOfBytes = numberOfBytes * YB;
      break;
    default:
      throw '$from is not supported selections';
  }

  // ignore: missing_return
  num _step2(double _double) {
    switch (type) {
      case IntParseType.intgr:
        return _double.toInt();
      case IntParseType.dbol:
        return _double.roundToDouble();
      case IntParseType.pdbol:
        return toParsedDouble(_double, numberOfInts); // 0.30 | 123.02
      default:
    }
    throw '';
  }

  if (useIncreasableNumbers) {
    switch (to) {
      case Unit.b:
        if (asStr) {
          return '${_step2(numberOfBytes / b)} b';
        } else {
          return _step2(numberOfBytes / b);
        }
      case Unit.B:
        if (asStr) {
          return '${_step2(numberOfBytes / 1)} B';
        } else {
          return _step2(numberOfBytes / 1);
        }
      case Unit.Kb:
        if (asStr) {
          return '${_step2(numberOfBytes / Kb)} Kb';
        } else {
          return _step2(numberOfBytes / Kb);
        }
      case Unit.KB:
        if (asStr) {
          return '${_step2(numberOfBytes / KB)} KB';
        } else {
          return _step2(numberOfBytes / KB);
        }
      case Unit.Mb:
        if (asStr) {
          return '${_step2(numberOfBytes / Mb)} Mb';
        } else {
          return _step2(numberOfBytes / Mb);
        }
      case Unit.MB:
        if (asStr) {
          return '${_step2(numberOfBytes / MB)} MB';
        } else {
          return _step2(numberOfBytes / MB);
        }
      case Unit.Gb:
        if (asStr) {
          return '${_step2(numberOfBytes / Gb)} Gb';
        } else {
          return _step2(numberOfBytes / Gb);
        }
      case Unit.GB:
        if (asStr) {
          return '${_step2(numberOfBytes / GB)} GB';
        } else {
          return _step2(numberOfBytes / GB);
        }
      case Unit.Tb:
        if (asStr) {
          return '${_step2(numberOfBytes / Tb)} Tb';
        } else {
          return _step2(numberOfBytes / Tb);
        }
      case Unit.TB:
        if (asStr) {
          return '${_step2(numberOfBytes / TB)} TB';
        } else {
          return _step2(numberOfBytes / TB);
        }
      case Unit.Pb:
        if (asStr) {
          return '${_step2(numberOfBytes / Pb)} Pb';
        } else {
          return _step2(numberOfBytes / Pb);
        }
      case Unit.PB:
        if (asStr) {
          return '${_step2(numberOfBytes / PB)} PB';
        } else {
          return _step2(numberOfBytes / PB);
        }
      case Unit.Yb:
        if (asStr) {
          return '${_step2(numberOfBytes / Yb)} Yb';
        } else {
          return _step2(numberOfBytes / Yb);
        }
      case Unit.YB:
        if (asStr) {
          return '${_step2(numberOfBytes / YB)} YB';
        } else {
          return _step2(numberOfBytes / YB);
        }
      default:
        if (asStr) {
          if (numberOfBytes < KB && numberOfBytes >= 0) {
            return '${_step2(numberOfBytes.toDouble())} B';
          } else if (numberOfBytes < MB && numberOfBytes >= KB) {
            return '${_step2(numberOfBytes / KB)} KB';
          } else if (numberOfBytes < GB && numberOfBytes >= MB) {
            return ('${_step2(numberOfBytes / MB)} MB');
          } else if (numberOfBytes < TB && numberOfBytes >= GB) {
            return ('${_step2(numberOfBytes / GB)} GB');
          } else if (numberOfBytes < PB && numberOfBytes >= TB) {
            return ('${_step2(numberOfBytes / TB)} TB');
          } else if (numberOfBytes < YB && numberOfBytes >= PB) {
            return ('${_step2(numberOfBytes / PB)} PB');
          }
        } else {
          if (numberOfBytes < KB && numberOfBytes >= 0) {
            return _step2(numberOfBytes.toDouble());
          } else if (numberOfBytes < MB && numberOfBytes >= KB) {
            return _step2(numberOfBytes / KB);
          } else if (numberOfBytes < GB && numberOfBytes >= MB) {
            return _step2(numberOfBytes / MB);
          } else if (numberOfBytes < TB && numberOfBytes >= GB) {
            return _step2(numberOfBytes / GB);
          } else if (numberOfBytes < PB && numberOfBytes >= TB) {
            return _step2(numberOfBytes / TB);
          } else if (numberOfBytes < YB && numberOfBytes >= PB) {
            return _step2(numberOfBytes / PB);
          }
        }
    }
  } else {
    switch (to) {
      case Unit.b:
        if (asStr) {
          return '${_step2(numberOfBytes / ib)} b';
        } else {
          return _step2(numberOfBytes / ib);
        }
      case Unit.B:
        if (asStr) {
          return '${_step2(numberOfBytes / 1)} B';
        } else {
          return _step2(numberOfBytes / 1);
        }
      case Unit.Kb:
        if (asStr) {
          return '${_step2(numberOfBytes / iKb)} Kb';
        } else {
          return _step2(numberOfBytes / iKb);
        }
      case Unit.KB:
        if (asStr) {
          return '${_step2(numberOfBytes / iKB)} KB';
        } else {
          return _step2(numberOfBytes / iKB);
        }
      case Unit.Mb:
        if (asStr) {
          return '${_step2(numberOfBytes / iMb)} Mb';
        } else {
          return _step2(numberOfBytes / iMb);
        }
      case Unit.MB:
        if (asStr) {
          return '${_step2(numberOfBytes / iMB)} MB';
        } else {
          return _step2(numberOfBytes / iMB);
        }
      case Unit.Gb:
        if (asStr) {
          return '${_step2(numberOfBytes / iGb)} Gb';
        } else {
          return _step2(numberOfBytes / iGb);
        }
      case Unit.GB:
        if (asStr) {
          return '${_step2(numberOfBytes / iGB)} GB';
        } else {
          return _step2(numberOfBytes / iGB);
        }
      case Unit.Tb:
        if (asStr) {
          return '${_step2(numberOfBytes / iTb)} Tb';
        } else {
          return _step2(numberOfBytes / iTb);
        }
      case Unit.TB:
        if (asStr) {
          return '${_step2(numberOfBytes / iTB)} TB';
        } else {
          return _step2(numberOfBytes / iTB);
        }
      case Unit.Pb:
        if (asStr) {
          return '${_step2(numberOfBytes / iPb)} Pb';
        } else {
          return _step2(numberOfBytes / iPb);
        }
      case Unit.PB:
        if (asStr) {
          return '${_step2(numberOfBytes / iPB)} PB';
        } else {
          return _step2(numberOfBytes / iPB);
        }
      case Unit.Yb:
        if (asStr) {
          return '${_step2(numberOfBytes / iYb)} Yb';
        } else {
          return _step2(numberOfBytes / iYb);
        }
      case Unit.YB:
        if (asStr) {
          return '${_step2(numberOfBytes / iYB)} YB';
        } else {
          return _step2(numberOfBytes / iYB);
        }
      default:
        if (asStr) {
          if (numberOfBytes < iKB && numberOfBytes >= 0) {
            return '${_step2(numberOfBytes.toDouble())} B';
          } else if (numberOfBytes < iMB && numberOfBytes >= iKB) {
            return '${_step2(numberOfBytes / iKB)} KB';
          } else if (numberOfBytes < iGB && numberOfBytes >= iMB) {
            return ('${_step2(numberOfBytes / iMB)} MB');
          } else if (numberOfBytes < iTB && numberOfBytes >= iGB) {
            return ('${_step2(numberOfBytes / iGB)} GB');
          } else if (numberOfBytes < iPB && numberOfBytes >= iTB) {
            return ('${_step2(numberOfBytes / iTB)} TB');
          } else if (numberOfBytes < iYB && numberOfBytes >= iPB) {
            return ('${_step2(numberOfBytes / iPB)} PB');
          }
        } else {
          if (numberOfBytes < iKB && numberOfBytes >= 0) {
            return _step2(numberOfBytes.toDouble());
          } else if (numberOfBytes < iMB && numberOfBytes >= iKB) {
            return _step2(numberOfBytes / iKB);
          } else if (numberOfBytes < iGB && numberOfBytes >= iMB) {
            return _step2(numberOfBytes / iMB);
          } else if (numberOfBytes < iTB && numberOfBytes >= iGB) {
            return _step2(numberOfBytes / iGB);
          } else if (numberOfBytes < iPB && numberOfBytes >= iTB) {
            return _step2(numberOfBytes / iTB);
          } else if (numberOfBytes < iYB && numberOfBytes >= iPB) {
            return _step2(numberOfBytes / iPB);
          }
        }
    }
  }
  // throw 'The Wanted quantity of bytes is not here, wtf is $numberOfBytes';
}

/// ### To Parsed Double
/// if you insert 123.123
/// columns `c` is 1 by default
/// ```
/// toParsedDouble(123.123); // 123.1
/// ```
/// but if we insert 123.123456
/// ```
/// toParsedDouble(123.123456, 3); // "123.123"
/// ```
double toParsedDouble(double d, int c) {
  assert(c < 20, 'Number of columns $c is fatal error');
  var r = 0.0;
  var columnsNumber = 1;
  for (var i = 0; i < c; i++) {
    columnsNumber = columnsNumber * 10;
  }
  r += (d * columnsNumber);
  r = r.roundToDouble();
  r = (r / columnsNumber);
  return r;
}

/// ## IDentifier Generator
/// Class that following ncore library for generating random
class IDG {
  static example() {
    print('Level 1 ID');
    print(IDG().lv1());
    print('\nLevel 3 ID');
    print(IDG().lv3());
    print('\nLevel 5 ID');
    print(IDG().lv5());
    print('\nLevel 5 Super ID');
    print(IDG().lv5s());
    print('\nContinuosly Level 3 Super ID');
    print(IDG().clv3s('aaaa-aaaa-aaaa'));
    print('\nContinuosly Level 1 Super ID');
    print(IDG().clv1s('aaaa'));
  }

  /// Base64 String Resolver to String without "=" chars
  base64resolver(String str) {
    var c = str.split('');
    var stil = true;
    do {
      c.last == '=' ? c.removeLast() : (stil = false);
    } while (stil);
    return c.join();
  }

  ///
  String lv1() {
    StringBuffer buffer = StringBuffer();
    for (var i = 0; i < 4; i++) {
      var verse = StringBuffer();
      for (var ii = 0; ii < 2; ii++) {
        var byte = Random().nextInt(120);
        verse.write('${base64resolver(base64Encode([byte]))}');
      }
      buffer.write(verse.toString() + (i >= 3 ? '' : '-'));
    }
    return buffer.toString();
  }

  String lv3() {
    StringBuffer buffer = StringBuffer();
    for (var i = 0; i < 4; i++) {
      var verse = StringBuffer();
      for (var ii = 0; ii < 3; ii++) {
        var byte = Random().nextInt(255);
        verse.write('${base64resolver(base64Encode([byte]))}');
      }
      buffer.write(verse.toString() + (i >= 3 ? '' : '-'));
    }
    return buffer.toString();
  }

  lv5() {
    StringBuffer buffer = StringBuffer();
    for (var i = 0; i < 4; i++) {
      var verse = StringBuffer();
      for (var ii = 0; ii < 3; ii++) {
        var byte = Random((tan(Random().nextInt(360)) *
                    1234 *
                    tan(Random().nextInt(360)) *
                    4321)
                .round())
            .nextInt(255);
        verse.write('${base64resolver(base64Encode([byte]))}');
      }
      buffer.write(verse.toString() + (i >= 3 ? '' : '-'));
    }
    return buffer.toString();
  }

  lv5s([int segments = 5]) {
    StringBuffer buffer = StringBuffer();
    for (var i = 0; i < segments; i++) {
      var verse = StringBuffer();
      for (var ii = 0; ii < 3; ii++) {
        var byte = Random((tan(Random().nextInt(361)) *
                    1234 *
                    tan(Random().nextInt(361)) *
                    4321)
                .round())
            .nextInt(255);
        verse.write('${base64resolver(base64Encode([byte]))}');
      }
      buffer.write(verse.toString() + (i >= (segments - 1) ? '' : '-'));
    }
    return buffer.toString();
  }

  /// ## Continuesly Level 3 Super
  /// Consists of 3 segments, 12 chars (a-Z) or/and numbers (0-9)
  /// Function algorithms can generate up to 3.225 zetalion varius
  /// ID
  ///
  /// Providing the id aaaa-aaaa-aaaa as first id for start generating ids
  ///
  /// it would return List contains the numeber of chars [nidls] and the new id
  List clv3s(String lastID) {
    List<String> allCharsList = [
      ...smallLetters,
      ...numbersStrings,
      ...cabitalLetters
    ];

    /// Generates the new id from the last id numbers list
    _newID(List<int> lastIDNumbersList) {
      // print("lastIDNumbersList: $lastIDNumbersList");
      var nidls = ProcessorKiller(lastIDNumbersList, 1, 62);
      // print(nidls);
      var buffer = StringBuffer();
      // var round = 0;
      nidls.forEach((nmbr) {
        // print(round);
        buffer.write(allCharsList[nmbr]);
        // round++;
      });
      var newId = [
        buffer.toString().substring(0, 4),
        '-',
        buffer.toString().substring(4, 8),
        '-',
        buffer.toString().substring(8, 12),
      ];
      return [nidls, newId.join()];
    }

    int _idConverter(List<int> idNumbers) {
      var lastIDNumber = 1;
      idNumbers.forEach((nmbr) {
        if (nmbr == 0) return;
        lastIDNumber *= nmbr;
      });
      return lastIDNumber;
    }

    List<int> _lyzer(String id) {
      var ml = <int>[];
      var ls = id.split('');
      ls.forEach((char) {
        try {
          ml.add(allCharsList.indexOf(char));
          return;
        } catch (e) {}
        if (allCharsList.contains(char)) {
          ml.add(allCharsList.indexOf(char));
        }
        if (allCharsList.contains(char)) {
          ml.add(allCharsList.indexOf(char));
        }
      });
      // print(_idConverter(ml));
      return ml;
    }

    switch (lastID.runtimeType) {
      case String:
        // print(lastID.length > 14);
        // print(lastID.length < 14);
        // print(lastID.length);
        // print(lastID);
        // print(lastID.contains(RegExp("~`!@#\$%^&*()_+={}:;'<,>.?/\\" '"')));
        if (lastID.length > 14 ||
            lastID.length < 14 ||
            lastID.contains(RegExp("~`!@#\$%^&*()_+={}:;'<,>.?/\\" '"'))) {
          throw Exception("The last ID $lastID Doesn't match the secquence");
        }
        var joindBuffer = StringBuffer();
        var segments = lastID.split('');
        segments.forEach((char) {
          if (char != '-') {
            joindBuffer.write(char);
          }
        });
        var numbersList = _lyzer(joindBuffer.toString());
        return _newID(numbersList);
      default:
        throw Exception('Unsupported id type ${lastID.runtimeType}');
    }
  }

  /// ## Continuesly Level 1 Super
  /// Consists of 1 segments, 4 chars (a-Z) or/and numbers (0-9)
  /// Function algorithms can generate up to 14,776,336 varius
  /// ID by enabling [cchars], [schars] and [nums] and [shuffled]
  /// as option
  ///
  /// The shuffling comes with const charecters that premixed
  /// and any application uses this algorithm from the current
  /// library version it may be changed in the future, so you
  /// must have the old libraries functions
  ///
  /// The First id will be
  List clv1s(
    String lastID, {
    bool shuffled = false,
    bool cchars = false,
    bool schars = true,
    bool nums = true,
  }) {
    List<String> _allCharsList = [];
    if (shuffled) {
      if (schars) {
        _allCharsList.addAll(smallLettersSuffled);
      }
      if (cchars) {
        _allCharsList.addAll(cabitalLettersSuffled);
      }
      if (nums) {
        _allCharsList.addAll(numbersStringsSuffled);
      }
    } else {
      if (schars) {
        _allCharsList.addAll(smallLetters);
      }
      if (cchars) {
        _allCharsList.addAll(cabitalLetters);
      }
      if (nums) {
        _allCharsList.addAll(numbersStrings);
      }
    }

    /// Generates the new id from the last id numbers list
    _newID(List<int> lastIDNumbersList) {
      var nidls = ProcessorKiller(
        lastIDNumbersList,
        1,
        _allCharsList.length,
      );
      // print(nidls);
      var buffer = StringBuffer();
      nidls.forEach((nmbr) {
        buffer.write(_allCharsList[nmbr]);
      });
      return [nidls, buffer.toString()];
    }

    int _idConverter(List<int> idNumbers) {
      var lastIDNumber = 1;
      idNumbers.forEach((nmbr) {
        if (nmbr == 0) return;
        lastIDNumber *= nmbr;
      });
      return lastIDNumber;
    }

    List<int> _lyzer(String id) {
      var ml = <int>[];
      var ls = id.split('');
      ls.forEach((char) {
        try {
          ml.add(_allCharsList.indexOf(char));
          return;
        } catch (e) {}
        if (_allCharsList.contains(char)) {
          ml.add(_allCharsList.indexOf(char));
        }
        if (_allCharsList.contains(char)) {
          ml.add(_allCharsList.indexOf(char));
        }
      });
      // print(_idConverter(ml));
      return ml;
    }

    switch (lastID.runtimeType) {
      case String:
        if (lastID.length > 4 ||
            lastID.length < 4 ||
            lastID.contains(RegExp("~`!@#\$%^&*()_+={}:;'<,>.?/\\" '"'))) {
          throw Exception("The last ID $lastID Does't match the secquence");
        }
        var joindBuffer = StringBuffer();
        var segments = lastID.split('');
        segments.forEach((char) {
          if (char != '-') {
            joindBuffer.write(char);
          }
        });
        var numbersList = _lyzer(joindBuffer.toString());
        return _newID(numbersList);
      default:
        throw Exception('Unsupported id type ${lastID.runtimeType}');
    }
  }

  /// ## Processor Killer
  /// Most Powerfull function designed for [clv3s] function
  /// it works like you adding a seconds in a clock and when
  /// the seconds overpass `max` number (minute) reseting it's
  /// field and makes minute++ then adding more of second and
  /// so
  List<int> ProcessorKiller(List<int> list, int number, [int max = 5]) {
    var end = false;
    addToNext(
        [int ci = 1,
        int listLength = 10,
        bool addOnLeft = false,
        bool next = false]) {
      if (ci >= listLength - 1) {
        return;
      }
      if (addOnLeft) {
        list[list.length - ci] += 1;
        addToNext(ci, max, false, true);
      } else {
        if (list[list.length - ci] == max) {
          list[list.length - ci] = 0;
          addToNext(ci + 1, max, true);
        } else {
          if (!next) {
            if (number > 0) {
              var avalibleSpace = max - list.last;
              var bagi = number - avalibleSpace;
              if (bagi.isNegative) {
                list.last += number;
                number = 0;
              } else {
                list.last += avalibleSpace;
                number -= avalibleSpace;
              }
            } else {
              end = true;
            }
          }
        }
      }
    }

    while (!end) {
      addToNext(1, list.length);
    }
    return list;
  }

  /// ### Max of Max
  /// A Function that found when developing [ProcessorKiller] algorithm
  /// and it's littel bit good in work, it's work like list filler
  _maxOfmax(List<int> list, int number, [int max = 62]) {
    for (var i = 1; i < list.length + 1; i++) {
      var nmbr = list[list.length - i];
      if (nmbr >= max) {
        // print(nmbr);
        // print(i);
      } else {
        var avalibleSpace = max - nmbr;
        var bagi = number - avalibleSpace;
        if (bagi.isNegative) {
          nmbr += number;
          number = 0;
        } else {
          nmbr += avalibleSpace;
          number -= avalibleSpace;
        }
        list[list.length - i] = nmbr;
      }
    }
    return list;
  }

  List<String> cabitalLetters = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  List<String> smallLetters = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  ];

  List<int> numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<String> numbersStrings = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];

  /// Suffled
  List<int> numbersShuffled = [9, 0, 1, 7, 8, 2, 4, 3, 5, 6];
  List<String> numbersStringsSuffled = [
    '9',
    '0',
    '1',
    '7',
    '8',
    '2',
    '4',
    '3',
    '5',
    '6',
  ];
  List<String> smallLettersSuffled = [
    'y',
    'w',
    'd',
    'n',
    'e',
    'g',
    'x',
    'z',
    'f',
    'm',
    'c',
    'h',
    'r',
    'q',
    'a',
    's',
    'u',
    'k',
    'i',
    'l',
    'v',
    'o',
    'b',
    'p',
    'j',
    't'
  ];
  List<String> cabitalLettersSuffled = [
    'C',
    'Y',
    'R',
    'M',
    'Q',
    'K',
    'G',
    'O',
    'S',
    'B',
    'P',
    'D',
    'W',
    'I',
    'Z',
    'E',
    'F',
    'U',
    'L',
    'T',
    'J',
    'X',
    'A',
    'N',
    'H',
    'V'
  ];
  
  List<String> supportedSpecialLetters = [
    '\$',
    '\\',
    '/',
    '-',
    '_',
    '*',
    '+',
    '!',
    '`',
    '~',
    '#',
    '%',
    '^',
    '&',
    '=',
    ';',
    ':',
    '.',
    ',',
    '<',
    '>',
  ];
}

// resloveBase64
// library ncore;

// /// ## NCore
// /// Small Statics sumation functions writen in dart used by the analyzer
// /// applications an it's libraries
// class NCore {
//   /// ### Middle
//   /// Gets you the middle of this list
//   /// ##### Work algorithm
//   /// ```
//   /// (a + b + n...) / 2
//   /// ```
//   /// #### Example:
//   /// ```
//   /// middle([5, 10, 20]) // 7.5
//   /// ```
//   static double middle(List<num> listOfNumbers) {
//     var _list = [...listOfNumbers];
//     var total = 0.0;
//     _list.forEach((e) {
//       total += e;
//     });
//     return total / _list.length;
//   }

//   /// ### Middles
//   /// Gets you the middles that are between numbers
//   /// if `sort` is true the list will be sorted and then you can get
//   /// result sames to rate of change
//   /// ##### Work algorithm
//   /// ```
//   /// a + b / 2
//   /// ```
//   /// #### Example:
//   /// ```
//   /// middles([5, 10, 20]) // [7.5, 15]
//   /// ```
//   static List<num> middles(List<num> listOfNumbers, {bool sort = false}) {
//     var _list = [...listOfNumbers];
//     var middles = <num>[0.0];
//     List<num> sortedAZ;
//     if (sort) {
//       sortedAZ = NCore.sortZA(_list);
//     } else {
//       sortedAZ = _list;
//     }
//     var a = sortedAZ.first;
//     var b;
//     sortedAZ.skip(1).forEach((e) {
//       b = e;
//       middles.add((a + b) / 2);
//       a = e;
//     });
//     return middles;
//   }

//   /// List Average Increase
//   /// Gets you the average increase between b and a in the list
//   ///
//   /// ##### Work algorithm
//   /// ```
//   /// listOfNumbers.skip(1);
//   /// b - a;
//   /// ```
//   /// #### Example:
//   /// ```
//   /// listAverageIncrease([5, 10, 20]) // [5, 10]
//   /// ```
//   static List<num> listAverageIncrease(List<num> listOfNumbers, {bool sort = false}) {
//     var _list = [...listOfNumbers];
//     var _averageIncreases = <num>[0.0];
//     List<num> sortedAZ;
//     if (sort) {
//       sortedAZ = NCore.sortZA(_list);
//     } else {
//       sortedAZ = _list;
//     }
//     var a = sortedAZ.first;
//     var b;
//     sortedAZ.skip(1).forEach((e) {
//       b = e;
//       _averageIncreases.add(b - a);
//       a = e;
//     });
//     return _averageIncreases;
//   }

//   /// ### Middle Rate Of Change
//   /// Gets you the middle rate of change of the given [listOfNumbers]
//   /// ##### Work algorithm
//   /// ```
//   /// listOfNumbers.skip(1);
//   /// b - a;
//   /// ```
//   /// ##### Example:
//   /// ```
//   /// middleRateOfChange([5, 10, 20]) // [5, 10]
//   /// ```
//   static num middleRateOfChange<T>(List<num> listOfNumbers) {
//     var _list = [...listOfNumbers];
//     var _middles = listAverageIncrease(_list);
//     if (T == int) {
//       return middle(_middles).toInt();
//     } else {
//       return middle(_middles);
//     }
//   }

//   /// ### Longest List
//   /// Finds the longest list in the `_lists` that provided
//   static int longestList(List<List> _list) {
//     var sortedList = <List>[];
//     _list.forEach((l) => sortedList.add(l));
//     sortedList.sort((a, b) => b.length.compareTo(a.length));
//     return sortedList.first.length;
//   }

//   /// ### List Width
//   /// Finds the list width in the provided `list`
//   static int listWidth(List list) {
//     List _list = [...list];
//     if (_list is List<String>) {
//       _list.sort((a, b) {
//         if (b.length > a.length) return 1;
//         if (b.length < a.length) return -1;
//         if (b.length == a.length) return 0;
//         return 0;
//       });
//       return _list.first.toString().length;
//     } else if (list is List<num>) {
//       _list.sort((a, b) {
//         if (b.toString().length > a.toString().length) return 1;
//         if (b.toString().length < a.toString().length) return -1;
//         if (b.toString().length == a.toString().length) return 0;
//         return 0;
//       });
//       return _list.first.toString().length;
//     } else {
//       throw Exception('Unsupported list type ${list.runtimeType}');
//     }
//   }

//   /// ### Largest Number
//   /// Gets the largest number in this list
//   static num largestNumber(List<num> listOfNumbers) {
//     var _list = [...listOfNumbers];
//     _list.sort((a, b) => a.compareTo(b));
//     return _list.first;
//   }

//   /// ### Smallest Number
//   /// Gets the smallest number in this list
//   static num smallestNumber(List<num> listOfNumbers) {
//     var _list = [...listOfNumbers];
//     _list.sort((a, b) => b.compareTo(a));
//     return _list.first;
//   }

//   /// ### Sort From A To Z
//   /// Sorting a `List<String>` or `List<num>` from a to z
//   static List<T> sortAZ<T>(List<T> list) {
//     var _list = [...list];
//     if (_list is List<String>) {
//       (_list as List<String>).sort((a, b) => a.compareTo(b));
//     } else if (_list is List<num>) {
//       (_list as List<num>).sort((a, b) => a.compareTo(b));
//     } else {
//       throw 'List Type UnSupported ${_list.runtimeType}';
//     }
//     return _list;
//   }

//   /// ### Sort From Z To A
//   /// Sorting a `List<String>` or `List<num>` from z to a
//   static List<T> sortZA<T>(List<T> list) {
//     var _list = [...list];
//     if (_list is List<String>) {
//       (_list as List<String>).sort((a, b) => b.compareTo(a));
//     } else if (_list is List<num>) {
//       (_list as List<num>).sort((a, b) => b.compareTo(a));
//     } else {
//       throw Exception('List Type UnSupported ${_list.runtimeType}');
//     }
//     return _list;
//   }
// }

// _addToListS(List<int> list, int number, [int max = 62]) {
//   var end = false;
//   var lastIndex = list.indexOf(list.last);
//   // for (var i = 1; i < list.length + 1; i++) {
//   var currentIndex = 1;
//   // var next = true;
//   // var notEnd = true;
//   // var addOnLeft = false;
//   addToNext(
//       [int ci = 1,
//       int listLength = 10,
//       bool addOnLeft = false,
//       bool next = false]) {
//     if (ci >= listLength) {
//       // print('List Max');
//       return;
//     }
//     if (addOnLeft) {
//       // print('Add To Left');
//       list[list.length - ci] += 1;
//       addToNext(ci, max, false, true);
//     } else {
//       if (list[list.length - ci] == max) {
//         list[list.length - ci] = 0;
//         addToNext(ci + 1, max, true);
//       } else {
//         if (!next) {
//           if (number > 0) {
//             // print(number);
//             var avalibleSpace = max - list.last;
//             var bagi = number - avalibleSpace;
//             if (bagi.isNegative) {
//               list.last += number;
//               number = 0;
//             } else {
//               list.last += avalibleSpace;
//               number -= avalibleSpace;
//             }
//           } else {
//             // print('Number = $number');
//             end = true;
//             // print('Exiting...');
//           }
//         }
//       }
//     }
//   }
