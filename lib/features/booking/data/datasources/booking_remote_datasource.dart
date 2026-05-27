import '../../../../core/network/api_client.dart';
import '../../domain/entities/booking_entity.dart';

abstract class BookingRemoteDatasource {
  Future<List<BookingEntity>> getBookings();
  Future<BookingEntity> getBookingDetail(int id);
  Future<BookingEntity> createBooking({
    required int tripId,
    required int participants,
    String? notes,
  });
  Future<void> cancelBooking(int id);
}

class BookingRemoteDatasourceImpl implements BookingRemoteDatasource {
  final ApiClient _api;
  const BookingRemoteDatasourceImpl(this._api);

  @override
  Future<List<BookingEntity>> getBookings() async {
    final response = await _api.get('/bookings');
    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => BookingEntity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<BookingEntity> getBookingDetail(int id) async {
    final response = await _api.get('/bookings/$id');
    return BookingEntity.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<BookingEntity> createBooking({
    required int tripId,
    required int participants,
    String? notes,
  }) async {
    final response = await _api.post('/bookings', data: {
      'trip_id': tripId,
      'participants': participants,
      if (notes != null) 'notes': notes,
    });
    return BookingEntity.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> cancelBooking(int id) async {
    await _api.patch('/bookings/$id/cancel');
  }
}
