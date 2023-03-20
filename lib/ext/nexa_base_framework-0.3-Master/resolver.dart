library resolver;

import 'dart:io';

resolverExambles() {
  print(dartIOPathResolver(Directory.current.path +
      '\\' +
      'hello' '/' +
      'world' '\\' +
      'helloWorld2'));
  print(currentDirPath);
  print(dateTimeResolver());
  print(dateTimeResolver('>'));
}

/// Date Time Resolover
/// Resolves the datetime to be used in the file and directory names
String dateTimeResolver([String splitPattern = '-']) => '${DateTime.now().year}'
    '$splitPattern${DateTime.now().month}'
    '$splitPattern${DateTime.now().day}'
    '$splitPattern${DateTime.now().hour}'
    '$splitPattern${DateTime.now().minute}'
    '$splitPattern${DateTime.now().second}'
    '$splitPattern${DateTime.now().millisecond}'
    '$splitPattern${DateTime.now().microsecond}';

/// Resolves the pathes that used by the dart [Directory]
String dartIOPathResolver(String path) {
  var pathSegments = path.split('\\');
  var newPathBuffer = StringBuffer();
  var currentIndex = 0;
  pathSegments.forEach((segment) {
    if (currentIndex < (pathSegments.length - 1)) {
      newPathBuffer.write(segment + '/');
    } else {
      newPathBuffer.write(segment);
    }
    currentIndex++;
  });
  return newPathBuffer.toString();
}

String get currentDirPath => dartIOPathResolver(Directory.current.path);
