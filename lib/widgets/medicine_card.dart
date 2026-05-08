import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../theme/app_theme.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  const MedicineCard({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    final color = Color(
        int.parse(medicine.color.replaceFirst('#', 'FF'), radix: 16));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: medicine.isActive ? color.withOpacity(0.4) : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.4)),
            ),
            child: Center(
              child: Text(medicine.icon, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: medicine.isActive ? Colors.white : Colors.white38,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${medicine.dosage} ${medicine.unit}',
                  style: TextStyle(
                    fontSize: 13,
                    color: color.withOpacity(medicine.isActive ? 0.9 : 0.4),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: medicine.times
                      .map((t) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: color.withOpacity(0.3)),
                            ),
                            child: Text(
                              t,
                              style: TextStyle(
                                fontSize: 12,
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          if (!medicine.isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'متوقف',
                style: TextStyle(fontSize: 11, color: Colors.white38),
              ),
            ),
        ],
      ),
    );
  }
}
