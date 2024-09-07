import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_v/home/tasks_lst/task_widget.dart';

import '../../Provider/app_provider.dart';
import '../../Provider/taskProvider.dart';
import '../../database/my_database.dart';
import '../../database/task.dart';

class TaskListTab extends StatefulWidget {
  @override
  State<TaskListTab> createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  DateTime selectedDate = DateTime.now();
  late TaskProvider taskProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Uncomment if you need to refresh tasks on initialization
      // taskProvider.refreshTasks(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    taskProvider = Provider.of<TaskProvider>(context);
    var provider = Provider.of<AppProvider>(context);

    return Column(
      children: [
        CalendarTimeline(
          showYears: true,
          initialDate: selectedDate,
          firstDate: DateTime.now().subtract(Duration(days: 365)),
          lastDate: DateTime.now().add(Duration(days: 365)),
          onDateSelected: (date) {
            if (date == null) return;
            setState(() {
              selectedDate = date;
              // Uncomment if you need to refresh tasks on date selection
              // taskProvider.refreshTasks(selectedDate);
            });
          },
          leftMargin: 20,
          monthColor: provider.isDark() ? Colors.white : Colors.black,
          dayColor: provider.isDark() ? Colors.white : Colors.black,
          activeDayColor: Theme.of(context).primaryColor,
          activeBackgroundDayColor:
              provider.isDark() ? Colors.black : Colors.white,
          selectableDayPredicate: (date) => true,
          locale: 'en',
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Task>>(
            stream: MyDatabase.listenForTasksRealTimeUpdate(selectedDate),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error loading data, please try again later.'),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var data =
                  snapshot.data?.docs.map((e) => e.data()).toList() ?? [];
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TaskWidget(data[index]);
                },
                itemCount: data.length,
              );
            },
          ),
        ),
      ],
    );
  }
}
