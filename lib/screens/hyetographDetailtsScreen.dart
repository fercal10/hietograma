
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hietograma/widget/HistogramPlots.dart';
import 'package:parallax_rain/parallax_rain.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../PDF/generateExport.dart';
import '../controllers/hyetographController.dart';
import '../models/hyetograph.dart';

class HyetographDetailsScreen extends StatefulWidget {
  final int id;

  const HyetographDetailsScreen({super.key, required this.id});

  @override
  State<HyetographDetailsScreen> createState() =>
      _HyetographDetailsScreenState();
}

class _HyetographDetailsScreenState extends State<HyetographDetailsScreen> {


  @override
  Widget build(BuildContext context) {
    final HyetographController hyetographController =
        Get.find<HyetographController>();

    Hyetograph? hyetograph = hyetographController.getHyetographById(widget.id);


    if (hyetograph == null) {
      Get.back();
      return const Scaffold();
    }
    //Iniciarlizar Datos
    List<int> durations = hyetograph.getDurations();
    List<double> data = hyetograph.getData();
    final indexSector = hyetograph.getIndexSector();

    List<DataRow> tableRows = <DataRow>[
      DataRow(
        cells: [
          DataCell(Text("${hyetograph.returnPeriod.toString()} Años")),
          ...data.map((e) => DataCell(Text(e.toStringAsFixed(2))))
        ],
      )
    ];

    List<DataColumn> tableColumns = <DataColumn>[
      const DataColumn(label: Text("Periodo de Retorno")),
      ...durations.map((e) => DataColumn(label: Text("${e.toString()} Minutos ")))
    ];

    int theRain = 20;
    void showRain(double n) {
      setState(() {
        theRain = 0;
      });

    }

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        centerTitle: true,
        title: Text(
          "Detalles  ${hyetograph.name}",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final Uint8List pdfShare =
                  await generateReport(PdfPageFormat.letter, hyetograph);
              await Printing.sharePdf(bytes: pdfShare, filename: "Test.pdf");
            },
            icon: const Icon(
              Icons.share,
              color: Colors.black,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
          Stack(
          fit: StackFit.loose,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 1.2,
              child: theRain==0?null: ParallaxRain(
                dropFallSpeed: 5,
                numberOfDrops: theRain,
                rainIsInBackground: true,
                dropColors: const [
                  Colors.blue,
                ],
              ),
            ),
            Column(
              children: [
                ItemDetails(
                    dato: "Elevación",
                    info: "${hyetograph.altitude.toString()} M.S.N.M. "),
                ItemDetails(
                    dato: "Periodo de Retorno",
                    info: "${hyetograph.returnPeriod.toString()} Años"),
                ItemDetails(
                    dato: "Zona",
                    info:
                        "${hyetograph.zone.name.toString()}- ${hyetograph.zone.curves[indexSector].name} "),
                ItemDetails(
                    dato: "Tiempo base", info: hyetograph.baseTime.toString()),
                const SizedBox(height: 25),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Stack(children: [
                      DataTable(
                        columnSpacing: 20,
                        horizontalMargin: 10,
                        border: TableBorder.all(),
                        columns: tableColumns,
                        rows: tableRows,
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                    " Hietograma con periodo de retorno  ${hyetograph.returnPeriod} años"),
                const SizedBox(height: 5),
                HistogramPlots(
                  showRain: showRain,
                  type: 1,
                  data: data,
                  durations: durations,
                ),
                const SizedBox(height: 15),
                HistogramPlots(
                  showRain: showRain,
                  type: 2,
                  data: data,
                  durations: durations,
                ),
                const SizedBox(height: 15),
                HistogramPlots(
                  showRain: showRain,
                  type: 3,
                  data: data,
                  durations: durations,
                ),
              ],
            ),
          ],
        ),
      ]),
    )
    );
  }
}

class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key, required this.dato, required this.info});

  final String dato;
  final String info;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1),
        ),
      ),
      width: width * 0.8,
      margin: const EdgeInsets.only(right: 10, left: 10),
      padding: const EdgeInsets.all(10),
      child: Wrap(
        children: [
          Text(
            "$dato: $info ",
            style: const TextStyle(
              fontSize: 18,
              overflow: TextOverflow.clip,
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
