import 'package:flutter/material.dart';

class PrimateDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> primateData;

  const PrimateDetailsScreen({
    Key? key,
    required this.primateData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Primate Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement edit functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            _buildInfoSection(),
            _buildHealthSection(),
            _buildDietSection(),
            _buildBehaviorSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(primateData['imageUrl'] ?? 
                'https://via.placeholder.com/400x200?text=Primate+Photo'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                primateData['name'] ?? 'Unknown Primate',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'ID: ${primateData['id'] ?? 'Unknown'}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Species', primateData['species'] ?? 'Unknown'),
            _buildInfoRow('Age', '${primateData['age'] ?? 'Unknown'} years'),
            _buildInfoRow('Sex', primateData['sex'] ?? 'Unknown'),
            _buildInfoRow('Arrival Date', primateData['arrivalDate'] ?? 'Unknown'),
            _buildInfoRow('Origin', primateData['origin'] ?? 'Unknown'),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildHealthIndicator(
              'Overall Health',
              primateData['healthStatus'] ?? 'Good',
              Icons.favorite,
              Colors.green,
            ),
            _buildInfoRow('Last Check-up', primateData['lastCheckup'] ?? 'Unknown'),
            _buildInfoRow('Weight', '${primateData['weight'] ?? 'Unknown'} kg'),
            _buildInfoRow('Medical Notes', primateData['medicalNotes'] ?? 'No notes'),
          ],
        ),
      ),
    );
  }

  Widget _buildDietSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Diet Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Diet Type', primateData['dietType'] ?? 'Standard'),
            _buildInfoRow('Special Needs', primateData['dietaryNeeds'] ?? 'None'),
            _buildInfoRow('Feeding Schedule', primateData['feedingSchedule'] ?? '3 times daily'),
          ],
        ),
      ),
    );
  }

  Widget _buildBehaviorSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Behavioral Notes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(primateData['behaviorNotes'] ?? 'No behavioral notes recorded'),
            const SizedBox(height: 16),
            _buildInfoRow('Social Status', primateData['socialStatus'] ?? 'Unknown'),
            _buildInfoRow('Enrichment Needs', primateData['enrichmentNeeds'] ?? 'Standard'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthIndicator(
    String label, 
    String status, 
    IconData icon, 
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}