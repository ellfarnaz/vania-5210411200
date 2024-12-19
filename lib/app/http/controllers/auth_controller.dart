import 'package:vania/vania.dart';
import 'package:farel_123/app/models/user.dart';

class AuthController extends Controller {
  Future<Response> register(Request request) async {
    try {
      request.validate({
        'name': 'required|string|max_length:100',
        'email': 'required|email',
        'password': 'required|string|min_length:6',
      }, {
        'name.required': 'Nama wajib diisi',
        'name.string': 'Nama harus berupa teks',
        'name.max_length': 'Nama maksimal 100 karakter',
        'email.required': 'Email wajib diisi',
        'email.email': 'Format email tidak valid',
        'password.required': 'Password wajib diisi',
        'password.min_length': 'Password minimal 6 karakter',
      });

      final userData = request.input();

      // Cek email yang sudah terdaftar
      final existingUser =
          await User().query().where('email', '=', userData['email']).first();

      if (existingUser != null) {
        return Response.json({'message': 'Email sudah terdaftar'}, 409);
      }

      // Hash password menggunakan bcrypt
      final hasher = Hash();
      userData['password'] = hasher.make(userData['password']);

      // Tambah timestamps
      userData['created_at'] = DateTime.now().toIso8601String();
      userData['updated_at'] = DateTime.now().toIso8601String();

      // Insert ke database
      await User().query().insert(userData);

      return Response.json({
        'message': 'Registrasi berhasil',
      }, 201);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat registrasi',
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> login(Request request) async {
    try {
      request.validate({
        'email': 'required|email',
        'password': 'required',
      }, {
        'email.required': 'Email wajib diisi',
        'email.email': 'Format email tidak valid',
        'password.required': 'Password wajib diisi',
      });

      final email = request.input('email');
      final password = request.input('password');

      // Cek user berdasarkan email
      final user = await User().query().where('email', '=', email).first();

      if (user == null) {
        return Response.json({
          'message': 'Email atau password salah',
        }, 401);
      }

      // Verifikasi password
      final hasher = Hash();
      if (!hasher.verify(password, user['password'])) {
        return Response.json({
          'message': 'Email atau password salah',
        }, 401);
      }

      // Generate token
      final token = await Auth().login(user).createToken(
            expiresIn: Duration(days: 30),
            withRefreshToken: true,
          );

      return Response.json({
        'message': 'Login berhasil',
        'token': token,
      }, 200);
    } catch (e) {
      return Response.json(
          {'message': 'Terjadi kesalahan saat login', 'error': e.toString()},
          500);
    }
  }

  Future<Response> logout(Request request) async {
    try {
      // Implementasi logout manual atau menggunakan middleware
      return Response.json({
        'message': 'Logout berhasil',
      }, 200);
    } catch (e) {
      return Response.json(
          {'message': 'Terjadi kesalahan saat logout', 'error': e.toString()},
          500);
    }
  }
}

final AuthController authController = AuthController();
