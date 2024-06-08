import 'package:flutter/material.dart';
import 'package:waterspring/widgets/currentdata.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // Data dummy
  String city = 'Jakarta';
  int temp = 27;
  String forecast = 'Cloudy';

  String searchQuery = '';
  List<Map<String, String>> destinations = [
    {
      'name': 'Air Terjun Jeg',
      'image': 'assets/images/Air terjun jembong.jpg',
    },
    {
      'name': 'Gatep Lawas',
      'image': 'assets/images/Gatep lawas.jpg',
    },
    {
      'name': 'Kolam Jembong',
      'image': 'assets/images/Kolam Jembong.jpg',
    },
    {
      'name': 'Lesung Permai',
      'image': 'assets/images/lesung permai.jpg',
    },
  ];
  List<String> filteredPropertyType = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredPropertyType
        .addAll(destinations.map((destination) => destination['name'] ?? ''));
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<String> filteredList = destinations
          .where((destination) =>
              destination['name']
                  ?.toLowerCase()
                  .contains(query.toLowerCase()) ??
              false)
          .map((destination) => destination['name'] ?? '')
          .toList();
      setState(() {
        filteredPropertyType.clear();
        filteredPropertyType.addAll(filteredList);
      });
    } else {
      setState(() {
        filteredPropertyType.clear();
        filteredPropertyType.addAll(
            destinations.map((destination) => destination['name'] ?? ''));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter destinations based on search query

    return Scaffold(
      // backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Jelajahi Potensi',
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Desa Ambengan',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Bilah pencarian
                    Material(
                      borderRadius: BorderRadius.circular(100),
                      elevation: 5,
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
                                  onChanged: (value) {
                                    setState(() {
                                      searchQuery = value;
                                    });
                                  },
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
              ),
              const SizedBox(
                height: 25,
              ),
              // Weather
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      forecast,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Text('$temp °C', style: const TextStyle(fontSize: 64)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              'assets/images/hujan.png',
                              width: 85,
                              height: 85,
                            ),
                            const Text('20% Rain'),
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset(
                              'assets/images/angin.png',
                              width: 85,
                              height: 85,
                            ),
                            const Text('8 km/h Wind'),
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset(
                              'assets/images/angin.png',
                              width: 85,
                              height: 85,
                            ),
                            const Text('30°C Sunny'),
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset(
                              'assets/images/angin.png',
                              width: 85,
                              height: 85,
                            ),
                            const Text('Snowy Day'),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Destinasi',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("View All"),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: filteredPropertyType.map((destinationName) {
                          final destination = destinations.firstWhere(
                            (dest) => dest['name'] == destinationName,
                            orElse: () => {
                              'name': '',
                              'image': 'assets/images/Gatep lawas.jpg',
                            },
                          );
                          return promoCard(
                            destination['image'] ??
                                'assets/images/Gatep lawas.jpg',
                            destinationName,
                            16.0,
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // Current Data
                    const SizedBox(height: 9),

                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              'Current Data',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // You can add CurrentDataDiagram here
                    const CurrentDataDiagram(
                      // height: 50,
                      percent: 40,
                      label: 'Spring',
                      barColor: Colors.lightBlueAccent,
                    ),
                    const SizedBox(height: 8),
                    const CurrentDataDiagram(
                      percent: 30,
                      label: 'Crops Land',
                      barColor: Colors.black,
                    ),
                    const SizedBox(height: 8),
                    const CurrentDataDiagram(
                      percent: 75,
                      label: 'Destination',
                      barColor: Colors.red,
                    ),
                    const SizedBox(height: 8),
                    const CurrentDataDiagram(
                      percent: 65,
                      label: 'Dam',
                      barColor: Colors.green,
                    ),
                    const SizedBox(height: 8),
                    const CurrentDataDiagram(
                      percent: 25,
                      label: 'Hotel',
                      barColor: Colors.blueAccent,
                    ),
                    const SizedBox(height: 8),
                    const CurrentDataDiagram(
                      percent: 45,
                      label: 'UMKM',
                      barColor: Colors.orangeAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget promoCard(String image, String destinationName, double fontSize) {
    return AspectRatio(
      aspectRatio: 2.62 / 3,
      child: Container(
        margin: const EdgeInsets.only(right: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(image),
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  stops: [0.1, 0.9],
                  colors: [
                    Colors.black.withOpacity(.8),
                    Colors.black.withOpacity(.1),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  destinationName,
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataPoint(
      {required int percent,
      required String label,
      required MaterialColor barColor}) {}
}
