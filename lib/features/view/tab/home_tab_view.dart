import 'package:flutter/material.dart';

import '../home_view.dart';
import '../library_view.dart';

class HomeTabView extends StatelessWidget {
  HomeTabView({Key? key}) : super(key: key);

  final List<MapEntry<String, Widget>> _items = [
    MapEntry('Home', HomeView()),
    MapEntry('Library', LibraryView()),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _items.length,
        child: Scaffold(
          bottomNavigationBar: buildBottomAppBar(),
          body: buildTabBarView(),
        ));
  }

  TabBarView buildTabBarView() => TabBarView(children: _items.map((e) => e.value).toList());

  BottomAppBar buildBottomAppBar() => BottomAppBar(child: TabBar(tabs: _items.map((e) => Tab(text: e.key)).toList()));
}
