import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Hietograma/controllers/hyetographController.dart';
import 'package:Hietograma/controllers/zoneController.dart';
import 'package:Hietograma/routes/routes.dart';

class HyetographScreen extends StatelessWidget {
  const HyetographScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ZoneController>(
      builder: (zoneController) => GetBuilder<HyetographController>(
        builder: (hyetographController) {
          return Scaffold(
              backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
              appBar: AppBar(
                elevation: 10,
                centerTitle: true,
                title: const Text("HIETOGRAMA"),
              ),
              floatingActionButton: SizedBox(
                height: 50.0,
                width: 130.0,
                child: FloatingActionButton(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      Text("Ingresar Datos"),
                    ],
                  ),
                  onPressed: () => Get.toNamed(RouterHelper.getAddHyetograph()),
                ),
              ),
              body: ListView.builder(
                  itemCount: hyetographController.hyetographs.length,
                  itemBuilder: (context, index) {
                    var hyetograph = hyetographController.hyetographs[index];
                    return ListTile(
                      onTap: () => Get.toNamed(
                          RouterHelper.getHyetographDetails(id: hyetograph.id)),
                      subtitle: Text(
                          "Zona ${hyetograph.zone.name}/ ${hyetograph.altitude.toString()} metros "),
                      title: Text(hyetograph.name),
                      trailing: const Icon(Icons.remove_red_eye_rounded),
                    );
                  }));
        },
      ),
    );
  }
}
