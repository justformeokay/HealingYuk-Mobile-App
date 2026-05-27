import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/search_result_entity.dart';
import '../../domain/usecases/search_trips_usecase.dart';

class SearchProvider extends ChangeNotifier {
  final SearchTripsUsecase _searchTrips;

  List<SearchResultEntity> _results = [];
  bool _isLoading = false;
  String? _error;
  String _query = '';
  Timer? _debounce;

  SearchProvider(this._searchTrips);

  List<SearchResultEntity> get results => _results;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get query => _query;
  bool get hasQuery => _query.isNotEmpty;

  void onQueryChanged(String query) {
    _query = query;
    _debounce?.cancel();
    if (query.isEmpty) {
      _results = [];
      _error = null;
      notifyListeners();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      search(query: query);
    });
  }

  Future<void> search({
    String? query,
    double? latitude,
    double? longitude,
    double? radius,
    String? departureDate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _searchTrips(
      query: query ?? _query,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      departureDate: departureDate,
    );

    result.fold(
      (failure) {
        _error = failure.message;
        _results = [];
      },
      (results) {
        _results = results;
        _error = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _query = '';
    _results = [];
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
