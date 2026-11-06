import 'package:flutter_test/flutter_test.dart';
import 'package:box_management_system/features/box_catalog/models/box_model.dart';
import 'package:box_management_system/features/box_catalog/providers/box_provider.dart';

void main() {
  group('BoxModel Unit Tests', () {
    test('calculateStatus returns correct status string', () {
      expect(BoxModel.calculateStatus(0), 'Out of Stock');
      expect(BoxModel.calculateStatus(-2), 'Out of Stock');
      expect(BoxModel.calculateStatus(3), 'Low Stock');
      expect(BoxModel.calculateStatus(5), 'Low Stock');
      expect(BoxModel.calculateStatus(10), 'In Stock');
    });

    test('volume calculations in cm³ and Liters are correct', () {
      final box = BoxModel(
        id: 'test-uuid-1234',
        boxCode: 'BOX-TEST-001',
        name: 'Kotak Uji Coba',
        lengthCm: 40.0,
        widthCm: 30.0,
        heightCm: 25.0,
        materialType: 'Corrugated Double Wall',
        quantity: 15,
        location: 'Rak Test-01',
        status: 'In Stock',
        createdAt: DateTime.now(),
      );

      // Volume = 40 * 30 * 25 = 30000 cm³ = 30 Liters
      expect(box.volumeCubicCm, 30000.0);
      expect(box.volumeLiters, 30.0);
      expect(box.isInStock, isTrue);
      expect(box.isLowStock, isFalse);
      expect(box.isOutOfStock, isFalse);
    });

    test('toJson and fromJson preserves data fields', () {
      final now = DateTime.now();
      final box = BoxModel(
        id: 'box-id-abc',
        boxCode: 'BOX-ABC',
        name: 'Kardus ABC',
        lengthCm: 20.0,
        widthCm: 15.0,
        heightCm: 10.0,
        materialType: 'Plastic',
        quantity: 2,
        location: 'Zone 1',
        status: 'Low Stock',
        createdAt: now,
      );

      final json = box.toJson();
      expect(json['box_code'], 'BOX-ABC');
      expect(json['length_cm'], 20.0);
      expect(json['quantity'], 2);

      final decoded = BoxModel.fromJson({
        'id': 'box-id-abc',
        ...json,
        'created_at': now.toIso8601String(),
      });
      expect(decoded.id, 'box-id-abc');
      expect(decoded.boxCode, 'BOX-ABC');
      expect(decoded.isLowStock, isTrue);
    });
  });

  group('Box Deletion & State Unit Tests', () {
    test('Removing box by ID updates state correctly', () {
      final box1 = BoxModel(
        id: 'uuid-1',
        boxCode: 'BOX-001',
        name: 'Kardus 1',
        lengthCm: 10,
        widthCm: 10,
        heightCm: 10,
        materialType: 'Plastic',
        quantity: 10,
        location: 'A-01',
        status: 'In Stock',
        createdAt: DateTime.now(),
      );

      final box2 = BoxModel(
        id: 'uuid-2',
        boxCode: 'BOX-002',
        name: 'Kardus 2',
        lengthCm: 20,
        widthCm: 20,
        heightCm: 20,
        materialType: 'Cardboard',
        quantity: 5,
        location: 'A-02',
        status: 'Low Stock',
        createdAt: DateTime.now(),
      );

      final initialState = BoxListState(boxes: [box1, box2]);
      expect(initialState.boxes.length, 2);

      // Simulate deletion of box1
      final updatedBoxes =
          initialState.boxes.where((b) => b.id != 'uuid-1').toList();
      final stateAfterDelete = initialState.copyWith(boxes: updatedBoxes);

      expect(stateAfterDelete.boxes.length, 1);
      expect(stateAfterDelete.boxes.first.id, 'uuid-2');
      expect(stateAfterDelete.boxes.any((b) => b.id == 'uuid-1'), isFalse);
    });
  });
}
