import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hietograma/models/zone.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class ShowMap extends StatefulWidget {
  final List<Zone> zones;
  final Function({required double log, required double lat}) selectLocation;

  const ShowMap({super.key, required this.zones, required this.selectLocation});

  @override
  State<ShowMap> createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  LatLng? pointSelect;

  @override
  void initState() {
    super.initState();
    firstLocation();
  }

  void firstLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();

    if (serviceEnabled &&
        permissionGranted != PermissionStatus.denied &&
        permissionGranted != PermissionStatus.deniedForever) {
      locationData = await location.getLocation();
      var latitude = locationData.latitude;
      var longitude = locationData.longitude;

      if (longitude != null && latitude != null) {
        setState(() {
          pointSelect = LatLng(latitude, longitude);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: Stack(
        children: [
          SizedBox(
            height: 500,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(7.828986, -66.157976),
                initialZoom: 6.2,
                onTap: (tapPosition, point) {
                  setState(() {
                    pointSelect = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: pointSelect != null
                      ? [
                          Marker(
                            point: pointSelect!,
                            width: 60,
                            height: 60,
                            child: const Icon(Icons.location_on,
                                color: Colors.red),
                          ),
                        ]
                      : [],
                ),
                PolygonLayer(
                  polygonLabels: true,
                  drawLabelsLast: true,
                  polygons: [
                    ...widget.zones.asMap().entries.map((e) {
                      return Polygon(
                        labelStyle: TextStyle(color: Colors.black),
                        points: e.value.coordinates
                            .map((a) => LatLng(a[1], a[0]))
                            .toList(),
                        color: Colors.primaries[e.key].withOpacity(0.3),
                        label: e.value.name,
                        isFilled: true,
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              height: 50,
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              color: const Color.fromRGBO(245, 245, 245, 0.8),
              child: const Text("Seleciona la Ubicación ",
                  style: TextStyle(fontSize: 20)),
            ),
          ),
          Positioned(
            bottom: 5,
            right: 15,
            child: ElevatedButton(
              onPressed: pointSelect == null
                  ? null
                  : () {
                      final pointSelect = this.pointSelect;
                      if (pointSelect != null) {
                        widget.selectLocation(
                            lat: pointSelect.latitude,
                            log: pointSelect.longitude);
                      }
                    },
              child: const Text("Seleccionar"),
            ),
          ),
          Positioned(
            bottom: 5,
            left: 15,
            child: ElevatedButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.blue.shade200)),
              child: const Text("Cerrar"),
              onPressed: () => Get.back(),
            ),
          )
        ],
      ),
    );
  }
}
