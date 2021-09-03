part of '../../quds_db.dart';

/// Enum db field representation.
/// With this field you can save enums in database
/// ```dart
/// enum Gender {
/// male,
/// female,
/// notSpecified
/// }
/// class Person extends DbModel{
/// var gender = EnumField<Gender>(columnName: 'gender',
/// valuesMap:{
/// 1:Gender.male,
/// 2:Gender.female,
/// 0:Gender.notSpecified});
/// }
/// ```
class EnumField<T> extends FieldWithValue<T> {
  /// Create an instance of [EnumField]
  EnumField(
      {String? columnName,
      bool? notNull,
      bool? isUnique,
      String? jsonMapName,
      required Map<int, T> valuesMap})
      : assert(valuesMap.keys.length > 0, 'Map must have entries'),
        super(
          columnName,
          notNull: notNull,
          isUnique: isUnique,
          jsonMapName: jsonMapName,
          jsonMapType: int,
        ) {
    this._valuesMap = _BiMap<int, T>()..addAll(valuesMap);
  }

  late _BiMap<int, T> _valuesMap;

  T? value;
  Type get valueType => int;

  /// Get the field value in db storable tyle.
  get dbValue => _valuesMap._inverse[value];

  /// Set the field value in db storable tyle.
  set dbValue(dynamic dbValue) => value = _valuesMap[dbValue];
}

class _BiMap<K, V> implements Map<K, V> {
  Map<K, V> _map = {};
  Map<V, K> _inverse = {};
  @override
  V? operator [](Object? key) {
    return _map[key];
  }

  @override
  void operator []=(K key, V value) {
    _map[key] = value;
    _inverse[value] = key;
  }

  @override
  void addAll(Map<K, V> other) {
    _map.addAll(other);
    _inverse.addAll({for (var e in other.entries) e.value: e.key});
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    for (var e in newEntries) this[e.key] = e.value;
  }

  @override
  Map<RK, RV> cast<RK, RV>() {
    throw UnimplementedError();
  }

  @override
  void clear() {
    _map.clear();
    _inverse.clear();
  }

  @override
  bool containsKey(Object? key) {
    return _map.containsKey(key);
  }

  bool inverseContainsKey(Object? key) {
    return _inverse.containsKey(key);
  }

  @override
  bool containsValue(Object? value) {
    return _map.containsValue(value);
  }

  bool inverseContainsValue(Object? value) {
    return _inverse.containsValue(value);
  }

  @override
  Iterable<MapEntry<K, V>> get entries => _map.entries;

  Iterable<MapEntry<V, K>> get inverseEntries => _inverse.entries;

  @override
  void forEach(void Function(K key, V value) action) {
    _map.forEach(action);
  }

  void inverseForEach(void Function(V key, K value) action) {
    _inverse.forEach(action);
  }

  @override
  bool get isEmpty => _map.isEmpty;

  @override
  bool get isNotEmpty => _map.isNotEmpty;

  @override
  Iterable<K> get keys => _map.keys;

  Iterable<V> get inverseKeys => _inverse.keys;

  @override
  int get length => _map.length;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert) {
    return _map.map(convert);
  }

  Map<V2, K2> inverseMap<K2, V2>(
      MapEntry<V2, K2> Function(V key, K value) convert) {
    return _inverse.map(convert);
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    var v = _map.putIfAbsent(key, ifAbsent);
    if (v != null) _inverse[v] = key;
    return v;
  }

  @override
  V? remove(Object? key) {
    var v = _map.remove(key);
    if (v != null) _inverse.remove(v);
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    var entries = _map.entries.toList();
    for (var e in entries) {
      if (test(e.key, e.value)) {
        _map.remove(e.key);
        _inverse.remove(e.value);
      }
    }
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    throw UnimplementedError();
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    throw UnimplementedError();
  }

  @override
  Iterable<V> get values => _map.values;
  Iterable<K> get inverseValues => _inverse.values;
}
