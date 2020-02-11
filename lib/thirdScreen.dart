import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class ThirdScreen extends StatefulWidget {
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}
class _ThirdScreenState extends State<ThirdScreen> {
  Completer<GoogleMapController> _controller = Completer();
 double zoomVal = 5.0;
  List<Marker> allMarkers = [];

  @override
  void initState() {
    super.initState();
    allMarkers.add(Marker(
      markerId: MarkerId('Bangalore'),
      draggable: true,
      onTap: (){
        print('Marked Taped');
      },
      position: LatLng(12.9716,77.5946),
    ));
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.red,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
               Navigator.pop(context);
            },
          ),
        ),
        body: Stack (
          children: <Widget>[
            _googlemap(context),
            _zoomminusfunction(),
            _zoomplusfunction(),
            _currLocation(),
            //a_savedLocation(),

          ],
        )
      ),
    );
  }

  Widget _googlemap(BuildContext context){
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(target: LatLng(12.9716,77.5946),zoom: 12),
          myLocationEnabled : true,
          myLocationButtonEnabled:false,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
          markers: Set.from(allMarkers),
          
        ),
      );
  }

  Widget _zoomminusfunction(){
    return Align(
      alignment: Alignment.topLeft,
      child : IconButton(
        icon: new Icon(FontAwesomeIcons.searchMinus ,color: Color(0xFFF44336)),
        onPressed: (){
          zoomVal--;
          _minus(zoomVal);
        }),
      );
  }
  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target : LatLng(12.9716,77.5946),zoom:zoomVal)));
  }
  Widget _zoomplusfunction(){
    return Align(
      alignment: Alignment.topRight,
      child : IconButton(
        icon: new Icon(FontAwesomeIcons.searchPlus ,color: Color(0xFFF44336)),
        onPressed: (){
          zoomVal++;
          _plus(zoomVal);
        }),
      );
  }
  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target : LatLng(12.9716,77.5946),zoom:zoomVal)));
  }
  Widget _currLocation(){
    return Align(
      alignment: Alignment(0.9, .9),
      child : FloatingActionButton(
        onPressed: _getLocation,
        tooltip: 'Get Location',
        child: Icon(Icons.location_searching,size: 20,),
      ),
      );
  }
  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
       allMarkers.clear();
      final marker = Marker(
          markerId: MarkerId("curr_loc"),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          infoWindow: InfoWindow(title: 'Home'),
      );
      allMarkers.add(marker);
    });
  }
  
}
