extension IsSingle<T> on Iterable<T> {
  bool get isSingle => this.singleOrNull != null;
}
