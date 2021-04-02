import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BLEScanTile extends StatelessWidget {
  final ScanResult result;
  final Function(ScanResult) onTap;
  BLEScanTile(this.result,this.onTap);
  @override
  Widget build(BuildContext context) {

    return ListTile(
      onTap: ()=> onTap(result),
      title: Text(result.device.name.isEmpty?'No Name':result.device.name),
      subtitle: Text(result.device.type.toString()),
    );
  }
}
