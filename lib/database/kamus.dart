import 'package:pi_project/database/database_helper.dart';

class Kamus {
  int id;
  String bali, inggris;

  Kamus({this.id, this.bali, this.inggris});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseHelper.columnBali: bali,
      DatabaseHelper.columnInggris: inggris,
    };

    if (id != null) {
      map[DatabaseHelper.columnID] = id;
    }

    return map;
  }

  Kamus.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseHelper.columnID];
    bali = map[DatabaseHelper.columnBali];
    inggris = map[DatabaseHelper.columnInggris];
  }
}
