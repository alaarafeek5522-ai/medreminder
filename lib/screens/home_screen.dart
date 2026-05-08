import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../providers/medicine_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/medicine_card.dart';
import '../widgets/today_header.dart';
import 'add_medicine_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<MedicineProvider>(
          builder: (context, provider, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: const TodayHeader().animate().fadeIn(duration: 600.ms),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                    child: Text(
                      'أدويتي',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
                provider.medicines.isEmpty
                    ? SliverFillRemaining(
                        child: _EmptyState(),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: AnimationLimiter(
                          child: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final med = provider.medicines[index];
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 400),
                                  child: SlideAnimation(
                                    verticalOffset: 50,
                                    child: FadeInAnimation(
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: Slidable(
                                          endActionPane: ActionPane(
                                            motion: const DrawerMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (_) =>
                                                    provider.toggleActive(med.id),
                                                backgroundColor: AppTheme.accent,
                                                icon: med.isActive
                                                    ? Icons.pause_circle
                                                    : Icons.play_circle,
                                                label: med.isActive
                                                    ? 'إيقاف'
                                                    : 'تشغيل',
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              SlidableAction(
                                                onPressed: (_) =>
                                                    provider.deleteMedicine(med.id),
                                                backgroundColor: AppTheme.danger,
                                                icon: Icons.delete_rounded,
                                                label: 'حذف',
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ],
                                          ),
                                          child: MedicineCard(medicine: med),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: provider.medicines.length,
                            ),
                          ),
                        ),
                      ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
        ),
        backgroundColor: AppTheme.accent,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text(
          'إضافة دواء',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ).animate().slideY(begin: 2, duration: 600.ms, curve: Curves.elasticOut),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('💊', style: TextStyle(fontSize: 80))
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(end: 1.1, duration: 1500.ms),
          const SizedBox(height: 16),
          Text(
            'مفيش أدوية لسه!',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white.withOpacity(0.6),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط + عشان تضيف دواء',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}
