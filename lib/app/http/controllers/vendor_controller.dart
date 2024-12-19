import 'package:vania/vania.dart';
import 'package:farel_123/app/models/vendor.dart';

class VendorController extends Controller {
  Future<Response> index() async {
    try {
      final vendors = await Vendor().query().get();
      return Response.json({
        'message': 'Daftar vendor berhasil diambil',
        'data': vendors,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data vendor',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'vend_id': 'required|string|max_length:5',
        'vend_name': 'required|string|max_length:50',
        'vend_address': 'required|string',
        'vend_kota': 'required|string',
        'vend_state': 'required|string|max_length:5',
        'vend_zip': 'required|string|max_length:7',
        'vend_country': 'required|string|max_length:25',
      });

      final vendorData = request.input();

      // Check existing vendor
      final existingVendor = await Vendor()
          .query()
          .where('vend_id', '=', vendorData['vend_id'])
          .first();

      if (existingVendor != null) {
        return Response.json(
            {'message': 'Vendor dengan ID ini sudah ada'}, 409);
      }

      // Add timestamps
      vendorData['created_at'] = DateTime.now().toIso8601String();
      vendorData['updated_at'] = DateTime.now().toIso8601String();

      // Insert to database
      await Vendor().query().insert(vendorData);

      return Response.json({
        'message': 'Vendor berhasil ditambahkan',
        'data': vendorData,
      }, 201);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menambahkan vendor',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> show(String id) async {
    try {
      final vendor = await Vendor().query().where('vend_id', '=', id).first();

      if (vendor == null) {
        return Response.json({'message': 'Vendor tidak ditemukan'}, 404);
      }

      return Response.json({
        'message': 'Detail vendor',
        'data': vendor,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil detail vendor',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> update(Request request, String id) async {
    try {
      request.validate({
        'vend_name': 'required|string|max_length:50',
        'vend_address': 'required|string',
        'vend_kota': 'required|string',
        'vend_state': 'required|string|max_length:5',
        'vend_zip': 'required|string|max_length:7',
        'vend_country': 'required|string|max_length:25',
      });

      final vendor = await Vendor().query().where('vend_id', '=', id).first();

      if (vendor == null) {
        return Response.json({
          'message': 'Vendor dengan ID $id tidak ditemukan',
        }, 404);
      }

      final vendorData = request.input();
      vendorData['updated_at'] = DateTime.now().toIso8601String();

      await Vendor().query().where('vend_id', '=', id).update(vendorData);

      final updatedVendor =
          await Vendor().query().where('vend_id', '=', id).first();

      return Response.json({
        'message': 'Vendor berhasil diperbarui',
        'data': updatedVendor,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat memperbarui vendor',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> destroy(String id) async {
    try {
      final vendor = await Vendor().query().where('vend_id', '=', id).first();

      if (vendor == null) {
        return Response.json(
            {'message': 'Vendor dengan ID $id tidak ditemukan'}, 404);
      }

      await Vendor().query().where('vend_id', '=', id).delete();

      return Response.json({
        'message': 'Vendor berhasil dihapus',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus vendor',
        'error': e.toString(),
      }, 500);
    }
  }
}

final VendorController vendorController = VendorController();
