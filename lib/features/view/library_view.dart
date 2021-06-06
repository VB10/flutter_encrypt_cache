import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../product/manager/IItemCache.dart';
import '../../product/widgets/card/item_card.dart';
import '../model/item_model.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({Key? key}) : super(key: key);

  @override
  _LibraryViewState createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  late final ItemCache itemCache;

  @override
  void initState() {
    super.initState();
    itemCache = ItemModelCache.dummy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButtonDelete(),
      appBar: AppBar(),
      body: buildBuildFetchDatas(),
    );
  }

  FloatingActionButton buildFloatingActionButtonDelete() => FloatingActionButton(
      onPressed: () async {
        await ItemModelCache.dummy().clearAllDatas();
        setState(() {});
      },
      child: Icon(Icons.delete_forever));

  Widget buildBuildFetchDatas() {
    return itemCache.getAllDatas().toBuild<List<ItemModel>>(
        onSuccess: (data) {
          if (data != null) {
            return buildListViewCached(data);
          } else {
            return buildErrorWidget();
          }
        },
        loadingWidget: CircularProgressIndicator.adaptive(),
        notFoundWidget: buildErrorWidget(),
        onError: buildErrorWidget());
  }

  ListView buildListViewCached(List<ItemModel> data) {
    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => SizedBox(height: context.dynamicHeight(0.25), child: ItemCard(model: data[index])),
    );
  }

  ErrorWidget buildErrorWidget() => ErrorWidget('Data not found');
}
