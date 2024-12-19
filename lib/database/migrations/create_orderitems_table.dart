import 'package:vania/vania.dart';

class CreateOrderitemsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orderitems', () {
      integer('order_item');
      integer('order_num');
      string('prod_id', length: 10);
      integer('quantity');
      integer('size');
      index(ColumnIndex.unique, 'order_item', ['order_item']);
      index(ColumnIndex.unique, 'order_num', ['order_num']);
      index(ColumnIndex.unique, 'prod_id', ['prod_id']);
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orderitems');
  }
}
