import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as flutter_contact;
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home.dart';

void main() {
  runApp(const MaterialApp(home: WhatsAppSenderPage(),
  debugShowCheckedModeBanner: false,
  ));
}

class WhatsAppSenderPage extends StatefulWidget {
  const WhatsAppSenderPage({Key? key}) : super(key: key);

  @override
  State<WhatsAppSenderPage> createState() => _WhatsAppSenderPageState();
}

class _WhatsAppSenderPageState extends State<WhatsAppSenderPage> {
  flutter_contact.Contact? _selectedContact;
  String? _selectedPhoneNumber;

  Future<void> pickContact() async {
  try {
    if (!await flutter_contact.FlutterContacts.requestPermission()) {
      print('Permission denied');
      return;
    }

    final contact = await flutter_contact.FlutterContacts.openExternalPick();

    if (contact != null && contact.phones.isNotEmpty) {
      setState(() {
        _selectedContact = contact;
        _selectedPhoneNumber = contact.phones.first.number;
      });
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

  String _sanitizePhoneNumber(String number) {
    String phone = number.replaceAll(RegExp(r'\D'), '');
    if (phone.startsWith('00')) {
      phone = phone.substring(2);
    } else if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }
    return phone;
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _sendWhatsApp() async {
    if (_selectedPhoneNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick a contact first")),
      );
      return;
    }

    String phone = _sanitizePhoneNumber(_selectedPhoneNumber!);

    final pos = await _getCurrentLocation();
    String locationText = '';
    if (pos != null) {
      locationText =
          "\nLocation: https://maps.google.com/?q=${pos.latitude},${pos.longitude}";
    }

    final message = Uri.encodeComponent("Hello from Flutter!$locationText");
    final url = Uri.parse("https://wa.me/$phone?text=$message");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch WhatsApp")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WhatsApp Sender')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickContact,
              child: const Text('Pick Contact'),
            ),
            if (_selectedContact != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Selected: ${_selectedContact!.displayName}\n${_selectedPhoneNumber ?? ""}',
                  textAlign: TextAlign.center,
                ),
              ),
            ElevatedButton(
              onPressed: _sendWhatsApp,
              child: const Text('Send WhatsApp'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}