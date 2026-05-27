import '../../domain/entities/trip_entity.dart';

class TripModel extends TripEntity {
  const TripModel({
    required super.id,
    required super.title,
    required super.slug,
    super.description,
    super.shortDescription,
    required super.price,
    super.discountPrice,
    required super.durationDays,
    required super.durationNights,
    required super.maxParticipants,
    required super.availableSlots,
    super.meetingPoint,
    super.latitude,
    super.longitude,
    super.departureDate,
    super.returnDate,
    super.difficultyLevel,
    super.rating,
    super.reviewCount,
    super.coverImage,
    super.images,
    super.categoryName,
    super.destinationName,
    super.organizerName,
    super.isAvailable,
    super.status,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] as List<dynamic>? ?? [])
        .map((e) => e is Map ? e['image_url'] as String? ?? '' : e.toString())
        .where((e) => e.isNotEmpty)
        .toList();

    return TripModel(
      id: json['id'] as int,
      title: json['title'] as String,
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String?,
      shortDescription: json['short_description'] as String?,
      price: _toDouble(json['price']),
      discountPrice: json['discount_price'] != null
          ? _toDouble(json['discount_price'])
          : null,
      durationDays: json['duration_days'] as int? ?? 1,
      durationNights: json['duration_nights'] as int? ?? 0,
      maxParticipants: json['max_participants'] as int? ?? 1,
      availableSlots: json['available_slots'] as int? ?? 0,
      meetingPoint: json['meeting_point'] as String?,
      latitude: json['latitude'] != null ? _toDouble(json['latitude']) : null,
      longitude:
          json['longitude'] != null ? _toDouble(json['longitude']) : null,
      departureDate: json['departure_date'] as String?,
      returnDate: json['return_date'] as String?,
      difficultyLevel: json['difficulty_level'] as String?,
      rating: _toDouble(json['average_rating'] ?? json['rating'] ?? 0),
      reviewCount: json['review_count'] as int? ?? 0,
      coverImage: json['cover_image'] as String?,
      images: images,
      categoryName: json['category']?['name'] as String? ??
          json['category_name'] as String?,
      destinationName: json['destination']?['name'] as String? ??
          json['destination_name'] as String?,
      organizerName: json['organizer']?['business_name'] as String? ??
          json['organizer_name'] as String?,
      isAvailable: json['is_available'] as bool? ?? true,
      status: json['status'] as String?,
    );
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is double) return val;
    if (val is int) return val.toDouble();
    return double.tryParse(val.toString()) ?? 0.0;
  }
}
