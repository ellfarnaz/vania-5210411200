import 'package:rizky_jago/app/models/product.dart';
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
        'name': 'required|string|max_length:100',
        'description': 'required|string|max_length:255',
        'price': 'required|numeric|min:0',
      }, {
        'name.required': 'Nama produk wajib diisi',
        'name.string': 'Nama produk harus berupa teks',
        'name.max_length': 'Nama produk maksimal 100 karakter',
        'description.required': 'Deskripsi produk wajib diisi',
        'description.string': 'Deskripsi produk harus berupa teks',
        'description.max_length': 'Deskripsi produk maksimal 255 karakter',
        'price.required': 'Harga produk wajib diisi',
        'price.numeric': 'Harga produk harus berupa angka',
        'price.min': 'Harga produk tidak boleh kurang dari 0',
      });

      final productData = request.input();

      // Check existing product
      final existingProduct = await Product()
          .query()
          .where('name', '=', productData['name'])
          .first();

      if (existingProduct != null) {
        return Response.json(
            {'message': 'Produk dengan nama ini sudah ada'}, 409);
      }

      // Add timestamps
      productData['created_at'] = DateTime.now().toIso8601String();
      productData['updated_at'] = DateTime.now().toIso8601String();

      // Insert to database
      final insertedId = await Product().query().insertGetId(productData);

      // Fetch the inserted product
      final insertedProduct = await Product().query().find(insertedId);

      return Response.json({
        'message': 'Produk berhasil ditambahkan',
        'data': insertedProduct,
      }, 201);
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({
          'errors': e.message,
        }, 400);
      }
      return Response.json({
        'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> show(int id) async {
    try {
      final product = await Product().query().find(id);

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

  Future<Response> update(Request request, int id) async {
    try {
      request.validate({
        'name': 'required|string|max_length:100',
        'description': 'required|string|max_length:255',
        'price': 'required|numeric|min:0',
      }, {
        'name.required': 'Nama produk wajib diisi',
        'name.string': 'Nama produk harus berupa teks',
        'name.max_length': 'Nama produk maksimal 100 karakter',
        'description.required': 'Deskripsi produk wajib diisi',
        'description.string': 'Deskripsi produk harus berupa teks',
        'description.max_length': 'Deskripsi produk maksimal 255 karakter',
        'price.required': 'Harga produk wajib diisi',
        'price.numeric': 'Harga produk harus berupa angka',
        'price.min': 'Harga produk tidak boleh kurang dari 0',
      });

      final product = await Product().query().find(id);

      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $id tidak ditemukan',
        }, 404);
      }

      final productData = request.input();
      productData['updated_at'] = DateTime.now().toIso8601String();

      await Product().query().where('id', '=', id).update(productData);

      // Fetch updated product
      final updatedProduct = await Product().query().find(id);

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
        'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> destroy(int id) async {
    try {
      final product = await Product().query().find(id);

      if (product == null) {
        return Response.json(
            {'message': 'Produk dengan ID $id tidak ditemukan'}, 404);
      }

      await Product().query().where('id', '=', id).delete();

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
