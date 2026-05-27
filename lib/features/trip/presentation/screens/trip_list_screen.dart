import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/trip_card.dart';
import '../../../../core/widgets/shimmer_widgets.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../providers/trip_provider.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({super.key});

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TripProvider>().loadTrips(refresh: true);
    });
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 200) {
      final provider = context.read<TripProvider>();
      if (!provider.isLoadingMore && provider.hasMore) {
        provider.loadTrips();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('All Trips'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<TripProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.trips.isEmpty) {
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, __) => const ListTileSkeleton(),
            );
          }

          if (provider.state == TripLoadState.error && provider.trips.isEmpty) {
            return ErrorStateWidget(
              message: provider.errorMessage ?? 'Failed to load trips',
              onRetry: () => provider.loadTrips(refresh: true),
            );
          }

          if (provider.trips.isEmpty) {
            return const EmptyStateWidget(
              title: 'No trips found',
              subtitle: 'Try different search criteria',
              icon: Icons.travel_explore,
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadTrips(refresh: true),
            color: AppColors.primary,
            child: ListView.separated(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount:
                  provider.trips.length + (provider.isLoadingMore ? 1 : 0),
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, i) {
                if (i == provider.trips.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return TripCard(
                  trip: provider.trips[i],
                  onTap: () => context.push('/trips/${provider.trips[i].id}'),
                  isWide: true,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
