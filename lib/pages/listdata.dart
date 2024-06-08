import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:waterspring/theme.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController textController;
  double currentPageValue = 0;
  PageController controller = PageController();
  bool isLoading = false;
  late LatLng _current = LatLng(-8.183052, 115.120491);
  final polygons = <Polygon>[];
  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    //Provider.of<PatientProvider>(context, listen: false).getPatient(1,"",1  );
    // Provider.of<PatientProvider>(context, listen: false).getPatient(0,"",1);
    // controller.addListener(() {
    //   setState(() {
    //     currentPageValue = controller.page!;
    //     print(currentPageValue);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Widget header() {
      return Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 30),
            width: MediaQuery.of(context).size.width,
            height: height * 0.34,
            decoration: const BoxDecoration(
              color: Color(0xFF4B39EF),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                  child: Text(
                    'Find Your Field',
                    style: whiteTextStyle.copyWith(
                      fontSize: 24,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                  child: Text(
                    'Easy Field Management',
                    style: whiteTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: regular,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 0),
                        child: TextFormField(
                          controller: textController,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Search name or field...',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            filled: true,
                            fillColor: const Color(0x4BFFFFFF),
                            contentPadding:
                                const EdgeInsetsDirectional.fromSTEB(
                                    16, 20, 16, 20),
                            prefixIcon: Icon(
                              Icons.search,
                              color: tertiaryColor,
                              size: 16,
                            ),
                            suffixIcon: Icon(
                              Icons.filter_list_outlined,
                              color: tertiaryColor,
                              size: 22,
                            ),
                          ),
                          style: whiteTextStyle.copyWith(
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: height * 0.30,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: backgorundColor,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      );
    }

    Widget _body() {
      return FlutterMap(
        options: MapOptions(
          center: _current,
          zoom: 13,
          // interactiveFlags: InteractiveFlag.doubleTapZoom,
        ),
        children: [
          TileLayer(
            urlTemplate: 'http://{s}.google.com/vt?lyrs=s,h&x={x}&y={y}&z={z}',
            subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
          ),
          PolygonLayer(polygons: polygons),
          MarkerLayer(
            rotate: false,
            anchorPos: AnchorPos.align(AnchorAlign.top),
            markers: [
              Marker(
                point: _current,
                builder: (ctx) => const Icon(Icons.pin, size: 60),
                width: 60,
                height: 60,
              ),
            ],
          )
        ],
      );
    }

    Widget content() {
      return Container(
        margin: const EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: Container(
          child: _body(),
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgorundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [header(), content()],
        ),
      ),
    );
  }
}
