// lib/features/did/data/repositories/did_repository_impl.dart
class DIDRepositoryImpl implements DIDRepository {
  final DIDRemoteDataSource remoteDataSource;
  final DIDLocalDataSource localDataSource;
  
  Future<Either<Failure, String>> createAnimalDID(AnimalDID animal) async {
    try {
      final did = await remoteDataSource.createDID(animal);
      await localDataSource.cacheDID(did);
      return Right(did);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}