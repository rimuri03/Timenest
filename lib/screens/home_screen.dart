import 'package:flutter/material.dart';
import '../models/task.dart';
import '../database/task_db.dart';
import '../widgets/task_form.dart';
import 'statistics_screen.dart'; // Make sure to import your StatisticsScreen

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  DateTime selectedDate = DateTime.now();

  Future<void> fetchTasks() async {
    final dbTasks = await TaskDB.instance.getTasks();
    setState(() {
      tasks = dbTasks.where((task) => isSameDate(task.date, selectedDate)).toList();
    });
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate completed and pending tasks
    final completed = tasks.where((task) => task.isCompleted).length;
    final pending = tasks.length - completed;

    return Scaffold(
      appBar: AppBar(
        title: Text('TimeNest'),
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          Expanded(
            child: tasks.isEmpty
                ? Center(child: Text('No tasks for this day.'))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return ListTile(
                        title: Text(task.title),
                        subtitle: Text('${task.time.format(context)} - ${task.description}'),
                        trailing: Checkbox(
                          value: task.isCompleted,
                          onChanged: (val) async {
                            task.isCompleted = val!;
                            await TaskDB.instance.updateTask(task);
                            fetchTasks();
                          },
                        ),
                      );
                    },
                  ),
          ),
          _buildFloatingActionButtons(completed, pending),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButtons(int completed, int pending) {
    return Align(
      alignment: Alignment.bottomRight, // Align to the right
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0), // Adjust padding to move FAB slightly off the edge
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensure the FABs only take up necessary space
          children: [
            FloatingActionButton(
              heroTag: 'statsButton',
              child: Icon(Icons.pie_chart),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StatisticsScreen(
                      completed: completed,
                      pending: pending,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'addButton',
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TaskForm(onTaskAdded: fetchTasks),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    final days = List.generate(7, (index) {
      final date = selectedDate.add(Duration(days: index - 3));
      return date;
    });

    return Container(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final date = days[index];
          final isSelected = isSameDate(date, selectedDate);
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
              });
              fetchTasks();
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '${_getWeekdayName(date.weekday)}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }
}
