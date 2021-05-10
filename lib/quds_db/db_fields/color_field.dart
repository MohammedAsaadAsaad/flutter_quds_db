import 'dart:ui';

import '../../quds_db.dart';

class ColorField extends FieldWithValue<Color> {
  ColorField(
      {String? columnName, bool? notNull, bool? isUnique, String? jsonMapName})
      : super(columnName,
            notNull: notNull,
            isUnique: isUnique,
            jsonMapName: jsonMapName,
            jsonMapType: Color);
}
