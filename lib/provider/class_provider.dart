import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/provider/class.dart';

class ClassData extends ChangeNotifier {
  List<Class> _classes = [Class(grade: 6, className: 'A')];
}
