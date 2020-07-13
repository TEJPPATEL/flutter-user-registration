import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

class DbUserManager {
  Database _database;
  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), "User.db"),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE user(id INTEGER PRIMARY KEY autoincrement , name TEXT , address TEXT , hobby TEXT,color TEXT,image TEXT)");
      });
    }
  }

  Future<int> insertUser(User user) async {
    await openDb();
    return await _database.insert('user', user.toMap());
  }

  Future<List<User>> getUser() async {
    await openDb();
    final List<Map<String , dynamic >> maps = await _database.query('user');
    return List.generate(maps.length, (index){
      return User(
        id : maps[index]['id'],
        name:maps[index]['name'],
        address : maps[index]['address'],
        hobby : maps[index]['hobby'],
        color : maps[index]['color'],
        image: maps[index]['image']
      );
    });
  }

  Future<int> updateUser(User user) async{
    await openDb();
    return await _database.update('user', user.toMap() , where: "id = ?" , whereArgs: [user.id]);
  }

  Future<void> deleteUser(int id) async {
    await openDb(); 
    await _database.delete('user',where: "id = ?" , whereArgs: [id]);
  }

}

class User {
  int id;
  String name;
  String address;
  String hobby;
  String color;
  String image;

  User({this.name, this.address,this.hobby,this.color,this.image,id});

  Map<String, dynamic> toMap() {
    return {'name': name, 'address': address ,'hobby':hobby , 'color' :color , 'image' : image};
  }
}
