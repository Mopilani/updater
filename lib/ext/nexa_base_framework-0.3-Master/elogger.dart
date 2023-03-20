/// All rights reserved for Mopilani Team, Acanxa Team, NexaPros Team
/// NexaPros 2021
/// Under Non Public license
@Info('0.01', '0.9+2-Master', '11/14/2021')

library elogger;

import 'dart:io';

import 'annotations.dart';
import 'resolver.dart' as resolver;

/// Elogger is our logger library that used here because the project based
/// on one file now
class ELogger {
  ELogger.init(
    this._logger, {
    this.printLogs = false,
    this.saveLogsToFile = false,
    this.lineNumber = 1,
    this.startTime,
    this.workDir,
  }) {
    if (_logger == null) {
      throw 'logger Name is null, try definging a logger name';
    }
    loggerName = _logger;
    startTime ??= resolver.dateTimeResolver();
    workDir ?? resolver.currentDirPath;
    _EloggerPersistentCache.set('saveLogsToFile', saveLogsToFile);
    _EloggerPersistentCache.set('startTime', startTime);
    _EloggerPersistentCache.set('printLogs', printLogs);
    _EloggerPersistentCache.set('line', lineNumber);
    _EloggerPersistentCache.set('workDir', workDir);
    _EloggerPersistentCache.set('logger', _logger);
    // _EloggerPersistentCache.set('initialized', initialized);
    if (_logger != null) {
      loggerDefaultName = _logger;
    }
    loggerDefaultFileName = '$_logger-$startTime.elog';
  }

  factory ELogger() {
    if (_EloggerPersistentCache.get('logger') != null) {
      if (_EloggerPersistentCache.get('printLogs') != null) {
        if (_EloggerPersistentCache.get('saveLogsToFile') != null) {
          if (_EloggerPersistentCache.get('startTime') != null) {
            if (_EloggerPersistentCache.get('workDir') != null) {
              // if (_EloggerPersistentCache.get('initialized') != null) {
              return ELogger.init(
                _EloggerPersistentCache.get('logger'),
                printLogs: _EloggerPersistentCache.get('printLogs'),
                saveLogsToFile: _EloggerPersistentCache.get('saveLogsToFile'),
                lineNumber: _EloggerPersistentCache.get('line'),
                startTime: _EloggerPersistentCache.get('startTime'),
                workDir: _EloggerPersistentCache.get('workDir'),
                // initialized: _EloggerPersistentCache.get('initialized'),
              );
              // }
            }
          }
        }
      }
    } else {
      throw 'No exist logger found, try define logger';
    }
    return ELogger.init('Elogger');
  }

  String? _logger;
  bool? printLogs, saveLogsToFile;
  String? loggerDefaultName = 'Elogger';
  int? lineNumber;
  String? workDir;
  String? startTime = DateTime.now().toString();
  List<dynamic> get logList => _log;

  set logList(newLine) {
    _log.add(newLine);
    _EloggerPersistentCache.set('log', _log);
  }

  set loggerName(logger) => _logger = logger;

  String get loggerName {
    if (_EloggerPersistentCache.get('logger') != null) {
      return _EloggerPersistentCache.get('logger');
    }
    return 'Elogger';
  }

  // ignore: prefer_final_fields
  List<dynamic> _log = [];

  String? loggerDefaultFileName;

  static bool get initialized {
    if (ELogger.init(
          _EloggerPersistentCache.get('logger'),
          printLogs: _EloggerPersistentCache.get('printLogs'),
          saveLogsToFile: _EloggerPersistentCache.get('saveLogsToFile'),
          lineNumber: _EloggerPersistentCache.get('line'),
          startTime: _EloggerPersistentCache.get('startTime'),
          workDir: _EloggerPersistentCache.get('workDir'),
          // ignore: unnecessary_null_comparison
        ).loggerName !=
        null) {
      return true;
    } else
      return false;
  }

