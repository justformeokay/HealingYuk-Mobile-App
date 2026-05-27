import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/trip_entity.dart';
import '../repositories/trip_repository.dart';

class GetTripDetailUsecase {
  final TripRepository _repository;
  const GetTripDetailUsecase(this._repository);

  Future<Either<Failure, TripEntity>> call(int id) =>
      _repository.getTripDetail(id);
}
