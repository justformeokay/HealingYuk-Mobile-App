import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../providers/search_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            context.read<SearchProvider>().clear();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextField(
            controller: _searchCtrl,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              hintText: 'Search trips, destinations...',
              border: InputBorder.none,
              fillColor: Colors.transparent,
            ),
            onChanged: context.read<SearchProvider>().onQueryChanged,
            textInputAction: TextInputAction.search,
            onSubmitted: (v) =>
                context.read<SearchProvider>().search(query: v),
          ),
        ),
        actions: [
          Consumer<SearchProvider>(
            builder: (_, s, __) => s.hasQuery
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _searchCtrl.clear();
                      context.read<SearchProvider>().clear();
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Consumer<SearchProvider>(
        builder: (context, search, _) {
          if (!search.hasQuery) {
            return _buildInitialState(context);
          }

          if (search.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (search.error != null) {
            return ErrorStateWidget(
              message: search.error!,
              onRetry: () => search.search(),
            );
          }

          if (search.results.isEmpty) {
            return const EmptyStateWidget(
              title: 'No results found',
              subtitle: 'Try a different keyword',
              icon: Icons.search_off_rounded,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: search.results.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (_, i) {
              final r = search.results[i];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                leading: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusMd),
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: r.coverImage != null
                        ? CachedNetworkImage(
                            imageUrl: r.coverImage!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: AppColors.surfaceVariant,
                            child: const Icon(Icons.landscape_outlined,
                                color: AppColors.textHint),
                          ),
                  ),
                ),
                title: Text(
                  r.title,
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 2,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (r.destinationName != null)
                      Text(
                        r.destinationName!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primary,
                            ),
                      ),
                    if (r.distanceKm != null)
                      Text(
                        '${r.distanceKm!.toStringAsFixed(1)} km away',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                  ],
                ),
                trailing: Text(
                  currency.format(r.price),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                onTap: () => context.push('/trips/${r.id}'),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Popular searches',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              'Rinjani',
              'Raja Ampat',
              'Bali',
              'Bromo',
              'Komodo',
              'Labuan Bajo',
            ]
                .map(
                  (tag) => GestureDetector(
                    onTap: () {
                      _searchCtrl.text = tag;
                      context.read<SearchProvider>().onQueryChanged(tag);
                    },
                    child: Chip(label: Text(tag, style: Theme.of(context).textTheme.bodySmall)),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
