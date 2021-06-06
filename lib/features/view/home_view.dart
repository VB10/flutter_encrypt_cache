import 'package:flutter/material.dart';

import '../../product/widgets/card/item_card.dart';
import '../viewmodel/home_view_model.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends HomeViewModel with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
      body: buildGridViewBody(),
    );
  }

  GridView buildGridViewBody() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: items.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => ItemCard(onPressed: () => navigateToDetail(index), model: items[index]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
