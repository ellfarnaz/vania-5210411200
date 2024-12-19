import 'package:vania/vania.dart';
import 'package:farel_123/app/models/order_item.dart';

class OrderItemController extends Controller {
  Future<Response> index() async {
    try {
      final orderItems = await OrderItem().query().get();
      return Response.json({
        'message': 'Daftar order item berhasil diambil',
        'data': orderItems,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data order item',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'order_item': 'required|integer',
        'order_num': 'required|integer',
        'prod_id': 'required|string|max_length:10',
        'quantity': 'required|integer',
        'size': 'required|integer',
      });

      final orderItemData = request.input();

      // Check existing order item
      final existingOrderItem = await OrderItem()
          .query()
          .where('order_item', '=', orderItemData['order_item'])
          .first();

      if (existingOrderItem != null) {
        return Response.json(
            {'message': 'Order item dengan ID ini sudah ada'}, 409);
      }

      // Add timestamps
      orderItemData['created_at'] = DateTime.now().toIso8601String();
      orderItemData['updated_at'] = DateTime.now().toIso8601String();

      // Insert to database
      await OrderItem().query().insert(orderItemData);

      return Response.json({
        'message': 'Order item berhasil ditambahkan',
        'data': orderItemData,
      }, 201);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menambahkan order item',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> show(int id) async {
    try {
      final orderItem =
          await OrderItem().query().where('order_item', '=', id).first();

      if (orderItem == null) {
        return Response.json({'message': 'Order item tidak ditemukan'}, 404);
      }

      return Response.json({
        'message': 'Detail order item',
        'data': orderItem,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil detail order item',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> update(Request request, int id) async {
    try {
      request.validate({
        'order_num': 'required|integer',
        'prod_id': 'required|string|max_length:10',
        'quantity': 'required|integer',
        'size': 'required|integer',
      });

      final orderItem =
          await OrderItem().query().where('order_item', '=', id).first();

      if (orderItem == null) {
        return Response.json({
          'message': 'Order item dengan ID $id tidak ditemukan',
        }, 404);
      }

      final orderItemData = request.input();
      orderItemData['updated_at'] = DateTime.now().toIso8601String();

      await OrderItem()
          .query()
          .where('order_item', '=', id)
          .update(orderItemData);

      final updatedOrderItem =
          await OrderItem().query().where('order_item', '=', id).first();

      return Response.json({
        'message': 'Order item berhasil diperbarui',
        'data': updatedOrderItem,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat memperbarui order item',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> destroy(int id) async {
    try {
      final orderItem =
          await OrderItem().query().where('order_item', '=', id).first();

      if (orderItem == null) {
        return Response.json(
            {'message': 'Order item dengan ID $id tidak ditemukan'}, 404);
      }

      await OrderItem().query().where('order_item', '=', id).delete();

      return Response.json({
        'message': 'Order item berhasil dihapus',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus order item',
        'error': e.toString(),
      }, 500);
    }
  }
}

final OrderItemController orderItemController = OrderItemController();
