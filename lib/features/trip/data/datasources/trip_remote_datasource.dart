import '../../../../core/network/api_client.dart';
import '../models/trip_model.dart';

abstract class TripRemoteDatasource {
  Future<List<TripModel>> getTrips({
    int page = 1,
    int limit = 15,
    String? categoryId,
    String? destinationId,
    String? query,
  });

  Future<TripModel> getTripDetail(int id);

  Future<List<TripModel>> getFeaturedTrips();

  Future<List<Map<String, dynamic>>> getCategories();

  Future<List<Map<String, dynamic>>> getDestinations();
}

class TripRemoteDatasourceImpl implements TripRemoteDatasource {
  final ApiClient _api;
  const TripRemoteDatasourceImpl(this._api);

  @override
  Future<List<TripModel>> getTrips({
    int page = 1,
    int limit = 15,
    String? categoryId,
    String? destinationId,
    String? query,
  }) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (categoryId != null) params['category_id'] = categoryId;
    if (destinationId != null) params['destination_id'] = destinationId;
    if (query != null && query.isNotEmpty) params['q'] = query;

    final response = await _api.get('/trips/', queryParams: params);
    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => TripModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<TripModel> getTripDetail(int id) async {
    final response = await _api.get('/trips/$id');
    return TripModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<TripModel>> getFeaturedTrips() async {
    final response = await _api.get('/trips/featured');
    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => TripModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await _api.get('/categories');
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((e) => e as Map<String, dynamic>).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getDestinations() async {
    final response = await _api.get('/destinations');
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((e) => e as Map<String, dynamic>).toList();
  }
}
