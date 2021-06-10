part of '../quds_db.dart';

/// Represents a query result with pagination.
class DataPageQueryResult<T> {
  /// The count of all results.
  final int total;

  /// The current page results.
  final List<T> results;

  /// The current page.
  final int page;

  /// Results per each page.
  final int resultsPerPage;

  /// Gets the number of all valid pages.
  int get pages {
    if (resultsPerPage <= 0) return 0;

    if (total % resultsPerPage == 0) return (total ~/ resultsPerPage);

    return (total ~/ resultsPerPage) + 1;
  }

  /// Create an instance of [DataPageQueryResult].
  DataPageQueryResult(this.total, this.results, this.page, this.resultsPerPage);
}
