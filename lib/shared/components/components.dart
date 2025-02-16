import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:task_list_app/shared/cubit/cubit/cubit.dart';
import 'package:uuid/uuid.dart';

class DefaultFormField extends StatelessWidget {
  const DefaultFormField({
    super.key,
    required this.emailController,
    required this.hint,
    required this.label,
    required this.validator,
    required this.keyboardType,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureTextt = false,
    this.onPressedForTheEye,
    this.onTap,
  });

  final TextEditingController emailController;
  final String hint;
  final String label;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final IconData? suffixIcon;
  final bool obscureTextt;
  final Function()? onPressedForTheEye;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      obscureText: obscureTextt,
      validator: validator,
      controller: emailController,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hint,
        label: Text(
          label,
        ),
        prefixIcon: Icon(
          prefixIcon,
        ),
        suffixIcon: IconButton(
          onPressed: onPressedForTheEye,
          icon: Icon(
            suffixIcon,
          ),
        ),
      ),
    );
  }
}

class BuildTaskItem extends StatelessWidget {
  const BuildTaskItem({
    super.key,
    required this.model,
  });
  final Map model;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Dismissible(
            key: Key(model["id"].toString()),
            onDismissed: (direction) {
              AppCubit.get(context).deleteData(id: model["id"]);
            },
            background: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red.withOpacity(0.4),
                  size: 30,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  "This Task Was Deleted",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            child: Material(
              elevation: 20,
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Text(
                        "${model["time"]}",
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              "${model["title"]}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${model["date"]}",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        AppCubit.get(context)
                            .updateData(status: 'done', id: model['id']);
                      },
                      icon: const Icon(
                        Icons.check_box_outlined,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        AppCubit.get(context)
                            .updateData(status: 'archive', id: model['id']);
                      },
                      icon: const Icon(
                        Icons.archive_outlined,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class TasksBuilder extends StatelessWidget {
  const TasksBuilder({super.key, required this.tasks});
  final List<Map> tasks;

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: tasks.isNotEmpty,
      fallback: (context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              color: Colors.grey,
              size: 100,
            ),
            Text(
              "No Tasks Yet, Please Add Some Tasks",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      builder: (context) => ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => BuildTaskItem(
          model: tasks[index],
        ),
        itemCount: tasks.length,
      ),
    );
  }
}
