import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'gamepad.dart';

class BluetoothList extends StatefulWidget {
  BluetoothList({Key key, this.title}) : super(key: key);

  static const String routeName = "/BluetoothList";
  final String title;
  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  


  @override
  _BluetoothListState createState() => _BluetoothListState();
  
  
}

class _BluetoothListState extends State<BluetoothList> {

  List<BluetoothService> services;
  BluetoothDevice connectedDevice;
  bool isScanning = false;
  bool isConnected = false;

  addDeviceTolist(final BluetoothDevice device) {
   if (!widget.devicesList.contains(device)) {
     setState(() {
       widget.devicesList.add(device);
     });
   }
  }

  @override
  void initState() {
   super.initState();
   if(!isScanning){
     widget.flutterBlue.connectedDevices
       .asStream()
       .listen((List<BluetoothDevice> devices) {
          for (BluetoothDevice device in devices) {
            addDeviceTolist(device);
          }
      });
      widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
        for (ScanResult result in results) {
          addDeviceTolist(result.device);
        }
      });
      widget.flutterBlue.startScan();
      isScanning = true;
   }
 }

 ListView buildView(BuildContext context) {
   if (connectedDevice != null) {
     return buildConnectDeviceView();
   }
   return buildListViewOfDevices(context);
 }
 writeData(BluetoothCharacteristic characteristic,String data) async{
   List<int> bytes = utf8.encode(data);
   await characteristic.write(bytes);
 }
 ListView buildConnectDeviceView() {
   return ListView(
     padding: const EdgeInsets.all(8),
     children: <Widget>[],
   );
 }

 ListView buildListViewOfDevices(BuildContext context) {
   List<Container> containers = new List<Container>();
   for (BluetoothDevice device in widget.devicesList) {
     containers.add(
       Container(
         height: 50,
         child: Row(
           children: <Widget>[
             Expanded(
               child: Column(
                 children: <Widget>[
                   Text(device.name == '' ? '(unknown device)' : device.name),
                   Text(device.id.toString()),
                 ],
               ),
             ),
             FlatButton(
               color: Colors.blue,
               child: isConnected ? Text(""): Text(
                 'Connect',
                 style: TextStyle(color: Colors.white),
               ),
               onPressed: () async {
                  widget.flutterBlue.stopScan();
                  try{
                    await device.connect();
                  }catch(e){
                    throw e;
                  }finally{
                    showAlertDialog(context, device.name);
                    services = await device.discoverServices();
                    services.forEach((service){
                      var characteristics = service.characteristics;
                      for(BluetoothCharacteristic c in characteristics){
                        writeData(c, "Alllllllo");
                      }
                    });
                    /*connectedDevice = device;
                    services.forEach((service) => {
                      print('Hallooooo');
                    });*/
                  }
               },
             ),
           ],
         ),
       ),
     );
   }
 
   return ListView(
     padding: const EdgeInsets.all(8),
     children: <Widget>[
       ...containers,
     ],
   );
 }
 showAlertDialog(BuildContext context, String name){
   Widget okBtn = FlatButton(child: Text('OK'),onPressed: () => {},);
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
        title: Text("Success"),
        content: name == '' ? Text("Connected to device : unknown device") : Text("Connected to device : $name "),
        actions: <Widget>[
          okBtn,
        ],
      );
     }
   );
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
      child:ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menu'),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: Text('GamePad'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'GamePad',device: connectedDevice)))
            },
          ),
          ListTile(
            title: Text('Devices List'),
            onTap: () => {
              
            },
          ),
        ],
      ) ,
    ),
      body: FlutterBlue.instance.isOn == null ? Center(child: Text("Bluetooth Off"),): buildView(context),
    );
  }
  
}
