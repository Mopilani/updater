part of 'updater.dart';

/// By extending [UpdaterX] class and making a new updater
/// instance [u] that saved in the [_updatersCache], you
/// must not recall the [u] by it's default constractor
/// cause it will resave it in the [_updaterCache] and the
/// data in the previous stream may be lost
class UpdaterX<T> extends UpdaterOrSpecial {
  UpdaterX(
    T initialState, {
    // int updateSpeed = 14,
    reset = true,
  }) {
    // _updateSpeed = updateSpeed;
    if (reset) {
      // currentEvent = initialState;
      streamController = StreamController<State<T>>();
      sink = streamController.sink;
      add(initialState);
      _updatersCache.addAll({toString(): this});
    }
  }

  /// Get The Events Stream That provided by the updater
  /// in the realtime
  Stream<State<T>> eventsStream<T>() {
    return (_updatersCache[toString()] as UpdaterX<T>).streamController.stream;
  }

  // late int _updateSpeed;
  var currentError;
  var watchingError;
  // var currentEvent;
  var _objectToWatch;
  var _oldObjectState;
  var _objectWatching = false;
  bool initialized = true;
  late StreamController<State<T>> streamController;
  late StreamSink sink;

  /// Dispose the updater instance after your events adding
  /// stopped
  void dispose() {
    // print('dispose');
    if (_updatersCache.containsKey(toString())) {
      _updatersCache.remove(toString());
    }
  }

  /// Add a new event to the updater instance to be passed
  /// to the events listeners
  void add(T event) {
    // print(event);
    // print(_updatersCache);
    if (_updatersCache.containsKey(toString())) {
      (_updatersCache[toString()] as UpdaterX)
          .sink
          .add(State(data: event, error: currentError));
    }
  }

  /// Watch an object state changes and provide it's events
  /// to the listeners
  void watch(object) {
    if (_updatersCache.containsKey(toString())) {
      (_updatersCache[toString()] as UpdaterX)._objectToWatch = object;
      (_updatersCache[toString()] as UpdaterX)._objectWatching = true;
    }
  }

  void error(error) {
    if (_updatersCache.containsKey(toString())) {
      (_updatersCache[toString()] as UpdaterX).currentError = error;
    }
  }

  /// Get the current updater instance name as string
  @override
  String toString() => runtimeType.toString();
}

class SpecialUpdaterX<T> extends UpdaterOrSpecial {
  factory SpecialUpdaterX(
    updaterSpecialId, {
    initialState,
    reset = false,
  }) {
    if (!reset &&
        _updatersCache.containsKey(updaterSpecialId) &&
        _updatersCache[updaterSpecialId] != null) {
      // print('Found In Cache');
      return _updatersCache[updaterSpecialId];
    } else {
      // print('Not Found In Cache');
      return SpecialUpdaterX._(
        updaterSpecialId,
        initialState,
        reset: reset,
      );
    }
  }

  SpecialUpdaterX._(
    this.updaterSpecialId,
    initialState, {
    reset = false,
  }) {
    if (reset) {
      streamController = StreamController<State<T>>();
      sink = streamController.sink;
      _updatersCache.addAll({updaterSpecialId: this});
      add(initialState);
    }
  }

  /// Get The Events Stream That provided by the updater
  /// in the realtime
  Stream<State<T>> eventsStream<T>() {
    return (_updatersCache[updaterSpecialId] as SpecialUpdaterX<T>)
        .streamController
        .stream.asBroadcastStream();
  }

  String updaterSpecialId;
  var currentError;
  var watchingError;
  var _objectToWatch;
  var _oldObjectState;
  var _objectWatching = false;
  bool initialized = true;
  late StreamController<State<T>> streamController;
  late StreamSink sink;

  /// Dispose the updater instance after your events adding
  /// stopped
  void dispose() {
    if (_updatersCache.containsKey(updaterSpecialId)) {
      (_updatersCache[updaterSpecialId] as SpecialUpdaterX).initialized = false;
      _updatersCache.remove(updaterSpecialId);
    }
  }

  /// Add a new event to the updater instance to be passed
  /// to the events listeners
  void add(T event) {
    if (_updatersCache.containsKey(updaterSpecialId)) {
      (_updatersCache[updaterSpecialId] as SpecialUpdaterX)
          .sink
          .add(State(data: event, error: currentError));
    }
  }

  /// Watch an object state changes and provide it's events
  /// to the listeners
  void watch(object) {
    if (_updatersCache.containsKey(updaterSpecialId)) {
      (_updatersCache[updaterSpecialId] as SpecialUpdaterX)._objectToWatch =
          object;
      (_updatersCache[updaterSpecialId] as SpecialUpdaterX)._objectWatching =
          true;
    }
  }

  void error(error) {
    if (_updatersCache.containsKey(updaterSpecialId)) {
      (_updatersCache[updaterSpecialId] as SpecialUpdaterX).currentError =
          error;
    }
  }

  /// Get the current updater instance name as string
  @override
  String toString() => runtimeType.toString();
}


// class CardUpdater<T> extends SpecialUpdaterX<T> {
//   CardUpdater(id, {initialState, bool updateForCurrentEvent = false}) 
//       : super(
//           id,
//           initialState,
//           reset: updateForCurrentEvent,
//         );
//   // {  updater.SpecialUpdaterX(
//   //     id,
//   //     initialState,
//   //     reset: updateForCurrentEvent,
//   //   );
//   // }
// }
