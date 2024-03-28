import 'package:get/get.dart';
import 'package:hietograma/models/hyetograph.dart';
import 'package:hive/hive.dart';

class HyetographController extends GetxController{
  late final Box<Hyetograph> _hyetographBox;
  final hyetographs = <Hyetograph>[];


  @override
  Future<void> onInit() async{
    await _getHyetograph();
    super.onInit();
  }



  Future<void> _getHyetograph() async {
    _hyetographBox = await Hive.openBox<Hyetograph>('hyetograph');
    _loadHyetograph();
  }

  Hyetograph? getHyetographById(int id) {
    return _hyetographBox.get(id);
  }

  void _loadHyetograph() {
    hyetographs.clear();
    hyetographs.addAll(_hyetographBox.values);
    update();
  }
  Future<void> saveHyetograph(Hyetograph newHyetograph) async{

    int key =await _hyetographBox.add(newHyetograph);
    newHyetograph.id = key;
    newHyetograph.save();
    _loadHyetograph();

  }

}