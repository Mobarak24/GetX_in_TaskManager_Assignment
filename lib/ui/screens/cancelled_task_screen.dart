import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/utilities/urls.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrappar_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../widgets/snack_bar_massage.dart';
import '../widgets/task_item.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {

  bool _getTaskInProgress = false;
  List<TaskModel> _taskList = [];

  @override
  void initState() {
    super.initState();
    _getCancelTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: _getTaskInProgress == false,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: ListView.builder(
          itemCount: _taskList.length,
          itemBuilder: (context, index) {
            return TaskItem(
              taskModel: _taskList[index],
              onUpdateTask: () {
                _getCancelTasks();
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _getCancelTasks() async {
    _getTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.canceledTask);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      _taskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMassage(
            context, response.errorMassage ?? 'Cancel task failed! Try again');
      }
    }
    _getTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
