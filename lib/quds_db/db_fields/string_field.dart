import '../../quds_db.dart';

class StringField extends FieldWithValue<String> {
  StringField(
      {String? columnName,
      bool? notNull,
      bool? isUnique,
      String? jsonMapName,
      String? defaultValue})
      : super(columnName,
            notNull: notNull,
            isUnique: isUnique,
            jsonMapName: jsonMapName,
            jsonMapType: String) {
    value = defaultValue;
  }

  StringField toLowerCase() {
    var result = StringField();
    result.queryBuilder = () => 'LOWER(${this.buildQuery()})';
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  StringField toUpperCase() {
    var result = StringField();
    result.queryBuilder = () => 'UPPER(${this.buildQuery()})';
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  StringField subString(int startIndex, int length) {
    var result = StringField();
    result.queryBuilder =
        () => 'SUBSTR(${this.buildQuery()},$startIndex,$length)';
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  IntField unicodeOfFirstCharacter() {
    var result = IntField();
    result.queryBuilder = () => 'UNICODE(${this.buildQuery()})';
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  StringField replace(String pattern, dynamic replacement) {
    assert(replacement is String || replacement is StringField);

    var result = StringField();
    result.queryBuilder = () => replacement is StringField
        ? 'REPLACE(${this.buildQuery()},?,${replacement.buildQuery()})'
        : 'REPLACE(${this.buildQuery()},?,?)';
    result.parametersBuilder = () => this.getParameters()
      ..addAll([pattern, if (replacement is String) replacement]);
    return result;
  }

  IntField indexOf(dynamic str) {
    assert(str is String || str is StringField);

    var result = IntField();
    result.queryBuilder = () => str is StringField
        ? 'INSTR(${this.buildQuery()},${str.buildQuery()})'
        : 'INSTR(${this.buildQuery()},?)';
    result.parametersBuilder =
        () => this.getParameters()..addAll([if (str is String) str]);
    return result;
  }

  StringField _buildTrimFunction(String trimName, String? ch) {
    var result = StringField();
    result.queryBuilder = () => (ch != null && ch.isNotEmpty)
        ? '$trimName(${this.buildQuery()},?)'
        : '$trimName(${this.buildQuery()})';
    result.parametersBuilder = () =>
        this.getParameters()..addAll([if ((ch != null && ch.isNotEmpty)) ch]);
    return result;
  }

  StringField trim([String? ch]) => _buildTrimFunction('TRIM', ch);
  StringField trimLeft([String? ch]) => _buildTrimFunction('LTRIM', ch);
  StringField trimRight([String? ch]) => _buildTrimFunction('RTRIM', ch);

  IntField get length {
    var result = IntField();
    result.queryBuilder = () => 'LENGTH(${this.buildQuery()})';
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  StringField concat(dynamic other) {
    assert(other is String || other is StringField);

    var result = StringField();
    result.queryBuilder = () =>
        '(${this.buildQuery()} || ' +
        (other is StringField ? other.buildQuery() : '?') +
        ')';
    result.parametersBuilder = () => this.getParameters()
      ..addAll(
          [if (other is StringField) ...(other.getParameters()) else other]);

    return result;
  }

  StringField operator +(other) => concat(other);

  ConditionQuery contains(String text) {
    return ConditionQuery(
        before: this, after: '%$text%', operatorString: 'LIKE');
  }

  ConditionQuery endsWith(String text) {
    return ConditionQuery(
        before: this, after: '%$text', operatorString: 'LIKE');
  }

  ConditionQuery startsWith(String text) {
    return ConditionQuery(
        before: this, after: '$text%', operatorString: 'LIKE');
  }

  OrderField get longerOrder {
    OrderField result = OrderField();
    result.queryBuilder = () => 'LENGTH(' + this.buildQuery() + ') DESC';
    result.parametersBuilder = () => this.getParameters();
    return result;
  }

  OrderField get shorterOrder {
    OrderField result = OrderField();
    result.queryBuilder = () => 'LENGTH(' + this.buildQuery() + ') ASC';
    result.parametersBuilder = () => this.getParameters();
    return result;
  }
}
