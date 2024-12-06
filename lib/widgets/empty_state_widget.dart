import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            '아직 할 일이 없습니다.',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '새로운 할 일을 추가해보세요!',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
