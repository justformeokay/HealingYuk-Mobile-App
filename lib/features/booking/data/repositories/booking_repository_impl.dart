import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDatasource _remote;
  const BookingRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<BookingEntity>>> getBookings() async {
    try {
      return Right(await _remote.getBookings());
    } on UnauthorizedException {
      return const Left(AuthFailure());
    } on NetworkException {
      return const Left(NetworkFailure());
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBookingDetail(int id) async {
    try {
      return Right(await _remote.getBookingDetail(id));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> createBooking({
    required int tripId,
    required int participants,
    String? notes,
  }) async {
    try {
      return Right(await _remote.createBooking(
        tripId: tripId,
        participants: participants,
        notes: notes,
      ));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message, errors: e.errors));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> cancelBooking(int id) async {
    try {
      await _remote.cancelBooking(id);
      return const Right(null);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
