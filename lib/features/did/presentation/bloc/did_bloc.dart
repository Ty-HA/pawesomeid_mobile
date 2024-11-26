// lib/features/did/presentation/bloc/did_bloc.dart
class DIDBloc extends Bloc<DIDEvent, DIDState> {
  final CreateAnimalDID createAnimalDID;
  
  DIDBloc({required this.createAnimalDID}) : super(DIDInitial()) {
    on<CreateDIDEvent>((event, emit) async {
      emit(DIDLoading());
      
      final result = await createAnimalDID(event.animal);
      
      result.fold(
        (failure) => emit(DIDError(message: _mapFailureToMessage(failure))),
        (did) => emit(DIDCreated(did: did))
      );
    });
  }
}