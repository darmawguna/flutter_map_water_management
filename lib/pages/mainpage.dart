import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:waterspring/pages/addPoly.dart';
import 'package:waterspring/pages/home.dart';
import 'package:waterspring/pages/listpoly.dart';
import 'package:waterspring/pages/samplepopupmarker.dart';
import 'package:waterspring/pages/slidingUP.dart';
import 'package:waterspring/pages/weather.dart';
import 'package:waterspring/providers/pageprovider.dart';
import 'package:waterspring/theme.dart';

class MainScreen extends StatefulWidget {
  final int pageIndex;
  const MainScreen({Key? key, this.pageIndex = 0}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  bool isDokter = true;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // PAGE PROVIDER
    PageProvider pageProvider = Provider.of<PageProvider>(context);

    setState(() {
      // SET TUGAS
      // if (perjalananProvider.perjalanan.length > 0) {
      //   if (perjalananProvider.perjalanan.first.status == 'DIKERJAKAN') {
      //     isTugas = true;
      //     if (perjalananProvider.perjalanan.first.waktuSelesai != null) {
      //       isTugas = false;
      //     }
      //   }
      // }

      currentIndex = widget.pageIndex;
    });

    // FLOATING BUTTON SAMPAH
    Widget addButton() {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPoly(),
            ),
          );
        },
        child: Icon(Icons.location_on),
      );
    }

    // CUSTOM BUTTON NAVBAR
    Widget customBottomNav() {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 12,
          clipBehavior: Clip.antiAlias,
          child: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              backgroundColor: whiteColor,
              currentIndex: pageProvider.currentIndex,
              onTap: (value) {
                if (value != 2) {
                  setState(() {
                    pageProvider.currentIndex = value;
                  });
                }
              },
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Icon(Icons.home),
                  ),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Icon(Icons.map_sharp),
                  ),
                  label: 'Maps',
                ),
                const BottomNavigationBarItem(
                  icon: SizedBox(),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Icon(Icons.radar),
                  ),
                  label: 'Weather',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/icon_profile.svg',
                      width: 18,
                      color: pageProvider.currentIndex == 4
                          ? primaryColor
                          : const Color(0xFF728196),
                    ),
                  ),
                  label: 'Profile',
                ),
              ],
              selectedItemColor: primaryColor,
              selectedLabelStyle: greenTextStyle.copyWith(fontSize: 13),
              unselectedLabelStyle: secondaryTextStyle.copyWith(fontSize: 12),
            ),
          ),
        ),
      );
    }

    // SCREEN
    Widget body() {
      switch (pageProvider.currentIndex) {
        case 0:
          return const HomePage();
        case 1:
          return const ListPolyPage();
        case 3:
          return const WeatherApp();
        case 4:
          return const PopupPage();
        default:
          return const SlidingUP();
      }
    }

    return Scaffold(
      backgroundColor: backgorundColor,
      floatingActionButton: addButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: customBottomNav(),
      body: body(),
    );
  }
}
