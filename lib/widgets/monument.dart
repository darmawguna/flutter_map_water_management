import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class Monument {
  static const double size = 25;

  Monument({
    required this.name,
    required this.type,
    required this.imagePath,
    required this.lat,
    required this.long,
  });

  final String name;
  final int type;
  final String imagePath;
  final double lat;
  final double long;
}

class MonumentMarker extends Marker {
  MonumentMarker({required this.monument})
      : super(
          rotateAlignment: Alignment.topCenter,
          height: Monument.size,
          width: Monument.size,
          point: LatLng(monument.lat, monument.long),
          builder: (ctx) => const Icon(
            Icons.place_rounded,
            color: Colors.greenAccent,
          ),
        );

  final Monument monument;
}

class MonumentMarkerPopup extends StatelessWidget {
  const MonumentMarkerPopup({super.key, required this.monument});
  final Monument monument;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.network(monument.imagePath, width: 250),
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Text(monument.name),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/hujan.png',
                            width: 20,
                            height: 20,
                          ),
                          const Text(
                            '20% Rain',
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/angin.png',
                            width: 20,
                            height: 20,
                          ),
                          const Text('8 km/h', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/angin.png',
                            width: 20,
                            height: 20,
                          ),
                          const Text('30°C', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Image.asset('assets/images/vci.png')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
