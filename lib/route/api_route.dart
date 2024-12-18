import 'package:rizky_jago/app/http/controllers/product_controller.dart';
import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override
  void register() {
    // REST API Routes
    Router.get('/products', productController.index);
    Router.post('/products', productController.store);
    Router.get('/products/{id}', productController.show);
    Router.put('/products/{id}', productController.update);
    Router.delete('/products/{id}', productController.destroy);
  }
}
