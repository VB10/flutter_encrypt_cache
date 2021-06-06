import 'dart:convert';
import 'dart:typed_data';

import 'package:vexana/vexana.dart';

class ItemModel extends INetworkModel<ItemModel> {
  String? title;
  String? date;
  DateTime get publishDate => DateTime.parse(date ?? DateTime.now().toIso8601String());
  String? document;
  int? id;
  Uint8List get items => base64Decode(itemValues ?? '');
  String? itemValues;
  ItemModel({this.title, this.date, this.document, this.id, this.itemValues});

  void setupItemValues(Uint8List? items) {
    if (items == null) return;
    itemValues = base64Encode(items);
  }

  ItemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    date = json['date'];
    document = json['document'];
    id = json['id'];
    itemValues = json['itemValues'];
  }

  factory ItemModel.dummy() {
    return ItemModel();
  }

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['date'] = date;
    data['document'] = document;
    data['id'] = id;
    data['itemValues'] = itemValues;
    return data;
  }

  @override
  ItemModel fromJson(Map<String, dynamic> json) {
    return ItemModel.fromJson(json);
  }

  factory ItemModel.fromString(String data) {
    return ItemModel.fromJson(jsonDecode(data));
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
