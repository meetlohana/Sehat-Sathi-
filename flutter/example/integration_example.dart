// EXAMPLE ONLY - shows the 3 small edits to an existing app.
// Your real HomeScreen / AppointmentScreen etc. stay as they are.
import 'package:flutter/material.dart';
import '../lib/voice_guide/voice_guide.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // EDIT 1: initialise once. Map the voice module to YOUR route names.
  VoiceGuide.init(
    navigatorKey: navigatorKey,
    routes: const VoiceRoutes(
      home: '/home',
      appointment: '/appointment',
      appointments: '/my-appointments',
      records: '/health-records',
      referral: '/referral',
      medicines: '/medicines',
      consultation: '/consultation',
      emergency: '/emergency',
    ),
    // Return the JWT your login code already stores:
    tokenProvider: () async => null, // e.g. () => AuthStorage.readToken()
    patientIdProvider: () async => null, // e.g. () => AuthStorage.patientId()
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: navigatorKey, // EDIT 2a: your app must expose a navigatorKey
        navigatorObservers: [VoiceGuide.routeObserver], // EDIT 2b: screen awareness
        initialRoute: '/home',
        routes: {
          '/home': (_) => const HomeScreen(),
          '/appointment': (_) => const AppointmentScreen(),
          // ... your other existing routes
        },
      );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => VoiceGuide.greet()); // optional welcome
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Sehat Sathi')),
        body: const Center(child: Text('Your existing home screen')),
        floatingActionButton: const VoiceGuideButton(), // EDIT 3: add the button
      );
}

/// Demo of step-by-step guidance. In your REAL AppointmentScreen add only the
/// VoiceGuide.reportStep(...) lines at the places marked below.
class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});
  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String? doctor, date, time;

  @override
  void initState() {
    super.initState();
    VoiceGuide.reportStep('doctor_selection'); // patient is choosing a doctor
  }

  void _book() {
    // call your real booking API here
    VoiceGuide.reportStep('done'); // -> "Appointment successfully book ho gayi hai."
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Doctor Appointment')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          ListTile(
            title: const Text('Dr. Sharma'),
            onTap: () {
              setState(() => doctor = 'Dr. Sharma');
              VoiceGuide.reportStep('date_selection');
            },
          ),
          ListTile(
            title: const Text('5 October'),
            onTap: () {
              setState(() => date = '5 Oct');
              VoiceGuide.reportStep('time_selection');
            },
          ),
          ListTile(
            title: const Text('10:30 AM'),
            onTap: () {
              setState(() => time = '10:30');
              VoiceGuide.reportStep('confirm');
            },
          ),
          ElevatedButton(
            onPressed: () => VoiceGuide.confirm('Appointment confirm kar doon?', _book),
            child: const Text('Confirm Appointment'),
          ),
        ]),
        floatingActionButton: const VoiceGuideButton(),
      );
}
