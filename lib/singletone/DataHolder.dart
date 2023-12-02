class DataHolder {

static final DataHolder _dataHolder = DataHolder._internal();

DataHolder._internal() {
  }

factory DataHolder(){
  return _dataHolder;
}


}