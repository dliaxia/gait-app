import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'History_data.dart';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'SelectBondedDevicePage.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as flutter_contact;
import 'package:geolocator/geolocator.dart'; 



BluetoothConnection? connection;



void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  MyApp({super.key});
// gait variables:
double _speed = 0;
double _cadence = 0;
String _gaitStatus = "UNKNOWN";
int _ldrState = 0; // 0 = OFF, 1 = ON, 2 = AUTO
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,



      title: 'gait main ',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(
          255,
          61,
          26,
          26,
        ), // White background
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  flutter_contact.Contact? _emergencyContact; // Stores the selected emergency contact

  int _selectedIndex = 0;

  // Gait variables
  double _speed = 0;
  double _cadence = 0;
  String _gaitStatus = "UNKNOWN";
  int _ldrState = 0; // 0 = OFF, 1 = ON, 2 = AUTO
  bool _mySwitchValue = false; // Switch state

  List<Widget> get _pages => [
    Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Stack(
          children: [
            // Top right connection indicator
            Align(
              alignment: Alignment.topRight,
              child: _buildConnectionIndicator(),
            ),
            // Main content
            Column(
              children: [
                const SizedBox(height: 60),
                const Text('Home', style: TextStyle(fontSize: 32)),
                CircularPercentIndicator(
                  animation: true,
                  animateFromLastPercent: true,
                  animationDuration: 1000,
                  curve: Curves.easeInOut,
                  radius: 150.0,
                  lineWidth: 25.0,
                  percent: 0.7,
                  center: Text('${_gaitStatus}'),
                  progressColor: const Color.fromRGBO(148, 144, 238, 1),
                ),
                const SizedBox(height: 19),
                const Text(
                  ' Gait Health!',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color.fromRGBO(148, 144, 238, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularPercentIndicator(
                          animation: true,
                          animateFromLastPercent: true,
                          animationDuration: 1000,
                          curve: Curves.easeInOut,
                          radius: 60.0,
                          lineWidth: 8.0,
                          percent: 0.4,
                          center: Text(
    '${_speed}', // shows speed with 1 decimal place
    style: const TextStyle(
      color: Color.fromRGBO(76, 175, 80, 1),
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  ),
                          progressColor: const Color.fromRGBO(76, 175, 80, 1),
                        ),
                        Text(
                          'Speed',
                          style: TextStyle(
                            color: const Color.fromRGBO(76, 175, 80, 1),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularPercentIndicator(
                          animation: true,
                          animateFromLastPercent: true,
                          animationDuration: 1000,
                          curve: Curves.easeInOut,
                          radius: 60.0,
                          lineWidth: 8.0,
                          percent: 0.9,
                          center: Text(
                            '${_cadence}',
                            style: const TextStyle(
                              color: Color.fromRGBO(255, 152, 0, 1),
                            ),
                          ),
                          progressColor: const Color.fromRGBO(255, 152, 0, 1),
                        ),
                        Text(
                          'Cadence',
                          style: TextStyle(
                            color: const Color.fromRGBO(255, 152, 0, 1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                const Spacer(),
                CalculateGaitButton(
                  onPressed: () {
                                  _fetchGaitDataFromESP32();
         ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
  content: Text('Calculating Gait...'),
  backgroundColor: Colors.blue,
  duration: Duration(seconds: 2), // Change duration here
),
         );                                  
                                },
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    //history page:
    Scaffold(
      backgroundColor: Colors.white,
    body: Stack(
      children: [
        // 🔽 Background image
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            'assests/images/history.png',
            fit: BoxFit.cover, // changer to Boxfit.fill if this doesn't work
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 100), // some top spacing
            Expanded(
              child: ListView.builder(
                itemCount: sampleHistoryEntries.length,
                itemBuilder: (context, index) {
                  final entry = sampleHistoryEntries[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        'Speed: ${entry.speed} m/s, Cadence: ${entry.cadence} steps/min',
                      ),
                      subtitle: Text(
                        'Gait Status: ${entry.gaitStatus}\n'
                        'Time: ${entry.timestamp.toLocal().toString().split('.').first}',
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
            ],
          ),
      ),
    ],
  ),
),
  //settings page:
  Scaffold(
    backgroundColor: Colors.white,
    body: Stack(
      children: [
        // Background Container
        Container(
          width: double.infinity, // Make it span the full width of the screen
          height: 140, // Set the desired height
          decoration: BoxDecoration(color: const Color(0xFF9390ED)),
        ),
        // Foreground Content
        Column(
          children: [
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center, // Align the oval and text in the center
              children: [
                // Stretched Oval
                Container(
                  width: 300, // Adjust the width of the oval
                  height: 100, // Adjust the height of the oval
                  decoration: BoxDecoration(
                    color: const Color(0xFF9390ED), // Background color of the oval
                    borderRadius: BorderRadius.circular(50), // Makes it an oval
                  ),
                ),
                // Settings Text
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Ensure the text is visible on the oval
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: ElevatedButton(
                    onPressed:_openDeviceList,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Connect',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        const Icon(
                          Icons.bluetooth,
                          color: Colors.purple,
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      pickContact();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.contact_emergency,
                          size: 45,
                          color: Colors.deepPurple,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ElevatedButton(
                    onPressed: 
                       _exportToExcel,
                    
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.analytics,
                          size: 45,
                          color: Colors.deepPurple,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 170,
                  height: 170,
                  child: ElevatedButton(
  onPressed: () async {
  if (connection != null && connection!.isConnected) {
    try {
      // Cycle through states: 0 -> 1 -> 2 -> 0 ...
      _ldrState = (_ldrState + 1) % 3;

      String command;
      if (_ldrState == 0) {
        command = "LDR_OFF";
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
  content: Text('LIghts are OFF'),
  backgroundColor: Colors.red,
  duration: Duration(seconds: 2), // Change duration here
),
        );
      } else if (_ldrState == 1) {
        command = "LDR_ON";
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
  content: Text('LIghts are ON'),
  backgroundColor: Colors.green,
  duration: Duration(seconds: 2), // Change duration here
        ),
);
      } else {
        command = "LDR_AUTO";
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
  content: Text('AUto mode activated'),
  backgroundColor: Colors.blueGrey,
  duration: Duration(seconds: 2), // Change duration here
        ),
);
      }

      // Send command with just \n at end (better matching ESP32):
      connection!.output.add(Uint8List.fromList("$command\n".codeUnits));
      await connection!.output.allSent;

      print("Command sent: $command");

      setState(() {});  // Optional: to update UI

    } catch (e) {
      print("Failed to send command: $e");
    }
  } else {
    print("Bluetooth is not connected.");
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
  content: Text('Bluetooth is not connected'),
  backgroundColor: Colors.red,
  duration: Duration(seconds: 2), // Change duration here
    ),
);
  }
},
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        'Lights',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      const Icon(
        Icons.flare,
        size: 35,
        color: Colors.deepPurple,
      ),
    ],
  ),
),
                ),
              ],
            ),
            const Spacer(),
            // the switch and label here
            Column(
              children: [
                Switch(
  value: _mySwitchValue,
  onChanged: (bool value) async {
    setState(() {
      _mySwitchValue = value;
    });

    if (connection != null && connection!.isConnected) {
      String command = value ? "GAIT_swivel" : "GAIT_step";

      try {
        connection!.output.add(Uint8List.fromList("$command\n".codeUnits));
        await connection!.output.allSent;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value ? 'Swivel mode activated' : 'Stepping mode activated'),
            backgroundColor: value ? Colors.blueGrey : Colors.grey,
            duration: Duration(seconds: 2),
          ),
        );

        print("Command sent: $command");
      } catch (e) {
        print("Failed to send command: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send command'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      print("Bluetooth is not connected.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bluetooth is not connected'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  },
),

                const SizedBox(height: 8),
                Text(
                  _mySwitchValue
                      ? 'Swivel mode'
                      : 'Stepping mode',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 24), // Extra space at the bottom
          ],
        ),
      ],
    ),
  ),
];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      requestBluetoothPermissions();
    });
  }
//permission for bluetooth
  Future<bool> requestBluetoothPermissions() async {
    final statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }
  //permission for location and sms
  Future<void> requestPermissions() async {
  await Permission.location.request();
  await Permission.sms.request();
}
// Function to get the current location
Future<Position?> getCurrentLocation() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return null;
      }
    }

    return await Geolocator.getCurrentPosition();
  } catch (e) {
    print('Location error: $e');
    return null;
  }
}
//sms functionality




  // excel export function
  // This function will be called when the user taps the export button
  Future<void> _exportToExcel() async {
  try {
    final excel = Excel.createExcel();
    final sheet = excel['Gait Data'];

    // Add headers
    final headers = [
      'Timestamp',
      'Speed (m/s)',
      'Cadence (steps/min)',
      'Gait Status',
    ];

    for (int col = 0; col < headers.length; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
          .value = TextCellValue(headers[col]);
    }

    // Add data rows
    for (int row = 0; row < sampleHistoryEntries.length; row++) {
      final entry = sampleHistoryEntries[row];

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row + 1))
          .value = TextCellValue(entry.timestamp.toLocal().toString().split('.').first);

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row + 1))
          .value = DoubleCellValue(entry.speed);

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row + 1))
          .value = DoubleCellValue(entry.cadence.toDouble());

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row + 1))
          .value = TextCellValue(entry.gaitStatus.toString());
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/gait_history_${DateTime.now().millisecondsSinceEpoch}.xlsx';

    final fileBytes = excel.encode();
    if (fileBytes == null) {
      print('Failed to encode Excel file');
      return;
    }

    final file = File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);

    await OpenFile.open(filePath);
    print('Excel file exported to: $filePath');
  } catch (e) {
    print('Error exporting to Excel: $e');
  }
}

