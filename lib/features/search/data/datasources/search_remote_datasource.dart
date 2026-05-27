import '../../../../core/network/api_client.dart';
import '../../domain/entities/search_result_entity.dart';

abstract class SearchRemoteDatasource {
  Future<List<SearchResultEntity>> searchTrips({
    String? query,
    double? latitude,
    double? longitude,
    double? radius,
    String? departureDate,
    int page = 1,
  });
}

class SearchRemoteDatasourceImpl implements SearchRemoteDatasource {
  final ApiClient _api;
  const SearchRemoteDatasourceImpl(this._api);

  @override
  Future<List<SearchResultEntity>> searchTrips({
    String? query,
    double? latitude,
    double? longitude,
    double? radius,
    String? departureDate,
    int page = 1,
  }) async {
    final params = <String, dynamic>{'page': page};
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (latitude != null) params['latitude'] = latitude;
    if (longitude != null) params['longitude'] = longitude;
    if (radius != null) params['radius'] = radius;
    if (departureDate != null) params['departure_date'] = departureDate;

    final response = await _api.get('/trips/search', queryParams: params);
    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => SearchResultEntity.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
