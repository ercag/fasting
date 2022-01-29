import 'package:flutter/cupertino.dart';

class FastingTypesModel {
  String? typeNo;
  String typeName;
  Widget child;
  bool? selected;

  FastingTypesModel(
      {this.typeNo,
      required this.typeName,
      required this.child,
      this.selected});
}
