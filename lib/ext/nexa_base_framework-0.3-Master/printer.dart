library print;

import 'elogger.dart';
import 'ncore.dart' as ncore;
import 'reader.dart';

/// Printer Example
example(List<String> args) async {
  var map = await readJsonFile('D:/LogFiels/_2021_8_10_12_18_46.json');
  var decodedList = <num>[];
  (map['Rounds']['CRss'] as List).forEach((e) {
    try {
      decodedList.add(num.parse(e));
    } catch (e) {
      ELogger.logE(e);
    }
  });

  // var averageRamUsage = middle(decodedList);
  // var averageIncrease = middleRateOfChange((decodedList));
  // var averageMiddles = middle(middles(decodedList));
  // var footer = [averageRamUsage, averageIncrease, averageMiddles];
  var headers = ['RAM U', 'Increase', 'Middles'];
  var _averageIncreases = <num>[];
  _averageIncreases.addAll(ncore.listAverageIncrease(decodedList));
  var _middles = ncore.middles(decodedList);
  multiColumnPrint(headers, [decodedList, _averageIncreases, _middles],
      reverse: false, margin: 4, showAVRG: true, showROC: true);
}

extension _ListAddtion on List {
  List<T> isortZA<T>() => ncore.sortZA(this as List<T>);
  List<T> isortAZ<T>() => ncore.sortAZ(this as List<T>);
}

/// ### Multi Column Print
/// Print multiple lists of data with it's header provided in `header`
/// propertie
void multiColumnPrint(List headers, List<List> lists,
    {List? footer,
    int margin = 3,
    bool numberedLines = true,
    bool reverse = false,
    bool showAVRG = false,
    bool showROC = false,
    bool showFullData = false,
    Map? moreSpecs}) {
  int _lengthOfLongestList(List<List> _list) {
    var sortedList = <List>[..._list];
    sortedList.sort((a, b) => b.length.compareTo(a.length));
    return sortedList.first.length;
  }

  if (numberedLines) {
    // Headers Configure
    headers = ['#', ...headers];
    // Footers Configure
    if (footer != null) {
      footer = ['>', ...footer];
    } else if (showAVRG) {
      footer = ['AVG'];
      lists.forEach((_list) {
        if (_list is List<num>) {
          if (footer != null)
            footer!
                .add(ncore.toParsedDouble(ncore.middle(_list).toDouble(), 3));
        }
      });
    }
    // print('Footer1 $footer');
    if (showROC) {
      if (footer != null) {
        footer = <List>[
          footer,
          <dynamic>['ROC']
        ];
        lists.forEach((_list) {
          if (_list is List<num>) {
            (footer![1] as List).add(ncore.toParsedDouble(
                ncore.middleRateOfChange(_list).toDouble(),
                (showFullData ? 10 : 3)));
          }
        });
      } else {
        lists.forEach((_list) {
          if (_list is List<num>) {
            footer = ([
              'ROC',
              ncore.toParsedDouble(ncore.middleRateOfChange(_list).toDouble(),
                  (showFullData ? 10 : 3))
            ]);
          }
        });
      }
    }

    if (reverse) {
      var index = 0;
      lists.forEach((_list) {
        lists[index] = _list.reversed.toList();
        index++;
      });
      lists = [
        List.generate(_lengthOfLongestList(lists) + 1, (index) => index)
            .skip(1)
            .toList()
            .isortZA<int>()
            .toList(),
        ...lists
      ];
    } else {
      lists = [
        List.generate(_lengthOfLongestList(lists) + 1, (index) => index)
            .skip(1)
            .toList()
            .isortAZ<int>()
            .toList(),
        ...lists
      ];
    }
  }

  var _WidestLists = [];
  lists.forEach((l) {
    var d = ncore.listWidth(l) + margin;
    _WidestLists.add(d);
  });
  var headersLine = '';
  for (var i = 0; i < headers.length; i++) {
    try {
      headersLine = headersLine +
          headers[i].toString() +
          ' ' *
              (_WidestLists[i] -
                  headers[i].toString().length -
                  (margin / 2).round()) +
          '| ';
    } catch (e) {}
  }
  // Printing the header of the table
  print(headersLine);
  // Printing the header divider of the table
  print('-' * (headersLine.length - 1));
  for (var i = 0; i < _lengthOfLongestList(lists); i++) {
    String line = '';
    for (var ii = 0; ii < lists.length; ii++) {
      try {
        line = line +
            lists[ii][i].toString() +
            ' ' *
                (_WidestLists[ii] -
                    lists[ii][i].toString().length -
                    (margin / 2).round()) +
            '| ';
      } catch (e) {
        // print(e);
      }
    }
    print(line);
  }

  if (footer != null) {
    if (footer is List<List>) {
      // footer!.forEach((list) {
      for (var i = 0; i < footer!.length; i++) {
        var footerLine = '';
        for (var ii = 0; ii < footer![i].length; ii++) {
          try {
            footerLine = footerLine +
                footer![i][ii].toString() +
                ' ' *
                    (_WidestLists[ii] -
                        footer![i][ii].toString().length -
                        (margin / 2).round()) +
                '| ';
          } catch (e) {}
        }
        // Printing the header divider of the table
        print('-' * (footerLine.length - 1));
        // Printing the header of the table
        print(footerLine);
      }
      // });
    } else {
      print(footer.runtimeType);
      var footerLine = '';
      for (var i = 0; i < footer!.length; i++) {
        try {
          footerLine = footerLine +
              footer![i].toString() +
              ' ' *
                  (_WidestLists[i] -
                      footer![i].toString().length -
                      (margin / 2).round()) +
              '| ';
        } catch (e) {}
      }
      // Printing the header divider of the table
      print('-' * (footerLine.length - 1));
      // Printing the header of the table
      print(footerLine);
    }
  }
}

