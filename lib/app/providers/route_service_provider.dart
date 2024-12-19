import 'package:vania/vania.dart';
import 'package:farel_123/route/api_route.dart';
import 'package:farel_123/route/web.dart';
import 'package:farel_123/route/web_socket.dart';

class RouteServiceProvider extends ServiceProvider {
  @override
  Future<void> boot() async {}

  @override
  Future<void> register() async {
    WebRoute().register();
    ApiRoute().register();
    WebSocketRoute().register();
  }
}
