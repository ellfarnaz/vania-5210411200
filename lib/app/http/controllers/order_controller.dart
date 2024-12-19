import 'package:vania/vania.dart';
import 'package:farel_123/app/models/order.dart';

class OrderController extends Controller {
  Future<Response> index() async {
    try {
      final orders = await Order().query().get();
      return Response.json({
        'message': 'Daftar order berhasil diambil',
        'data': orders,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data order',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'order_num': 'required|integer',
        'order_date': 'required|date',
        'cust_id': 'required|string|max_length:5',
      });

      final orderData = request.input();

      // Check existing order
      final existingOrder = await Order()
          .query()
          .where('order_num', '=', orderData['order_num'])
          .first();

      if (existingOrder != null) {
        return Response.json(
            {'message': 'Order dengan nomor ini sudah ada'}, 409);
      }

      // Add timestamps
      orderData['created_at'] = DateTime.now().toIso8601String();
      orderData['updated_at'] = DateTime.now().toIso8601String();

      // Insert to database
      await Order().query().insert(orderData);

      return Response.json({
        'message': 'Order berhasil ditambahkan',
        'data': orderData,
      }, 201);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menambahkan order',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> show(int id) async {
    try {
      final order = await Order().query().where('order_num', '=', id).first();

      if (order == null) {
        return Response.json({'message': 'Order tidak ditemukan'}, 404);
      }

      return Response.json({
        'message': 'Detail order',
        'data': order,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil detail order',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> update(Request request, int id) async {
    try {
      request.validate({
        'order_date': 'required|date',
        'cust_id': 'required|string|max_length:5',
      });

      final order = await Order().query().where('order_num', '=', id).first();

      if (order == null) {
        return Response.json({
          'message': 'Order dengan nomor $id tidak ditemukan',
        }, 404);
      }

      final orderData = request.input();
      orderData['updated_at'] = DateTime.now().toIso8601String();

      await Order().query().where('order_num', '=', id).update(orderData);

      final updatedOrder =
          await Order().query().where('order_num', '=', id).first();

      return Response.json({
        'message': 'Order berhasil diperbarui',
        'data': updatedOrder,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat memperbarui order',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> destroy(int id) async {
    try {
      final order = await Order().query().where('order_num', '=', id).first();

      if (order == null) {
        return Response.json(
            {'message': 'Order dengan nomor $id tidak ditemukan'}, 404);
      }

      await Order().query().where('order_num', '=', id).delete();

      return Response.json({
        'message': 'Order berhasil dihapus',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus order',
        'error': e.toString(),
      }, 500);
    }
  }
}

final OrderController orderController = OrderController();
