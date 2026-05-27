import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../services/session_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/trip/data/datasources/trip_remote_datasource.dart';
import '../../features/trip/data/repositories/trip_repository_impl.dart';
import '../../features/trip/domain/repositories/trip_repository.dart';
import '../../features/trip/domain/usecases/get_trips_usecase.dart';
import '../../features/trip/domain/usecases/get_trip_detail_usecase.dart';
import '../../features/trip/domain/usecases/get_featured_trips_usecase.dart';
import '../../features/trip/presentation/providers/trip_provider.dart';
import '../../features/home/presentation/providers/home_provider.dart';
import '../../features/search/data/datasources/search_remote_datasource.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/domain/usecases/search_trips_usecase.dart';
import '../../features/search/presentation/providers/search_provider.dart';
import '../../features/booking/data/datasources/booking_remote_datasource.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/domain/usecases/get_bookings_usecase.dart';
import '../../features/booking/presentation/providers/booking_provider.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // ── Core ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );
  sl.registerLazySingleton<SessionService>(() => SessionService(sl()));
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

  // ── Auth ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => RegisterUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerFactory(() => AuthProvider(sl(), sl(), sl(), sl()));

  // ── Trip ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<TripRemoteDatasource>(
      () => TripRemoteDatasourceImpl(sl()));
  sl.registerLazySingleton<TripRepository>(() => TripRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetTripsUsecase(sl()));
  sl.registerLazySingleton(() => GetTripDetailUsecase(sl()));
  sl.registerLazySingleton(() => GetFeaturedTripsUsecase(sl()));
  sl.registerFactory(() => TripProvider(sl(), sl(), sl()));

  // ── Home ──────────────────────────────────────────────────────────────────
  sl.registerFactory(() => HomeProvider(sl(), sl()));

  // ── Search ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<SearchRemoteDatasource>(
      () => SearchRemoteDatasourceImpl(sl()));
  sl.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(sl()));
  sl.registerLazySingleton(() => SearchTripsUsecase(sl()));
  sl.registerFactory(() => SearchProvider(sl()));

  // ── Booking ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<BookingRemoteDatasource>(
      () => BookingRemoteDatasourceImpl(sl()));
  sl.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetBookingsUsecase(sl()));
  sl.registerLazySingleton(() => CreateBookingUsecase(sl()));
  sl.registerLazySingleton(() => CancelBookingUsecase(sl()));
  sl.registerFactory(() => BookingProvider(sl(), sl(), sl()));

  // ── Profile ───────────────────────────────────────────────────────────────
  sl.registerFactory(() => ProfileProvider(sl<ApiClient>(), sl<SessionService>()));
}
