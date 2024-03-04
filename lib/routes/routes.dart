import 'package:get/get.dart';
import 'package:hietograma/screens/addHyetographScreen.dart';
import 'package:hietograma/screens/hyetographDetailtsScreen.dart';
import 'package:hietograma/screens/hyetographScreen.dart';

class RouterHelper {
  static const String _initial = "/";
  static const String _addHyetograph = "/add-hyetograph";
  static const String _hyetographDeatils = "/hyetograph-details";

  static String getInitial() => _initial;

  static String getAddHyetograph() => _addHyetograph;

  static String getHyetographDeatils({int? id}) =>
      "$_hyetographDeatils?id=$id";

  static final route = [
    GetPage(name: _initial, page: () => const HyetographScreen()),
    GetPage(name: _addHyetograph, page: () => const AddHyetographScreen()),
    GetPage(
        name: _hyetographDeatils,
        page: () {
          final id = int.parse(Get.parameters['id']!);
          return HyetographDetailsScreen( id: id,);
        }),
  ];
}
