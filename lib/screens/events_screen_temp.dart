import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/providers/rewards_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';

/// Écran des événements temporaire - Version simplifiée
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Événements'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<RewardsProvider>(
        builder: (context, rewardsProvider, child) {
          final events = rewardsProvider.getActiveEvents();

          if (events.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_available,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucun événement actif',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Revenez plus tard pour de nouveaux défis !',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.celebration,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              event['name'] ?? 'Événement',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'ACTIF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event['description'] ?? 'Description de l\'événement',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          final audioProvider = Provider.of<AudioProvider>(
                            context,
                            listen: false,
                          );
                          audioProvider.playButtonClick();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Participation enregistrée !'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        child: const Text('Participer'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
