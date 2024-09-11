import 'package:aippmsa/helpers/database_helper.dart';
import 'package:aippmsa/models/User.dart';
import 'package:sqflite/sqflite.dart';

class UserService {
  Future<void> saveUser(User user) async {
    final db = await DatabaseHelper().database;
    await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUser() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<void> clearUser() async {
    final db = await DatabaseHelper().database;
    await db.delete('users');
  }
}