import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vexana/vexana.dart';

class EncryptNetworkManager {
  late final INetworkManager manager;

  EncryptNetworkManager() {
    manager = NetworkManager(options: BaseOptions(baseUrl: dotenv.env['BASE_URL'] ?? ''), isEnableLogger: true);
  }
}
