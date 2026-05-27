import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../../core/widgets/shimmer_widgets.dart';
import '../providers/trip_provider.dart';

class TripDetailScreen extends StatefulWidget {
  final int tripId;
  const TripDetailScreen({super.key, required this.tripId});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TripProvider>().loadTripDetail(widget.tripId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) return _buildSkeleton();
        if (provider.state == TripLoadState.error) {
          return Scaffold(
            appBar: AppBar(),
            body: ErrorStateWidget(
              message: provider.errorMessage ?? 'Failed to load trip',
              onRetry: () => provider.loadTripDetail(widget.tripId),
            ),
          );
        }
        final trip = provider.selectedTrip;
        if (trip == null) return const Scaffold();

        final currency = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        );

        final allImages = [
          if (trip.coverImage != null) trip.coverImage!,
          ...trip.images,
        ];

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppColors.white,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18, color: AppColors.textPrimary),
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/trips');
                        }
                      },
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: allImages.isEmpty
                      ? Container(
                          color: AppColors.surfaceVariant,
                          child: const Center(
                            child: Icon(Icons.landscape_outlined,
                                color: AppColors.textHint, size: 60),
                          ),
                        )
                      : Stack(
                          children: [
                            PageView.builder(
                              itemCount: allImages.length,
                              onPageChanged: (i) =>
                                  setState(() => _currentImageIndex = i),
                              itemBuilder: (_, i) => CachedNetworkImage(
                                imageUrl: allImages[i],
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(
                                    color: AppColors.shimmerBase),
                                errorWidget: (_, __, ___) => Container(
                                    color: AppColors.surfaceVariant),
                              ),
                            ),
                            Positioned(
                              bottom: AppSpacing.md,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  allImages.length,
                                  (i) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    width: i == _currentImageIndex ? 16 : 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: i == _currentImageIndex
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (trip.categoryName != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusFull),
                          ),
                          child: Text(
                            trip.categoryName!,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: AppColors.primary),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(trip.title,
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: AppSpacing.md),
                      _InfoRow(children: [
                        _InfoChip(
                          icon: Icons.location_on_outlined,
                          label: trip.destinationName ?? 'Unknown',
                        ),
                        _InfoChip(
                          icon: Icons.access_time_rounded,
                          label:
                              '${trip.durationDays}D${trip.durationNights}N',
                        ),
                        _InfoChip(
                          icon: Icons.people_outline_rounded,
                          label: '${trip.availableSlots} slots',
                          color: trip.availableSlots < 5
                              ? AppColors.secondary
                              : null,
                        ),
                        if (trip.difficultyLevel != null)
                          _InfoChip(
                            icon: Icons.terrain_rounded,
                            label: trip.difficultyLevel!,
                          ),
                      ]),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFFFC107), size: 18),
                          const SizedBox(width: 4),
                          Text(
                            trip.rating.toStringAsFixed(1),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${trip.reviewCount} reviews)',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: const Divider(height: 8, thickness: 8,
                    color: AppColors.background),
              ),
              if (trip.description != null)
                SliverToBoxAdapter(
                  child: Container(
                    color: AppColors.white,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description',
                            style:
                                Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          trip.description!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.6,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (trip.meetingPoint != null)
                SliverToBoxAdapter(
                  child: Container(
                    color: AppColors.white,
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Meeting Point',
                            style:
                                Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusSm),
                              ),
                              child: const Icon(
                                  Icons.location_on_rounded,
                                  color: AppColors.primary,
                                  size: 20),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                trip.meetingPoint!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SliverToBoxAdapter(
                  child: SizedBox(height: 100)),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(context, trip, currency),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, trip, NumberFormat currency) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currency.format(trip.effectivePrice),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                '/ person',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: PrimaryButton(
              label: trip.isSoldOut ? 'Sold Out' : 'Book Now',
              onPressed: trip.isSoldOut
                  ? null
                  : () => context.push('/booking/${trip.id}'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Scaffold(
      body: Column(
        children: [
          ShimmerBox(width: double.infinity, height: 300, borderRadius: 0),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 80, height: 20),
                const SizedBox(height: AppSpacing.md),
                ShimmerBox(width: double.infinity, height: 28),
                const SizedBox(height: AppSpacing.sm),
                ShimmerBox(width: 200, height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final List<Widget> children;
  const _InfoRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: children,
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: c),
          const SizedBox(width: 4),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: c)),
        ],
      ),
    );
  }
}
