import 'package:flutter/material.dart';

class DraggableList {
  final String header;
  final List<DraggableListItem> items;

  const DraggableList({
    required this.header,
    required this.items,
  });
}

class DraggableListItem {
  String? text;
  Widget? image;

  DraggableListItem({
    this.text,
    this.image,
  });
}
