import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geobase/geobase.dart';
import 'package:get/get.dart';
import 'package:hietograma/controllers/hyetographController.dart';
import 'package:hietograma/controllers/zoneController.dart';
import 'package:hietograma/widget/show_map.dart';
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
    final List<Zone> zonesOptions = zoneController.zones;
    if (zonesOptions.isEmpty) {
      Get.back();
      return const Scaffold();
    }
    void selectLocation({required double lat, required double log}) {
      if (zonesOptions.isNotEmpty) {
        var findLocation = zonesOptions.firstWhereOrNull((e) {
          List<Geographic> listPosition = e.coordinates
              .map((x) => Geographic(
                    lat: x[1],
                    lon: x[0],
                  ))
              .toList();
          GeoBox geoBox = GeoBox.from(listPosition);
          return geoBox.intersectsPoint(Geographic(lat: lat, lon: log));
        });

        if (findLocation != null) {
          setState(() {
            zonesSelect = findLocation;
          });
        } else {
          const snackBar = SnackBar(
            content:
                Text('Ubicacion selecionada no coincide con ninguna Region!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
      Get.back();
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
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
                            setState(() {});
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
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) => ShowMap(
                                    zones: zonesOptions,
                                    selectLocation: selectLocation),
                              );

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
                  if (sectorName != null) {
                    var validateSector = zonesSelect!.curves
                        .firstWhere((e) => e.name == sectorName);

                    if (int.parse(value) < validateSector.heightMin ||
                        int.parse(value) >= validateSector.heightMax) {
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
              const Text("Periodo de Retorno",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: SegmentedButton<int>(

                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((s) {
                      const Set<MaterialState> interactiveStates =
                          <MaterialState>{
                        MaterialState.pressed,
                        MaterialState.hovered,
                        MaterialState.focused,
                        MaterialState.selected
                      };
                      if (s.any(interactiveStates.contains)) {
                        return Colors.blue[600];
                      }
                      return Colors.grey[200];
                    })

                        // foregroundColor: Colors.blue,

                        ),
                    segments: returnPeriodOptions
                        .map((e) => ButtonSegment<int>(
                              value: e,
                              label: Text("${e.toString()}\n años",textAlign: TextAlign.center),
                            ))
                        .toList(),
                    selected: <int>{returnPeriodSelect},
                    onSelectionChanged: (Set<int> newSelection) {
                      setState(() {
                        returnPeriodSelect = newSelection.first;
                      });
                    }),
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
