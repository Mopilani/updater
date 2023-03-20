/// All rights reserved for Mopilani Team, Acanxa Team, NexaPros Team
/// NexaPros 2021 
/// Under Non Public license
@Info('0.1', '0.2', '11/12/2021')

/// An annotation used to define the class or a function when it does
/// released with the library realease
@Info('0.1', '1', '11/12/2021')
class Since {
  const Since(String version);
}

/// An annotation used to define the version of single object in the file
@Info('0.1', '1', '11/12/2021')
class Version {
  const Version(String version);
}

/// Annotation used to define the compatibilty requirements
/// for the class like other classes
@Info('0.1', '1', '11/12/2021')
class Compatiblity {
  const Compatiblity(List compatibiltyInfo);
}

/// Info is a other version of [Info]
/// that wraper for [Since], [Version] and [Modefied] annotations
@Info('0.1', '2', '11/12/2021')
class Info {
  const Info(String since, String version, [String? modefied]);
}

/// Annotation used to define the last modefie for an object
@Info('0.1+1', '1', '11/12/2021')
class Modefied {
  const Modefied(String date);
}
