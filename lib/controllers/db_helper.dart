import 'package:hive/hive.dart';

class DbHelper {

  late Box box;

  DbHelper(){
    openBox();
  }

  void openBox() {
    box = Hive.box('transaction');
  }

  Future addData(int amount, String note, DateTime date, String type)async{
    var value = {'amount' : amount, 'note' : note, 'date' : date, 'type' : type};
    box.add(value);
  }

  Future<Map> fetch()async{
    if(box.values.isEmpty){
      return Future.value({});
    }else{
      return Future.value(box.toMap());
    }
  }
}