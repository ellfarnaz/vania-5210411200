import 'package:farel_123/app/models/product.dart';
import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';

class ProductController extends Controller {
  Future<Response> index() async {
    try {
      final products = await Product().query().get();
      return Response.json({
        'message': 'Daftar produk berhasil diambil',
        'data': products,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data produk',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'prod_id': 'required|string|max_length:10',
        'vend_id': 'required|string|max_length:5',
        'prod_name': 'required|string|max_length:25',
        'prod_price': 'required|integer',
        'prod_desc': 'required|string',
      }, {
        'prod_id.required': 'ID produk wajib diisi',
        'prod_id.string': 'ID produk harus berupa teks',
        'prod_id.max_length': 'ID produk maksimal 10 karakter',
        'vend_id.required': 'ID vendor wajib diisi',
        'vend_id.string': 'ID vendor harus berupa teks',
        'vend_id.max_length': 'ID vendor maksimal 5 karakter',
        'prod_name.required': 'Nama produk wajib diisi',
        'prod_name.string': 'Nama produk harus berupa teks',
        'prod_name.max_length': 'Nama produk maksimal 25 karakter',
        'prod_price.required': 'Harga produk wajib diisi',
        'prod_price.integer': 'Harga produk harus berupa angka',
        'prod_desc.required': 'Deskripsi produk wajib diisi',
        'prod_desc.string': 'Deskripsi produk harus berupa teks',
      });

      final productData = request.input();

      // Check existing product
      final existingProduct = await Product()
          .query()
          .where('prod_id', '=', productData['prod_id'])
          .first();

      if (existingProduct != null) {
        return Response.json(
            {'message': 'Produk dengan ID ini sudah ada'}, 409);
      }

      // Add timestamps
      productData['created_at'] = DateTime.now().toIso8601String();
      productData['updated_at'] = DateTime.now().toIso8601String();

      // Insert to database
      await Product().query().insert(productData);

      return Response.json({
        'message': 'Produk berhasil ditambahkan',
        'data': productData,
      }, 201);
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({
          'errors': e.message,
        }, 400);
      }
      return Response.json({
        'message': 'Terjadi kesalahan saat menambahkan produk',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> show(String id) async {
    try {
      final product = await Product().query().where('prod_id', '=', id).first();

      if (product == null) {
        return Response.json({'message': 'Produk tidak ditemukan'}, 404);
      }

      return Response.json({
        'message': 'Detail produk',
        'data': product,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil detail produk',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> update(Request request, String id) async {
    try {
      request.validate({
        'vend_id': 'required|string|max_length:5',
        'prod_name': 'required|string|max_length:25',
        'prod_price': 'required|integer',
        'prod_desc': 'required|string',
      }, {
        'vend_id.required': 'ID vendor wajib diisi',
        'vend_id.string': 'ID vendor harus berupa teks',
        'vend_id.max_length': 'ID vendor maksimal 5 karakter',
        'prod_name.required': 'Nama produk wajib diisi',
        'prod_name.string': 'Nama produk harus berupa teks',
        'prod_name.max_length': 'Nama produk maksimal 25 karakter',
        'prod_price.required': 'Harga produk wajib diisi',
        'prod_price.integer': 'Harga produk harus berupa angka',
        'prod_desc.required': 'Deskripsi produk wajib diisi',
        'prod_desc.string': 'Deskripsi produk harus berupa teks',
      });

      final product = await Product().query().where('prod_id', '=', id).first();

      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $id tidak ditemukan',
        }, 404);
      }

      final productData = request.input();
      productData['updated_at'] = DateTime.now().toIso8601String();

      // Hapus id dari productData jika ada
      productData.remove('id');

      await Product().query().where('prod_id', '=', id).update(productData);

      final updatedProduct =
          await Product().query().where('prod_id', '=', id).first();

      return Response.json({
        'message': 'Produk berhasil diperbarui',
        'data': updatedProduct,
      }, 200);
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({
          'errors': e.message,
        }, 400);
      }
      return Response.json({
        'message': 'Terjadi kesalahan saat memperbarui produk',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> destroy(String id) async {
    try {
      final product = await Product().query().where('prod_id', '=', id).first();

      if (product == null) {
        return Response.json(
            {'message': 'Produk dengan ID $id tidak ditemukan'}, 404);
      }

      await Product().query().where('prod_id', '=', id).delete();

      return Response.json({
        'message': 'Produk berhasil dihapus',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus produk',
        'error': e.toString(),
      }, 500);
    }
  }
}

final ProductController productController = ProductController();
