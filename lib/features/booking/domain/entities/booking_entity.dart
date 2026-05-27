import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final int id;
  final String bookingCode;
  final String status;
  final int participants;
  final double totalAmount;
  final String? tripTitle;
  final String? tripCoverImage;
  final String? departureDate;
  final String createdAt;

  const BookingEntity({
    required this.id,
    required this.bookingCode,
    required this.status,
    required this.participants,
    required this.totalAmount,
    this.tripTitle,
    this.tripCoverImage,
    this.departureDate,
    required this.createdAt,
  });

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';

  @override
  List<Object?> get props => [id, bookingCode];

  factory BookingEntity.fromJson(Map<String, dynamic> json) {
    return BookingEntity(
      id: json['id'] as int,
      bookingCode: json['booking_code'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      participants: json['participants'] as int? ?? 1,
      totalAmount:
          double.tryParse((json['total_amount'] ?? 0).toString()) ?? 0.0,
      tripTitle: json['trip']?['title'] as String? ?? json['trip_title'] as String?,
      tripCoverImage:
          json['trip']?['cover_image'] as String? ?? json['trip_cover_image'] as String?,
      departureDate:
          json['trip']?['departure_date'] as String? ?? json['departure_date'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
