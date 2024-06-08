import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:waterspring/services/function.dart';
// import 'package:turf/area.dart';
import 'package:waterspring/theme.dart';

class AddPoly extends StatefulWidget {
  const AddPoly({super.key});

  @override
  State<AddPoly> createState() => _AddPolyState();
}

class LuType {
  final int id;
  final String name;

  LuType({
    required this.id,
    required this.name,
  });
}

class _AddPolyState extends State<AddPoly> {
  final mapController = MapController();
  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 95.0;
  double _widePoly = 0;
  late String latitude;
  late String longitude;
  late PolyEditor polyEditor;
  late LatLng _current = LatLng(13.535932, 100.939911);
  late LatLng _selected = LatLng(13.535932, 100.939911);
  int _access = 0;
  TextEditingController _currentLoc = TextEditingController();
  TextEditingController _currentAddress = TextEditingController();
  TextEditingController _wide = TextEditingController();
  static List<LuType> _types = [
    LuType(id: 1, name: "Paddy"),
    LuType(id: 2, name: "Cassava"),
    LuType(id: 3, name: "Corn"),
    LuType(id: 4, name: "Sugarcane"),
    LuType(id: 5, name: "Watershed"),
    LuType(id: 6, name: "Reservoir"),
    LuType(id: 7, name: "Lake"),
    LuType(id: 8, name: "Water Spring"),
    LuType(id: 9, name: "Water Fall"),
    LuType(id: 10, name: "Forest"),
    LuType(id: 11, name: "Park"),
    LuType(id: 12, name: "Art Shop"),
    LuType(id: 13, name: "Retail"),
    LuType(id: 14, name: "Public Places"),
  ];

