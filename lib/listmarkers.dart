import 'package:flutter/material.dart';
import 'package:place_tracer/models/marker_model.dart';

class MarkerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MarkersList'),
      ),
      body: BodyLayout(),
    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _markersList(context);
  }
}

Widget _markersList(BuildContext context) {
  return FutureBuilder<List<PlaceMarker>> (
    future: fetchAllMarkers(),
    builder: (BuildContext context, AsyncSnapshot<List<PlaceMarker>> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting: return new Text('Loading....');
        default:
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          else
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            PlaceMarker marker = snapshot.data[index];
            return ListTile(
              title: Text(marker.title),
              subtitle: Text(marker.description),
            );
          } //itembuilder
        );
      } // switch
    } //builder
  );
}




/*
class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: RaisedButton(
          color: Colors.red,
          child: Text(
            'MARK YOUR LOACTION',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(38.0),
              side: BorderSide(color: Colors.red, width: 2.0)),
          onPressed: () {
            //Use`Navigator` widget to pop oir go back to previous route / screen
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}*/