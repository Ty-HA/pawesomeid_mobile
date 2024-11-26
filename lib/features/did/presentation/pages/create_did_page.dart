// lib/features/did/presentation/pages/create_did_page.dart
class CreateDIDPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<DIDBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text('Créer DID Animal')),
        body: BlocBuilder<DIDBloc, DIDState>(
          builder: (context, state) {
            if (state is DIDLoading) {
              return Center(child: CircularProgressIndicator());
            }
            // ... reste de l'implémentation
          },
        ),
      ),
    );
  }
}