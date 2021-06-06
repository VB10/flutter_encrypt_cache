import 'dart:typed_data';

import 'package:vexana/vexana.dart';

import '../model/item_model.dart';

abstract class IHomeService {
  final INetworkManager manager;
  IHomeService(this.manager);

  Future<List<ItemModel>> fetchItem();
  Future<Uint8List?> downloadFile(String url, {ProgressCallback? callback});
}

enum _HomeServicePath { CACHE }

extension on _HomeServicePath {
  String get rawValue {
    switch (this) {
      case _HomeServicePath.CACHE:
        return '/caches.json';
    }
  }
}

class HomeService extends IHomeService {
  HomeService(INetworkManager manager) : super(manager);

  @override
  Future<List<ItemModel>> fetchItem() async {
    final response =
        await manager.send<ItemModel, List<ItemModel>>(_HomeServicePath.CACHE.rawValue, parseModel: ItemModel(), method: RequestType.GET);
    return response.data ?? [];
  }

  @override
  Future<Uint8List?> downloadFile(String url, {ProgressCallback? callback}) async {
    final response = await manager.downloadFileSimple(url, callback);
    if (response.data is Uint8List) return response.data;

    return null;
  }
}
