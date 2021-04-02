import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceDetailsPage extends StatefulWidget {
  final ScanResult scanResult;

  DeviceDetailsPage(this.scanResult);
  @override
  _DeviceDetailsPageState createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  bool connected = false;

  Widget rowWidget(String key, String value) {
    return rowItem(
        key,
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ));
  }

  Widget rowItem(String key, Widget widget) {
    return Row(
      children: [
        Text(key,
            style: TextStyle(
              fontSize: 14,
            )),
        SizedBox(
          width: 16,
          child: Text(':'),
        ),
        Expanded(
          child: widget,
        )
      ],
    );
  }

  void connect() {
    widget.scanResult.device.connect().then((value) {
      print('connected');
      setState(() {
        connected = true;
      });
    }).catchError((_) {
      print('error');
    });
  }

  void disconnect() {
    widget.scanResult.device.disconnect().then((value) {
      print('disconnected');
      setState(() {
        connected = false;
      });
    }).catchError((_) {
      print('error');
    });
  }

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: connected?Colors.green:null,
      appBar: AppBar(
        title: Text(widget.scanResult.device.name),
        actions: [
          IconButton(icon: Icon(Icons.bluetooth_connected), onPressed: connect),
          IconButton(
              icon: Icon(Icons.bluetooth_disabled_outlined),
              onPressed: () => disconnect)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device characteristics'),
            Divider(),
            Column(
              children: [
                rowWidget('ID', widget.scanResult.device.id.toString()),
                rowWidget('Type', widget.scanResult.device.type.toString()),
                rowWidget(
                    'Name',
                    widget.scanResult.device.name.isEmpty
                        ? 'No Device Name'
                        : widget.scanResult.device.name),
                rowWidget(
                    'Local name',
                    widget.scanResult.advertisementData.localName.isEmpty
                        ? 'No Local Name'
                        : widget.scanResult.advertisementData.localName),
                rowWidget(
                    'Power level',
                    widget.scanResult.advertisementData.txPowerLevel == null
                        ? 'NONE'
                        : widget.scanResult.advertisementData.txPowerLevel
                            .toString()),
              ],
            ),
            Text('Device services'),
            Column(
              children: [
                rowItem(
                    'Services',
                    StreamBuilder<List<BluetoothService>>(
                      stream: widget.scanResult.device.services,
                      builder: (context,
                          AsyncSnapshot<List<BluetoothService>> snapshot) {
                        if (snapshot.data == null)
                          return SizedBox();
                        else
                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (_, index) => Column(
                              children: List<Widget>.generate(snapshot.data![index].characteristics.length, (i) => ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Characteristic'),
                Text(
                    '0x${snapshot.data![index].characteristics[i].uuid.toString().toUpperCase().substring(4, 8)}',
                    style: Theme.of(context).textTheme.body1?.copyWith(
                        color: Theme.of(context).textTheme.caption?.color))
              ],
            ),
          )),
                            ),
                            itemCount: snapshot.data!.length,
                          );
                      },
                    )),
                rowItem(
                    'State',
                    StreamBuilder<BluetoothDeviceState>(
                      stream: widget.scanResult.device.state,
                      builder: (context,
                          AsyncSnapshot<BluetoothDeviceState> snapshot) {
                        if (snapshot.data == null)
                          return SizedBox();
                        else
                          return Text(snapshot.data!.index.toString());
                      },
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
