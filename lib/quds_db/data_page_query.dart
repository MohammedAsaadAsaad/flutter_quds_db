part of '../quds_db.dart';

/// Represnts db page query.
class DataPageQuery<T> {
  /// The desired page.
  final int page;

  /// The results desired count per page.
  final int resultsPerPage;

  /// Create an instance of [DataPageQuery]
  DataPageQuery({required this.page, required this.resultsPerPage});
}
