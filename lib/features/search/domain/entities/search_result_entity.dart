import 'package:equatable/equatable.dart';

class SearchResultEntity extends Equatable {
  final int id;
  final String title;
  final String slug;
  final double price;
  final String? coverImage;
  final String? destinationName;
  final int durationDays;
  final int durationNights;
  final double rating;
  final int availableSlots;
  final double? distanceKm;

  const SearchResultEntity({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    this.coverImage,
    this.destinationName,
    required this.durationDays,
    required this.durationNights,
    this.rating = 0,
    required this.availableSlots,
    this.distanceKm,
  });

  factory SearchResultEntity.fromJson(Map<String, dynamic> json) {
    return SearchResultEntity(
      id: json['id'] as int,
      title: json['title'] as String,
      slug: json['slug'] as String? ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      coverImage: json['cover_image'] as String?,
      destinationName: json['destination']?['name'] as String? ??
          json['destination_name'] as String?,
      durationDays: json['duration_days'] as int? ?? 1,
      durationNights: json['duration_nights'] as int? ?? 0,
      rating:
          double.tryParse((json['average_rating'] ?? 0).toString()) ?? 0.0,
      availableSlots: json['available_slots'] as int? ?? 0,
      distanceKm: json['distance_km'] != null
          ? double.tryParse(json['distance_km'].toString())
          : null,
    );
  }

  @override
  List<Object?> get props => [id];
}
