part of '../../quds_db.dart';

/// A Blob field for binary data.
class BlobField extends FieldWithValue<Uint8List> {
  /// Create an instance of BlobField
  BlobField({String? columnName, bool? notNull, bool? isUnique})
      : super(columnName, notNull: notNull, isUnique: isUnique);

  /// Get [BlobField] with [n] random bytes
  static BlobField randomBlob(int n) {
    var result = BlobField();
    result.queryBuilder = () => 'RANDOMBLOB($n)';
    return result;
  }

  /// Get [BlobField] with [n] zero bytes
  static BlobField zeroBlob(int n) {
    var result = BlobField();
    result.queryBuilder = () => 'ZEROBLOB($n)';
    return result;
  }

  /// Get [StringField] with `HEX()` function
  StringField hex() {
    var result = StringField();
    result.queryBuilder = () => 'HEX(${buildQuery()})';
    result.parametersBuilder = () => getParameters();
    return result;
  }
}