  static log(text,
      {bool err = false,
      @Deprecated('Use scss for cut') bool success = false,
      bool scss = false}) {
    /// if "success" value is not true it mean the "scss" value is assaigned
    if (!success) {
      success = scss;
    }

    /// if the `printLog` is enabled will call the print log function
    if (_EloggerPersistentCache.get('printLogs') != null) {
      if (_EloggerPersistentCache.get('printLogs')) {
        ELogger.init(
          _EloggerPersistentCache.get('logger'),
          printLogs: _EloggerPersistentCache.get('printLogs'),
          saveLogsToFile: _EloggerPersistentCache.get('saveLogsToFile'),
          lineNumber: _EloggerPersistentCache.get('line'),
          startTime: _EloggerPersistentCache.get('startTime'),
          workDir: _EloggerPersistentCache.get('workDir'),
        ).printAsLogger(text.toString(), err: err, success: success);
      }
    }
    if (_EloggerPersistentCache.get('saveLogsToFile') != null) {
      if (_EloggerPersistentCache.get('saveLogsToFile')) {
        ELogger.init(
          _EloggerPersistentCache.get('logger'),
          printLogs: _EloggerPersistentCache.get('printLogs'),
          saveLogsToFile: _EloggerPersistentCache.get('saveLogsToFile'),
          lineNumber: _EloggerPersistentCache.get('line'),
          startTime: _EloggerPersistentCache.get('startTime'),
          workDir: _EloggerPersistentCache.get('workDir'),
        ).recordToFile(text.toString());
      }
    }
  }

  /// ### Log Error
  /// Logs the error state
  static logE(text) {
    /// if the `printLog` is enabled will call the print log function
    if (_EloggerPersistentCache.get('printLogs') != null) {
      if (_EloggerPersistentCache.get('printLogs')) {
        ELogger.init(
          _EloggerPersistentCache.get('logger'),
          printLogs: _EloggerPersistentCache.get('printLogs'),
          saveLogsToFile: _EloggerPersistentCache.get('saveLogsToFile'),
          lineNumber: _EloggerPersistentCache.get('line'),
          startTime: _EloggerPersistentCache.get('startTime'),
          workDir: _EloggerPersistentCache.get('workDir'),
        ).printAsLogger(text.toString(), err: true, success: false);
      }
    }
    if (_EloggerPersistentCache.get('saveLogsToFile') != null) {
      if (_EloggerPersistentCache.get('saveLogsToFile')) {
        ELogger.init(
          _EloggerPersistentCache.get('logger'),
          printLogs: _EloggerPersistentCache.get('printLogs'),
          saveLogsToFile: _EloggerPersistentCache.get('saveLogsToFile'),
          lineNumber: _EloggerPersistentCache.get('line'),
          workDir: _EloggerPersistentCache.get('workDir'),
          startTime: _EloggerPersistentCache.get('startTime'),
        ).recordToFile('${text.toString()} -[Error]-');
      }
    }
  }

  /// ### Log Success
  /// Logs the success state
  static logS(text) {
    /// if the `printLog` is enabled will call the print log function
    if (_EloggerPersistentCache.get('printLogs') != null) {
      if (_EloggerPersistentCache.get('printLogs')) {
        ELogger.init(
          _EloggerPersistentCache.get('logger'),
          printLogs: _EloggerPersistentCache.get('printLogs'),
          saveLogsToFile: _EloggerPersistentCache.get('saveLogsToFile'),
          lineNumber: _EloggerPersistentCache.get('line'),
          startTime: _EloggerPersistentCache.get('startTime'),
          workDir: _EloggerPersistentCache.get('workDir'),
        ).printAsLogger(text.toString(), err: false, success: true);
      }
    }
    if (_EloggerPersistentCache.get('saveLogsToFile') != null) {
      if (_EloggerPersistentCache.get('saveLogsToFile')) {
        ELogger.init(
          _EloggerPersistentCache.get('logger'),
          printLogs: _EloggerPersistentCache.get('printLogs'),
          saveLogsToFile: _EloggerPersistentCache.get('saveLogsToFile'),
          lineNumber: _EloggerPersistentCache.get('line'),
          workDir: _EloggerPersistentCache.get('workDir'),
          startTime: _EloggerPersistentCache.get('startTime'),
        ).recordToFile('${text.toString()} -[Success]-');
      }
    }
  }

