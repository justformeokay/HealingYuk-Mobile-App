import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/search_result_entity.dart';
import '../repositories/search_repository.dart';

class SearchTripsUsecase {
  final SearchRepository _repository;
  const SearchTripsUsecase(this._repository);

  Future<Either<Failure, List<SearchResultEntity>>> call({
    String? query,
    double? latitude,
    double? longitude,
    double? radius,
    String? departureDate,
    int page = 1,
  }) =>
      _repository.searchTrips(
        query: query,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        departureDate: departureDate,
        page: page,
      );
}