// Stores the saved Bluetooth address
  String? _savedAddress;

  // Stores the Bluetooth connection
  BluetoothConnection? _connection;

  // Tracks connection status
  bool _isConnected = false;

  /// Loads the saved Bluetooth MAC address from SharedPreferences and tries to connect.
  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final address = prefs.getString('smart_walker');
    if (address != null) {
      setState(() {
        _savedAddress = address;
      });
      _tryConnect(address);
    }
  }

  /// Tries to connect to the given Bluetooth address.
  Future<void> _tryConnect(String address) async {
    try {
      final connection = await BluetoothConnection.toAddress(address);
      setState(() {
        _connection = connection;
        _isConnected = true;
      });

      connection.input?.listen((data) {
        print('Received data: ${String.fromCharCodes(data)}');
      }).onDone(() {
        setState(() {
          _isConnected = false;
        });
        print('Disconnected');
      });
    } catch (e) {
      print('Connection error: $e');
    }
  }

  /// Opens a simple device picker and prints the selected device address.
  void _openDeviceList() async {
  final selectedDevice = await Navigator.of(context).push<BluetoothDevice>(
    MaterialPageRoute(
      builder: (context) => SelectBondedDevicePage(
        checkAvailability: false,
      ),
    ),
  );

  if (selectedDevice != null) {
    print('Selected device: ${selectedDevice.address}');

    try {
      BluetoothConnection.toAddress(selectedDevice.address).then((conn) {
        print('✅ Connected to device at ${selectedDevice.address}');
        connection = conn;

        // You can update state/UI if needed
        setState(() {
          _isConnected = true;  // assuming you have this flag
        });

        // Optionally listen to incoming data
        connection!.input!.listen((data) {
          print('🔄 Received: ${ascii.decode(data)}');
        });
      }).catchError((error) {
        print('❌ Failed to connect: $error');
      });
    } catch (e) {
      print('❌ Connection error: $e');
    }
  }
}

  // Fetches gait data from the ESP32 device via Bluetooth.
