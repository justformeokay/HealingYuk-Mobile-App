import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/trip_card.dart';
import '../../../../core/widgets/shimmer_widgets.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () => context.read<HomeProvider>().refresh(),
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            _buildSearchBar(),
            _buildCategoryChips(),
            _buildFeaturedSection(),
            _buildLatestSection(),
            const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxl)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppColors.white,
      elevation: 0,
      expandedHeight: 80,
      flexibleSpace: FlexibleSpaceBar(
        background: Consumer<AuthProvider>(
          builder: (context, auth, _) => Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg + 20,
              AppSpacing.lg,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Halo, ${auth.user?.name.split(' ').first ?? 'Traveler'} 👋',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Where do you want to go?',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push('/profile'),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primaryLight.withOpacity(0.15),
                    child: Text(
                      (auth.user?.name.isNotEmpty == true
                              ? auth.user!.name[0]
                              : 'U')
                          .toUpperCase(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        child: GestureDetector(
          onTap: () => context.push('/search'),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Row(
              children: [
                const SizedBox(width: AppSpacing.md),
                const Icon(Icons.search_rounded,
                    color: AppColors.textHint, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Search destinations, trips...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textHint,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = [
      {'icon': '🏔️', 'label': 'Hiking'},
      {'icon': '🏖️', 'label': 'Beach'},
      {'icon': '🏛️', 'label': 'Cultural'},
      {'icon': '🤿', 'label': 'Adventure'},
      {'icon': '🧘', 'label': 'Wellness'},
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          itemCount: categories.length,
          separatorBuilder: (_, __) =>
              const SizedBox(width: AppSpacing.sm),
          itemBuilder: (context, i) {
            final cat = categories[i];
            return GestureDetector(
              onTap: () => context.push('/trips'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusFull),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Text(cat['icon']!),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      cat['label']!,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Trips',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => context.push('/trips'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('See all'),
                ),
              ],
            ),
          ),
          Consumer<HomeProvider>(
            builder: (context, home, _) {
              if (home.isLoading) {
                return SizedBox(
                  height: 240,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg),
                    itemCount: 3,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppSpacing.md),
                    itemBuilder: (_, __) => const SizedBox(
                      width: 200,
                      child: TripCardSkeleton(),
                    ),
                  ),
                );
              }

              if (home.featuredTrips.isEmpty) {
                return const SizedBox.shrink();
              }

              return SizedBox(
                height: 240,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg),
                  itemCount: home.featuredTrips.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.md),
                  itemBuilder: (_, i) => SizedBox(
                    width: 200,
                    child: TripCard(
                      trip: home.featuredTrips[i],
                      onTap: () => context.push(
                          '/trips/${home.featuredTrips[i].id}'),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLatestSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Text(
              'Latest Trips',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Consumer<HomeProvider>(
            builder: (context, home, _) {
              if (home.isLoading) {
                return Column(
                  children: List.generate(
                    3,
                    (_) => const Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ListTileSkeleton(),
                    ),
                  ),
                );
              }

              if (home.error != null) {
                return ErrorStateWidget(
                  message: home.error!,
                  onRetry: () => home.loadHomeData(),
                );
              }

              if (home.latestTrips.isEmpty) {
                return const EmptyStateWidget(
                  title: 'No trips available',
                  subtitle: 'Check back later for new trips',
                  icon: Icons.explore_outlined,
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg),
                itemCount: home.latestTrips.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (_, i) => TripCard(
                  trip: home.latestTrips[i],
                  onTap: () =>
                      context.push('/trips/${home.latestTrips[i].id}'),
                  isWide: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
