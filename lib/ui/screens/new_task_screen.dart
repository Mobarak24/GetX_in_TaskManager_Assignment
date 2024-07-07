import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_wrappar_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widgets/snack_bar_massage.dart';
import 'package:task_manager/ui/widgets/task_item.dart';
import 'package:task_manager/ui/widgets/task_summery_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  bool _getNewTasksInProgress = false;
  List<TaskModel> newTaskList = [];


  @override
  void initState() {
    super.initState();
    _getNewTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildSummerySection(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: RefreshIndicator(
                onRefresh: () async {
                  _getNewTasks();
                },
              child: Visibility(
                visible: _getNewTasksInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: ListView.builder(
                  itemCount: newTaskList.length,
                  itemBuilder: (context, index) {
                    return  TaskItem(
                      taskModel: newTaskList[index],
                    );
                  },
                ),
              ),
            ),
          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddButton,
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        tooltip: 'Add New Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onTapAddButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
  }

  Widget _buildSummerySection() {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          TaskSummeryCard(
            text: 'New Task',
            count: '10',
          ),
          TaskSummeryCard(
            text: 'Completed',
            count: '5',
          ),
          TaskSummeryCard(
            text: 'Progress',
            count: '7',
          ),
          TaskSummeryCard(
            text: 'Canceled',
            count: '2',
          ),
        ],
      ),
    );
  }

  Future<void> _getNewTasks() async {
    _getNewTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.newTasks);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      newTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMassage(
            context, response.errorMassage ?? 'Get new task failed! Try again');
      }
    }
    _getNewTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
