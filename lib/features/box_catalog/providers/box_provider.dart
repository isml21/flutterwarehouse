import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/controllers/auth_controller.dart';
import '../models/box_model.dart';
import '../models/box_transaction_model.dart';

/// State for Box Catalog (List of boxes, loading state, error message)
class BoxListState {
  final List<BoxModel> boxes;
  final bool isLoading;
  final String? errorMessage;

  const BoxListState({
    this.boxes = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  BoxListState copyWith({
    List<BoxModel>? boxes,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BoxListState(
      boxes: boxes ?? this.boxes,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Box List Notifier using Riverpod 3.x
class BoxListNotifier extends Notifier<BoxListState> {
  @override
  BoxListState build() {
    Future.microtask(fetchBoxes);
    return const BoxListState(isLoading: true);
  }

  SupabaseClient get _supabase => ref.read(supabaseProvider);

  /// Fetch all boxes from Supabase PostgreSQL
  Future<void> fetchBoxes() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _supabase
          .from('boxes')
          .select()
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      final boxes = data
          .map((item) => BoxModel.fromJson(item as Map<String, dynamic>))
          .toList();

      state = state.copyWith(boxes: boxes, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load boxes: ${e.toString()}',
      );
    }
  }

  /// Add / Register a new box in Supabase
  Future<BoxModel> addBox(BoxModel box) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // 1. Insert into 'boxes' table
      final payload = box.toJson(includeId: false);
      final response =
          await _supabase.from('boxes').insert(payload).select().single();

      final createdBox = BoxModel.fromJson(response);

      // 2. If initial quantity > 0, log an initial 'IN' transaction
      if (createdBox.quantity > 0) {
        final currentUserId = _supabase.auth.currentUser?.id;
        final txData = <String, dynamic>{
          'box_id': createdBox.id,
          'transaction_type': 'IN',
          'amount': createdBox.quantity,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        };
        if (currentUserId != null) {
          txData['user_id'] = currentUserId;
        }
        await _supabase.from('box_transactions').insert(txData);
      }

      // 3. Update local state
      state = state.copyWith(
        boxes: [createdBox, ...state.boxes],
        isLoading: false,
      );

      return createdBox;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to add box: ${e.toString()}',
      );
      rethrow;
    }
  }

  /// Delete / Remove a box from Supabase and local state
  Future<void> deleteBox(String boxId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // 1. Delete from Supabase 'boxes' table (CASCADE will auto-clean box_transactions)
      await _supabase.from('boxes').delete().eq('id', boxId);

      // 2. Update local state
      final updatedList = state.boxes.where((b) => b.id != boxId).toList();
      state = state.copyWith(
        boxes: updatedList,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal menghapus box: ${e.toString()}',
      );
      rethrow;
    }
  }

  /// Update Stock: Stock IN or Stock OUT with validation & transaction log
  Future<BoxModel> updateStock({
    required String boxId,
    required String transactionType, // 'IN' or 'OUT'
    required int amount,
  }) async {
    if (amount <= 0) {
      throw Exception('Transaction amount must be greater than zero.');
    }

    // 1. Fetch current box from Supabase to ensure fresh state
    final currentBoxResponse =
        await _supabase.from('boxes').select().eq('id', boxId).single();
    final currentBox = BoxModel.fromJson(currentBoxResponse);

    final isOut = transactionType.toUpperCase() == 'OUT';
    if (isOut && currentBox.quantity < amount) {
      throw Exception(
        'Insufficient stock! Current stock is ${currentBox.quantity}, cannot stock out $amount.',
      );
    }

    final newQuantity = isOut
        ? currentBox.quantity - amount
        : currentBox.quantity + amount;
    final newStatus = BoxModel.calculateStatus(newQuantity);

    // 2. Update 'boxes' table
    await _supabase.from('boxes').update({
      'quantity': newQuantity,
      'status': newStatus,
    }).eq('id', boxId);

    // 3. Insert transaction log into 'box_transactions'
    final currentUserId = _supabase.auth.currentUser?.id;
    final txData = <String, dynamic>{
      'box_id': boxId,
      'transaction_type': transactionType.toUpperCase(),
      'amount': amount,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    };
    if (currentUserId != null) {
      txData['user_id'] = currentUserId;
    }
    await _supabase.from('box_transactions').insert(txData);

    final updatedBox = currentBox.copyWith(
      quantity: newQuantity,
      status: newStatus,
    );

    // 4. Update local state list
    final updatedList = state.boxes.map((b) {
      return b.id == boxId ? updatedBox : b;
    }).toList();

    state = state.copyWith(boxes: updatedList);
    return updatedBox;
  }

  /// Fetch box by ID (UUID) or Box Code
  Future<BoxModel?> fetchBoxById(String idOrCode) async {
    try {
      // First try by UUID id
      try {
        final res = await _supabase
            .from('boxes')
            .select()
            .eq('id', idOrCode.trim())
            .maybeSingle();
        if (res != null) {
          return BoxModel.fromJson(res);
        }
      } catch (_) {
        // Fallthrough if not valid UUID
      }

      // Fallback try by box_code
      final resByCode = await _supabase
          .from('boxes')
          .select()
          .eq('box_code', idOrCode.trim())
          .maybeSingle();

      if (resByCode != null) {
        return BoxModel.fromJson(resByCode);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Fetch transaction logs for a box
  Future<List<BoxTransactionModel>> fetchTransactions(String boxId) async {
    try {
      final res = await _supabase
          .from('box_transactions')
          .select()
          .eq('box_id', boxId)
          .order('created_at', ascending: false)
          .limit(25);

      final List<dynamic> data = res as List<dynamic>;
      return data
          .map((item) =>
              BoxTransactionModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}

/// Provider for BoxListNotifier
final boxListProvider =
    NotifierProvider<BoxListNotifier, BoxListState>(BoxListNotifier.new);

/// Search Query Notifier
class BoxSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String q) => state = q;
}

final boxSearchQueryProvider =
    NotifierProvider<BoxSearchQueryNotifier, String>(BoxSearchQueryNotifier.new);

/// Selected Status Filter Notifier ('All', 'In Stock', 'Low Stock', 'Out of Stock')
class BoxStatusFilterNotifier extends Notifier<String> {
  @override
  String build() => 'All';

  void setFilter(String f) => state = f;
}

final boxStatusFilterProvider =
    NotifierProvider<BoxStatusFilterNotifier, String>(BoxStatusFilterNotifier.new);

/// Filtered Boxes Provider (combines list, search query, and status filter)
final filteredBoxesProvider = Provider<List<BoxModel>>((ref) {
  final boxState = ref.watch(boxListProvider);
  final query = ref.watch(boxSearchQueryProvider).trim().toLowerCase();
  final filter = ref.watch(boxStatusFilterProvider);

  return boxState.boxes.where((box) {
    // 1. Status Filter
    if (filter != 'All') {
      if (box.status.toLowerCase() != filter.toLowerCase()) {
        return false;
      }
    }

    // 2. Search Query Filter (box_code or name or location)
    if (query.isNotEmpty) {
      final matchCode = box.boxCode.toLowerCase().contains(query);
      final matchName = box.name.toLowerCase().contains(query);
      final matchLocation = box.location.toLowerCase().contains(query);
      return matchCode || matchName || matchLocation;
    }

    return true;
  }).toList();
});
