import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

// Database Name :- ugchats.db

// Logins Table Name :-  logins
//                       id TEXT NOT NULL PRIMARY KEY
//                       username TEXT NOT NULL UNIQUE
//                       password TEXT NOT NULL
//                       fullname TEXT NOT NULL
//                       email TEXT NOT NULL

Future<sql.Database> connectDB() async {
  final dbPath = path.join(await sql.getDatabasesPath(), 'ugchats.db');

  final db = sql.openDatabase(
    dbPath,
    version: 1,
    onCreate: (db, version) => db.execute(
      'CREATE TABLE logins (id TEXT NOT NULL PRIMARY KEY, username TEXT NOT NULL UNIQUE, password TEXT NOT NULL, fullname TEXT NOT NULL, email TEXT NOT NULL)',
    ),
  );
  return db;
}

Future<void> registerUserDB(
  String id,
  String userName,
  String passWord,
  String fullName,
  String email,
) async {
  final db = await connectDB();

  db.insert(
    'logins',
    {
      'id': id,
      'username': userName,
      'password': passWord,
      'fullname': fullName,
      'email': email,
    },
  );
}

Future<Map> loginDB(String username, String password) async {
  final db = await connectDB();
  var user;
  await db
      .rawQuery(
        'SELECT * FROM logins WHERE username="$username" AND password="$password"',
      )
      .then((value) => user = value[0]);

  return user;
}
