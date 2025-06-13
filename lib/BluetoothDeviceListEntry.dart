import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceListEntry extends StatelessWidget {
  final BluetoothDevice device;
  final int? rssi;
  final bool enabled;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  const BluetoothDeviceListEntry({
    Key? key,
    required this.device,
    this.rssi,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.3,
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        leading: Icon(Icons.devices),
        title: Text(device.name ?? "Unknown device"),
        subtitle: Text("${device.address}${rssi != null ? " • RSSI: $rssi" : ""}"),
        trailing: device.isBonded ? Icon(Icons.link) : null,
      ),
    );
  }
}
