import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/presentation/login_screen.dart';
import '../../qr_scanner/presentation/qr_scan_screen.dart';
import '../../qr_scanner/presentation/widgets/box_detail_bottom_sheet.dart';
import '../providers/box_provider.dart';
import 'add_box_screen.dart';
import 'widgets/box_card.dart';
import 'widgets/delete_box_dialog.dart';

class BoxListScreen extends ConsumerStatefulWidget {
  const BoxListScreen({super.key});

  @override
  ConsumerState<BoxListScreen> createState() => _BoxListScreenState();
}

class _BoxListScreenState extends ConsumerState<BoxListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: GlassContainer(
          blur: 18,
          opacity: 0.90,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.dangerLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.danger.withValues(alpha: 0.2)),
                ),
                child: const Icon(Icons.logout_rounded, color: AppColors.danger, size: 26),
              ),
              const SizedBox(height: 16),
              const Text(
                'Keluar Aplikasi?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Apakah Anda yakin ingin keluar dari sesi gudang ini?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.danger,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Keluar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(authControllerProvider.notifier).signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final boxState = ref.watch(boxListProvider);
    final filteredBoxes = ref.watch(filteredBoxesProvider);
    final currentFilter = ref.watch(boxStatusFilterProvider);
    final user = ref.watch(currentUserProvider);

    // KPI Aggregations
    final totalTypes = boxState.boxes.length;
    final totalUnits = boxState.boxes.fold<int>(0, (sum, b) => sum + b.quantity);
    final lowStockCount =
        boxState.boxes.where((b) => b.isLowStock).length;
    final outOfStockCount =
        boxState.boxes.where((b) => b.isOutOfStock).length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: AppBar(
              backgroundColor: Colors.white.withValues(alpha: 0.75),
              elevation: 0,
              scrolledUnderElevation: 0,
              shape: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.8),
                  width: 1,
                ),
              ),
              title: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Katalog Box Gudang',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        user?.email ?? 'Petugas Gudang',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'Segarkan Data',
                  onPressed: () =>
                      ref.read(boxListProvider.notifier).fetchBoxes(),
                  icon: const Icon(Icons.refresh_rounded),
                ),
                IconButton(
                  tooltip: 'Keluar',
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout_rounded),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
      body: AmbientBackground(
        child: RefreshIndicator(
          onRefresh: () => ref.read(boxListProvider.notifier).fetchBoxes(),
          color: AppColors.accent,
          child: CustomScrollView(
            slivers: [
              // KPI Summary Glass Cards
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      _buildKpiCard(
                        label: 'Total Jenis',
                        value: '$totalTypes',
                        icon: Icons.category_rounded,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      _buildKpiCard(
                        label: 'Total Unit',
                        value: '$totalUnits',
                        icon: Icons.inventory_2_rounded,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 8),
                      _buildKpiCard(
                        label: 'Stok Kritis',
                        value: '$lowStockCount',
                        icon: Icons.warning_amber_rounded,
                        color: AppColors.warning,
                        isWarning: lowStockCount > 0,
                      ),
                      const SizedBox(width: 8),
                      _buildKpiCard(
                        label: 'Stok Habis',
                        value: '$outOfStockCount',
                        icon: Icons.highlight_off_rounded,
                        color: AppColors.danger,
                        isWarning: outOfStockCount > 0,
                      ),
                    ],
                  ),
                ),
              ),

              // Glassmorphic Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GlassContainer(
                    blur: 14,
                    opacity: 0.85,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.9),
                      width: 1.2,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        ref.read(boxSearchQueryProvider.notifier).setQuery(val);
                      },
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        hintText: 'Cari Box Code, Nama, atau Lokasi...',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.textSecondary,
                          size: 22,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  ref
                                      .read(boxSearchQueryProvider.notifier)
                                      .setQuery('');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),

              // Filter Chips (All, In Stock, Low Stock, Out of Stock)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildFilterChip('All', 'Semua (${boxState.boxes.length})',
                          currentFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip('In Stock', 'In Stock', currentFilter,
                          color: AppColors.success),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'Low Stock', 'Low Stock ($lowStockCount)', currentFilter,
                          color: AppColors.warning),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'Out of Stock', 'Out of Stock ($outOfStockCount)', currentFilter,
                          color: AppColors.danger),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // Content List / Loading / Empty State
              if (boxState.isLoading && boxState.boxes.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.accent),
                        SizedBox(height: 16),
                        Text(
                          'Memuat data inventaris box...',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (boxState.errorMessage != null && boxState.boxes.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: GlassContainer(
                        blur: 16,
                        opacity: 0.90,
                        padding: const EdgeInsets.all(24),
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cloud_off_rounded,
                                size: 54, color: AppColors.danger),
                            const SizedBox(height: 12),
                            const Text(
                              'Gagal Terhubung ke Database',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              boxState.errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  ref.read(boxListProvider.notifier).fetchBoxes(),
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text('Coba Lagi'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else if (filteredBoxes.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: GlassContainer(
                        blur: 16,
                        opacity: 0.85,
                        padding: const EdgeInsets.all(28),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.7),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.8)),
                              ),
                              child: const Icon(
                                Icons.inventory_2_outlined,
                                size: 48,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Tidak Ada Box Ditemukan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Coba ubah kata kunci pencarian atau filter status inventaris.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final box = filteredBoxes[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: BoxCard(
                            box: box,
                            onTap: () {
                              BoxDetailBottomSheet.show(
                                context,
                                box: box,
                                onStockUpdated: () {
                                  ref.read(boxListProvider.notifier).fetchBoxes();
                                },
                              );
                            },
                            onQuickStock: () {
                              BoxDetailBottomSheet.show(
                                context,
                                box: box,
                                onStockUpdated: () {
                                  ref.read(boxListProvider.notifier).fetchBoxes();
                                },
                              );
                            },
                            onDelete: () async {
                              final deleted = await DeleteBoxDialog.show(context, box);
                              if (deleted && context.mounted) {
                                ref.read(boxListProvider.notifier).fetchBoxes();
                              }
                            },
                          ),
                        );
                      },
                      childCount: filteredBoxes.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),

      // Glassmorphic Floating Action Buttons (Scan QR and Tambah Box Baru)
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'fab_scan',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const QrScanScreen()),
              );
            },
            icon: const Icon(Icons.qr_code_scanner_rounded),
            label: const Text('Scan QR Box'),
            backgroundColor: AppColors.amber,
            foregroundColor: AppColors.primary,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'fab_add',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddBoxScreen()),
              );
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Tambah Box Baru'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    bool isWarning = false,
  }) {
    return Expanded(
      child: GlassContainer(
        blur: 14,
        opacity: isWarning ? 0.88 : 0.80,
        color: isWarning ? color.withValues(alpha: 0.12) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isWarning
              ? color.withValues(alpha: 0.45)
              : Colors.white.withValues(alpha: 0.85),
          width: isWarning ? 1.5 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isWarning
                ? color.withValues(alpha: 0.10)
                : AppColors.primary.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 15, color: color),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String filterKey,
    String label,
    String activeFilter, {
    Color? color,
  }) {
    final isSelected = activeFilter == filterKey;
    final activeColor = color ?? AppColors.primary;

    return FilterChip(
      selected: isSelected,
      label: Text(label),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
        color: isSelected ? Colors.white : AppColors.textPrimary,
      ),
      backgroundColor: Colors.white.withValues(alpha: 0.70),
      selectedColor: activeColor,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? activeColor : Colors.white.withValues(alpha: 0.8),
          width: 1.2,
        ),
      ),
      elevation: 0,
      pressElevation: 1,
      onSelected: (_) {
        ref.read(boxStatusFilterProvider.notifier).setFilter(filterKey);
      },
    );
  }
}
