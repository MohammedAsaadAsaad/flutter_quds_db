import '../src/sqflite_ffi_impl.dart';
import '../src/sqflite_import.dart';

/// Ffi exception.
class SqfliteFfiException extends SqfliteDatabaseException {
  /// Ffi exception.
  SqfliteFfiException(
      {required this.code,
      required String message,
      this.details,
      int? resultCode})
      : super(message, details, resultCode: resultCode);

  /// The database.
  SqfliteFfiDatabase? database;

  /// SQL statement.
  String? sql;

  /// SQL arguments.
  List<Object?>? sqlArguments;

  /// Error code.
  final String code;

  /// Error details.
  Map<String, Object?>? details;

  int? get _resultCode => getResultCode();

  @override
  String toString() {
    var map = <String, Object?>{};
    if (details != null) {
      if (details is Map) {
        var detailsMap = Map.from(details!).cast<String, Object?>();

        /// remove sql and arguments that we h
        detailsMap.remove('arguments');
        detailsMap.remove('sql');
        if (detailsMap.isNotEmpty) {
          map['details'] = detailsMap;
        }
      } else {
        map['details'] = details;
      }
    }
    return 'SqfliteFfiException($code${_resultCode == null ? '' : ': $_resultCode, '}, $message} ${super.toString()} $map';
  }
}
