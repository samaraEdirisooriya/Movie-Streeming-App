import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fvp/fvp.dart' as fvp;
import 'package:movie/Bottombar.dart';
void main() {

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
       return  const MaterialApp(
      title: 'Flutter Demo',
      home:BottomNavigation(),
    );
  }
}