library reviver;

class Reviver {}

List reviveListFromString(String listString, [type = dynamic]) {
  List<int> intListReviver(String _listString) {
    var list = _listString.split(',');
    var listBuffer = <int>[];
    list.forEach((e) {
      listBuffer.add(int.parse(e));
    });
    return listBuffer;
  }

  List<num> numListReviver(String _listString) {
    var list = _listString.split(',');
    var listBuffer = <num>[];
    list.forEach((e) {
      listBuffer.add(num.parse(e));
    });
    return listBuffer;
  }

  List<String> stringListReviver(String _listString) {
    var list = _listString.split(',');
    var listBuffer = <String>[];
    list.forEach((e) {
      listBuffer.add(e);
    });
    return listBuffer;
  }

  List dynamicListReviver(String _listString) {
    var list = _listString.split(',');
    var listBuffer = [];
    list.forEach((element) {
      try {
        listBuffer.add(num.parse(element));
      } catch (e) {
        listBuffer.add(element);
      }
    });
    return listBuffer;
  }

  if (listString.startsWith('[') && listString.endsWith(']')) {
    listString[0];
    listString[listString.length - 1];
    if (type == int) {
      return intListReviver(listString);
    } else if (type == String) {
      return stringListReviver(listString);
    } else if (type == dynamic) {
      return dynamicListReviver(listString);
    } else if (type == num) {
      return numListReviver(listString);
    } else {
      throw 'Unsupported Type $type';
    }
  } else {
    throw 'The list must start with "[" and end with "]"';
  }
}

// class _Pair {
//   _Pair();
//   // ignore: unused_element
//   _Pair.from(this.first, this.second);
//   late dynamic first;
//   late dynamic second;

//   @override
//   String toString() => '{$first:$second}';
// }

// ListToString() {}

// MapToString(Map map, [branch = 1]) {
//   var pairsList = <_Pair>[];
//   map.forEach((key, value) {
//     var pair = _Pair();
//     switch (key.runtimeType) {
//       case int:
//         pair.first = key;
//         break;
//       case String:
//         pair.first = key;
//         break;
//       case bool:
//         pair.first = key;
//         break;
//       default:
//         throw 'Key Type Unsupported';
//     }
//     switch (value.runtimeType) {
//       case int:
//         pair.second = "'value'";
//         break;
//       case String:
//         pair.second = "value";
//         break;
//       case List:
//         pair.second = _readListFromString_MapToStringMinion(value);
//         break;
//       case Map:
//         MapToString(map, branch + 1);
//         break;
//       default:
//         throw 'Value Type Unsupported';
//     }
//     pairsList.add(pair);
//   });
// }

// readMapString(String mapString) {
//   // stringDynamicMapReviver(String mapString) {
//   //   var MapBuffer = <String, dynamic>{};
//   //   for (var i = 0; i < mapString.length; i++) {
//   //     var char = mapString[i];
//   //     var pair
//   //     switch (char) {
//   //       case '{':
//   //       _Pair
//   //         break;
//   //       case ':':
//   //         break;
//   //       default:
//   //     }
//   //   }
//   // }

//   if (mapString.startsWith('{') && mapString.endsWith('}')) {
//   } else {
//     throw 'The Map must start with "{" and end with "}"';
//   }
// }
