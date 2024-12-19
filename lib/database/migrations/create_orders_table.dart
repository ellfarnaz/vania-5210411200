import 'package:vania/vania.dart';

class CreateOrdersTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orders', () {
      integer('order_num');
      date('order_date');
      string('cust_id', length: 5);
      index(ColumnIndex.unique, 'order_num', ['order_num']);
      index(ColumnIndex.unique, 'cust_id', ['cust_id']);
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orders');
  }
}
