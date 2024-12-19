import 'package:vania/vania.dart';

class CreateUserTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('users', () {
      id();
      string('name', length: 100);
      string('email', length: 100, unique: true);
      string('password', length: 255);
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('users');
  }
}
