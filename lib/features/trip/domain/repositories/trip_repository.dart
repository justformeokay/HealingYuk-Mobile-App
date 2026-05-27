import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/trip_entity.dart';

abstract class TripRepository {
  Future<Either<Failure, List<TripEntity>>> getTrips({
    int page = 1,
    int limit = 15,
    String? categoryId,
    String? destinationId,
    String? query,
  });

  Future<Either<Failure, TripEntity>> getTripDetail(int id);

  Future<Either<Failure, List<TripEntity>>> getFeaturedTrips();

  Future<Either<Failure, List<dynamic>>> getCategories();

  Future<Either<Failure, List<dynamic>>> getDestinations();
}
