import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/pagination/paginated_list_logic.dart';
import 'package:neast/core/pagination/paginated_list_state.dart';

/// 通用分页列表 Notifier（带 family 参数）。
///
/// Riverpod 3.x 的 family 机制通过"构造函数参数"承载 family 入参，
/// 因此本基类在 [Notifier] 之上额外持有 [arg]。
///
/// 子类只需实现 [fetchPage]，并在其中引用 [arg] 作为过滤/筛选条件；即可复用
/// `initialLoad / refresh / loadMore`、并发保护、错误处理、hasMore 判定。
///
/// 使用示例：
///
/// ```dart
/// class CollectibleNotifier
///     extends PaginatedListFamilyNotifier<CollectibleModel, String?> {
///   CollectibleNotifier(super.arg);
///
///   @override
///   Future<List<CollectibleModel>> fetchPage(int page, int pageSize) =>
///       ref.read(collectionServiceProvider).list(page, pageSize, arg);
/// }
///
/// final collectibleProvider = NotifierProvider.family<
///     CollectibleNotifier,
///     PaginatedListState<CollectibleModel>,
///     String?>(
///   CollectibleNotifier.new,
/// );
/// ```
///
/// ## 扩展业务参数
///
/// 业务参数应通过 [arg] 承载，**不要**塞进 [fetchPage] 的签名。多参数推荐用
/// record 作 `Arg`，新增字段时只需改 record 与 service 调用，签名保持稳定：
///
/// ```dart
/// typedef WishArg = ({String sort, int? categoryId});
///
/// class WishListNotifier extends PaginatedListFamilyNotifier<WishModel, WishArg> {
///   WishListNotifier(super.arg);
///
///   @override
///   Future<List<WishModel>> fetchPage(int page, int pageSize) =>
///       ref.read(wishServiceProvider).getWishPoolList(
///         page: page, pageSize: pageSize,
///         sort: arg.sort, categoryId: arg.categoryId,
///       );
/// }
///
/// final wishProvider = NotifierProvider.family<
///     WishListNotifier, PaginatedListState<WishModel>, WishArg>(
///   WishListNotifier.new,
/// );
///
/// // 使用：ref.watch(wishProvider((sort: 'HOT', categoryId: null)))
/// ```
///
/// 如果某些参数需要在「同一列表实例」中由用户切换（而非切到新实例），改用
/// [PaginatedListNotifier]，在子类持有可变字段并配合
/// [PaginatedListLogic.applyFilter]。
abstract class PaginatedListFamilyNotifier<T, Arg>
    extends Notifier<PaginatedListState<T>> with PaginatedListLogic<T> {

  PaginatedListFamilyNotifier(this.arg);

  /// 当前 Provider 实例对应的 family 入参。
  final Arg arg;

  /// 初始分页大小，默认 10，子类可覆写。
  int get initialPageSize => 10;

  @override
  PaginatedListState<T> build() =>
      PaginatedListState<T>(pageSize: initialPageSize);
}
