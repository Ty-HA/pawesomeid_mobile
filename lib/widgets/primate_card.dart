// lib/widgets/primate_card.dart
import 'package:flutter/material.dart';
import '../models/primate.dart';

class PrimateCard extends StatelessWidget {
 final Primate primate;
 final VoidCallback? onTap;

 const PrimateCard({
   Key? key, 
   required this.primate,
   this.onTap,
 }) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return Card(
     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
     child: InkWell(
       onTap: onTap,
       child: Padding(
         padding: const EdgeInsets.all(16),
         child: Row(
           children: [
             Container(
               width: 80,
               height: 80,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(8),
                 image: DecorationImage(
                   image: primate.imageUrl.startsWith('http') 
                     ? NetworkImage(primate.imageUrl)
                     : AssetImage(primate.imageUrl) as ImageProvider,
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
                     primate.name,
                     style: Theme.of(context).textTheme.titleLarge,
                   ),
                  const SizedBox(height: 4),
                   Text(
                     primate.species,
                     style: Theme.of(context).textTheme.bodyLarge,
                   ),
                   const SizedBox(height: 4),
                   Text(
                     'Age: ${primate.age} years',
                     style: Theme.of(context).textTheme.bodyMedium,
                   ),
                   const SizedBox(height: 8),
                   Row(
                     children: [
                       const Icon(Icons.verified, size: 16, color: Colors.blue),
                       const SizedBox(width: 4),
                       Expanded(
                         child: Text(
                           'DID: ${primate.did.substring(0, 10)}...',
                           style: Theme.of(context).textTheme.bodySmall,
                           overflow: TextOverflow.ellipsis,
                         ),
                       ),
                     ],
                   ),
                 ],
               ),
             ),
             const Icon(Icons.chevron_right),
           ],
         ),
       ),
     ),
   );
 }
}