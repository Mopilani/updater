class State<T> {
  State({
    this.data,
    this.error,
    this.stackTrace,
  });
  T? data;
  dynamic error;
  dynamic stackTrace;

  bool get hasData => data == null ? false : true;
  bool get hasError => error == null ? false : true;
}
