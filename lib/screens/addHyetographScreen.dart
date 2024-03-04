import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geobase/geobase.dart';
import 'package:get/get.dart';
import 'package:hietograma/controllers/hyetographController.dart';
import 'package:hietograma/controllers/zoneController.dart';

import '../models/hyetograph.dart';
import '../models/zone.dart';

class AddHyetographScreen extends StatefulWidget {
  const AddHyetographScreen({super.key});

  @override
  State<AddHyetographScreen> createState() => _AddHyetographScreenState();
}

class _AddHyetographScreenState extends State<AddHyetographScreen> {
  final hyetographController = Get.find<HyetographController>();
  final zoneController = Get.find<ZoneController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Controllers
  final nameController = TextEditingController();
  final altitudeController = TextEditingController();
  final baseTimeController = TextEditingController();
  final totalRainDurationController = TextEditingController();
  final returnPeriodController = TextEditingController();

  static final returnPeriodOptions = [2, 5, 10, 25];
  int returnPeriodSelect = returnPeriodOptions[0];

  Zone? zonesSelect;

  void _onSave() {
    print(zoneController.zones);

    if (_formKey.currentState!.validate() && zonesSelect != null) {
      Hyetograph newHyetograph = Hyetograph(
          name: nameController.text.trim(),
          altitude: int.parse(altitudeController.text.trim()),
          baseTime: int.parse(baseTimeController.text.trim()),
          totalRainDuration: int.parse(totalRainDurationController.text.trim()),
          returnPeriod: returnPeriodSelect,
          zone: zonesSelect as Zone);
      hyetographController.saveHyetograph(newHyetograph);
      Get.back();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    altitudeController.dispose();
    baseTimeController.dispose();
    totalRainDurationController.dispose();
    returnPeriodController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Zone> zonesOptions = zoneController.zones ?? [];
    if (zonesOptions.isEmpty) {
      Get.back();
      return const Scaffold();
    };

    print(zonesOptions[0].coordinates);
    List<Geographic> listPosition = zonesOptions[0]
        .coordinates
        .map((x) => Geographic(lat: x[1], lon: x[0], ))
        .toList();
    Polygon newPolygon = Polygon.from([listPosition]);
    GeoBox geoBox = GeoBox.from(listPosition);
    print( geoBox.intersectsPoint(Geographic(lat: 8.62,lon: -70.27)));
    // geoBox.intersectsPoint(point)

    // print(newPolygon.);

    zonesSelect = zonesOptions[0];
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        centerTitle: true,
        title: const Text(
          "Crear Hietograma ",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                controller: nameController,
                decoration: const InputDecoration(
                  hoverColor: Colors.blue,
                  border: OutlineInputBorder(gapPadding: 6),
                  filled: true,
                  icon: Icon(Icons.abc),
                  labelText: "Titulo",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return " Titulo requerido ";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              DropdownButton<Zone>(
                isExpanded: true,
                padding: const EdgeInsets.fromLTRB(40, 0, 10, 0),
                icon: const Icon(Icons.park),
                onChanged: (Zone? newValue) {
                  if (newValue != null) {
                    setState(() {
                      zonesSelect = newValue;
                    });
                  }
                },
                value: zonesSelect,
                items: zonesOptions
                    .map((e) =>
                        DropdownMenuItem<Zone>(value: e, child: Text(e.name)))
                    .toList(),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: altitudeController,
                decoration: const InputDecoration(
                  suffixText: "metros",
                  hoverColor: Colors.blue,
                  border: OutlineInputBorder(gapPadding: 6),
                  filled: true,
                  icon: Icon(Icons.hiking),
                  labelText: "Altitud",
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return " Altitud requerida ";
                  }
                  if (int.parse(value) < zonesSelect!.heightMin) {
                    return "La Altura minima de la Curva IDF es ${zonesSelect!.heightMin}";
                  } else if (int.parse(value) > zonesSelect!.heightMax) {
                    return "La Altura maxima de la Curva IDF es ${zonesSelect!.heightMax}";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: baseTimeController,
                decoration: const InputDecoration(
                  suffixText: "minutos",
                  hoverColor: Colors.blue,
                  border: OutlineInputBorder(gapPadding: 6),
                  filled: true,
                  icon: Icon(Icons.timer),
                  labelText: "Tiempo Base ",
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return " Tiempo Base requerido ";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: totalRainDurationController,
                decoration: const InputDecoration(
                  suffixText: "minutos",
                  hoverColor: Colors.blue,
                  border: OutlineInputBorder(gapPadding: 6),
                  filled: true,
                  icon: Icon(Icons.timelapse_rounded),
                  labelText: "Duración de la Lluvia  ",
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return " Duración de la Lluvia  requerida";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ListTile(
                title: const Text("Periodo de Retorno"),
                trailing: DropdownButton<int>(
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        returnPeriodSelect = newValue;
                      });
                    }
                  },
                  value: returnPeriodSelect,
                  items: returnPeriodOptions
                      .map((e) => DropdownMenuItem<int>(
                          value: e, child: Text("${e.toString()} años")))
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () => _onSave(),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.save,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('CARGAR'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
