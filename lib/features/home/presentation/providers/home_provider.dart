import 'package:flutter/foundation.dart';
import '../../../trip/domain/entities/trip_entity.dart';
import '../../../trip/domain/usecases/get_trips_usecase.dart';
import '../../../trip/domain/usecases/get_featured_trips_usecase.dart';

class HomeProvider extends ChangeNotifier {
  final GetTripsUsecase _getTrips;
  final GetFeaturedTripsUsecase _getFeatured;

  List<TripEntity> _featuredTrips = [];
  List<TripEntity> _latestTrips = [];
  bool _isLoading = false;
  String? _error;

  HomeProvider(this._getTrips, this._getFeatured);

  List<TripEntity> get featuredTrips => _featuredTrips;
  List<TripEntity> get latestTrips => _latestTrips;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadHomeData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final results = await Future.wait([
      _getFeatured(),
      _getTrips(page: 1, limit: 10),
    ]);

    results[0].fold(
      (failure) => _featuredTrips = [],
      (trips) => _featuredTrips = trips as List<TripEntity>,
    );

    results[1].fold(
      (failure) {
        _error = failure.message;
        _latestTrips = [];
      },
      (trips) => _latestTrips = trips as List<TripEntity>,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => loadHomeData();
}
