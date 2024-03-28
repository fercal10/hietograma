import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hietograma/controllers/hyetographController.dart';
import 'package:hietograma/controllers/zoneController.dart';
import '../models/hyetograph.dart';
import '../models/zone.dart';
import 'package:location/location.dart';

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
  String? sectorName;

  void _onSave() {

    if (_formKey.currentState!.validate() &&
        zonesSelect != null &&
        sectorName != null) {
      Hyetograph newHyetograph = Hyetograph(
          name: nameController.text.trim(),
          altitude: int.parse(altitudeController.text.trim()),
          baseTime: int.parse(baseTimeController.text.trim()),
          totalRainDuration: int.parse(totalRainDurationController.text.trim()),
          returnPeriod: returnPeriodSelect,
          zone: zonesSelect!,
          sectorName: sectorName!);
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
    final List<Zone> zonesOptions = zoneController.zones ;
    if (zonesOptions.isEmpty) {
      Get.back();
      return const Scaffold();
    }




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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const Text("Regiones",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 10, 0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: DropdownButton<Zone>(
                        isExpanded: true,
                        onChanged: (Zone? newValue) {
                          if (newValue != null) {
                              zonesSelect = newValue;
                            setState(() {
                            });
                          }
                        },
                        value: zonesSelect,
                        items: zonesOptions
                            .map((e) => DropdownMenuItem<Zone>(
                                value: e, child: Text(e.name)))
                            .toList(),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                            onPressed: () async {
                              Location location = Location();

                              bool serviceEnabled;
                              PermissionStatus permissionGranted;
                              LocationData locationData;

                              serviceEnabled = await location.serviceEnabled();
                              if (!serviceEnabled) {
                                serviceEnabled =
                                    await location.requestService();
                                if (!serviceEnabled) {
                                  return;
                                }
                              }

                              permissionGranted =
                                  await location.hasPermission();
                              if (permissionGranted ==
                                  PermissionStatus.denied) {
                                permissionGranted =
                                    await location.requestPermission();
                                if (permissionGranted !=
                                    PermissionStatus.granted) {
                                  return;
                                }
                              }

                              locationData = await location.getLocation();

                            },
                            icon: const Icon(
                              Icons.location_searching,
                              color: Colors.black,
                            )))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Sectores",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 10, 0),
                child: DropdownButton<String>(
                  isExpanded: true,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  // icon: const Icon(Icons.),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        sectorName = newValue;
                      });
                    }
                  },
                  value: sectorName,
                  items: zonesSelect != null
                      ? zonesSelect!.curves
                          .map((e) => DropdownMenuItem<String>(
                              value: e.name,
                              child: Text(
                                  "${e.name} ${e.heightMin}m${e.heightMax != -1 ? ' - ${e.heightMax}m' : ''}")))
                          .toList()
                      : [],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                maxLength: 4,
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
                  } else if (int.parse(value) >= zonesSelect!.heightMax &&
                      zonesSelect!.heightMax != -1) {
                    return "La Altura maxima de la Curva IDF es ${zonesSelect!.heightMax}";
                  }
                  if(sectorName!= null){
                    var validateSector =zonesSelect!.curves.firstWhere((e) =>e.name== sectorName );

                    if(int.parse(value) < validateSector.heightMin ||int.parse(value) >= validateSector.heightMax){
                      return "La altitud no coincide con el sector";
                    }

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
                  if (totalRainDurationController.text.isNotEmpty &&
                      int.parse(value) / 2 >
                          int.parse(totalRainDurationController.text)) {
                    return " Tiempo Base Deber ser menor que el tiempo total de lluvia  ";
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
