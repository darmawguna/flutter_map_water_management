import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingUP extends StatefulWidget {
  const SlidingUP({super.key});

  @override
  State<SlidingUP> createState() => _SlidingUPState();
}

class _SlidingUPState extends State<SlidingUP> {
  final mapController = MapController();
  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  final double _panelHeightClosed = 95.0;
  late String latitude;
  late String longitude;
  late PolyEditor polyEditor;
  late LatLng _current = const LatLng(13.535932, 100.939911);
  late LatLng _selected = const LatLng(13.535932, 100.939911);
  final polygons = <Polygon>[];
  final testPolygon = Polygon(
    color: Colors.deepOrange,
    isFilled: true,
    points: [],
  );
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  final PanelController _pc = PanelController();
  @override
  void initState() {
    super.initState();
    polyEditor = PolyEditor(
      addClosePathMarker: true,
      points: testPolygon.points,
      pointIcon: const Icon(Icons.crop_square, size: 23),
      intermediateIcon: const Icon(Icons.lens, size: 15, color: Colors.grey),
      callbackRefresh: () => {setState(() {})},
    );
    polygons.add(testPolygon);
    _fabHeight = _initFabHeight;
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, display an error message.
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Location Services Disabled'),
            content: const Text('Please enable location services.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, display an error message.
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Location Permissions Denied'),
              content: const Text(
                  'Please grant location permissions to access your current location.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, display an error message.
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Location Permissions Denied Forever'),
            content: const Text(
                'Location permissions are permanently denied. Please enable them in your device settings.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // Permissions are granted, get the current position.
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      // latitude = position.latitude.toString();
      _current = LatLng(position.latitude, position.longitude);
      // print(_current.latitude.toString());
      // longitude = position.longitude.toString();
      // position.
    });

    // updatePlacemark(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;

    return Material(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            controller: _pc,
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: _body(),
            panelBuilder: (sc) => _panel(sc),
            collapsed: Container(
              padding: const EdgeInsets.all(5),
              color: Theme.of(context).primaryColorLight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16, left: 8.0),
                    child: Column(
                      children: [
                        Text(
                          "Wide of AOI",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("829.8 Ha")
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: ElevatedButton(
                            onPressed: () {},
                            child: const Row(
                              children: [
                                Icon(Icons.clear),
                                Text("Clear"),
                              ],
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              _pc.open();
                            },
                            child: const Row(
                              children: [Icon(Icons.forward), Text("Next")],
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
            // defaultPanelState: PanelState.CLOSED,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
            }),
          ),

          // the fab
          Positioned(
            right: 20.0,
            bottom: _fabHeight,
            child: FloatingActionButton(
              onPressed: () {
                _getCurrentLocation();
              },
              backgroundColor: Colors.white,
              child: Icon(
                Icons.gps_fixed,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),

          Positioned(
              top: 0,
              child: ClipRRect(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).padding.top,
                        color: Colors.transparent,
                      )))),

          //the SlidingUpPanel Title
          Positioned(
            top: 52.0,
            child: Container(
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
                          hintText: "Search Your Looking For",
                          prefixIcon: Icon(Icons.search),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.lightBlueAccent,
                      child: Icon(
                        Icons.sort_by_alpha_sharp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        child: Container(
          child: Stepper(
            type: StepperType.horizontal,
            physics: const ScrollPhysics(),
            currentStep: _currentStep,
            onStepTapped: (step) => tapped(step),
            onStepContinue: continued,
            onStepCancel: cancel,
            steps: <Step>[
              Step(
                title: const Text('Area of Interest'),
                // subtitle: Text('Polygonal Area'),
                content: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Coordinates Point',
                          suffixIcon: Icon(Icons.map_outlined)),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Address',
                          suffixIcon: Icon(Icons.maps_home_work)),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Wide Area',
                          suffixIcon: Icon(Icons.square_foot)),
                    ),
                  ],
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 0 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: const Text('Characteristic'),
                content: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Land Use type'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Ownership'),
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Status Area'),
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Photo'),
                    ),
                  ],
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 1 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: const Text('Drought'),
                // subtitle: Text('VHI & Rainfall'),
                content: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Mobile Number'),
                    ),
                  ],
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 2 ? StepState.complete : StepState.disabled,
              ),
            ],
          ),
        ));
  }

  Widget _button(String label, IconData icon, Color color) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.15),
                  blurRadius: 8.0,
                )
              ]),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Text(label),
      ],
    );
  }

  Widget _body() {
    return FlutterMap(
      options: MapOptions(
          center: _current,
          zoom: 13,
          onTap: (_, ll) {
            polyEditor.add(testPolygon.points, ll);
          },
          onLongPress: (_, p) {
            setState(() {
              _selected = LatLng(p.latitude, p.longitude);
            });
          }
          // interactiveFlags: InteractiveFlag.doubleTapZoom,
          ),
      children: [
        TileLayer(
          urlTemplate: 'http://{s}.google.com/vt?lyrs=s,h&x={x}&y={y}&z={z}',
          subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
        ),
        PolygonLayer(polygons: polygons),
        DragMarkers(markers: polyEditor.edit()),
        MarkerLayer(
          rotate: false,
          anchorPos: AnchorPos.align(AnchorAlign.top),
          markers: [
            Marker(
              point: _selected,
              builder: (ctx) => const Icon(Icons.location_pin, size: 60),
              width: 60,
              height: 60,
            ),
          ],
        )
      ],
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
