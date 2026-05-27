import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/trip_entity.dart';
import '../repositories/trip_repository.dart';

class GetTripsUsecase {
  final TripRepository _repository;
  const GetTripsUsecase(this._repository);

  Future<Either<Failure, List<TripEntity>>> call({
    int page = 1,
    int limit = 15,
    String? categoryId,
    String? destinationId,
    String? query,
  }) =>
      _repository.getTrips(
        page: page,
        limit: limit,
        categoryId: categoryId,
        destinationId: destinationId,
        query: query,
      );
}
