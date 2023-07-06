import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Device {
  Device(this.name, this.address);

  String name;
  String address;
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('samples.flutter.dev/string');

  Future<dynamic> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      // case 'callMe':
      //   print('call callMe : arguments = ${call.arguments}');
      //   return Future.value('called from platform!');
      //return Future.error('error message!!');
      case 'receive':
        print('call callMe : arguments = ${call.arguments}');
        setState(() {
          params = call.arguments;
        });
      case 'terminalMap':
        setState(() {
          print('${call.arguments}');
          Map<String, dynamic> terminalMap = jsonDecode(call.arguments);
          //list.clear();
          terminalMap.forEach((k, v) => list.add(Device(k, v)));

          print(terminalMap.length);
        });
      default:
        print('Unknowm method ${call.method}');
        throw MissingPluginException();
        break;
    }
  }

  String params = '---';

  // late Map<String, String> terminalMap;
  final list = [];

  Future<void> _KotlinStart() async {
    final String result = await platform.invokeMethod('Aisatsu', params);
    setState(() {
      params = result;
    });
  }

  Future<void> _World() async {
    String str =
        '{"makotoipod":"6D:C5:E3:A7:12:EA","允さんのGalaxy A41":"7B:49:B6:32:88:C4"}';
    Map<String, dynamic> map = jsonDecode(str);
    await platform.invokeMethod('World',map);

    // setState(() {
    //   params = result;
    // });


    // print(map.length);
  }

  Future<void> _connect(String address) async {
    print(address);
    Map<String,String> sendBLEmap = {
      address : 'konnitiha'
    };
    await platform.invokeMethod('connect', sendBLEmap);

  }


  @override
  initState() {
    super.initState();
    // Platforms -> Dart
    platform.setMethodCallHandler(_platformCallHandler);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _KotlinStart,
                  child: const Text('Kotlin起動'),
                ),
                ElevatedButton(
                  onPressed: _World,
                  child: const Text('世界！'),
                ),
              ],
            ),
            Text(
              params,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: list.length, //List(List名).length
                    itemBuilder: (BuildContext context, int index) {
                      // return Container(
                      //     height: 50,
                      //     child: Row(
                      //       children: [
                      //         Text(list[index].name + ',' + list[index].address),
                      //         ElevatedButton(
                      //             onPressed: (){
                      //               _connect(list[index].address);
                      //             },
                      //             child: Text('connect')
                      //         )
                      //       ],
                      //     ));
                      return ListBody(
                        children: [
                          ListTile(
                            title: Text(
                              list[index].name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(list[index].address),
                            trailing: Icon(Icons.sms),
                            onTap:() => _connect(list[index].address),
                          ),
                          Divider()
                        ],
                      );
                    })),
          ],
        ),
      ),
    );
  }
}