import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_list_app/shared/components/constants.dart';
import 'package:task_list_app/shared/cubit/cubit/cubit.dart';
import 'package:task_list_app/shared/cubit/states/states.dart';

import '../../shared/components/components.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;
        return TasksBuilder(
          tasks: tasks,
        );
      },
    );
  }
}
