import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/search_result_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<SearchResultEntity>>> searchTrips({
    String? query,
    double? latitude,
    double? longitude,
    double? radius,
    String? departureDate,
    int page = 1,
  });
}
