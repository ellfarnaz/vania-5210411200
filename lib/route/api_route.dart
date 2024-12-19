import 'package:farel_123/app/http/controllers/product_controller.dart';
import 'package:farel_123/app/http/controllers/auth_controller.dart';
import 'package:farel_123/app/http/controllers/customer_controller.dart';
import 'package:farel_123/app/http/controllers/vendor_controller.dart';
import 'package:farel_123/app/http/controllers/order_controller.dart';
import 'package:farel_123/app/http/controllers/order_item_controller.dart';
import 'package:farel_123/app/http/controllers/product_note_controller.dart';
import 'package:farel_123/app/http/middleware/authenticate.dart';
import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override
  void register() {
    // Auth Routes
    Router.post('/auth/register', authController.register);
    Router.post('/auth/login', authController.login);
    Router.post('/auth/logout', authController.logout)
        .middleware([AuthenticateMiddleware()]);

    // Product Routes (dengan autentikasi)
    Router.get('/products', productController.index)
        .middleware([AuthenticateMiddleware()]);
    Router.post('/products', productController.store)
        .middleware([AuthenticateMiddleware()]);
    Router.get('/products/{id}', productController.show)
        .middleware([AuthenticateMiddleware()]);
    Router.put('/products/{id}', productController.update)
        .middleware([AuthenticateMiddleware()]);
    Router.delete('/products/{id}', productController.destroy)
        .middleware([AuthenticateMiddleware()]);

    // Customer Routes (dengan autentikasi)
    Router.get('/customers', customerController.index)
        .middleware([AuthenticateMiddleware()]);
    Router.post('/customers', customerController.store)
        .middleware([AuthenticateMiddleware()]);
    Router.get('/customers/{id}', customerController.show)
        .middleware([AuthenticateMiddleware()]);
    Router.put('/customers/{id}', customerController.update)
        .middleware([AuthenticateMiddleware()]);
    Router.delete('/customers/{id}', customerController.destroy)
        .middleware([AuthenticateMiddleware()]);

    // Vendor Routes (dengan autentikasi)
    Router.get('/vendors', vendorController.index)
        .middleware([AuthenticateMiddleware()]);
    Router.post('/vendors', vendorController.store)
        .middleware([AuthenticateMiddleware()]);
    Router.get('/vendors/{id}', vendorController.show)
        .middleware([AuthenticateMiddleware()]);
    Router.put('/vendors/{id}', vendorController.update)
        .middleware([AuthenticateMiddleware()]);
    Router.delete('/vendors/{id}', vendorController.destroy)
        .middleware([AuthenticateMiddleware()]);

    // Order Routes (dengan autentikasi)
    Router.get('/orders', orderController.index)
        .middleware([AuthenticateMiddleware()]);
    Router.post('/orders', orderController.store)
        .middleware([AuthenticateMiddleware()]);
    Router.get('/orders/{id}', orderController.show)
        .middleware([AuthenticateMiddleware()]);
    Router.put('/orders/{id}', orderController.update)
        .middleware([AuthenticateMiddleware()]);
    Router.delete('/orders/{id}', orderController.destroy)
        .middleware([AuthenticateMiddleware()]);

    // OrderItem Routes (dengan autentikasi)
    Router.get('/orderitems', orderItemController.index)
        .middleware([AuthenticateMiddleware()]);
    Router.post('/orderitems', orderItemController.store)
        .middleware([AuthenticateMiddleware()]);
    Router.get('/orderitems/{id}', orderItemController.show)
        .middleware([AuthenticateMiddleware()]);
    Router.put('/orderitems/{id}', orderItemController.update)
        .middleware([AuthenticateMiddleware()]);
    Router.delete('/orderitems/{id}', orderItemController.destroy)
        .middleware([AuthenticateMiddleware()]);

    // ProductNote Routes (dengan autentikasi)
    Router.get('/productnotes', productNoteController.index)
        .middleware([AuthenticateMiddleware()]);
    Router.post('/productnotes', productNoteController.store)
        .middleware([AuthenticateMiddleware()]);
    Router.get('/productnotes/{id}', productNoteController.show)
        .middleware([AuthenticateMiddleware()]);
    Router.put('/productnotes/{id}', productNoteController.update)
        .middleware([AuthenticateMiddleware()]);
    Router.delete('/productnotes/{id}', productNoteController.destroy)
        .middleware([AuthenticateMiddleware()]);
  }
}
