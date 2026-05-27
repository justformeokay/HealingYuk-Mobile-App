import 'package:flutter/foundation.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/usecases/get_trips_usecase.dart';
import '../../domain/usecases/get_trip_detail_usecase.dart';
import '../../domain/usecases/get_featured_trips_usecase.dart';

enum TripLoadState { initial, loading, loaded, error }

class TripProvider extends ChangeNotifier {
  final GetTripsUsecase _getTrips;
  final GetTripDetailUsecase _getTripDetail;
  final GetFeaturedTripsUsecase _getFeatured;

  TripLoadState _state = TripLoadState.initial;
  List<TripEntity> _trips = [];
  TripEntity? _selectedTrip;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  TripProvider(this._getTrips, this._getTripDetail, this._getFeatured);

  TripLoadState get state => _state;
  List<TripEntity> get trips => _trips;
  TripEntity? get selectedTrip => _selectedTrip;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  bool get isLoading => _state == TripLoadState.loading;

  Future<void> loadTrips({
    bool refresh = false,
    String? categoryId,
    String? destinationId,
    String? query,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _trips = [];
    }

    if (!_hasMore && !refresh) return;

    if (_currentPage == 1) {
      _state = TripLoadState.loading;
      notifyListeners();
    } else {
      _isLoadingMore = true;
      notifyListeners();
    }

    final result = await _getTrips(
      page: _currentPage,
      categoryId: categoryId,
      destinationId: destinationId,
      query: query,
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = TripLoadState.error;
      },
      (newTrips) {
        _trips.addAll(newTrips);
        _hasMore = newTrips.length >= 15;
        _currentPage++;
        _state = TripLoadState.loaded;
        _errorMessage = null;
      },
    );

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> loadTripDetail(int id) async {
    _selectedTrip = null;
    _state = TripLoadState.loading;
    notifyListeners();

    final result = await _getTripDetail(id);
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = TripLoadState.error;
      },
      (trip) {
        _selectedTrip = trip;
        _state = TripLoadState.loaded;
        _errorMessage = null;
      },
    );
    notifyListeners();
  }

  Future<List<TripEntity>> loadFeaturedTrips() async {
    final result = await _getFeatured();
    return result.fold((_) => [], (trips) => trips);
  }
}
