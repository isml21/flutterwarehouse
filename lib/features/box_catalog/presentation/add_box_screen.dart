import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/glass_container.dart';
import '../models/box_model.dart';
import '../providers/box_provider.dart';
import 'widgets/qr_dialog.dart';

class AddBoxScreen extends ConsumerStatefulWidget {
  const AddBoxScreen({super.key});

  @override
  ConsumerState<AddBoxScreen> createState() => _AddBoxScreenState();
}

class _AddBoxScreenState extends ConsumerState<AddBoxScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _lengthController = TextEditingController(text: '30');
  final _widthController = TextEditingController(text: '20');
  final _heightController = TextEditingController(text: '15');
  final _quantityController = TextEditingController(text: '10');
  final _locationController = TextEditingController(text: 'Rak A-01');

  String _selectedMaterial = 'Corrugated Single Wall';
  bool _isSaving = false;

  final List<String> _materialOptions = [
    'Corrugated Single Wall',
    'Corrugated Double Wall',
    'Heavy Duty PP Plastic',
    'Plywood / Wood',
    'Metal Container',
    'Rigid Paperboard',
  ];

  @override
  void initState() {
    super.initState();
    _generateRandomCode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _generateRandomCode() {
    final randomNum = Random().nextInt(9000) + 1000;
    setState(() {
      _codeController.text = 'BOX-$randomNum';
    });
  }

  double get _volumeLiters {
    final l = double.tryParse(_lengthController.text) ?? 0;
    final w = double.tryParse(_widthController.text) ?? 0;
    final h = double.tryParse(_heightController.text) ?? 0;
    return (l * w * h) / 1000.0;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final length = double.parse(_lengthController.text);
      final width = double.parse(_widthController.text);
      final height = double.parse(_heightController.text);
      final quantity = int.parse(_quantityController.text);
      final code = _codeController.text.trim();
      final name = _nameController.text.trim();
      final location = _locationController.text.trim();
      final status = BoxModel.calculateStatus(quantity);

      final newBox = BoxModel(
        id: '', // Supabase assigns UUID
        boxCode: code,
        name: name,
        lengthCm: length,
        widthCm: width,
        heightCm: height,
        materialType: _selectedMaterial,
        quantity: quantity,
        location: location,
        status: status,
        createdAt: DateTime.now(),
      );

      final createdBox =
          await ref.read(boxListProvider.notifier).addBox(newBox);

      if (mounted) {
        setState(() => _isSaving = false);
        AppSnackbar.showSuccess(
          context,
          'Box "${createdBox.boxCode}" berhasil didaftarkan!',
        );

        // Show the generated QR Code dialog with Box UUID payload
        await QrDialog.show(context, createdBox);

        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        AppSnackbar.showError(
          context,
          'Gagal menyimpan box: ${e.toString().replaceAll('Exception: ', '')}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
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
              title: const Text(
                'Registrasi Box Baru',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
        ),
      ),
      body: AmbientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Identification Section Card
                _buildSectionCard(
                  title: 'Identitas Box Gudang',
                  icon: Icons.qr_code_2_rounded,
                  children: [
                    // Box Code with Auto-Gen button
                    const Text(
                      'Kode Box (Unik)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _codeController,
                            textCapitalization: TextCapitalization.characters,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Misal: BOX-001',
                              prefixIcon: Icon(Icons.tag_rounded, size: 20),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Kode Box wajib diisi';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: _generateRandomCode,
                          icon: const Icon(Icons.autorenew_rounded, size: 18),
                          label: const Text('Acak'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 14),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Box Name
                    const Text(
                      'Nama / Deskripsi Box',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Misal: Kardus Kemasan Ekspor Medium',
                        prefixIcon: Icon(Icons.label_outline_rounded, size: 20),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Nama box wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Dimensions Section Card with Live Volume Preview
                _buildSectionCard(
                  title: 'Dimensi & Ukuran (cm)',
                  icon: Icons.straighten_rounded,
                  children: [
                    Row(
                      children: [
                        // Length
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Panjang (L)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _lengthController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: const InputDecoration(
                                  suffixText: 'cm',
                                ),
                                onChanged: (_) => setState(() {}),
                                validator: (val) {
                                  final n = double.tryParse(val ?? '');
                                  if (n == null || n <= 0) return '> 0';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Width
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Lebar (W)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _widthController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: const InputDecoration(
                                  suffixText: 'cm',
                                ),
                                onChanged: (_) => setState(() {}),
                                validator: (val) {
                                  final n = double.tryParse(val ?? '');
                                  if (n == null || n <= 0) return '> 0';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Height
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tinggi (H)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _heightController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: const InputDecoration(
                                  suffixText: 'cm',
                                ),
                                onChanged: (_) => setState(() {}),
                                validator: (val) {
                                  final n = double.tryParse(val ?? '');
                                  if (n == null || n <= 0) return '> 0';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Live Volume Preview (Frosted Glass container)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              size: 18, color: AppColors.accent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Kapasitas Volume: ${_volumeLiters.toStringAsFixed(2)} Liter (${(_volumeLiters * 1000).toInt()} cm³)',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Storage & Material Section Card
                _buildSectionCard(
                  title: 'Material & Lokasi Penyimpanan',
                  icon: Icons.warehouse_rounded,
                  children: [
                    // Material Type Dropdown
                    const Text(
                      'Tipe Material',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedMaterial,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.layers_outlined, size: 20),
                      ),
                      items: _materialOptions.map((mat) {
                        return DropdownMenuItem(
                          value: mat,
                          child: Text(mat),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedMaterial = val);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Location
                    const Text(
                      'Lokasi Rak / Zona Gudang',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        hintText: 'Misal: Rak A-02, Pallet 4, Bay 10',
                        prefixIcon: Icon(Icons.location_on_outlined, size: 20),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Lokasi wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Initial Quantity
                    const Text(
                      'Jumlah Stok Awal (Unit)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: '0',
                        prefixIcon: Icon(Icons.inventory_2_outlined, size: 20),
                      ),
                      validator: (val) {
                        final n = int.tryParse(val ?? '');
                        if (n == null || n < 0) return 'Stok minimal 0';
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Submit Action Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _submitForm,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.qr_code_rounded, size: 20),
                    label: Text(
                      _isSaving
                          ? 'Menyimpan & Membuat QR...'
                          : 'Simpan Box & Generate QR Code',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return GlassContainer(
      blur: 16,
      opacity: 0.85,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.9),
        width: 1.2,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: AppColors.accent),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Divider(
            height: 24,
            color: Colors.white.withValues(alpha: 0.8),
          ),
          ...children,
        ],
      ),
    );
  }
}
