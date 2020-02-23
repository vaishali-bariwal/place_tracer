import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:place_tracer/models/marker_model.dart';


class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String placesTable = 'places';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colLat = 'lat';

  String colLong = 'long';
  String colMarkerId = 'markerId';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'bomb1.db';

    // Open/create the database at a given path
    var markerDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return markerDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $placesTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription TEXT, $colLat TEXT, $colLong TEXT,$colMarkerId TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getPlacesMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(placesTable);
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertNote(PlaceMarker marker) async {
    Database db = await this.database;
    var result = await db.insert(placesTable, marker.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateNote(PlaceMarker marker) async {
    var db = await this.database;
    var result = await db.update(placesTable, marker.toMap(),
        where: '$colId = ?', whereArgs: [marker.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $placesTable WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $placesTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<PlaceMarker>> getMarkersList() async {
    var noteMapList = await getPlacesMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<PlaceMarker> noteList = List<PlaceMarker>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(PlaceMarker.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }
}