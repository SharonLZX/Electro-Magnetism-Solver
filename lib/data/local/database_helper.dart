import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:electro_magnetism_solver/features/auth/data/models/result_model.dart';

class DBHandler {
  late Future<Database> database;

  void openDB() async {
    database =
        openDatabase(join(await getDatabasesPath(), 'result_db.db'),
            onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE results(id INTEGER PRIMARY KEY, question TEXT, result TEXT)');
    }, version: 1);
  }

  Future<void> insertResult(Result result) async {
    final db = await database;
    await db.insert(
      'results',
      result.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Result>> retrieveResult() async{
    final db = await database;
    final List<Map<String, Object?>> resultMaps = await db.query('results');
    return [
      for (final {
        'id': id as int,
        'question': question as String,
        'result': result as String,
      } in resultMaps)
      Result(id: id, question: question, result: result),
    ];
  }
}
