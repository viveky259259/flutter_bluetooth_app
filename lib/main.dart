import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_app/device_details_page.dart';
import 'package:flutter_bluetooth_app/widgets/ble_scan_tile.dart';

void main() {
  runApp(HyperVoltApp());
}

class HyperVoltApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchPage(),
      title: 'HyperVolt',
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    startSearch();
  }

  void startSearch() {
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 10));
  }

  void stopSearch() {
    FlutterBlue.instance.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HyperVolt'),
      ),
      body: StreamBuilder<List<ScanResult>>(
        stream: FlutterBlue.instance.scanResults,
        initialData: [],
        builder: (c, snapshot) => Column(
          children: snapshot.data!
              .map(
                (r) => BLEScanTile(r, (result) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => DeviceDetailsPage(r)));
                }),
              )
              .toList(),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: stopSearch,
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search), onPressed: startSearch);
          }
        },
      ),
    );
  }
}
