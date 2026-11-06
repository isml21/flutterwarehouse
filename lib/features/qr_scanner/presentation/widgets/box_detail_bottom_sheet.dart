import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../box_catalog/models/box_model.dart';
import '../../../box_catalog/models/box_transaction_model.dart';
import '../../../box_catalog/presentation/widgets/delete_box_dialog.dart';
import '../../../box_catalog/presentation/widgets/stock_badge.dart';
import '../../../box_catalog/providers/box_provider.dart';

class BoxDetailBottomSheet extends ConsumerStatefulWidget {
  final BoxModel initialBox;
  final VoidCallback? onStockUpdated;

  const BoxDetailBottomSheet({
    super.key,
    required this.initialBox,
    this.onStockUpdated,
  });

  static Future<void> show(
    BuildContext context, {
    required BoxModel box,
    VoidCallback? onStockUpdated,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) => BoxDetailBottomSheet(
        initialBox: box,
        onStockUpdated: onStockUpdated,
      ),
    );
  }

  @override
  ConsumerState<BoxDetailBottomSheet> createState() =>
      _BoxDetailBottomSheetState();
}

class _BoxDetailBottomSheetState extends ConsumerState<BoxDetailBottomSheet> {
  late BoxModel _currentBox;
  String _selectedAction = 'IN'; // 'IN' or 'OUT'
  int _amount = 1;
  final TextEditingController _amountController =
      TextEditingController(text: '1');
  bool _isSubmitting = false;
  List<BoxTransactionModel> _transactions = [];
  bool _isLoadingTransactions = true;

