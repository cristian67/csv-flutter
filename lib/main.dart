import 'dart:async';
import 'dart:io';

import 'package:csv_app/src/model/csv_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:csv/csv.dart';



void main() {
  runApp(
    MaterialApp(
      title: 'Reading and Writing Files',
      home: FlutterDemo(storage: CounterStorage()),
    ),
  );
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.toString());
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.csv');
  }

  Future<int> readCounter() async {
    try {

      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);

    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    
    List<List<dynamic>> rows = List<List<dynamic>>();
    CsvModel associate = new CsvModel();

    associate.id = 1;
    associate.nombre = "cristian";
    associate.edad = 25;
    
    for (int i = 0; i < associate.toString().length; i++) {
    List<dynamic> row = List();
    row.add(associate.id);
    row.add(associate.nombre);
    row.add(associate.edad);

    rows.add(row);

    print(rows);

    }

    //store file in documents folder
    // File f = new File("/data/user/0/com.example.csv/app_flutter/hello.csv");

    // convert rows to String and write as csv file
    String csv = const ListToCsvConverter().convert(rows);
    // return f.writeAsString(counter);
    final file = await _localFile;

    // // Write the file
    return file.writeAsString(csv);
  }
}


class FlutterDemo extends StatefulWidget {
  final CounterStorage storage;

  FlutterDemo({Key key, @required this.storage}) : super(key: key);

  @override
  _FlutterDemoState createState() => _FlutterDemoState();
}


class _FlutterDemoState extends State<FlutterDemo> {
  int _counter;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _incrementCounter() {
    setState(() {
      _counter++;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeCounter(_counter);
  }


  share() async {
    final ByteData bytes = await rootBundle.load('/data/user/0/com.example.csv/app_flutter/hello.csv');
    await Share.file('esys image', 'data.csv', bytes.buffer.asUint8List(), 'image/png');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reading and Writing Files')),
      body: Center(
        child: Column(
          children: <Widget>[
            Divider(height: 100),
            Text( 'Button tapped $_counter time${_counter == 1 ? '' : 's'}.',),
            Divider(height: 100),
            RaisedButton(
              onPressed: share,
              child: Text(
              'Compartir',
              style: TextStyle(fontSize: 10)
              ),
            )
          ],
        ) 
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}