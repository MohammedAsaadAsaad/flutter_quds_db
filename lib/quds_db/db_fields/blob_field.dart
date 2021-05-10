import 'dart:typed_data';
import '../../quds_db.dart';

class BlobField extends FieldWithValue<Uint8List> {
  BlobField({String? columnName, bool? notNull, bool? isUnique})
      : super(columnName, notNull: notNull, isUnique: isUnique);

  static BlobField randomBlob(int n) {
    var result = BlobField();
    result.queryBuilder = () => 'RANDOMBLOB($n)';
    return result;
  }

  static BlobField zeroBlob(int n) {
    var result = BlobField();
    result.queryBuilder = () => 'ZEROBLOB($n)';
    return result;
  }

  StringField hex() {
    var result = StringField();
    result.queryBuilder = () => 'HEX(${this.buildQuery()})';
    result.parametersBuilder = () => this.getParameters();
    return result;
  }
}
