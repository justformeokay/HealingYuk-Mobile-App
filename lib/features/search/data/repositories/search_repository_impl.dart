import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/search_result_entity.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDatasource _remote;
  const SearchRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<SearchResultEntity>>> searchTrips({
    String? query,
    double? latitude,
    double? longitude,
    double? radius,
    String? departureDate,
    int page = 1,
  }) async {
    try {
      final results = await _remote.searchTrips(
        query: query,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        departureDate: departureDate,
        page: page,
      );
      return Right(results);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
