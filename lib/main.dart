import 'package:flutter/material.dart';
import 'thirdScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.red[300],
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Background Image Example'),
        ),
        body: Stack(children: <Widget>[
          Center(
            child: new Image.asset(
              'assets/images/home.jpg',
              width: size.width,
              height: size.height,
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ButtonTheme(
                    minWidth: 250.0,
                    height: 60.0,
                    buttonColor: Colors.red,
                    child: RaisedButton(
                        child: Text(
                          'MARK YOUR LOACTION',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(38.0),
                            side: BorderSide(color: Colors.red, width: 2.0)),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                            return new ThirdScreen();
                          }));
                        })),
                new Text("        "),
                new Text("        "),
                new Text("        "),
                new Text("        "),
                ButtonTheme(
                    minWidth: 250.0,
                    height: 60.0,
                    buttonColor: Colors.red,
                    child: RaisedButton(
                        child: Text(
                          'SAVED LOACTION',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(38.0),
                            side: BorderSide(color: Colors.red, width: 2.0)),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                            return new SecondScreen();
                          }));
                        })),
              ],
            ),
          )
        ]));
  }
}

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
}
