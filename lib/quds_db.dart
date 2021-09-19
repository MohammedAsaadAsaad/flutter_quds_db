/// A sqflite expansion package that simplifies creating databases and tables, crud operations, queries with modelization
library sqlite_quds_db;

// import 'dart:ffi';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:core';
import 'dart:ui';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'quds_db/support_functions/support_functions.dart';

// library quds_db;
part 'quds_db/data_page_query.dart';
part 'quds_db/data_page_query_result.dart';
part 'quds_db/db_functions.dart';
part 'quds_db/db_helper.dart';
part 'quds_db/db_model.dart';
part 'quds_db/db_table_provider.dart';
part 'quds_db/entry_change_type.dart';
part 'quds_db/database_operations.dart';

//Query parts
part 'quds_db/query_parts/query_part.dart';
part 'quds_db/query_parts/condition.dart';
part 'quds_db/query_parts/field_with_value.dart';
part 'quds_db/query_parts/order_field.dart';
part 'quds_db/query_parts/operator_query.dart';

//Db fields
part 'quds_db/db_fields/enum_field.dart';
part 'quds_db/db_fields/blob_field.dart';
part 'quds_db/db_fields/bool_field.dart';
part 'quds_db/db_fields/color_field.dart';
part 'quds_db/db_fields/datetime_field.dart';
part 'quds_db/db_fields/double_field.dart';
part 'quds_db/db_fields/int_field.dart';
part 'quds_db/db_fields/num_field.dart';
part 'quds_db/db_fields/string_field.dart';
part 'quds_db/db_fields/json_field.dart';
part 'quds_db/db_fields/id_field.dart';
part 'quds_db/db_fields/datetime_string_field.dart';
