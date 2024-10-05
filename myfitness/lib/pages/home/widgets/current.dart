import 'package:flutter/material.dart';
import 'package:myfitness/models/fitness_program.dart';

class CurrentPrograms extends StatefulWidget {
  const CurrentPrograms({Key? key}) : super(key: key);

  @override
  State<CurrentPrograms> createState() => _CurrentProgramsState();
}

class _CurrentProgramsState extends State<CurrentPrograms> {
  ProgramType active = fitnessPrograms[0].type;

  void _changeProgram(ProgramType newType) {
    setState(() {
      active = newType;
    });
  }

  void _showMoreOptions(BuildContext context, FitnessProgram program) {
    // Define cardio-specific options and their images
    final List<Map<String, String>> cardioOptions = [
      {'name': 'Indoor Running', 'image': 'assets/running.png'},
      {'name': 'Outdoor Running', 'image': 'assets/outdoor running.jpg'},
      {'name': 'Rope Skipping', 'image': 'assets/rope skipping.jpg'},
      {'name': 'Indoor Cycling', 'image': 'assets/indoor cycling.jpg'},
      {'name': 'Outdoor Cycling', 'image': 'assets/outdoor cycling.jpg'},
      {'name': 'Outdoor Walking', 'image': 'assets/outdoor walking.jpg'},
    ];

    // Define weight-lifting options and their images
    final List<Map<String, String>> weightOptions = [
      {'name': 'Barbell', 'image': 'assets/barbell.jpg'},
      {'name': 'Dumbbell', 'image': 'assets/dumbbell.jpg'},
      {'name': 'Kettlebell', 'image': 'assets/kettlebell.jpg'},
      {'name': 'Smith Machine', 'image': 'assets/smith.jpg'},
    ];

    List<Map<String, String>> options = program.type == ProgramType.cardio
        ? cardioOptions
        : weightOptions;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 700, // Increased height for the bottom box
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${program.name} ',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(
                    options.length,
                    (index) {
                      String optionName = options[index]['name']!;
                      String imagePath = options[index]['image']!;

                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Close modal after selection
                        },
                        child: Container(
                          height: 100, // Reduced height for the option containers
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: AssetImage(imagePath),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.darken,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            optionName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16, // Adjusted font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Programs',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              // Removed the arrow icon
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 100, // Reduced height of the program containers
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: fitnessPrograms.length,
            itemBuilder: (context, index) {
              return Program(
                program: fitnessPrograms[index],
                active: fitnessPrograms[index].type == active,
                onTap: (ProgramType programType) {
                  _changeProgram(programType);
                  _showMoreOptions(context, fitnessPrograms[index]);
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 40),
          ),
        ),
      ],
    );
  }
}

class Program extends StatelessWidget {
  final FitnessProgram program;
  final bool active;
  final Function(ProgramType) onTap;

  const Program({
    Key? key,
    required this.program,
    this.active = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(program.type);
      },
      child: Container(
        height: 80, // Reduced height of the program container
        width: 170, // Reduced width of the program container
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              active
                  ? const Color(0xff1ebdf8).withOpacity(.8)
                  : Colors.white.withOpacity(.8),
              BlendMode.lighten,
            ),
            image: program.image,
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(10),
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: active ? Colors.white : Colors.black,
            fontSize: 12, // Slightly increased font size
            fontWeight: FontWeight.w500,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(program.name),
            ],
          ),
        ),
      ),
    );
  }
}
