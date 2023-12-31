import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:my_tiffin/asistantMethods/address_changer.dart';
import 'package:my_tiffin/asistantMethods/cartItemCounter.dart';
import 'package:my_tiffin/asistantMethods/totalAmount.dart';
import 'package:my_tiffin/globalVariables/globleVariable.dart';
import 'package:my_tiffin/splashScreen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();

  runApp(
    KhaltiScope(
      enabledDebugging: true,
      publicKey: 'test_public_key_979cdfa49afe44d7be57b5f2e1e11335',
      builder: (context, navigatorKey) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<Menu>(create: (_) => Menu()),
            ChangeNotifierProvider(create: (c) => CartItemCounter()),
            ChangeNotifierProvider(create: (c) => TotalAmount()),
            ChangeNotifierProvider(create: (c) => AddressChanger()),
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            localizationsDelegates: const[
              KhaltiLocalizations.delegate
            ],
            title: 'Staff App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const MySplashScreen(),
          ),
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Menu>(create: (_) => Menu()),
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
      ],
      child: MaterialApp(
        title: 'Staff App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MySplashScreen(),
      ),
    );
  }
}