  @override
  void initState() {
    super.initState();
    _currentBox = widget.initialBox;
    _loadTransactionHistory();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadTransactionHistory() async {
    final txList = await ref
        .read(boxListProvider.notifier)
        .fetchTransactions(_currentBox.id);
    if (mounted) {
      setState(() {
        _transactions = txList;
        _isLoadingTransactions = false;
      });
    }
  }

  void _setAmount(int newAmount) {
    if (newAmount < 1) newAmount = 1;
    setState(() {
      _amount = newAmount;
      _amountController.text = newAmount.toString();
    });
  }

  void _adjustAmount(int delta) {
    _setAmount(_amount + delta);
  }

  Future<void> _handleDeleteBox() async {
    final deleted = await DeleteBoxDialog.show(context, _currentBox);
    if (deleted && mounted) {
      Navigator.of(context).pop();
      widget.onStockUpdated?.call();
    }
  }

  Future<void> _handleConfirmTransaction() async {
    final isOut = _selectedAction == 'OUT';

    // Stock validation
    if (isOut && _amount > _currentBox.quantity) {
      AppSnackbar.showError(
        context,
        'Jumlah Stock Out ($_amount) melebihi stok yang tersedia (${_currentBox.quantity})!',
      );
      return;
    }

    if (_amount <= 0) {
      AppSnackbar.showError(context, 'Jumlah harus lebih besar dari 0.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final updatedBox =
          await ref.read(boxListProvider.notifier).updateStock(
                boxId: _currentBox.id,
                transactionType: _selectedAction,
                amount: _amount,
              );

      if (mounted) {
        setState(() {
          _currentBox = updatedBox;
          _isSubmitting = false;
          _amount = 1;
          _amountController.text = '1';
        });

        widget.onStockUpdated?.call();

        AppSnackbar.showSuccess(
          context,
          'Berhasil mencatat ${_selectedAction == 'IN' ? 'Stock In' : 'Stock Out'} sejumlah $_amount unit!',
        );

        // Refresh transactions
        _loadTransactionHistory();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        AppSnackbar.showError(context, e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOut = _selectedAction == 'OUT';
    final hasEnoughStock = !isOut || _amount <= _currentBox.quantity;
    final predictedStock = isOut
        ? _currentBox.quantity - _amount
        : _currentBox.quantity + _amount;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.9),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            top: 12,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.divider.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Top Header: Box Code, Delete Action, and Close
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryLight],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _currentBox.boxCode,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        StockBadge(status: _currentBox.status),
                      ],
                    ),
                    Row(
                      children: [
                        // Delete Button in Detail Sheet
                        IconButton(
                          tooltip: 'Hapus Box',
                          onPressed: _handleDeleteBox,
                          icon: const Icon(Icons.delete_outline_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.dangerLight.withValues(alpha: 0.8),
                            foregroundColor: AppColors.danger,
                            side: BorderSide(
                              color: AppColors.danger.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.8),
                            foregroundColor: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Box Name
                Text(
                  _currentBox.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 14),

                // Specification Grid (Frosted Glass Container)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.9),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildSpecItem(
                            icon: Icons.straighten_rounded,
                            label: 'Dimensi',
                            value: _currentBox.dimensionFormatted,
                          ),
                          _buildSpecItem(
                            icon: Icons.inventory_2_outlined,
                            label: 'Stok Saat Ini',
                            value: '${_currentBox.quantity} Unit',
                            valueColor:
                                AppColors.getStatusColor(_currentBox.status),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        children: [
                          _buildSpecItem(
                            icon: Icons.location_on_outlined,
                            label: 'Lokasi Rak',
                            value: _currentBox.location,
                          ),
                          _buildSpecItem(
                            icon: Icons.layers_outlined,
                            label: 'Material',
                            value: _currentBox.materialType,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Action Toggle: Stock IN vs Stock OUT
                const Text(
                  'Pilih Aksi Transaksi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionTab(
                        title: 'Stock IN (Masuk)',
                        icon: Icons.arrow_downward_rounded,
                        isActive: _selectedAction == 'IN',
                        activeColor: AppColors.success,
                        onTap: () => setState(() => _selectedAction = 'IN'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionTab(
                        title: 'Stock OUT (Keluar)',
                        icon: Icons.arrow_upward_rounded,
                        isActive: _selectedAction == 'OUT',
                        activeColor: AppColors.danger,
                        onTap: () => setState(() => _selectedAction = 'OUT'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Quantity Stepper & Input
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Jumlah Barang',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Stok Akhir: $predictedStock Unit',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: predictedStock < 0
                            ? AppColors.danger
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    // Decrement Button
                    _buildStepperButton(
                      icon: Icons.remove_rounded,
                      onPressed: _amount > 1 ? () => _adjustAmount(-1) : null,
                    ),
                    const SizedBox(width: 12),

                    // Amount Text Field
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                          fillColor: Colors.white.withValues(alpha: 0.8),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: hasEnoughStock
                                  ? Colors.white.withValues(alpha: 0.8)
                                  : AppColors.danger,
                              width: 1.2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: hasEnoughStock
                                  ? AppColors.border
                                  : AppColors.danger,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          final parsed = int.tryParse(val);
                          if (parsed != null && parsed >= 0) {
                            setState(() => _amount = parsed);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Increment Button
                    _buildStepperButton(
                      icon: Icons.add_rounded,
                      onPressed: () => _adjustAmount(1),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Quick Add Chips (+5, +10, +25, +50)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [5, 10, 25, 50].map((addVal) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ActionChip(
                        label: Text('+$addVal'),
                        labelStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        backgroundColor: Colors.white.withValues(alpha: 0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        onPressed: () => _adjustAmount(addVal),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                // Insufficient stock warning
                if (!hasEnoughStock)
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.dangerLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.danger.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: AppColors.danger, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Jumlah keluar ($_amount) melebihi stok yang ada (${_currentBox.quantity})!',
                            style: const TextStyle(
                              color: AppColors.danger,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed:
                        (!hasEnoughStock || _amount <= 0 || _isSubmitting)
                            ? null
                            : _handleConfirmTransaction,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            isOut
                                ? Icons.remove_circle_outline_rounded
                                : Icons.add_circle_outline_rounded,
                            size: 20,
                          ),
                    label: Text(
                      _isSubmitting
                          ? 'Menyimpan Transaksi...'
                          : (isOut
                              ? 'Konfirmasi Stock OUT ($_amount Unit)'
                              : 'Konfirmasi Stock IN ($_amount Unit)'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isOut ? AppColors.danger : AppColors.success,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.divider,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      shadowColor: (isOut ? AppColors.danger : AppColors.success)
                          .withValues(alpha: 0.3),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Secondary Delete Action in bottom sheet
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _handleDeleteBox,
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: const Text('Hapus Item Ini dari Database'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: BorderSide(
                        color: AppColors.danger.withValues(alpha: 0.3),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Transaction History Section
                const Text(
                  'Riwayat Transaksi Box Ini',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),

                if (_isLoadingTransactions)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else if (_transactions.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
                    ),
                    child: const Center(
                      child: Text(
                        'Belum ada riwayat transaksi.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _transactions.length > 5 ? 5 : _transactions.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 12),
                    itemBuilder: (context, index) {
                      final tx = _transactions[index];
                      final isTxIn = tx.isIn;
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isTxIn
                                    ? AppColors.successLight
                                    : AppColors.dangerLight,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isTxIn
                                    ? Icons.arrow_downward_rounded
                                    : Icons.arrow_upward_rounded,
                                size: 14,
                                color: isTxIn
                                    ? AppColors.success
                                    : AppColors.danger,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isTxIn ? 'Stock IN (Masuk)' : 'Stock OUT (Keluar)',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${tx.createdAt.toLocal().day}/${tx.createdAt.toLocal().month}/${tx.createdAt.toLocal().year} ${tx.createdAt.toLocal().hour.toString().padLeft(2, '0')}:${tx.createdAt.toLocal().minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${isTxIn ? '+' : '-'}${tx.amount} Unit',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isTxIn
                                    ? AppColors.success
                                    : AppColors.danger,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTab({
    required String title,
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.70),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? activeColor : Colors.white.withValues(alpha: 0.85),
            width: isActive ? 2 : 1.2,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? activeColor : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isActive ? activeColor : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        color: AppColors.textPrimary,
        disabledColor: AppColors.textMuted,
        onPressed: onPressed,
      ),
    );
  }
}
