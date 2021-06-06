import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../core/network/encrypt_network_manager.dart';
import '../model/item_model.dart';
import '../service/home_service.dart';
import '../view/home_view.dart';
import '../view/home_view_detail.dart';

abstract class HomeViewModel extends State<HomeView> {
  late final IHomeService homeService;

  List<ItemModel> items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    homeService = HomeService(EncryptNetworkManager().manager);
    _fetchAndShow();
  }

  Future<void> _fetchAndShow() async {
    _changeLoading();
    items = await homeService.fetchItem();
    _changeLoading();
  }

  void navigateToDetail(int index) {
    context.navigateToPage(HomeViewDetail(
      model: items[index],
      homeService: homeService,
    ));
  }

  void _changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}
