class LogBuffer<T> {
  int size;
  int pointer = 0;
  late final List<T?> dataList;
  LogBuffer({required this.size}) {
    dataList = List<T?>.filled(size, null);
  }

  add(T log) {
    dataList[pointer] = log;
    pointer = (pointer + 1) % size;
  }

  List<T> getList() {
    List<T> listOutData = [];
    var ptrLog = pointer;
    do {
      var lg = dataList[ptrLog];
      if (lg != null) {
        listOutData.add(lg);
      }
      ptrLog = (ptrLog + 1) % size;
    } while (ptrLog != pointer);
    return listOutData;
  }

  int getPointer() => pointer;
}
