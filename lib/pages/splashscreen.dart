import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterspring/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    cekLogin();
    super.initState();

    // SET PROVIDER
    // Provider.of<ArticleProvider>(context, listen: false).getArticles();
    // Provider.of<SampahProvider>(context, listen: false).getSampah();
    // Provider.of<SliderProvider>(context, listen: false).getSliders();
  }

  cekLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool islogin = prefs.getBool('isLogin') ?? false;
    //islogin = true;
    // Get user Data
    if (islogin == true) {
      // await Provider.of<AuthProvider>(context, listen: false).getUser(token);
      //prefs = await SharedPreferences.getInstance();
      //islogin = prefs.getBool('isLogin') ?? false;
    }

    islogin
        ? Navigator.pushNamed(context, '/main')
        : Navigator.pushNamed(context, '/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgorundColor,
      body: Center(
        child: SizedBox(
          width: 160,
          height: 200,
          child: Image.asset('assets/icons/icon.png'),
        ),
      ),
    );
  }
}
