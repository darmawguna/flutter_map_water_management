import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:waterspring/theme.dart';
import 'package:waterspring/widgets/monument.dart';

class ListPolyPage extends StatefulWidget {
  const ListPolyPage({super.key});

  @override
  State<ListPolyPage> createState() => _ListPolyPageState();
}

class _ListPolyPageState extends State<ListPolyPage> {
  final PopupController _popupLayerController = PopupController();
  late LatLng _current = LatLng(-8.1703565592498, 115.1179992895023);
  final polygons = <Polygon>[
    Polygon(
      points: [
        LatLng(-8.1703565592498, 115.1179992895023),
        LatLng(-8.17077604654896, 115.1182514171497),
        LatLng(-8.170999064933525, 115.11902925776401),
        LatLng(-8.17057426790314, 115.11912045287052),
        LatLng(-8.170637987486518, 115.11963007258335),
        LatLng(-8.170149470420554, 115.11969981001774),
        LatLng(-8.16969281262245, 115.11849818037906),
        LatLng(-8.1703565592498, 115.1179992895023)
      ],
      color: Colors.orange.withOpacity(0.2),
      isFilled: true,
      label: 'Pemukiman',
      borderStrokeWidth: 1,
      borderColor: secondaryColor,
    ),
    Polygon(
        points: [
          LatLng(-8.18793392783054, 115.12127778748723),
          LatLng(-8.182581679523016, 115.13406656007024),
          LatLng(-8.176889527041691, 115.1296462796137),
          LatLng(-8.17795150195569, 115.12599847535344),
          LatLng(-8.180627666192226, 115.11930368165227),
          LatLng(-8.183856030880813, 115.11831662873479),
          LatLng(-8.18793392783054, 115.12127778748723),
        ],
        color: Colors.green.shade900.withOpacity(0.2),
        isFilled: true,
        label: 'Hutan Desa',
        borderStrokeWidth: 1,
        borderColor: secondaryColor),
    Polygon(
        points: [
          LatLng(-8.166867894630865, 115.11755404280582),
          LatLng(-8.168014856226092, 115.11856255339542),
          LatLng(-8.167016575023544, 115.11977491187015),
          LatLng(-8.165827130331792, 115.11866984175602),
          LatLng(-8.166867894630865, 115.11755404280582)
        ],
        color: Colors.greenAccent.withOpacity(0.2),
        isFilled: true,
        label: 'Sawah',
        borderStrokeWidth: 1,
        borderColor: secondaryColor)
  ];
  final testPolygon = Polygon(
      color: Colors.deepOrange,
      points: [],
      borderStrokeWidth: 2,
      borderColor: secondaryColor);
  @override
  void initState() {
    // TODO: implement initState
    polygons.add(testPolygon);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Theme(
        data: Theme.of(context)
            .copyWith(colorScheme: ColorScheme.light(primary: primaryColor)),
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            //the SlidingUpPanel Title
            _body(),
            Positioned(
              top: 50.0,
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Search Your Location",
                            prefixIcon: Icon(Icons.search),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Marker buildPin(LatLng point) => Marker(
        point: point,
        builder: (ctx) => const Icon(Icons.water_drop,
            size: 30, color: Colors.blueAccent, semanticLabel: 'gatep Lawas'),
        width: 60,
        height: 60,
      );
  Widget _body() {
    return FlutterMap(
      options: MapOptions(
        center: _current,
        zoom: 16,
        // interactiveFlags: InteractiveFlag.doubleTapZoom,
      ),
      children: [
        TileLayer(
          urlTemplate: 'http://{s}.google.com/vt?lyrs=s,h&x={x}&y={y}&z={z}',
          subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
        ),
        PolygonLayer(polygons: polygons),
        PopupMarkerLayer(
          options: PopupMarkerLayerOptions(
            markers: <Marker>[
              MonumentMarker(
                monument: Monument(
                  name: 'Gde Jaya Art Shop',
                  type: 1,
                  imagePath:
                      'https://c8.alamy.com/comp/2B13YCK/art-shop-gallery-hoi-an-vietnam-2B13YCK.jpg',
                  lat: -8.170056887240605,
                  long: 115.11959019883973,
                ),
              ),
              MonumentMarker(
                monument: Monument(
                  name: 'Kolam Renang Jembong',
                  type: 1,
                  imagePath:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2r6x3zOTjKpcVJXiH1-Ykg5TJvAy6fPReVPa3oSf-i_YzotJsxrZKInC8yxYzyoIKB8w&usqp=CAU',
                  lat: -8.188313781066519,
                  long: 115.11724788158917,
                ),
              ),
              MonumentMarker(
                monument: Monument(
                  name: 'Pandawa',
                  type: 1,
                  imagePath:
                      'https://i.ytimg.com/vi/7B9z2ey2UE8/maxresdefault.jpg',
                  lat: -8.178866544196348,
                  long: 115.12330982486891,
                ),
              ),
              MonumentMarker(
                monument: Monument(
                  name: 'Gatep Lawas',
                  type: 1,
                  imagePath:
                      'https://awsimages.detik.net.id/community/media/visual/2022/06/05/obyek-wisata-gatep-lawas-di-banjar-pebantenan-desa-ambengan-kecamatan-sukasada-kabupaten-buleleng-bali.jpeg?w=1200',
                  lat: -8.189768557872902,
                  long: 115.11345148544191,
                ),
              ),
            ],
            popupController: _popupLayerController,
            popupDisplayOptions: PopupDisplayOptions(
              builder: (_, Marker marker) {
                if (marker is MonumentMarker) {
                  return MonumentMarkerPopup(monument: marker.monument);
                }
                return const Card(child: Text('Not a 2vbmonument'));
              },
            ),
          ),
        ),
        MarkerLayer(
          rotate: false,
          anchorPos: AnchorPos.align(AnchorAlign.top),
          markers: [
            Marker(
              point: _current,
              builder: (ctx) => const Icon(
                Icons.location_on,
                size: 60,
              ),
            ),
          ],
        )
      ],
    );
  }
}
