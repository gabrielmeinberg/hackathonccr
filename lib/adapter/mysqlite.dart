import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppointmentDB {

  createDB() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'cart.db');
      
      // open the database
      return await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute("CREATE TABLE IF NOT EXISTS appointment ( "
            "id INTEGER PRIMARY KEY,"
            "descricao TEXT,"
            "data TEXT,"
            "id_process TEXT"
            "create_at DATETIME DEFAULT CURRENT_TIMESTAMP)");
      });

    } catch (e) {
      print("ERRR >>>>");
      print(e);
    }
  }

  Future<int> insertAppointment(String descricao, String data, String idProcess) async {
    Database _db = await createDB();
    return await _db
        .insert("appointment", {"descricao": descricao, "data": data, "id_process": idProcess});
  }

  Future<List<Map>> getAppointment() async {
    Database _db = await createDB();
    var result = await _db.rawQuery('SELECT * FROM appointment');
    if (result != null) {
      return result.toList();
    }
    return null;
  }


  Future<void> deleteTable() async {
    Database _db = await createDB();
    await _db.rawDelete('DELETE FROM cart');
  }
}
