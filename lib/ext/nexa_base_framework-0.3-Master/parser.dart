library parser;

import 'annotations.dart';

/// ## Args Parser
/// A class library designed to parse command line applications args
@Version('0.2')
class ArgsParser {
  List _args = [];
  Map<String, dynamic> options = {};
  Map<String, dynamic> flags = {};
  // Objets list
  List<dynamic> ol = [];
  // Commands Names list
  List<String> commmandsNames = [];

  @Info('0.2', '0.1')
  ArgsParser option(String name,
      {required Function(String d) callBack, String? defaultv}) {
    ol.add(_Option(callBack, name, defaultv));
    return ArgsParser();
  }

  @Info('0.2', '0.1')
  ArgsParser command(String name) {
    commmandsNames.add(name);
    return ArgsParser();
  }

  @Info('0.2', '0.1')
  ArgsParser flag(String name,
      {required Function(bool d) callBack, bool? defaultv}) {
    ol.add(_Flag(callBack, name, defaultv ?? false));
    return ArgsParser();
  }

  @Info('0.2', '0.1')
  _option(String name,
      {required void Function(String value) callBack, String? defalutv}) {
    if (_args.contains('--' + name)) {
      var ei = _args.indexOf('--' + name);
      try {
        if (!_isOption(_args[ei + 1])) {
          if (!_isFalg(_args[ei + 1])) {
            callBack(_args[ei + 1]);
            options.addAll({name: _args[ei + 1]});
          } else {
            throw Exception('The value of the "$name" marked as Flag');
          }
        } else {
          throw Exception('The value of the "$name" marked as Option');
        }
      } catch (e) {
        throw e.toString() + '\nThe value of the option "$name" not found';
      }
    } else {
      if (defalutv != null) {
        callBack(defalutv);
        options.addAll({name: defalutv});
      }
      options.addAll({name: null});
    }
  }

  @Info('0.2', '0.1')
  _flag(String name,
      {required void Function(bool value) callBack, bool defalutv = false}) {
    if (_args.contains('-' + name)) {
      callBack(true);
      flags.addAll({name: true});
    } else {
      callBack(defalutv);
      flags.addAll({name: false});
    }
  }

  @Info('0.2', '0.1')
  bool _isOption(String str) => str.contains('--') ? true : false;
  bool _isFalg(String str) => str.contains('-') ? true : false;
  bool _isCommand(String str) =>
      str.contains(RegExp('-/:=+_@#\$%><.,"' + "'")) ? true : false;

  @Info('0.2', '0.1')
  parse(List<String> args) {
    _args = args;
    _parse();
  }

  @Info('0.2', '0.1')
  _parse() {
    if (_args != null && _args.isNotEmpty) {
      if (commmandsNames.contains(_args.first) && _isCommand(_args.first)) {
        commandName = _args.first;
      }
      ol.forEach((command) {
        if (command is _Option) {
          _option(command.name,
              callBack: command.callBack, defalutv: command.defaultv);
        } else if (command is _Flag) {
          _flag(command.name,
              callBack: command.callBack, defalutv: command.defaultv);
        }
        // command.call();
      });
    }
  }

  String? _commandName;
  set commandName(String name) => _commandName = name;
  String get commandName => _commandName!;

  List get allEnteries => _args;
}

@Info('0.2', '0.1')
class _Option {
  _Option(this.callBack, this.name, this.defaultv);
  void Function(String) callBack;
  String name;
  String? defaultv;
}

@Info('0.2', '0.1')
class _Flag {
  _Flag(this.callBack, this.name, this.defaultv);
  void Function(bool) callBack;
  String name;
  bool defaultv;
}

@Info('0.2', '0.1')
class _Command {
  _Command(this.name, {this.flags, this.options});
  List<_Option>? options;
  List<_Flag>? flags;
  String name;
}

main(List<String> args) {
  var name;
  var start;
  var alent;
  var parser = ArgsParser();
  parser.option('name', callBack: (d) => name = d);
  parser.flag('start', callBack: (d) => start = d);
  parser.option('allEnteries', callBack: (d) => alent = d);

  parser.parse(['--name', 'Mohmmed', '-start', 'asdasd', '--allEnteries']);
  print(name);
  print(start);
  print(parser.options);
  print(parser.flags);
  print(parser.allEnteries);
}


// Map<String, String> PathParser(File f) {
//   var r = '';
//   var _collectedElemets = <String>[];
//   var _cacheStat = <String, String>{};
//   var path = f.path;

//   for (var i = 0; i < path.length; i++) {
//     if (path[i] == '/') {
//       var startIndex = i + 1;
//       r = '';
//       for (var ii = startIndex; ii < path.length; ii++) {
//         if (path[ii] != '/') {
//           r = r + path[ii];
//         } else {
//           break;
//         }
//       }
//       _collectedElemets.add(r);
//     }
//   }
//   var currentIndex = 0;
//   _collectedElemets.forEach((element) {
//     var length = _collectedElemets.length;
//     currentIndex++;
//     if (currentIndex == length) {
//       _cacheStat['File'] = r;
//     } else {
//       _cacheStat['Folder$currentIndex'] = r;
//     }
//   });
//   return _cacheStat;
// }
