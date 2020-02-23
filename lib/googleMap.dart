import 'dart:async';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:place_tracer/models/marker_model.dart';

class ThirdScreen extends StatefulWidget {
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  Completer<GoogleMapController> _controller = Completer();
  final _formKey = GlobalKey<FormState>();
  double zoomVal = 5.0;
  List<Marker> allMarkers = [];
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allMarkers.add(Marker(
      markerId: MarkerId('Bangalore'),
      draggable: true,
      onTap: () {
        print('Marked Taped');
      },
      position: LatLng(12.9716, 77.5946),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Maps Sample App',
            textAlign: TextAlign.start,
          ),
          backgroundColor: Colors.red,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
                Navigator.pop(context);
            },
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15.0, right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {return _markerSaverPopUp();}
                    );
                  },
                  child: Text(
                    'Save',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                )),
              ]),
        body: Stack(
            children: <Widget>[
              _googlemap(context),
              _currLocation(),
              //a_savedLocation(),
            ],
          )),
    );
  }
                  
  Widget _googlemap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(12.9716, 77.5946), zoom: 12),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set.from(allMarkers),
        onLongPress: ((latLng) => _reachTappedLocation(latLng)),
      ));
  }

  void _reachTappedLocation(LatLng _lat) {
    //print('${_lat.latitude}, ${_lat.longitude}');
    Marker marker = allMarkers.firstWhere(
        (p) => p.markerId == MarkerId('marker_2'),
        orElse: () => null);
    allMarkers.remove(marker);
    allMarkers.clear();
    allMarkers.add(
      Marker(
        markerId: MarkerId('marker_2'),
        position: LatLng(_lat.latitude, _lat.longitude),
        draggable: true,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: 'tapped location'),
      ),
    );
    print(allMarkers[allMarkers.length-1]);
    setState(() {});
  }
                  
  Widget _currLocation() {
    return Align(
      alignment: Alignment(0.9, .9),
      child: FloatingActionButton(
        focusColor: Colors.amber,
        onPressed: _getLocation,
        tooltip: 'Get Location',
        child: Icon(
          Icons.location_searching,
          size: 20,
        ),
      ),
    );
    }
  
  void _getLocation() async {
      var currentLocation = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  
      setState(() {
        allMarkers.clear();
        Marker marker = Marker(
          markerId: MarkerId("marker_2"),
          draggable: true,
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          infoWindow: InfoWindow(title: 'Home'),
        );
        allMarkers.add(marker);
      });
  }
  
  
  Widget _markerSaverPopUp() {
    return AlertDialog(
    backgroundColor: Colors.green[100],
    shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(38.0),
      side: BorderSide(color: Colors.red[300], width: 4.0)),
    content: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                  return null;
              },
              controller :_titleController, 
              decoration: const InputDecoration(labelText :"Enter Place Name"),),
          ),
          
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                  return null;
              },
              controller :_descriptionController,
              decoration: const InputDecoration(labelText :"Enter Place Description"),),
          ),
          new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              textColor: Colors.red,
              child: Text("Submit"),
              shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(38.0),
                    side: BorderSide(color: Colors.red[200], width: 2.0)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  PlaceMarker model = new PlaceMarker("", "", "", "");
                  model.description = _descriptionController.text;
                  model.markerId = _titleController.text;
                  model.title = _titleController.text;
                  Marker marker1= allMarkers.firstWhere(
                    (p) => p.markerId == MarkerId('marker_2'),
                    orElse: () => null
                    );
                  model.lat = marker1.position.latitude.toString();
                  model.long = marker1.position.latitude.toString();
                  _descriptionController.clear();
                  _titleController.clear();
                  //print(model.lat);
                  model.save();
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              textColor: Colors.red,
              child: Text("Cancel"),
              shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(38.0),
                    side: BorderSide(color: Colors.red[200], width: 2.0)),
              onPressed: () {
              Navigator.of(context).pop();
               },
            ),
          )
          ],
          )
        ],
      ),
    ),
  );
  }
                  
}
