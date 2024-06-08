import 'package:flutter/material.dart';
import 'package:waterspring/theme.dart';
import 'package:waterspring/widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // HEADER
    Widget header() {
      return Center(
        child: Container(
          margin: const EdgeInsets.only(top: 70),
          width: 160,
          height: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 128,
                height: 122,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/icons/icon.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                '- Rekam Medis Terintegrasi -',
                style: darkGreenTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                ),
              )
            ],
          ),
        ),
      );
    }

    // TEXT
    Widget welcome() {
      return Container(
        margin: const EdgeInsets.only(top: 142),
        child: Column(
          children: [
            Text(
              'Selamat Datang!',
              style: primaryTextStyle.copyWith(
                fontSize: 24,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Silahkan Login \nuntuk menggunakan aplikasi Med-OID',
              style: primaryTextStyle.copyWith(
                fontSize: 12,
                fontWeight: regular,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // BUTTON LOGIN
    Widget buttonLogin() {
      return Container(
        margin: const EdgeInsets.only(top: 50),
        child: CustomButton(
          text: 'Masuk',
          color: secondaryTextColor,
          press: () => Navigator.pushNamed(context, '/login'),
        ),
      );
    }

    // BUTTON REGISTER
    Widget buttonRegister() {
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: CustomButton(
          text: 'Registrasi',
          color: primaryColor,
          press: () => Navigator.pushNamed(context, '/register'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgorundColor,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                header(),
                welcome(),
                buttonLogin(),
                buttonRegister(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
