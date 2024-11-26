// lib/features/did/presentation/bloc/did_state.dart
abstract class DIDState extends Equatable {
  const DIDState();
  
  @override
  List<Object> get props => [];
}

class DIDInitial extends DIDState {}
class DIDLoading extends DIDState {}
class DIDCreated extends DIDState {
  final String did;
  const DIDCreated({required this.did});
}