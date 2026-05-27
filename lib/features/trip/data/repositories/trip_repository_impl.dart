import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/trip_remote_datasource.dart';

class TripRepositoryImpl implements TripRepository {
  final TripRemoteDatasource _remote;
  const TripRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<TripEntity>>> getTrips({
    int page = 1,
    int limit = 15,
    String? categoryId,
    String? destinationId,
    String? query,
  }) async {
    try {
      final trips = await _remote.getTrips(
        page: page,
        limit: limit,
        categoryId: categoryId,
        destinationId: destinationId,
        query: query,
      );
      return Right(trips);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on AppException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, TripEntity>> getTripDetail(int id) async {
    try {
      final trip = await _remote.getTripDetail(id);
      return Right(trip);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on NotFoundException catch (e) {
      return Left(ServerFailure(e.message, statusCode: 404));
    } on AppException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<TripEntity>>> getFeaturedTrips() async {
    try {
      final trips = await _remote.getFeaturedTrips();
      return Right(trips);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on AppException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getCategories() async {
    try {
      final cats = await _remote.getCategories();
      return Right(cats);
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getDestinations() async {
    try {
      final dest = await _remote.getDestinations();
      return Right(dest);
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
