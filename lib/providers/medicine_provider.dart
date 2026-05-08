import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medicine.dart';

class MedicineProvider extends ChangeNotifier {
  List<Medicine> _medicines = [];
  List<Medicine> get medicines => _medicines;

  List<Medicine> get activeMedicines =>
      _medicines.where((m) => m.isActive).toList();

  MedicineProvider() {
    loadMedicines();
  }

  Future<void> loadMedicines() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('medicines');
    if (data != null) {
      final List decoded = jsonDecode(data);
      _medicines = decoded.map((e) => Medicine.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'medicines', jsonEncode(_medicines.map((m) => m.toJson()).toList()));
  }

  Future<void> addMedicine(Medicine medicine) async {
    _medicines.add(medicine);
    await _save();
    notifyListeners();
  }

  Future<void> deleteMedicine(String id) async {
    _medicines.removeWhere((m) => m.id == id);
    await _save();
    notifyListeners();
  }

  Future<void> toggleActive(String id) async {
    final index = _medicines.indexWhere((m) => m.id == id);
    if (index != -1) {
      _medicines[index].isActive = !_medicines[index].isActive;
      await _save();
      notifyListeners();
    }
  }

  List<Medicine> getMedicinesForNow() {
    final now = TimeOfDay.now();
    final dayIndex = DateTime.now().weekday % 7;
    return _medicines.where((m) {
      if (!m.isActive) return false;
      if (!m.days[dayIndex]) return false;
      return m.times.any((t) {
        final parts = t.split(':');
        final h = int.parse(parts[0]);
        final min = int.parse(parts[1]);
        return h == now.hour && (now.minute - min).abs() < 30;
      });
    }).toList();
  }
}
