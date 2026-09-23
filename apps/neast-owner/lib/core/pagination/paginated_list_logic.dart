import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/core/pagination/paginated_list_state.dart';
import 'package:neast_landlords/core/utils/notifier_utils.dart';
import 'package:neast_landlords/core/utils/toast_util.dart';

/// 通用分页列表逻辑 mixin。
///
/// 被 [PaginatedListNotifier] 与 [PaginatedListFamilyNotifier] 两个基类共享，
/// 避免在两处重复编写 initialLoad / refresh / loadMore / _fetch。
///
/// 子类（通过混入到具体 Notifier 上）只需实现 [fetchPage]，给出"如何获取第 page 页"。
mixin PaginatedListLogic<T> on Notifier<PaginatedListState<T>> {
  /// 构建代数，每次 [runBuild] 执行时自增。
  ///
  /// 用于让 `build` 重跑、或 provider 被释放后依然 in-flight 的请求，
  /// 在其结果回来时被识别为"过期"，从而避免把旧数据写入已重置的 state。
  int _generation = 0;

  // 注意：riverpod 3.3.x 起 `runBuild` 返回 `WhenComplete`
  // (= `void Function(void Function())?`)，3.2.x 时为 `void`。
  // 该 typedef 未对外导出，故此处展开其类型以保持跨版本可编译。
  @override
  void Function(void Function())? runBuild() {
    _generation++;
    return super.runBuild();
  }

  /// 子类契约：拉取指定页的数据。
  ///
  /// 返回本页的数据列表（不要再自行拼接累积列表）。当返回数量 < [pageSize]
  /// 时，会被视为"到底"。错误请直接抛出，由 [_fetch] 统一捕获。
  Future<List<T>> fetchPage(int page, int pageSize);

  /// 非 [DioException] 异常的兜底处理。
  ///
  /// 默认弹 Toast 显示错误文本，和现有业务代码行为保持一致。
  /// 子类可覆写此方法以替换或扩展提示方式（例如记录埋点、自定义错误文案等）。
  ///
  /// 注意：[DioException] 已由 [NotifierUtils.runGuarded] 在 utils 层统一提示，
  /// 不会进入此钩子。
  @protected
  void onFetchError(Object error, StackTrace stack) {
    ToastUtil.show(error.toString());
  }

  /// 首次加载：已有数据则直接返回，避免重复请求。
  Future<void> initialLoad() async {
    if (state.list.isNotEmpty) return;
    await _fetch(refresh: true);
  }

  /// 下拉刷新：从第 1 页开始重新加载。
  Future<void> refresh({bool isLoading = false}) async {
    await _fetch(refresh: true, isLoading: isLoading);
  }

  /// 加载更多：在有下一页且无进行中的请求时触发。
  Future<void> loadMore() async {
    if (state.isFetching || !state.hasMore) return;
    await _fetch(refresh: false);
  }

  /// 切换过滤条件后重新拉取列表。
  ///
  /// 使用场景：子类持有可变的过滤字段（如 `_sort`、`_keyword` 等），用户切换时
  /// 通过本方法在「修改字段 → 清空当前列表 → 从第 1 页 refresh」之间保持原子性。
  ///
  /// 清空 [PaginatedListState.list] 是为了让首屏 loading 再次显示——`_fetch` 中
  /// `isLoading` 仅在 `state.list.isEmpty` 时才会被置 true。
  ///
  /// 示例：
  ///
  /// ```dart
  /// Future<void> setSort(String sort) async {
  ///   if (sort == _sort) return;
  ///   await applyFilter(() => _sort = sort);
  /// }
  /// ```
  @protected
  Future<void> applyFilter(void Function() update, {bool isLoading = false}) async {
    update();
    if(isLoading) {
      state = state.copyWith(
        list: const [],
        pageNo: 1,
        hasMore: true,
        isLoading: true
      );
    }
    await refresh();
  }

  /// 从当前 [PaginatedListState.list] 本地移除所有满足 [test] 的条目。
  ///
  /// 适用于「接口成功后只改 UI 的这一项、不重拉整页」的场景
  /// （典型：单条删除 / 局部更新），避免 `refresh()` 把已加载的多页数据
  /// 截断到第 1 页而丢失滚动位置。
  ///
  /// 注意：只改本地状态，不调接口；也不会改 [PaginatedListState.hasMore]
  /// 和 [PaginatedListState.pageNo]。后端删除成功后由调用方触发一次
  /// 即可。无匹配项时是 no-op。
  void removeWhere(bool Function(T element) test) {
    final newList = state.list.where((e) => !test(e)).toList(growable: false);
    if (newList.length == state.list.length) return;
    state = state.copyWith(list: newList);
  }

  Future<void> _fetch({required bool refresh, bool isLoading = false}) async {
    if (state.isFetching) return;

    final gen = _generation;
    final page = refresh ? 1 : state.pageNo;

    state = state.copyWith(
      isFetching: true,
      isLoading: isLoading || (refresh && state.list.isEmpty),
    );

    final result = await ref.runGuarded<List<T>>(
      () => fetchPage(page, state.pageSize),
      onError: onFetchError,
    );

    // provider 已被释放，或 build 期间被重跑（state 已重置），
    // 此时不能再写 state：直接作废本次响应，避免崩溃或脏数据。
    if (!ref.mounted || gen != _generation) return;

    if (result != null) {
      final newList = refresh ? result : [...state.list, ...result];
      state = state.copyWith(
        list: newList,
        pageNo: page + 1,
        hasMore: result.length >= state.pageSize,
        isFetching: false,
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        isFetching: false,
        isLoading: false,
      );
    }
  }
}
