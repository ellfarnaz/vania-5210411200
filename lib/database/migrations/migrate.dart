import 'dart:io';
import 'package:vania/vania.dart';
import 'create_users_table.dart';
import 'create_products_table.dart';
import 'create_items_table.dart';
import 'create_personal_access_tokens_table.dart';
import 'create_customers_table.dart';
import 'create_orders_table.dart';
import 'create_orderitems_table.dart';
import 'create_vendors_table.dart';
import 'create_productnotes_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
    await CreateUserTable().up();
    await CreateVendorsTable().up();
    await CreateProductsTable().up();
    await CreateItemsTable().up();
    await CreatePersonalAccessTokensTable().up();
    await CreateCustomersTable().up();
    await CreateOrdersTable().up();
    await CreateOrderitemsTable().up();
    await CreateProductnotesTable().up();
  }

  dropTables() async {
    await CreateProductnotesTable().down();
    await CreateOrderitemsTable().down();
    await CreateOrdersTable().down();
    await CreateCustomersTable().down();
    await CreatePersonalAccessTokensTable().down();
    await CreateItemsTable().down();
    await CreateProductsTable().down();
    await CreateVendorsTable().down();
    await CreateUserTable().down();
  }
}
