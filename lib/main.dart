import 'dart:math';

import 'package:dishes/core/constant/global_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'feature/home/view/home_page.dart';
import 'feature/login/view/loginScreen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dishes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key,});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Future<void> generateRandomNumber() async {
    final SharedPreferences local=await SharedPreferences.getInstance();

    final list=local.getStringList("wishlist");
    ref.read(wishlistItems.notifier).update((state) =>list??[] );
    final random = Random();
    const int min = 0; // Change this to your minimum number
    const int max = 4;
    int  randomNumber = min + random.nextInt(max - min + 1);
    ref.read(randomIndexProvider.notifier).update((state) =>randomNumber );
    // Change this to your maximum number

  }
getUser() async {
  final SharedPreferences local=await SharedPreferences.getInstance();
  final email=local.get("email");

  if(email!=null){
    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => HomePage(),), (route) => false);

  }
  else{
    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => LoginScreen(),), (route) => false);
  }
}
@override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      generateRandomNumber();
    });
Future.delayed(const Duration(seconds: 2)).then((value) {
  getUser();
});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;

    return Scaffold(

      body: Center(
        child: SizedBox(
          width: width*0.8,
            height:height*0.5,
            child: Image.asset("assets/dishes_logo.png")),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
