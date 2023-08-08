import 'package:flutter/material.dart';

class Todo {
  final String TypeName;
  final Color backgroundColor;
  bool isSelected;

  Todo(
      {required this.TypeName,
      required this.isSelected,
      required this.backgroundColor});
}
