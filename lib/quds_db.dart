/// A sqflite expansion package that simplifies creating databases and tables, crud operations, queries with modelization
library sqlite_quds_db;

// import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common/sqlite_api.dart' as sqlite_api;
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:core';
import 'dart:ui';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;

// library quds_db;
part 'quds_db/data_page_query.dart';
part 'quds_db/data_page_query_result.dart';
part 'quds_db/db_functions.dart';
part 'quds_db/db_helper.dart';
// part 'quds_db/_web_sql_helper.dart';
part 'quds_db/db_model.dart';
part 'quds_db/db_table_provider.dart';
part 'quds_db/entry_change_type.dart';

//Query parts
part 'quds_db/query_parts/query_part.dart';
part 'quds_db/query_parts/condition.dart';
part 'quds_db/query_parts/field_with_value.dart';
part 'quds_db/query_parts/order_field.dart';
part 'quds_db/query_parts/operator_query.dart';

//Db fields
part 'quds_db/db_fields/blob_field.dart';
part 'quds_db/db_fields/bool_field.dart';
part 'quds_db/db_fields/color_field.dart';
part 'quds_db/db_fields/datetime_field.dart';
part 'quds_db/db_fields/double_field.dart';
part 'quds_db/db_fields/int_field.dart';
part 'quds_db/db_fields/num_field.dart';
part 'quds_db/db_fields/string_field.dart';
part 'quds_db/db_fields/id_field.dart';
part 'quds_db/db_fields/datetime_string_field.dart';
