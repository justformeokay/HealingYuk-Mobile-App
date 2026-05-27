import 'package:equatable/equatable.dart';

class TripEntity extends Equatable {
  final int id;
  final String title;
  final String slug;
  final String? description;
  final String? shortDescription;
  final double price;
  final double? discountPrice;
  final int durationDays;
  final int durationNights;
  final int maxParticipants;
  final int availableSlots;
  final String? meetingPoint;
  final double? latitude;
  final double? longitude;
  final String? departureDate;
  final String? returnDate;
  final String? difficultyLevel;
  final double rating;
  final int reviewCount;
  final String? coverImage;
  final List<String> images;
  final String? categoryName;
  final String? destinationName;
  final String? organizerName;
  final bool isAvailable;
  final String? status;

  const TripEntity({
    required this.id,
    required this.title,
    required this.slug,
    this.description,
    this.shortDescription,
    required this.price,
    this.discountPrice,
    required this.durationDays,
    required this.durationNights,
    required this.maxParticipants,
    required this.availableSlots,
    this.meetingPoint,
    this.latitude,
    this.longitude,
    this.departureDate,
    this.returnDate,
    this.difficultyLevel,
    this.rating = 0,
    this.reviewCount = 0,
    this.coverImage,
    this.images = const [],
    this.categoryName,
    this.destinationName,
    this.organizerName,
    this.isAvailable = true,
    this.status,
  });

  double get effectivePrice => discountPrice ?? price;

  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  bool get isSoldOut => availableSlots <= 0;

  @override
  List<Object?> get props => [id, slug];
}
