import 'package:flutter/material.dart';

import 'model/model.dart';

List<Product> prodList = [];
Widget dropDownWidget(
    {required void Function(String?) onChanged,
    required List<DropdownMenuItem<String>> items,
    required String hintText}) {
  return DropdownButton(
    hint: Text(
      hintText,
      textAlign: TextAlign.center,
    ),
    isExpanded: true,
    iconEnabledColor: const Color(0xFF2F4D7D),
    iconSize: 25,
    elevation: 16,
    onChanged: onChanged,
    items: items.toList(),
  );
}
