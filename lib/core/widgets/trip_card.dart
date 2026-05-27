import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../features/trip/domain/entities/trip_entity.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class TripCard extends StatelessWidget {
  final TripEntity trip;
  final VoidCallback onTap;
  final bool isWide;

  const TripCard({
    super.key,
    required this.trip,
    required this.onTap,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isWide ? double.infinity : 200,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isWide ? _buildWide(theme, currency) : _buildCompact(theme, currency),
      ),
    );
  }

  Widget _buildCompact(ThemeData theme, NumberFormat currency) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(height: 120, isCompact: true),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (trip.destinationName != null)
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 11, color: AppColors.primary),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        trip.destinationName!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 3),
              Text(
                trip.title,
                style: theme.textTheme.titleSmall?.copyWith(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      size: 12, color: Color(0xFFFFC107)),
                  const SizedBox(width: 2),
                  Text(
                    trip.rating.toStringAsFixed(1),
                    style: theme.textTheme.labelSmall?.copyWith(fontSize: 11),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      '(${trip.reviewCount})',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.textHint,
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                currency.format(trip.effectivePrice),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWide(ThemeData theme, NumberFormat currency) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(AppSpacing.radiusLg),
          ),
          child: SizedBox(
            width: 110,
            height: 110,
            child: _buildImageWidget(),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (trip.destinationName != null)
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 12, color: AppColors.primary),
                      const SizedBox(width: 2),
                      Text(
                        trip.destinationName!,
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  trip.title,
                  style: theme.textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${trip.durationDays}D${trip.durationNights}N',
                      style: theme.textTheme.labelSmall,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Icon(Icons.people_outline_rounded,
                        size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${trip.availableSlots} slots',
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  currency.format(trip.effectivePrice),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage({required double height, required bool isCompact}) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusLg),
      ),
      child: Stack(
        children: [
          SizedBox(
            height: height,
            width: double.infinity,
            child: _buildImageWidget(),
          ),
          if (trip.isSoldOut)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: Text(
                    'SOLD OUT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          if (trip.hasDiscount)
            Positioned(
              top: AppSpacing.sm,
              left: AppSpacing.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: const Text(
                  'SALE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    if (trip.coverImage != null && trip.coverImage!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: trip.coverImage!,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(color: AppColors.shimmerBase),
        errorWidget: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(Icons.landscape_outlined,
            color: AppColors.textHint, size: 32),
      ),
    );
  }
}
