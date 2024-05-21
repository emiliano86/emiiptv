import 'package:emiiptv/page/Link_page.dart';
import 'package:emiiptv/page/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(

    url: 'xxxxx',
    anonKey: 'xxxxxxxxxxxxxxxxxxxxxxxxxx',
  );
  WidgetsFlutterBinding.ensureInitialized();
  Pref.sharedPreferences=await SharedPreferences.getInstance();
  runApp(MyApp());
}

class Pref {
  static SharedPreferences? sharedPreferences;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet,
          Intent>{

        LogicalKeySet(LogicalKeyboardKey.select):const ActivateIntent(),







      },
      child:MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(


          primarySwatch: Colors.blue,
        ),
        home: Login(),
      ),
    );
  }
}

