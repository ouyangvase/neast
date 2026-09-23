import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/core/pagination/paginated_list_logic.dart';
import 'package:neast_landlords/core/pagination/paginated_list_state.dart';

/// 通用分页列表 Notifier（不带 family 参数）。
///
/// 子类只需实现 [fetchPage]，即可获得 `initialLoad / refresh / loadMore`
/// 以及统一的并发保护、错误处理、hasMore 判定。
///
/// 如果需要自定义初始分页大小，可以覆写 [initialPageSize]。
/// 如需更复杂的初始状态（例如预置 pageSize 之外的字段），可覆写 [build]。
///
/// 使用示例：
///
/// ```dart
/// class NoteListNotifier extends PaginatedListNotifier<NoteModel> {
///   @override
///   int get initialPageSize => 5;
///
///   @override
///   Future<List<NoteModel>> fetchPage(int page, int pageSize) =>
///       ref.read(noteServiceProvider).fetchNotes(page: page, pageSize: pageSize);
/// }
///
/// final noteListProvider =
///     NotifierProvider<NoteListNotifier, PaginatedListState<NoteModel>>(
///   NoteListNotifier.new,
/// );
/// ```
///
/// ## 扩展业务参数
///
/// [fetchPage] 的契约只关心 `page` / `pageSize` 这两个分页基础设施参数，
/// **业务参数（排序、关键词、分类等）不应进入签名**。按以下两种模式扩展：
///
/// 1) 「运行时可切换」——子类持有字段 + 暴露 `setXxx()`，内部调用
/// [PaginatedListLogic.applyFilter] 重置并刷新：
///
/// ```dart
/// class NoteListNotifier extends PaginatedListNotifier<NoteModel> {
///   String _sort = 'HOT';
///   String get sort => _sort;
///
///   @override
///   Future<List<NoteModel>> fetchPage(int page, int pageSize) =>
///       ref.read(noteServiceProvider)
///          .fetchNotes(page: page, pageSize: pageSize, sort: _sort);
///
///   Future<void> setSort(String sort) async {
///     if (sort == _sort) return;
///     await applyFilter(() => _sort = sort);
///   }
/// }
/// ```
///
/// 2) 「创建期固定」——不同入参 = 不同列表实例，改用
/// [PaginatedListFamilyNotifier]，把参数收进 family `Arg`（推荐 record）。
abstract class PaginatedListNotifier<T> extends Notifier<PaginatedListState<T>>
    with PaginatedListLogic<T> {
  /// 初始分页大小，默认 10，子类可覆写。
  int get initialPageSize => 10;

  @override
  PaginatedListState<T> build() =>
      PaginatedListState<T>(pageSize: initialPageSize);
}
