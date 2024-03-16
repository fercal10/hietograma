import 'dart:math';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/hyetograph.dart';


Future<Uint8List> generateReport(PdfPageFormat pageFormat,Hyetograph hyetograph ) async {
  List<double> dataTable = hyetograph.getData();
  var duration = hyetograph.getDurations();
  var tableHeaders = <dynamic>["Periodo de Retorno", ...duration.map((e) => "$e min")];

  double maxData= dataTable.reduce((a, b) => a>b?a:b)* 1.2;
  List<double> listInY= List<double>.generate(10, (index) => (maxData*(index/10)).toPrecision(0) ) ;


  List<double> dataType1 = [...dataTable];

  List<double> dataType2 = dataTable.reversed.toList();

  List<double> dataType3 =[] ;
  var axiList =[...dataTable];
  for (var i = 0; i <dataTable.length; i++) {
    double maximo = axiList.first;
    for (int j = 1; j < axiList.length; j++) {
      if (axiList[j] > maximo) maximo = axiList[j];
    }

    if (i.isOdd) {
      dataType3.add(maximo);
    } else {
      dataType3.insert(0, maximo);
    }
    axiList.remove(maximo);
  }

  dataType3.addAll(axiList);



  const baseColor = PdfColors.cyan;
  // Create a PDF document.
  final document = pw.Document();

  final theme = pw.ThemeData.withFont(
    base: await PdfGoogleFonts.openSansRegular(),
    bold: await PdfGoogleFonts.openSansBold(),
  );
  // Top bar chart
  pw.Chart generateChart( List<double> datos ) => pw.Chart(
    left: pw.Container(
      alignment: pw.Alignment.topCenter,
      margin: const pw.EdgeInsets.only(right: 5, top: 10),
      child: pw.Transform.rotateBox(
        angle: pi / 2,
        child: pw.Text('Agua'),
      ),
    ),

    grid: pw.CartesianGrid(
      xAxis: pw.FixedAxis.fromStrings(
        List<String>.generate(
            datos.length, (index) =>"${duration[index]}"),
        marginStart: 30,
        marginEnd: 30,
        textStyle: const pw.TextStyle( fontSize: 10),
        ticks: true,
      ),
      yAxis: pw.FixedAxis(
        listInY,
        format: (v) => '$v mm',
        textStyle: const pw.TextStyle( fontSize: 10),
        divisions: true,
      ),
    ),
    datasets: [
      pw.BarDataSet(
        width: 50,
        color: PdfColors.blue,
        borderColor: PdfColors.blue,
        data: List<pw.PointChartValue>.generate(
          datos.length,
              (i) {
            final v = datos[i] ;
            return pw.PointChartValue(i.toDouble(), v.toDouble());
          },
        ),
      ),
    ],
  );


  // Data table
  final table = pw.TableHelper.fromTextArray(
    border: null,
    headers: tableHeaders,
    data: List<List<dynamic>>.generate(
     1,
          (index) => <dynamic>[
            "${hyetograph.returnPeriod.toString()} Años",
            ...dataType1.map((e) => "${e}"),
       
      ],
    ),
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontWeight: pw.FontWeight.bold,
    ),
    headerDecoration: const pw.BoxDecoration(
      color: baseColor,
    ),
    rowDecoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          color: baseColor,
          width: .5,
        ),
      ),
    ),
    cellAlignment: pw.Alignment.centerRight,
    cellAlignments: {0: pw.Alignment.centerLeft},

  );

  // Add page to the PDF
  document.addPage(
    pw.Page(
      pageFormat: pageFormat,
      margin: const pw.EdgeInsets.all(15),
      theme: theme,
      build: (context) {
        // Page layout
        return pw.Column(
          children: [
            pw.Text('Hietograma de ${hyetograph.zone.name} ',
                style: const pw.TextStyle(
                  color: baseColor,
                  fontSize: 30,
                )),
            pw.SizedBox(height: 10),
            table,
            pw.SizedBox(height: 10),
            pw.Divider(),
            pw.Expanded(flex: 2, child: generateChart(dataType1)),
            pw.Expanded(flex: 2, child: generateChart(dataType2)),
            pw.Expanded(flex: 2, child: generateChart(dataType3)),


          ],
        );
      },
    ),
  );

  // Second page with a pie chart


  // Return the PDF file content
  return document.save();
}