import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';


class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Search'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            var status = await Permission.bluetooth.request();
            if (status.isGranted) {
              Get.to(SecondScreen());
            } else {
              // Handle permission denied
              Get.snackbar("Permission", "Bluetooth permission denied.");
            }
          },
          child: Text('Search Bluetooth Devices'),
        ),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  //FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  final flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> devicesList = [];
  Map<String, bool> connectionStatus = {};

  @override
  void initState() {
    super.initState();
    startScan();
  }

  // void startScan() async {
  //   devicesList.clear();
  //   FlutterBluePlus.startScan(timeout: Duration(seconds: 15));
  //
  //   print('Start Scan Function is Started');
  //
  //   FlutterBluePlus.scanResults.listen((results) {
  //     for (ScanResult result in results) {
  //       if (!devicesList.contains(result.device)) {
  //         setState(() {
  //           devicesList.add(result.device);
  //           print('Devices List : $devicesList');
  //           connectionStatus[result.device.id.id] = false;
  //         });
  //       }
  //     }
  //     print('Device Name: ${devicesList[0].advName}, Device ID: ${devicesList[0].connectionState}');
  //   });
  //
  //   await Future.delayed(Duration(seconds: 5));
  //   FlutterBluePlus.stopScan();
  // }

  void startScan() async {
    devicesList.clear();
    FlutterBluePlus.startScan(timeout: Duration(seconds: 15));

    print('Start Scan Function is Started');

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devicesList.contains(result.device)) {
          setState(() {
            devicesList.add(result.device);
            print('Devices List: $devicesList');
            connectionStatus[result.device.remoteId.toString()] = false;
          });
        }
      }

      if (devicesList.isNotEmpty) {
        print('Device Platform Name: ${devicesList[0].platformName}, Device Remote ID: ${devicesList[0].remoteId}');
      }
    });

    await Future.delayed(Duration(seconds: 5));
    FlutterBluePlus.stopScan();
  }













  // void toggleConnection(BluetoothDevice device) async {
  //   bool isConnected = connectionStatus[device.id.id] ?? false;
  //
  //   if (isConnected) {
  //     await device.disconnect();
  //     setState(() {
  //       connectionStatus[device.id.id] = false;
  //     });
  //   } else {
  //     await device.connect();
  //     setState(() {
  //       connectionStatus[device.id.id] = true;
  //     });
  //   }
  // }



  void toggleConnection(BluetoothDevice device) async {
    bool isConnected = connectionStatus[device.remoteId.toString()] ?? false;

    if (isConnected) {
      await device.disconnect();
      setState(() {
        connectionStatus[device.remoteId.toString()] = false;
      });
    } else {
      await device.connect();
      setState(() {
        connectionStatus[device.remoteId.toString()] = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Bluetooth Devices'),
      ),
      body: ListView.builder(
        itemCount: devicesList.length,
        itemBuilder: (context, index) {
          BluetoothDevice device = devicesList[index];
          // Print the device platformName and remoteId to the console
          print('Device Platform Name: ${device.platformName}, Device Remote ID: ${device.remoteId}');

          bool isConnected = connectionStatus[device.remoteId.toString()] ?? false;

          return ListTile(
            title: Text(device.platformName.isNotEmpty ? device.platformName : 'Unknown Device'),
            subtitle: Text(device.remoteId.toString()),
            trailing: ElevatedButton(
              onPressed: () => toggleConnection(device),
              child: Text(isConnected ? 'Disconnect' : 'Connect'),
            ),
          );
        },
      ),
    );
  }


// @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Available Bluetooth Devices'),
  //     ),
  //     body: ListView.builder(
  //       itemCount: devicesList.length,
  //       itemBuilder: (context, index) {
  //         BluetoothDevice device = devicesList[index];
  //         // Print the device name and ID to the console
  //         print('Device Name: ${device.advName}, Device ID: ${device.id}');
  //         bool isConnected = connectionStatus[device.id.id] ?? false;
  //
  //         return ListTile(
  //           title: Text(device.name.isNotEmpty ? device.name : 'Unknown Device'),
  //           subtitle: Text(device.id.id),
  //           trailing: ElevatedButton(
  //             onPressed: () => toggleConnection(device),
  //             child: Text(isConnected ? 'Disconnect' : 'Connect'),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }



}
