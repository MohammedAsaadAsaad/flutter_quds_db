class DataPageQueryResult<T> {
  final int total;
  final List<T> results;
  final int page;
  final int resultsPerPage;
  int get pages {
    if (resultsPerPage <= 0) return 0;

    if (total % resultsPerPage == 0) return (total ~/ resultsPerPage);

    return (total ~/ resultsPerPage) + 1;
  }

  DataPageQueryResult(this.total, this.results, this.page, this.resultsPerPage);
}
