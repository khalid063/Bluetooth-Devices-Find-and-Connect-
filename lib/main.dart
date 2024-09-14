import 'package:bluetooth_find_and_connect/ble_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'first_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bluetooth Find and Connect',
      debugShowCheckedModeBanner: false,
      //home: FirstScreen(),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  ///=================================== Get X Controllers =====================///

  //final BleController controller = Get.find<BleController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BLE Scanner'),
          backgroundColor: Colors.greenAccent,
          centerTitle: true,
        ),

      body: Center(
        child: Column(
          children: [

            SizedBox(height: 20,),
            Text('Get Bluetooth List'),
            SizedBox(height: 20,),


            Container(
              height: 500,
              color: Colors.greenAccent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  GetBuilder<BleController>(
                    init: BleController(),
                    builder: (BleController controller) {
                      return Column(
                        children: [
                          // Wrap ListView.builder in a fixed height Container
                          Container(
                            height: 400, // Fixed height to constrain ListView
                            child: StreamBuilder<List<ScanResult>>(
                              stream: controller.scanResult,
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      final data = snapshot.data![index];
                                      return Card(
                                        elevation: 2,
                                        child: ListTile(
                                          title: Text(data.device.advName.toString()),
                                          subtitle: Text(data.device.remoteId.toString()),
                                          trailing: Text(data.rssi.toString()),
                                          onTap: () {
                                            controller.connectToDevice(data.device);
                                          },
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return Center(child: Text('No Device Found'));
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              SizedBox(width: 20,),
                              ElevatedButton(
                                onPressed: () {
                                  controller.scanDevices();
                                },
                                child: Text('Scan'),
                              ),
                              Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  controller.scanDevices();
                                },
                                child: Text('print'),
                              ),
                              SizedBox(width: 20,),

                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            )
        ],
        )
      ),

    );
  }
}


