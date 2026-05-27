import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/trip_entity.dart';
import '../repositories/trip_repository.dart';

class GetFeaturedTripsUsecase {
  final TripRepository _repository;
  const GetFeaturedTripsUsecase(this._repository);

  Future<Either<Failure, List<TripEntity>>> call() =>
      _repository.getFeaturedTrips();
}
