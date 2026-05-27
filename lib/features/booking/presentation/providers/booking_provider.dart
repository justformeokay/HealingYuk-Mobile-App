import 'package:flutter/foundation.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/get_bookings_usecase.dart';

class BookingProvider extends ChangeNotifier {
  final GetBookingsUsecase _getBookings;
  final CreateBookingUsecase _createBooking;
  final CancelBookingUsecase _cancelBooking;

  List<BookingEntity> _bookings = [];
  BookingEntity? _newBooking;
  bool _isLoading = false;
  bool _isCreating = false;
  String? _error;

  BookingProvider(this._getBookings, this._createBooking, this._cancelBooking);

  List<BookingEntity> get bookings => _bookings;
  BookingEntity? get newBooking => _newBooking;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  String? get error => _error;

  Future<void> loadBookings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _getBookings();
    result.fold(
      (failure) {
        _error = failure.message;
        _bookings = [];
      },
      (bookings) {
        _bookings = bookings;
        _error = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createBooking({
    required int tripId,
    required int participants,
    String? notes,
  }) async {
    _isCreating = true;
    _error = null;
    notifyListeners();

    final result = await _createBooking(
      tripId: tripId,
      participants: participants,
      notes: notes,
    );

    final success = result.fold(
      (failure) {
        _error = failure.message;
        return false;
      },
      (booking) {
        _newBooking = booking;
        _bookings.insert(0, booking);
        return true;
      },
    );

    _isCreating = false;
    notifyListeners();
    return success;
  }

  Future<bool> cancelBooking(int id) async {
    final result = await _cancelBooking(id);
    return result.fold(
      (failure) {
        _error = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        _bookings = _bookings.map((b) {
          if (b.id == id) {
            return BookingEntity(
              id: b.id,
              bookingCode: b.bookingCode,
              status: 'cancelled',
              participants: b.participants,
              totalAmount: b.totalAmount,
              tripTitle: b.tripTitle,
              tripCoverImage: b.tripCoverImage,
              departureDate: b.departureDate,
              createdAt: b.createdAt,
            );
          }
          return b;
        }).toList();
        notifyListeners();
        return true;
      },
    );
  }
}