  static logEx(text) {
    /// if the `printLog` is enabled will call the print log function
    if (_EloggerPersistentCache.get('printLogs') != null) {
      if (_EloggerPersistentCache.get('printLogs')) {
        ELogger.init(
          _EloggerPersistentCache.get('logger'),
          printLogs: _EloggerPersistentCache.get('printLogs'),
          saveLogsToFile: _EloggerPersistentCache.get('saveLogsToFile'),
          lineNumber: _EloggerPersistentCache.get('line'),
          startTime: _EloggerPersistentCache.get('startTime'),
          workDir: _EloggerPersistentCache.get('workDir'),
        ).printAsLogger(text.toString(), err: false, success: true);
      }
    }
    if (_EloggerPersistentCache.get('saveLogsToFile') != null) {
      if (_EloggerPersistentCache.get('saveLogsToFile')) {
        ELogger.init(
          _EloggerPersistentCache.get('logger'),
          printLogs: _EloggerPersistentCache.get('printLogs'),
          saveLogsToFile: _EloggerPersistentCache.get('saveLogsToFile'),
          lineNumber: _EloggerPersistentCache.get('line'),
          workDir: _EloggerPersistentCache.get('workDir'),
          startTime: _EloggerPersistentCache.get('startTime'),
        ).recordToFile(Exception('${text.toString()} -[Exception]-'));
      }
    }
  }

  static logSt(text) {
    /// if the `printLog` is enabled will call the print log function
    if (_EloggerPersistentCache.get('printLogs') != null) {
      if (_EloggerPersistentCache.get('printLogs')) {
        ELogger.init(
          _EloggerPersistentCache.get('logger'),
          printLogs: _EloggerPersistentCache.get('printLogs'),
          saveLogsToFile: _EloggerPersistentCache.get('saveLogsToFile'),
          lineNumber: _EloggerPersistentCache.get('line'),
          startTime: _EloggerPersistentCache.get('startTime'),
          workDir: _EloggerPersistentCache.get('workDir'),
        ).printAsLogger(text.toString(), err: false, success: true);
      }
    }
    if (_EloggerPersistentCache.get('saveLogsToFile') != null) {
      if (_EloggerPersistentCache.get('saveLogsToFile')) {
        ELogger.init(
          _EloggerPersistentCache.get('logger'),
          printLogs: _EloggerPersistentCache.get('printLogs'),
          saveLogsToFile: _EloggerPersistentCache.get('saveLogsToFile'),
          lineNumber: _EloggerPersistentCache.get('line'),
          workDir: _EloggerPersistentCache.get('workDir'),
          startTime: _EloggerPersistentCache.get('startTime'),
        ).recordToFile('${text.toString()} -[START]-');
      }
    }
  }

  static logEn(text) {
    /// if the `printLog` is enabled will call the print log function
    if (_EloggerPersistentCache.get('printLogs') != null) {
      if (_EloggerPersistentCache.get('printLogs')) {
        ELogger.init(
          _EloggerPersistentCache.get('logger'),
          printLogs: _EloggerPersistentCache.get('printLogs'),
          saveLogsToFile: _EloggerPersistentCache.get('saveLogsToFile'),
          lineNumber: _EloggerPersistentCache.get('line'),
          startTime: _EloggerPersistentCache.get('startTime'),
          workDir: _EloggerPersistentCache.get('workDir'),
        ).printAsLogger(text.toString(), err: false, success: true);
      }
    }
    if (_EloggerPersistentCache.get('saveLogsToFile') != null) {
      if (_EloggerPersistentCache.get('saveLogsToFile')) {
        ELogger.init(
          _EloggerPersistentCache.get('logger'),
          printLogs: _EloggerPersistentCache.get('printLogs'),
          saveLogsToFile: _EloggerPersistentCache.get('saveLogsToFile'),
          lineNumber: _EloggerPersistentCache.get('line'),
          workDir: _EloggerPersistentCache.get('workDir'),
          startTime: _EloggerPersistentCache.get('startTime'),
        ).recordToFile('${text.toString()} -[END]-');
      }
    }
  }

