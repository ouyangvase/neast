/// 通用分页列表状态。
///
/// 仅描述"内存中"的分页列表快照，不涉及序列化。
/// 字段含义：
/// - [list]：已加载的累积条目。
/// - [isLoading]：首屏空数据加载指示；仅在首屏尚无数据时为 true。
/// - [isFetching]：请求进行中标识，用于并发保护与下拉/上拉指示。
/// - [hasMore]：后端是否还有下一页。
/// - [pageNo]：下一次请求应传入的页码（已成功拉取第 N 页后递增为 N+1）。
/// - [pageSize]：分页大小。
class PaginatedListState<T> {
  const PaginatedListState({
    this.list = const [],
    this.isLoading = false,
    this.isFetching = false,
    this.hasMore = true,
    this.pageNo = 1,
    this.pageSize = 10,
  });

  final List<T> list;
  final bool isLoading;
  final bool isFetching;
  final bool hasMore;
  final int pageNo;
  final int pageSize;

  PaginatedListState<T> copyWith({
    List<T>? list,
    bool? isLoading,
    bool? isFetching,
    bool? hasMore,
    int? pageNo,
    int? pageSize,
  }) {
    return PaginatedListState<T>(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      isFetching: isFetching ?? this.isFetching,
      hasMore: hasMore ?? this.hasMore,
      pageNo: pageNo ?? this.pageNo,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
