import 'package:vania/vania.dart';

class CreateItemsTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('items', () {
      id();
      timeStamps();
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('items');
  }
}