  /// ### Recored to File
  /// Records the current line to the log file
  void recordToFile(dynamic contents) {
    var dir = Directory(workDir!);
    if (!dir.existsSync()) {
      dir.create().then((directory) {
        var file = File('${directory.path}/$loggerDefaultFileName');
        if (lineNumber == 1) {
          file.writeAsStringSync('$lineNumber: $contents ',
              mode: FileMode.append);
        } else {
          file.writeAsStringSync('\n$lineNumber: $contents ',
              mode: FileMode.append);
        }
        _EloggerPersistentCache.set('line', lineNumber! + 1);
      });
    } else {
      var file = File('${dir.path}/$loggerDefaultFileName');
      file.writeAsStringSync('\n$lineNumber: $contents ',
          mode: FileMode.append);
      _EloggerPersistentCache.set('line', lineNumber! + 1);
    }
  }

  int logFileNumber = 1;

  Future saveAllLog({LogType logType = LogType.byTime}) async {
    var dir = Directory.current.path;
    if (logType == LogType.byTimes) {
      try {
        var file = File('$dir/$loggerDefaultFileName');
        await file.exists().then(
          (value) async {
            if (value) {
              for (var i = 0; i < 10; i++) {
                print("Retry to rename the log file becase it's found");
                if (await File('').exists()) {
                  break;
                } else {
                  logFileNumber++;
                }
              }
            } else {
              loggerDefaultFileName = '$_logger.elog';
            }
          },
        );
        file.openWrite();
      } catch (e) {
        printAsLogger(e.toString(), err: true);
      }
    } else if (logType == LogType.byTime) {
      try {
        var file = File('$dir/$loggerDefaultFileName');
        await file.exists().then(
          (value) async {
            if (value) {
              for (var i = 0; i < 10; i++) {
                print("Retry to rename the log file becase it's found");
                loggerDefaultFileName = '$_logger At ${DateTime.now()}.elog';
              }
            } else {
              loggerDefaultFileName = '$_logger At ${DateTime.now()}.elog';
            }
          },
        );
        file = File('$dir/$loggerDefaultFileName');
        for (var i = 0; i < _log.length; i++) {
          await file.writeAsString(_log[i], mode: FileMode.append);
        }
      } catch (e) {
        printAsLogger(e.toString(), err: true);
      }
    }
  }

  /// ### Program End
  /// When the programs end, all the log will be save in a single file
  ///
  /// `!` It not used commonly now cause the logs are printed previously
  Future<void> programEnd(LogType logType) async {
    await saveAllLog(logType: logType);
  }

  void printAsLogger(String text, {bool err = false, bool success = false}) {
    // var modfiedText = '';
    if (err) {
      print('--------[Error]-----------');
      print('$_logger: $text');
      print('^^^^^^^^^^^^^^^^^^^^^^^^^^');
    } else if (success) {
      print('$_logger: $text -[Success]-');
    } else {
      print('$_logger: $text');
    }
  }
}

void log(Object text) {
  if (ELogger.initialized) ELogger.log(text);
}

/// Log Error line
void logE(Object text) {
  if (ELogger.initialized) ELogger.logE(text);
}

/// Log Success line
void logS(Object text) {
  if (ELogger.initialized) ELogger.logS(text);
}

/// Log Start of the event
void logSt(Object text) {
  if (ELogger.initialized) ELogger.logSt(text);
}

/// Log End of the event
void logEn(Object text) {
  if (ELogger.initialized) ELogger.logEn(text);
}

/// Log log Exception
void logEx(Object text) {
  if (ELogger.initialized) ELogger.logEx(text);
}
enum LogType {
  byTime,
  byTimes,
  NoThing,
}

class _EloggerPersistentCache {
  static final Map<String, dynamic> _cache = <String, dynamic>{};

  static dynamic set(String key, dynamic value) => _cache[key] = value;

  static dynamic get(String key) => _cache[key];
}
