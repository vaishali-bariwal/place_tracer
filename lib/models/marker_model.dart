import 'package:sqflite/sqflite.dart';

import 'package:place_tracer/db_utils/db_sqlite.dart';




class PlaceMarker
{
  int _id;
  String _markerId;
  String _lat;
  String _long;
  String _title;
  String _description;
  DatabaseHelper db_helper = DatabaseHelper();

  PlaceMarker(this._markerId, this._lat, this._long, this._title,
      [this._description]);

  PlaceMarker.withId(this._id, this._markerId, this._lat, this._long, this._title,
      [this._description]);

  int get id => _id;

  String get markerId => _markerId;

  String get description => _description;

  String get lat => _lat;
  
  String get long => _long;

  String get title => _title;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    
      if (newDescription.length <= 255) {
      this._description = newDescription;
      }
    
  }

  set lat(String lat) {
      this._lat = lat;
  }

  set long(String long) {
      this._long = long;
  }


  set markerId(String markerId) {
    this._markerId = markerId;
  }

Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['lat'] = _lat;
    map['long'] = _long;
    map['markerId'] = _markerId;

    return map;
  }

  // Extract a Note object from a Map object
  PlaceMarker.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._lat = map['lat'];
    this._long = map['long'];
    this._markerId = map['markerId'];
  }

  
  
  void save() async { 
    print(this.description);
    db_helper.insertNote(this);

    print("Saved successfully");
    List<PlaceMarker> markers = await db_helper.getMarkersList();
    print("Now list is: ");
    for(final marker in markers) {
      print(marker._description);
    }
    print("====");
  }


    /*//note.date = DateFormat.yMMMd().format(DateTime.now());

    if (this.id != null) {
      await helper.updateNote(this.);
    } else {
      await helper.insertNote(note);
    }
  }

    void _delete() async {
      await helper.deleteNote(note.id);
      moveToLastScreen();
    }*/
}

Future<List<PlaceMarker>> fetchAllMarkers() {
  DatabaseHelper dbHelper = DatabaseHelper();
  final Future<Database> dbFuture = dbHelper.initializeDatabase();
  
  return dbFuture.then((database) {
    Future<List<PlaceMarker>> markersFuture = dbHelper.getMarkersList();
    return markersFuture;
    });
}