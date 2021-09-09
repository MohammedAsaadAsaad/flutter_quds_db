part of '../quds_db.dart';

/// Represents the change type in some table.
enum EntryChangeType {
  /// New row has been inserted.
  Insertion,

  /// Some row has been modified.
  Modification,

  /// Some row has been deleted.
  Deletion
}
