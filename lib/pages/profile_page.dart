import 'package:capcynfoods/components.dart';
import 'package:capcynfoods/services/presence_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';
import 'export_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // auth services
  final authService = AuthService();

  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [IconButton(onPressed: logout, icon: const Icon(Icons.logout))],
      ),
      drawer: Drawer(
          child: ListView(
        children: [
          DrawerHeader(
            child: Text('Capcynfoods Absensi'),
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Recap'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExportDataPage(),
              ),
            ),
          ),
        ],
      )),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
        children: [
          Text(
            "Hello,",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          Text(
            authService.getCurrentUserName() ?? "",
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          CardPresence(),
          SizedBox(height: 20.0),
          CardHistory(),
        ],
      ),
    );
  }
}

class CardPresence extends StatefulWidget {
  const CardPresence({super.key});

  @override
  State<CardPresence> createState() => _CardPresenceState();
}

class _CardPresenceState extends State<CardPresence> {
  final presenceService = PresenceService();
  late Future<Map<String, dynamic>> historyToday;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    setState(() {
      historyToday = presenceService.getHistoryToday();
    });
  }

  void checkIn() async {
    await presenceService.signIn();
    refreshData();
  }

  void leave() async {
    await presenceService.signOut();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFedf4fc),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Absen hari ini'), CustomDateTimeNow()],
          ),
          const SizedBox(height: 15.0),
          FutureBuilder<Map<String, dynamic>>(
            future: historyToday,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              final presenceData = snapshot.data ?? {};
              final startTime = presenceData['start'];
              final endTime = presenceData['end'];
              print("presenceData is : $presenceData");
              print("startTime is : $startTime");
              print("endTime is : $endTime");

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        startTime != null ? DateFormat('HH:mm').format(DateTime.parse(startTime)) : '--:--',
                        style: const TextStyle(fontSize: 30.0),
                      ),
                      const Text(' - ', style: TextStyle(fontSize: 30.0)),
                      Text(
                        endTime != null ? DateFormat('HH:mm').format(DateTime.parse(endTime)) : '--:--',
                        style: const TextStyle(fontSize: 30.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: startTime == null ? checkIn : leave,
                      child: Text(
                        startTime == null ? 'Masuk' : 'Pulang',
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: startTime == null ? Color(0xFF8a4af3) : Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class CardHistory extends StatefulWidget {
  const CardHistory({super.key});

  @override
  State<CardHistory> createState() => _CardHistoryState();
}

class _CardHistoryState extends State<CardHistory> {
  final authService = AuthService();

  late final Stream<List<Map<String, dynamic>>> _historyStream;

  @override
  void initState() {
    super.initState();
    _historyStream = Supabase.instance.client
        .from('presences')
        .stream(primaryKey: ['id'])
        .eq('user_id', authService.getCurrentUserId() ?? '');
  }
  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riwayat Absensi',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          StreamBuilder(
            stream: _historyStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final presences = snapshot.data as List<Map<String, dynamic>>;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: presences.length,
                itemBuilder: (context, index) {
                  String startTime =
                      presences[index]['start'] != null ? DateFormat('HH:mm').format(DateTime.parse(presences[index]['start'])) : '--:--';
                  String endTime = presences[index]['end'] != null ? DateFormat('HH:mm').format(DateTime.parse(presences[index]['end'])) : '--:--';
                  DateTime date = DateTime.parse(presences[index]['date']);

                  return Container(
                    width: fullWidth,
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xFFedf4fc),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDateTimeNow(
                          dateTime: date,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.login, color: Color(0xFF8a4af3)),
                                  SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [Text('Mulai'), SizedBox(height: 10.0), Text(startTime)],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.logout, color: Colors.red),
                                  SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [Text('Selesai'), SizedBox(height: 10.0), Text(endTime)],
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
