import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'features/view/tab/home_tab_view.dart';
import 'product/constants/app_constants.dart';
import 'product/manager/IItemCache.dart';

// TODO: Add provider or anatoher state provider
final GlobalKey<ScaffoldMessengerState> scaffoldMassenger = GlobalKey();

Future main() async {
  await _init();
  runApp(MyApp());
}

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: AppConstants.DOTENV_PATH);

  await ItemModelCache.dummy().clearAllDatas();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      scaffoldMessengerKey: scaffoldMassenger,
      theme: ThemeData.dark(),
      home: HomeTabView(),
    );
  }
}
