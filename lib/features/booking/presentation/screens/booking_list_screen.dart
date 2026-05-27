import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../providers/booking_provider.dart';
import '../../domain/entities/booking_entity.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: AppColors.white,
      ),
      body: Consumer<BookingProvider>(
        builder: (context, booking, _) {
          if (booking.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (booking.error != null) {
            return ErrorStateWidget(
              message: booking.error!,
              onRetry: booking.loadBookings,
            );
          }

          if (booking.bookings.isEmpty) {
            return EmptyStateWidget(
              title: 'No bookings yet',
              subtitle: 'Your trip bookings will appear here',
              icon: Icons.card_travel_rounded,
              actionLabel: 'Explore Trips',
              onAction: () => context.go('/home'),
            );
          }

          return RefreshIndicator(
            onRefresh: booking.loadBookings,
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: booking.bookings.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (_, i) =>
                  _BookingCard(booking: booking.bookings[i]),
            ),
          );
        },
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingEntity booking;
  const _BookingCard({required this.booking});

  Color _statusColor() {
    return switch (booking.status) {
      'confirmed' => Colors.green,
      'cancelled' => Colors.red,
      'pending' => Colors.orange,
      _ => Colors.grey,
    };
  }

  @override
  Widget build(BuildContext context) {
    final currency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        onTap: () => context.push('/bookings/${booking.id}'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      booking.tripTitle ?? 'Trip',
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor().withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      booking.status.toUpperCase(),
                      style: TextStyle(
                        color: _statusColor(),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Code: ${booking.bookingCode}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const Icon(Icons.people_outline_rounded,
                      size: 16, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text('${booking.participants} pax',
                      style: Theme.of(context).textTheme.bodySmall),
                  const Spacer(),
                  Text(
                    currency.format(booking.totalAmount),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
