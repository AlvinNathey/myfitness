import 'package:flutter/material.dart';

enum ProgramType {
  cardio,
  lift,
}

class FitnessProgram {
  final AssetImage image;
  final String name;
  final ProgramType type;

  FitnessProgram({
    required this.image,
    required this.name,
    required this.type,
  });
}

final List<FitnessProgram> fitnessPrograms = [
  FitnessProgram(
    image: const AssetImage('assets/running.png'),
    name: 'Cardio options',
    type: ProgramType.cardio,
  ),
  FitnessProgram(
    image: const AssetImage('assets/gym.png'),
    name: 'Weight Lifting Options',
    type: ProgramType.lift,
  ),
];
