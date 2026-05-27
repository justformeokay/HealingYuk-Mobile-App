import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetBookingsUsecase {
  final BookingRepository _r;
  const GetBookingsUsecase(this._r);
  Future<Either<Failure, List<BookingEntity>>> call() => _r.getBookings();
}

class CreateBookingUsecase {
  final BookingRepository _r;
  const CreateBookingUsecase(this._r);
  Future<Either<Failure, BookingEntity>> call({
    required int tripId,
    required int participants,
    String? notes,
  }) =>
      _r.createBooking(
          tripId: tripId, participants: participants, notes: notes);
}

class CancelBookingUsecase {
  final BookingRepository _r;
  const CancelBookingUsecase(this._r);
  Future<Either<Failure, void>> call(int id) => _r.cancelBooking(id);
}
