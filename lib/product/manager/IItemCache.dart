import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart' as collection;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/util/crypto_data.dart';
import '../../features/model/item_model.dart';

abstract class ItemCache {
  final String _localPath = 'vb10';
  final ItemModel item;

  ItemCache(this.item);
  Future<void> cacheIt();
  Future<Directory> createDirectory();
  Future<File> createDirectoryWithPath();

  Future<ItemModel?> takeItemWithCache(int id);

  Future<List<ItemModel>> getAllDatas();
  Future<void> clearAllDatas();
  Future<void> clearAllDatasWithExpiry();

  int get _expiryValue => 7;
}

class ItemModelCache extends ItemCache {
  late final EncrypData encrypData;

  Directory? _directory;

  ItemModelCache(ItemModel item) : super(item) {
    encrypData = EncrypData();
  }
  factory ItemModelCache.dummy() {
    return ItemModelCache(ItemModel.dummy());
  }

  @override
  Future<void> cacheIt() async {
    final file = await createDirectoryWithPath();
    item.itemValues = encrypData.crypteFile(item.itemValues ?? '');
    await file.writeAsString(item.toString());
  }

  @override
  Future<Directory> createDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  @override
  Future<File> createDirectoryWithPath() async {
    final directory = await createDirectory();
    _directory = await Directory('${directory.path}/$_localPath').create();

    final path = '${directory.path}/$_localPath/';
    return File('$path/${item.id}.json');
  }

  @override
  Future<List<ItemModel>> getAllDatas() async {
    final _directory = await createDirectory();
    final itemDirectory = await Directory('${_directory.path}/$_localPath').create();

    final items = await itemDirectory.list().toSet();
    var cachedItems = <ItemModel>[];
    await Future.forEach<FileSystemEntity>(items, (element) async {
      final file = File(element.path);
      final jsonBody = json.decode(await file.readAsString());
      final feedItem = ItemModel.fromJson(jsonBody);
      feedItem.itemValues = encrypData.decryptFile(feedItem.itemValues ?? '');
      cachedItems.add(feedItem);
    });

    return cachedItems;
  }

  @override
  Future<void> clearAllDatas() async {
    final directory = await createDirectory();
    final itemDirectory = await Directory('${directory.path}/$_localPath').create();

    await itemDirectory.delete(recursive: true);
  }

  @override
  Future<void> clearAllDatasWithExpiry() async {
    final directory = await createDirectory();
    final itemDirectory = await Directory('${directory.path}/$_localPath').create();
    final items = await itemDirectory.list().toSet();
    await Future.forEach<FileSystemEntity>(items, (element) async {
      final file = File(element.path);

      final jsonBody = json.decode(await file.readAsString());
      final feedItem = ItemModel.fromJson(jsonBody);
      final _itemDate = feedItem.publishDate;
      if (_itemDate.difference(DateTime.now()).inDays.abs() > _expiryValue) {
        Logger().i('${feedItem.id} has removed');
        await file.delete();
      }
    });
  }

  @override
  Future<ItemModel?> takeItemWithCache(int? id) async {
    if (_directory == null) {
      final appDirectory = await createDirectory();
      _directory ??= await Directory('${appDirectory.path}/$_localPath').create();
    }
    final items = await _directory!.list().toSet();
    final _item = items.firstWhereOrNull((element) => element.path.contains('$id'));

    if (_item != null) {
      if (await _item.exists()) {
        final file = File(_item.path);

        final jsonBody = json.decode(await file.readAsString());
        final feedItem = ItemModel.fromJson(jsonBody);
        feedItem.itemValues = encrypData.decryptFile(feedItem.itemValues ?? '');
        return feedItem;
      }
    }

    return null;
  }
}
