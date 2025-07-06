import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:board_games_empire/router/route_constants.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.question_mark_rounded,
                size: 90,
                color: Colors.grey,
              ),

              const SizedBox(height: 24),

              Text(
                'Oops! Page Not Found',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              const Text(
                'The page you were looking for doesn\'t seem to exist.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: () {
                  context.goNamed(AppRouteNames.home);
                },
                icon: const Icon(Icons.home),
                label: const Text('Go to Homepage'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
