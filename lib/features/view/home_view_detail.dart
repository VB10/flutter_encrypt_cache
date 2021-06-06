import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import '../../main.dart';
import '../../product/manager/IItemCache.dart';
import '../../product/widgets/snackbar/sucess_snackbar.dart';
import '../model/item_model.dart';
import '../service/home_service.dart';

class HomeViewDetail extends StatefulWidget {
  final ItemModel model;
  final IHomeService homeService;
  const HomeViewDetail({Key? key, required this.model, required this.homeService}) : super(key: key);

  @override
  _HomeViewDetailState createState() => _HomeViewDetailState();
}

class _HomeViewDetailState extends State<HomeViewDetail> {
  late ItemCache _itemCache;

  late ItemModel _model;

  @override
  void initState() {
    super.initState();
    _model = widget.model;
    _itemCache = ItemModelCache(_model);
  }

  Future<Uint8List?> fetchData() async {
    final cacheData = await _itemCache.takeItemWithCache(widget.model.id ?? 0);
    if (cacheData != null) {
      return cacheData.items;
    }

    final data = await widget.homeService.downloadFile(widget.model.document ?? '');
    _model.setupItemValues(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButtonDownlaod(),
      appBar: AppBar(title: Text(widget.model.title ?? '')),
      body: fetchData().toBuild<Uint8List?>(
          onSuccess: (data) {
            if (data != null) {
              return PdfView(controller: PdfController(document: PdfDocument.openData(data)));
            } else {
              return buildErrorWidget();
            }
          },
          loadingWidget: CircularProgressIndicator(),
          notFoundWidget: buildErrorWidget(),
          onError: buildErrorWidget()),
    );
  }

  Text buildErrorWidget() => Text('Error');

  FloatingActionButton buildFloatingActionButtonDownlaod() {
    return FloatingActionButton(
      onPressed: () async {
        await _itemCache.cacheIt();
        scaffoldMassenger.currentState?.showSnackBar(SucessSnackBar());
      },
      child: Icon(Icons.download),
    );
  }
}
