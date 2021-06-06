import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../../features/model/item_model.dart';

class ItemCard extends StatelessWidget {
  final ItemModel model;
  final VoidCallback? onPressed;
  const ItemCard({Key? key, required this.model, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: context.paddingLow,
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/fluttertr-ead5c.appspot.com/o/Screen%20Shot%202021-06-06%20at%2012.19.12%20AM.png?alt=media&token=252a52c6-ff7d-42e2-afa9-e7fb3cb53854',
              ),
            ),
          ),
          Text(model.title ?? '')
        ],
      ),
    ));
  }
}
