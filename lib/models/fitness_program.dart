
enum ProgramType {
  cardio,
  lift,
}

class FitnessProgram {
  final String image; // Changed to String for image path
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
    image: 'assets/running.png', // Use String for image path
    name: 'Cardio options',
    type: ProgramType.cardio,
  ),
  FitnessProgram(
    image: 'assets/gym.png', // Use String for image path
    name: 'Weight Lifting Options',
    type: ProgramType.lift,
  ),
];
