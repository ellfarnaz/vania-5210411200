import 'package:vania/vania.dart';
import 'package:farel_123/app/models/customer.dart';

class CustomerController extends Controller {
  Future<Response> index() async {
    try {
      final customers = await Customer().query().get();
      return Response.json({
        'message': 'Daftar customer berhasil diambil',
        'data': customers,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data customer',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'cust_id': 'required|string|max_length:5',
        'cust_name': 'required|string|max_length:50',
        'cust_address': 'required|string|max_length:50',
        'cust_city': 'required|string|max_length:20',
        'cust_state': 'required|string|max_length:5',
        'cust_zip': 'required|string|max_length:7',
        'cust_country': 'required|string|max_length:25',
        'cust_telp': 'required|string|max_length:15',
      });

      final customerData = request.input();

      // Check existing customer
      final existingCustomer = await Customer()
          .query()
          .where('cust_id', '=', customerData['cust_id'])
          .first();

      if (existingCustomer != null) {
        return Response.json(
            {'message': 'Customer dengan ID ini sudah ada'}, 409);
      }

      // Add timestamps
      customerData['created_at'] = DateTime.now().toIso8601String();
      customerData['updated_at'] = DateTime.now().toIso8601String();

      // Insert to database
      await Customer().query().insert(customerData);

      return Response.json({
        'message': 'Customer berhasil ditambahkan',
        'data': customerData,
      }, 201);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menambahkan customer',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> show(String id) async {
    try {
      final customer =
          await Customer().query().where('cust_id', '=', id).first();

      if (customer == null) {
        return Response.json({'message': 'Customer tidak ditemukan'}, 404);
      }

      return Response.json({
        'message': 'Detail customer',
        'data': customer,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil detail customer',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> update(Request request, String id) async {
    try {
      request.validate({
        'cust_name': 'required|string|max_length:50',
        'cust_address': 'required|string|max_length:50',
        'cust_city': 'required|string|max_length:20',
        'cust_state': 'required|string|max_length:5',
        'cust_zip': 'required|string|max_length:7',
        'cust_country': 'required|string|max_length:25',
        'cust_telp': 'required|string|max_length:15',
      });

      final customer =
          await Customer().query().where('cust_id', '=', id).first();

      if (customer == null) {
        return Response.json({
          'message': 'Customer dengan ID $id tidak ditemukan',
        }, 404);
      }

      final customerData = request.input();
      customerData['updated_at'] = DateTime.now().toIso8601String();

      await Customer().query().where('cust_id', '=', id).update(customerData);

      final updatedCustomer =
          await Customer().query().where('cust_id', '=', id).first();

      return Response.json({
        'message': 'Customer berhasil diperbarui',
        'data': updatedCustomer,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat memperbarui customer',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> destroy(String id) async {
    try {
      final customer =
          await Customer().query().where('cust_id', '=', id).first();

      if (customer == null) {
        return Response.json(
            {'message': 'Customer dengan ID $id tidak ditemukan'}, 404);
      }

      await Customer().query().where('cust_id', '=', id).delete();

      return Response.json({
        'message': 'Customer berhasil dihapus',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus customer',
        'error': e.toString(),
      }, 500);
    }
  }
}

final CustomerController customerController = CustomerController();
