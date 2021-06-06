import 'dart:convert';
import 'dart:io';

import 'package:encypt_cache/core/util/crypto_data.dart';
import 'package:encypt_cache/features/model/item_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vexana/vexana.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'mock_cache_platform.dart';

void main() {
  late INetworkManager manager;
  setUp(() {
    manager = NetworkManager(options: BaseOptions());
    PathProviderPlatform.instance = MockPathProviderPlatform();
  });
  test('Fetch Pdf And Cache', () async {
    final response = await manager.downloadFileSimple('http://www.africau.edu/images/default/sample.pdf', null);
    final directory = await getApplicationDocumentsDirectory();
    await Directory('${directory.path}').create();
    await Directory('${directory.path}/vb2').create();
    final path = '${directory.path}/vb2/1.pdf';
    final file = File(path);
    final fileWithData = await file.writeAsBytes(response.data!);
    expect(await fileWithData.exists(), true);
  });

  test('Cache Model In File', () async {
    final model = ItemModel(id: 1345);
    final directory = await getApplicationDocumentsDirectory();
    await Directory('${directory.path}').create();
    await Directory('${directory.path}/vb2').create();
    final path = '${directory.path}/vb2/${model.title}.json';
    final file = File(path);
    final fileWithData = await file.writeAsString(model.toString());
    expect(await fileWithData.exists(), true);
  });

  test('Cache Model & Encryption', () async {
    final model = ItemModel(id: 1345);
    final crypto = EncrypData();
    final directory = await getApplicationDocumentsDirectory();
    await Directory('${directory.path}').create();
    await Directory('${directory.path}/vb2').create();
    final path = '${directory.path}/vb2/${model.title}.json';
    final file = File(path);
    final modelValuesWithCrypto = crypto.crypteFile(model.toString());
    await file.writeAsString(modelValuesWithCrypto);
    final dcryptedFile = await file.readAsString();
    final decryptedModel = ItemModel.fromString(crypto.decryptFile(dcryptedFile));
    expect(decryptedModel.id == model.id, true);
  });
}
