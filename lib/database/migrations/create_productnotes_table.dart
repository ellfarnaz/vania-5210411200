import 'package:vania/vania.dart';

class CreateProductnotesTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('productnotes', () {
      string('note_id', length: 5);
      string('prod_id', length: 10);
      date('note_date');
      text('note_text');
      index(ColumnIndex.unique, 'note_id', ['note_id']);
      index(ColumnIndex.unique, 'prod_id', ['prod_id']);
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('productnotes');
  }
}
