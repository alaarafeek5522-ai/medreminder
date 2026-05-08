import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/medicine.dart';
import '../providers/medicine_provider.dart';
import '../theme/app_theme.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  String _selectedUnit = 'حبة';
  String _selectedColor = '#00D4AA';
  String _selectedIcon = '💊';
  final List<bool> _days = List.filled(7, true);
  final List<String> _times = ['08:00'];

  final List<String> _dayNames = ['أح','اث','ث','أر','خ','ج','س'];

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppTheme.accent),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _times.add('${picked.hour.toString().padLeft(2,'0')}:${picked.minute.toString().padLeft(2,'0')}');
      });
    }
  }

  void _save() {
    if (_nameController.text.isEmpty || _dosageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اكمل البيانات الأول!')),
      );
      return;
    }
    final med = Medicine(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      dosage: _dosageController.text,
      unit: _selectedUnit,
      times: _times,
      days: _days,
      color: _selectedColor,
      icon: _selectedIcon,
    );
    context.read<MedicineProvider>().addMedicine(med);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة دواء جديد'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('حفظ',
                style: TextStyle(color: AppTheme.accent, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection('اسم الدواء', TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('مثال: بنادول'),
          )),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _buildSection('الجرعة', TextField(
              controller: _dosageController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('مثال: 500'),
            ))),
            const SizedBox(width: 12),
            _buildSection('الوحدة', DropdownButton<String>(
              value: _selectedUnit,
              dropdownColor: AppTheme.card,
              style: const TextStyle(color: Colors.white),
              items: AppTheme.units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
              onChanged: (v) => setState(() => _selectedUnit = v!),
            )),
          ]),
          const SizedBox(height: 20),
          _buildSection('الأيام', Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) => GestureDetector(
              onTap: () => setState(() => _days[i] = !_days[i]),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: _days[i] ? AppTheme.accent : AppTheme.card,
                child: Text(_dayNames[i],
                    style: TextStyle(
                        fontSize: 12,
                        color: _days[i] ? Colors.black : Colors.white54,
                        fontWeight: FontWeight.bold)),
              ),
            )),
          )),
          const SizedBox(height: 20),
          _buildSection('مواعيد الدواء', Column(
            children: [
              ..._times.map((t) => ListTile(
                leading: const Icon(Icons.access_time, color: AppTheme.accent),
                title: Text(t, style: const TextStyle(color: Colors.white, fontSize: 18)),
                trailing: _times.length > 1
                    ? IconButton(
                        icon: const Icon(Icons.remove_circle, color: AppTheme.danger),
                        onPressed: () => setState(() => _times.remove(t)),
                      )
                    : null,
              )),
              TextButton.icon(
                onPressed: _pickTime,
                icon: const Icon(Icons.add, color: AppTheme.accent),
                label: const Text('إضافة موعد', style: TextStyle(color: AppTheme.accent)),
              ),
            ],
          )),
          const SizedBox(height: 20),
          _buildSection('الأيقونة', Wrap(
            spacing: 12,
            children: AppTheme.medicineIcons.map((icon) => GestureDetector(
              onTap: () => setState(() => _selectedIcon = icon),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _selectedIcon == icon ? AppTheme.accent.withOpacity(0.2) : AppTheme.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedIcon == icon ? AppTheme.accent : Colors.transparent,
                  ),
                ),
                child: Text(icon, style: const TextStyle(fontSize: 28)),
              ),
            )).toList(),
          )),
          const SizedBox(height: 20),
          _buildSection('اللون', Wrap(
            spacing: 10,
            children: AppTheme.medicineColors.map((color) {
              final hex = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = hex),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedColor == hex ? Colors.white : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
              );
            }).toList(),
          )),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6))),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        filled: true,
        fillColor: AppTheme.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.accent),
        ),
      );
}
