// lib/injection_container.dart
final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => DIDBloc(createAnimalDID: sl()));
  
  // Use Cases
  sl.registerLazySingleton(() => CreateAnimalDID(sl()));
  
  // Repositories
  sl.registerLazySingleton<DIDRepository>(
    () => DIDRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
}