  final _items =
      _types.map((type) => MultiSelectItem<LuType>(type, type.name)).toList();
  List<LuType> _selectType = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();
  final polygons = <Polygon>[];
  // List<String> _wlevel = <String>['A', 'B', 'C'];
  final testPolygon = Polygon(
      color: Colors.deepOrange,
      points: [],
      borderStrokeWidth: 2,
      borderColor: secondaryColor);
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  PanelController _pc = new PanelController();
  @override
  void initState() {
    super.initState();
    polyEditor = PolyEditor(
      addClosePathMarker: true,
      points: testPolygon.points,
      pointIcon: Icon(
        Icons.crop_square,
        size: 23,
        color: tertiaryColor,
      ),
      intermediateIcon: const Icon(Icons.lens, size: 15, color: Colors.grey),
      callbackRefresh: () => {
        setState(() {
          _widePoly = calculatePolygonArea(testPolygon.points);
          _widePoly = double.parse((_widePoly).toStringAsFixed(2));
          _wide = TextEditingController(text: _widePoly.toString());
        })
      },
    );
    polygons.add(testPolygon);
    _fabHeight = _initFabHeight;
    _getCurrentLocation();
    _currentLoc = TextEditingController(
        text: _selected.latitude.toString() +
            ',' +
            _selected.longitude.toString());
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
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _current = LatLng(position.latitude, position.longitude);
      _getAddressFromLatLng(position.latitude, position.longitude);
    });

    // updatePlacemark(position.latitude, position.longitude);
  }

  Future<void> _getAddressFromLatLng(latitude, longitude) async {
    await placemarkFromCoordinates(latitude, longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = TextEditingController(
            text:
                '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}');
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;

    return Scaffold(
        appBar: AppBar(
          title: Text("New Field"),
          backgroundColor: primaryColor,
        ),
        body: Theme(
          data: Theme.of(context)
              .copyWith(colorScheme: ColorScheme.light(primary: primaryColor)),
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
                  padding: EdgeInsets.all(5),
                  color: backgorundColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16, left: 8.0),
                        child: Column(
                          children: [
                            Text(
                              "Wide of AOI",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(_widePoly.toString() + " are")
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    testPolygon.points.clear();
                                  });
                                },
                                // style: elevatedstyle,
                                child: Row(
                                  children: [
                                    Icon(Icons.clear),
                                    Text("Clear"),
                                  ],
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  _pc.open();
                                },
                                // style: elevatedstyle,
                                child: Row(
                                  children: [Icon(Icons.forward), Text("Next")],
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                // defaultPanelState: PanelState.CLOSED,
                borderRadius: BorderRadius.only(
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
                  child: Icon(
                    Icons.gps_fixed,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    _getCurrentLocation();
                  },
                  backgroundColor: Colors.white,
                ),
              ),

              //the SlidingUpPanel Title
              Positioned(
                top: 20.0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24.0, 18.0, 24.0, 18.0),
                  child: Text(
                    "SlidingUpPanel Example",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 16.0)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        child: Container(
          child: Stepper(
            type: StepperType.horizontal,
            physics: ScrollPhysics(),
            currentStep: _currentStep,
            onStepTapped: (step) => tapped(step),
            onStepContinue: continued,
            onStepCancel: cancel,
            controlsBuilder: (context, details) {
              return Container(
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    if (_currentStep != 0)
                      Expanded(
                          child: ElevatedButton(
                              onPressed: details.onStepCancel,
                              child: Text("BACK"))),
                    const SizedBox(
                      width: 12,
                    ),
                    (_currentStep < 2)
                        ? Expanded(
                            child: ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: Text("NEXT")))
                        : Expanded(
                            child: ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: Text("SAVE"))),
                  ],
                ),
              );
            },
            steps: <Step>[
              Step(
                title: new Text('Area of Interest'),
                // subtitle: Text('Polygonal Area'),
                content: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Coordinates Point',
                      ),
                      controller: _currentLoc,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Address'),
                      controller: _currentAddress,
                    ),
                    TextFormField(
                      controller: _wide,
                      decoration: InputDecoration(labelText: 'Wide Area'),
                    ),
                  ],
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep > 0 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: new Text('Characteristic'),
                content: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 4, bottom: 4),
                        child: MultiSelectBottomSheetField(
                          key: _multiSelectKey,
                          initialChildSize: 0.4,
                          listType: MultiSelectListType.LIST,
                          searchable: true,
                          buttonText: Text("Land Use Type"),
                          title: Text("Land Use Type"),
                          items: _items,
                          onConfirm: (values) {
                            setState(() {
                              _selectType.remove(values);
                            });
                          },
                          chipDisplay: MultiSelectChipDisplay(
                            onTap: (value) {
                              setState(() {
                                _selectType.remove(value);
                              });
                            },
                          ),
                        )),
                    Row(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Water Level'),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Permanence'),
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Ownership'),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 4, bottom: 4),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: black40, width: 1))),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: Text(
                              "Status Area",
                              style: TextStyle(fontSize: 16, color: black60),
                            ),
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 0,
                                groupValue: _access,
                                onChanged: (value) {
                                  setState(() {
                                    _access = value!;
                                  });
                                },
                              ),
                              Text("Public"),
                              Radio(
                                value: 1,
                                groupValue: _access,
                                onChanged: (value) {
                                  setState(() {
                                    _access = value!;
                                  });
                                },
                              ),
                              Text("Private")
                            ],
                          )
                        ],
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Photo'),
                    ),
                  ],
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep > 1 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: new Text('Drought'),
                // subtitle: Text('VHI & Rainfall'),
                content: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Mobile Number'),
                    ),
                  ],
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep > 2 ? StepState.complete : StepState.indexed,
              ),
            ],
          ),
        ));
  }

  Widget _body() {
    return FlutterMap(
      options: MapOptions(
          center: _current,
          zoom: 16,
          onTap: (_, ll) {
            polyEditor.add(testPolygon.points, ll);
            // setState(() {});
            // polygons.add(testPolygon);
            // print(polygons.remove());
          },
          onLongPress: (_, p) {
            setState(() {
              _selected = LatLng(p.latitude, p.longitude);
              _currentLoc = TextEditingController(
                  text: _selected.latitude.toString() +
                      ',' +
                      _selected.longitude.toString());
              _getAddressFromLatLng(p.latitude, p.longitude);
            });
          }
          // interactiveFlags: InteractiveFlag.doubleTapZoom,
          ),
      children: [
        TileLayer(
          urlTemplate: 'http://{s}.google.com/vt?lyrs=s,h&x={x}&y={y}&z={z}',
          subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
        ),
        PolygonLayer(polygons: polygons),
        DragMarkers(markers: polyEditor.edit()),
        MarkerLayer(
          rotate: false,
          anchorPos: AnchorPos.align(AnchorAlign.top),
          markers: [
            Marker(
              point: _selected,
              builder: (ctx) => Icon(
                Icons.location_pin,
                size: 60,
                color: primaryColor,
              ),
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
    if (_currentStep < 2) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      print('Submit');
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
