import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<Either<Failure, List<BookingEntity>>> getBookings();

  Future<Either<Failure, BookingEntity>> getBookingDetail(int id);

  Future<Either<Failure, BookingEntity>> createBooking({
    required int tripId,
    required int participants,
    String? notes,
  });

  Future<Either<Failure, void>> cancelBooking(int id);
}
