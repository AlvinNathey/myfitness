import 'package:flutter/material.dart';
import 'package:myfitness/models/fitness_program.dart';
import 'package:myfitness/database.dart'; // Import your DatabaseService

class CurrentPrograms extends StatefulWidget {
  final Function onActivityAdded; // Add this line

  const CurrentPrograms({super.key, required this.onActivityAdded}); // Update the constructor

  @override
  State<CurrentPrograms> createState() => _CurrentProgramsState();
}

class _CurrentProgramsState extends State<CurrentPrograms> {
  ProgramType active = fitnessPrograms[0].type;
  String? selectedWorkout; // To store selected workout
  String? selectedImage; // To store the image path of the selected workout

  // Create an instance of DatabaseService
  DatabaseService dbService = DatabaseService(); 

  // Fetch the latest data and update the UI
  void _refreshData() async {
    setState(() {
      // You can update any part of the UI with the newly fetched data here
    });
  }

  void _changeProgram(ProgramType newType) {
    setState(() {
      active = newType;
      selectedWorkout = null; // Reset selected workout on program change
      selectedImage = null; // Reset selected image on program change
    });
  }

  void _showMoreOptions(BuildContext context, FitnessProgram program) {
    final List<Map<String, String>> cardioOptions = [
      {'name': 'Indoor Running', 'image': 'assets/running.png'},
      {'name': 'Outdoor Running', 'image': 'assets/outdoor running.jpg'},
      {'name': 'Rope Skipping', 'image': 'assets/rope skipping.jpg'},
      {'name': 'Indoor Cycling', 'image': 'assets/indoor cycling.jpg'},
      {'name': 'Outdoor Cycling', 'image': 'assets/outdoor cycling.jpg'},
      {'name': 'Outdoor Walking', 'image': 'assets/outdoor walking.jpg'},
    ];

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
          height: 700,
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
                          setState(() {
                            selectedWorkout = optionName; // Set selected workout
                            selectedImage = imagePath; // Set selected image path
                          });
                          Navigator.pop(context); // Close modal after selection
                          _showInputDialog(context); // Show input dialog
                        },
                        child: Container(
                          height: 100,
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showInputDialog(BuildContext context) {
    String duration = '';
    String calories = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.all(16),
          title: Text('$selectedWorkout Workout'),
          content: SizedBox(
            height: 300, // Increased height to accommodate image and text fields
            child: Column(
              children: [
                // Display selected workout image
                Container(
                  height: 150, // Keep the image height as is
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: selectedImage != null 
                          ? AssetImage(selectedImage!)
                          : AssetImage('assets/profile.jpg'), // Default image if no workout selected
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(labelText: 'Duration (min)'),
                  keyboardType: TextInputType.number, // Allow only numbers
                  onChanged: (value) {
                    duration = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Calories (kcal)'),
                  keyboardType: TextInputType.number, // Allow only numbers
                  onChanged: (value) {
                    calories = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedWorkout != null && duration.isNotEmpty && calories.isNotEmpty) {
                  await dbService.addActivity(selectedWorkout!, duration, calories, selectedImage);
                  
                  // Call the callback here
                  widget.onActivityAdded(); // This calls the callback to refresh activities
                  
                  _refreshData(); // Refresh data after recording the workout
                  
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  // Handle empty inputs
                  print('Please fill all fields');
                }
              },
              child: const Text('Record'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Row(
              children: fitnessPrograms.map((program) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _changeProgram(program.type);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 55,
                      decoration: BoxDecoration(
                        color: active == program.type ? const Color(0xffcff2ff) : null,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        program.name,
                        style: TextStyle(
                          fontSize: 15,
                          color: active == program.type ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            Column(
              children: fitnessPrograms
                  .where((program) => program.type == active)
                  .map((program) {
                return GestureDetector(
                  onTap: () {
                    _showMoreOptions(context, program);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(program.image),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      program.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
