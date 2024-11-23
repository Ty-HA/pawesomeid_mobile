// sanctuary_details_screen.dart
import 'package:flutter/material.dart';
import 'primate_details_screen.dart';

class SanctuaryDetailsScreen extends StatelessWidget {
  final String sanctuaryName;
  final String location;

  // Mock data pour la liste des primates
  final List<Map<String, dynamic>> primates = [
    {
      'id': 'PRM-2024-001',
      'name': 'Charlie',
      'species': 'Chimpanzee',
      'age': 8,
      'sex': 'Male',
      'imageUrl': 'assets/images/chimpanze.jpg',
      'status': 'Healthy',
      'arrivalDate': '2020-06-15',
      'origin': 'Rescued from illegal pet trade',
      'healthStatus': 'Good',
      'lastCheckup': '2024-03-15',
      'weight': '45.5',
      'medicalNotes': 'Regular check-up completed. All vaccinations up to date.',
      'dietType': 'Standard Primate Diet',
      'dietaryNeeds': 'Extra fruits during training',
      'feedingSchedule': '3 times daily',
      'behaviorNotes': 'Friendly and social. Shows great progress in rehabilitation program.',
      'socialStatus': 'Well integrated with group',
      'enrichmentNeeds': 'Enjoys puzzle feeders and rope swings',
    },
    {
      'id': 'PRM-2024-002',
      'name': 'Lucy',
      'species': 'Orangutan',
      'age': 6,
      'sex': 'Female',
      'imageUrl': 'assets/images/orang.jpg',
      'status': 'Under observation',
      'arrivalDate': '2021-03-20',
      'origin': 'Born in sanctuary',
      'healthStatus': 'Excellent',
      'lastCheckup': '2024-03-10',
      'weight': '35.2',
      'medicalNotes': 'Growing well, showing normal development patterns',
      'dietType': 'Standard Primate Diet',
      'dietaryNeeds': 'Additional calcium supplements',
      'feedingSchedule': '4 times daily',
      'behaviorNotes': 'Very intelligent, quick learner in enrichment activities',
      'socialStatus': 'Popular among peers',
      'enrichmentNeeds': 'Complex puzzle toys, climbing structures',
    },
    {
      'id': 'PRM-2024-003',
      'name': 'Max',
      'species': 'Chimpanze',
      'age': 12,
      'sex': 'Female',
      'imageUrl': 'assets/images/chimpanze2.jpg',
      'status': 'Under observation',
      'arrivalDate': '2021-03-20',
      'origin': 'Born in sanctuary',
      'healthStatus': 'Excellent',
      'lastCheckup': '2024-03-10',
      'weight': '35.2',
      'medicalNotes': 'Growing well, showing normal development patterns',
      'dietType': 'Standard Primate Diet',
      'dietaryNeeds': 'Additional calcium supplements',
      'feedingSchedule': '4 times daily',
      'behaviorNotes': 'Very intelligent, quick learner in enrichment activities',
      'socialStatus': 'Popular among peers',
      'enrichmentNeeds': 'Complex puzzle toys, climbing structures',
    }
    // Ajoutez plus de primates selon vos besoins
  ];

  SanctuaryDetailsScreen({
    Key? key,
    required this.sanctuaryName,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: Text(
          sanctuaryName,
          style: const TextStyle(
            color: Color(0xFFecaa00),  
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFecaa00),
        ),
      ),
      body: Column(
        children: [
          _buildSanctuaryHeader(context),
          Expanded(
            child: _buildPrimatesList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSanctuaryHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xFF1A237E).withOpacity(0.1),
                child: const Icon(
                  Icons.park,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sanctuaryName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    Text(
                      location,
                      style: TextStyle(
                        color: const Color(0xFF1A237E).withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFecaa00).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.pets,
                  size: 18,
                  color: Color(0xFFecaa00),
                ),
                const SizedBox(width: 8),
                Text(
                  '${primates.length} Primates',
                  style: const TextStyle(
                    color: Color(0xFFecaa00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimatesList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: primates.length,
      itemBuilder: (context, index) {
        final primate = primates[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrimateDetailsScreen(
                  primateData: primate,
                ),
              ),
            ),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(primate['imageUrl']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          primate['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          primate['species'],
                          style: TextStyle(
                            color: const Color(0xFF1A237E).withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFecaa00).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            primate['status'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFecaa00),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFecaa00),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}