void _fetchGaitDataFromESP32() async {
  try {
    
    // For example, you might have a Stream<List<int>> or BluetoothConnection object

    // Read a line or some bytes from the socket (example with BluetoothConnection from flutter_bluetooth_serial)
    if (_connection != null && _connection!.isConnected) {
      String dataString = await _connection!.input!.first
          .then((bytes) => utf8.decode(bytes));

      // Or if you read line by line:
      // String dataString = await bluetoothConnection.input!.transform(utf8.decoder).transform(LineSplitter()).first;

      // Parse the values
      final parts = dataString.split(',');

      if (parts.length >= 3) {
        double speed = double.parse(parts[0]);
        double cadence = double.parse(parts[1]);
        String gaitStatus = parts[2].trim();

        // Now you can use the data
        print('Speed: $speed');
        print('Cadence: $cadence');
        print('Gait Status: $gaitStatus');

        // Update your UI or variables here
        setState(() {
          _speed = speed;
          _cadence = cadence;
          _gaitStatus = gaitStatus;
        });

      } else {
        print('Invalid data format: $dataString');
      }
    }
  } catch (e) {
    print('Failed to fetch gait data: $e');
  }
}
// opens the device's contacts list to select a contact
Future<void> pickContact() async {
  try {
    if (!await flutter_contact.FlutterContacts.requestPermission()) {
      print('Permission denied');
      return;
    }

    final contact = await flutter_contact.FlutterContacts.openExternalPick();

    if (contact != null && contact.phones.isNotEmpty) {
      _emergencyContact = contact; // Save for later
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected: ${contact.displayName} as emergency contact'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No valid contact selected'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (e) {
    print('Error picking contact: $e');
  }
}

//sends an SMS with the current location in emergency situations
void onBluetoothDataReceived(String data) async {
  if (data.trim() == 'Fell') {
    if (_emergencyContact == null || _emergencyContact!.phones.isEmpty) {
      print('No emergency contact set or no phone number found.');
      return;
    }

    final pos = await getCurrentLocation(); // Your existing function
    if (pos == null) {
      print('Could not get location.');
      return;
    }

    final number = _emergencyContact!.phones.first.number;
    final message = 'Emergency! The walker has fallen.\nLocation: https://maps.google.com/?q=${pos.latitude},${pos.longitude}';

    
    print('Emergency SMS sent to $number');
  }
}


/// Builds a small colored circle indicating Bluetooth connection status.
  Widget _buildConnectionIndicator() {
    return CircleAvatar(
      radius: 12,
      backgroundColor: _isConnected ? Colors.green : Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ensures white background
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
class CalculateGaitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CalculateGaitButton({Key? key, required this.onPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: const Color.fromRGBO(148, 144, 238, 1),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: const Text('Calculate Gait'),
      ),
    );
  }
}
