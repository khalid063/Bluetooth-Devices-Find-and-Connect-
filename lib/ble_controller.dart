import 'package:flutter/scheduler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  FlutterBluePlus ble = FlutterBluePlus();

  /// This Function Write for show the "Found Devices list" into Run line
  /// by which we can know is the function work or not
  @override
  void onInit() {
    super.onInit();
    // Print scan results as soon as they are found
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        print('Found device: ${result.device.advName}, RSSI: ${result.rssi}');
      }
    });
  }


  Future scanDevices() async {
    // Check and request Bluetooth permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetooth,
      Permission.locationWhenInUse, // Necessary for finding nearby devices
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (allGranted) {
      print('Starting Bluetooth scan...');
      FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

      // Stop scan after 10 seconds
      Future.delayed(Duration(seconds: 10), () {
        FlutterBluePlus.stopScan();
        print('Scan stopped.');
      });
    } else {
      print('Bluetooth permissions not granted.');
    }
  }


  // Future scanDevices() async {
  //   // Request necessary permissions
  //   if (await Permission.bluetoothScan.request().isGranted) {
  //     if (await Permission.bluetoothConnect.request().isGranted) {
  //       print('Starting Bluetooth scan...');
  //       FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
  //
  //       // Stop scan after 10 seconds
  //       Future.delayed(Duration(seconds: 10), () {
  //         FlutterBluePlus.stopScan();
  //         print('Scan stopped.');
  //       });
  //     } else {
  //       print('Bluetooth connect permission not granted.');
  //     }
  //   } else {
  //     print('Bluetooth scan permission not granted.');
  //   }
  // }


  Future<void> connectToDevice(BluetoothDevice device) async {
    //device.clearGattCache();
    print('Tapped Device Data which is connected : $device');
    Get.snackbar('Connection is Success !', 'Device Connected : $device', snackPosition: SnackPosition.BOTTOM,);

    await device?.connect(timeout: Duration(seconds: 15));


    device?.connectionState.listen((event) {
      if(FlutterBluePlus.adapterState == BluetoothBondState.bonding) {
        print("Device Connecting To : ${device.advName}");
      }else if (FlutterBluePlus.adapterState == BluetoothBondState.bonded) {
        print("Device Connected : ${device.advName}");
        Get.snackbar('Success !', 'Device Connected : ${device.advName}',);
      } else {
        print("Device Disconnected");
      }

    });

  }


  // Stream to expose scan results to the UI
  Stream<List<ScanResult>> get scanResult => FlutterBluePlus.scanResults;
}


































//
// class BleController extends GetxController {
//
//   FlutterBluePlus ble = new FlutterBluePlus();
//
//   Future scanDevices() async{
//     if (await Permission.bluetoothScan.request().isGranted) {
//       if (await Permission.bluetoothConnect.request().isGranted) {
//         FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
//
//         FlutterBluePlus.stopScan();
//
//       }
//     }
//   }
//
//   Stream<List<ScanResult>> get scanResult => FlutterBluePlus.scanResults;
//
//
//
// }











// import 'package:flutter/scheduler.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class BleController extends GetxController {
//
//   FlutterBluePlus ble = new FlutterBluePlus();
//
//   Future scanDevices() async{
//     if (await Permission.bluetoothScan.request().isGranted) {
//       if (await Permission.bluetoothConnect.request().isGranted) {
//         FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
//
//         FlutterBluePlus.stopScan();
//
//       }
//     }
//   }
//
//   Stream<List<ScanResult>> get scanResult => FlutterBluePlus.scanResults;
//
//
// }