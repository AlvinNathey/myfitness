import 'package:flutter/material.dart';
import 'package:myfitness/pages/home/widgets/activity.dart';
import 'package:myfitness/pages/home/widgets/current.dart';

class Records extends StatelessWidget {
  const Records({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CurrentPrograms(),
        RecentActivities(),
      ],
    );
  }
}
