class ProbeRepeat {
  ProbeRepeat({this.count = 1});
  final int count;
  int idx = 0;

  increment() {
    if (idx != count) {
      idx++;
    }
  }

  reset() {
    idx = 0;
  }

  bool get isComplete => idx == count;
}
