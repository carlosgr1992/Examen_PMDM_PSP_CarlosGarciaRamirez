import 'FireBaseAdmin.dart';
import 'HttpAdmin.dart';

class DataHolder {
  static final DataHolder _dataHolder = DataHolder._internal();
  static final FirebaseAdmin firebaseAdmin = FirebaseAdmin();
  static final HttpAdmin httpAdmin=HttpAdmin();

  DataHolder._internal();
  
   void initDataHolder(){


  }

  factory DataHolder() {
    return _dataHolder;
  }



}
