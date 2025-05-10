import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  int _selectedIndex = 0;

  List<Widget> _pages() => [
    Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text('Home', style: TextStyle(fontSize: 32)),
            new CircularPercentIndicator(
              radius: 150.0,
              lineWidth: 25.0,
              percent: 0.7,
              center: new Text("whatever it is"),
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
                CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 8.0,
                  percent: 0.4,
                  center: const Text(
                    "Speed",
                    style: TextStyle(
                      color: const Color.fromRGBO(76, 175, 80, 1),
                    ),
                  ),

                  progressColor: const Color.fromRGBO(76, 175, 80, 1),
                ),

                CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 8.0,
                  percent: 0.9,
                  center: const Text(
                    "Stability",
                    style: TextStyle(
                      color: const Color.fromRGBO(255, 152, 0, 1),
                    ),
                  ),
                  progressColor: const Color.fromRGBO(255, 152, 0, 1),
                ),
              ],
            ),

            const SizedBox(height: 19),

            const Spacer(),
            CalculateGaitButton(
              onPressed: () {
                print('Calculate Gait pressed!');
              },
            ),
          ],
        ),
      ),
    ),
    const Center(child: Text('History', style: TextStyle(fontSize: 32))),
    const Center(child: Text('Settings', style: TextStyle(fontSize: 32))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ensures white background
      body: _pages()[_selectedIndex],
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
