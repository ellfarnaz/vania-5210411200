import 'package:vania/vania.dart';
import 'package:farel_123/app/models/product_note.dart';

class ProductNoteController extends Controller {
  Future<Response> index() async {
    try {
      final productNotes = await ProductNote().query().get();
      return Response.json({
        'message': 'Daftar product note berhasil diambil',
        'data': productNotes,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data product note',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'note_id': 'required|string|max_length:5',
        'prod_id': 'required|string|max_length:10',
        'note_date': 'required|date',
        'note_text': 'required|string',
      });

      final productNoteData = request.input();

      // Check existing product note
      final existingProductNote = await ProductNote()
          .query()
          .where('note_id', '=', productNoteData['note_id'])
          .first();

      if (existingProductNote != null) {
        return Response.json(
            {'message': 'Product note dengan ID ini sudah ada'}, 409);
      }

      // Add timestamps
      productNoteData['created_at'] = DateTime.now().toIso8601String();
      productNoteData['updated_at'] = DateTime.now().toIso8601String();

      // Insert to database
      await ProductNote().query().insert(productNoteData);

      return Response.json({
        'message': 'Product note berhasil ditambahkan',
        'data': productNoteData,
      }, 201);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menambahkan product note',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> show(String id) async {
    try {
      final productNote =
          await ProductNote().query().where('note_id', '=', id).first();

      if (productNote == null) {
        return Response.json({'message': 'Product note tidak ditemukan'}, 404);
      }

      return Response.json({
        'message': 'Detail product note',
        'data': productNote,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil detail product note',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> update(Request request, String id) async {
    try {
      request.validate({
        'prod_id': 'required|string|max_length:10',
        'note_date': 'required|date',
        'note_text': 'required|string',
      });

      final productNote =
          await ProductNote().query().where('note_id', '=', id).first();

      if (productNote == null) {
        return Response.json({
          'message': 'Product note dengan ID $id tidak ditemukan',
        }, 404);
      }

      final productNoteData = request.input();
      productNoteData['updated_at'] = DateTime.now().toIso8601String();

      await ProductNote()
          .query()
          .where('note_id', '=', id)
          .update(productNoteData);

      final updatedProductNote =
          await ProductNote().query().where('note_id', '=', id).first();

      return Response.json({
        'message': 'Product note berhasil diperbarui',
        'data': updatedProductNote,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat memperbarui product note',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> destroy(String id) async {
    try {
      final productNote =
          await ProductNote().query().where('note_id', '=', id).first();

      if (productNote == null) {
        return Response.json(
            {'message': 'Product note dengan ID $id tidak ditemukan'}, 404);
      }

      await ProductNote().query().where('note_id', '=', id).delete();

      return Response.json({
        'message': 'Product note berhasil dihapus',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus product note',
        'error': e.toString(),
      }, 500);
    }
  }
}

final ProductNoteController productNoteController = ProductNoteController();