/// ### Print In Single Column
/// Prints the list of elemets in a Single Column
void printInSingleColumn(List list) {
  print('-------------');
  list.forEach((e) {
    print(e);
  });
  print('-------------');
}

/// ### Customized Numbers Print To Single Column
/// Dedicated to print list of Bytes Numbers
void cnPrintToSingleColumn(List<num> list,
    {ncore.IntParseType type = ncore.IntParseType.intgr,
    bool asStr = true,
    ncore.Unit unit = ncore.megaBitUnit,
    int numberOfInts = 2}) {
  print('-------------');
  list.forEach((e) {
    print(ncore.bytesTranslater(e.toInt(),
        asStr: asStr, numberOfInts: numberOfInts, type: type, to: unit));
  });
  print('-------------');
}

void splitedPrint(dynamic d) {
  print('-------------');
  print(d);
  print('-------------');
}

void splitedPrintWithHeader(d, h) {
  var _h = '------$h------';
  print(_h);
  print(d);
  print('-' * _h.length);
}

void bytesPrint(dynamic d, [bool splited = false]) {
  if (splited) {
    print('-------------');
    print(ncore.bytesTranslater(d));
    print('-------------');
  } else {
    print(ncore.bytesTranslater(d));
  }
}


// /// propertie
// void multiColumnPrint(List headers, List<List> lists,
//     {int margin = 1, bool numberedLines = true, bool reverse = false}) {
//   int _longestListLength(List<List> _list) {
//     var sortedList = <List>[..._list];
//     sortedList.sort((a, b) => b.length.compareTo(a.length));
//     return sortedList.first.length;
//   }

//   if (numberedLines) {
//     // var linesNumbersList =
//     //     List.generate(151, (index) => index).sortZA().toList();
//     headers = ['#', ...headers];
//     if (reverse) {
//       lists = [
//         List.generate(_longestListLength(lists), (index) => index)
//             .skip(1)
//             .toList()
//             .sortZA<int>()
//             .toList(),
//         ...lists
//       ];
//     } else {
//       lists = [
//         List.generate(_longestListLength(lists), (index) => index)
//             .sortAZ<int>()
//             .toList(),
//         ...lists
//       ];
//     }
//   }

//   var frameWidth = 0.0;
//   var _WidestLists = [];
//   lists.forEach((l) {
//     var d = NCore.listWidth(l);
//     frameWidth += d;
//     _WidestLists.add(d);
//   });
//   var headersLine = '';
//   for (var i = 0; i < headers.length; i++) {
//     // if (i == 0) {
//     //   if (headers[i].length >= _WidestLists[i]) {
//     //   } else {
//     //     headersLine = headers[i] +
//     //         ' ' * (_WidestLists[i] - headers[i].toString().length - margin);
//     //   }
//     // } else {
//       // if (headersLine != null) {
//         try {
//           headersLine = headersLine +
//               headers[i].toString() +
//               ' ' * (_WidestLists[i] - headers[i].toString().length - margin);
//         } catch (e) {}
//       // }
//     // }
//   }
//   // Printing the header of the table
//   print(headersLine);
//   // Printing the header divider of the table
//   print('-' * frameWidth.toInt());
//   for (var i = 0; i < _longestListLength(lists); i++) {
//     String? line;
//     for (var ii = 0; ii < lists.length; ii++) {
//       if (ii == 0) {
//         try {
//           line = lists[ii][i].toString() +
//               ' ' *
//                   (_WidestLists[ii] - lists[ii][i].toString().length - margin);
//         } catch (e) {
//           // print(e);
//         }
//       } else {
//         if (line != null) {
//           try {
//             line = line +
//                 lists[ii][i].toString() +
//                 ' ' *
//                     (_WidestLists[ii] -
//                         lists[ii][i].toString().length -
//                         margin);
//           } catch (e) {
//             // print(e);
//           }
//         }
//       }
//     }
//     print(line);
//   }
// }
