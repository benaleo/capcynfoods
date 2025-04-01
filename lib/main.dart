import 'package:capcynfoods/auth/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'notes-page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://qhgsyeolpmyakbjdfdvk.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoZ3N5ZW9scG15YWtiamRmZHZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM0MzUzMDksImV4cCI6MjA1OTAxMTMwOX0.GvmAfZq06xxmhy1DHyXJQ2pK5VOoDVRjyuIdiUPqD88",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
