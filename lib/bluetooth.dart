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
               child: connectedDevice != null && connectedDevice.id == device.id ? Icon(Icons.check,size: 24,):Text(
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
   Widget okBtn = FlatButton(
      child: Text('OK'),
     onPressed: () => {
       Navigator.push(context, MaterialPageRoute(builder: (context) => GamePadPage(title: 'GamePad',device: connectedDevice)))
     },
    );
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: ()=>{
            widget.flutterBlue.stopScan(),
            Navigator.of(context).pop()
          },
        ),
      ),
      body: FlutterBlue.instance.isOn == null ? Center(child: Text("Bluetooth Off"),): buildView(context),
    );
  }
  
}
