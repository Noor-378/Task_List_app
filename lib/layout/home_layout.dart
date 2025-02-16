import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_list_app/moduls/archived_tasks/archived_tasks_screen.dart';
import 'package:task_list_app/moduls/done_tasks/done_tasks_screen.dart';
import 'package:task_list_app/moduls/new_tasks/new_tasks_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_list_app/shared/components/components.dart';
import 'package:task_list_app/shared/components/constants.dart';
import 'package:task_list_app/shared/cubit/cubit/cubit.dart';
import 'package:task_list_app/shared/cubit/states/states.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            key: scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              elevation: 20,
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            //
           body: 
           ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 20,
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                      
                    );
                    titleController.clear();
                    timeController.clear();
                    dateController.clear();
                    
                    

                    // insertToDatabase(
                    //   title: titleController.text,
                    //   date: dateController.text,
                    //   time: timeController.text,
                    // ).then((value) {
                    //   getDataFromDatabase(database).then((value) {
                    //     // setState(() {
                    //     //   tasks = value;
                    //     // });
                    //   });
                    //   Navigator.pop(context);
                    //   isBottomSheetShown = false;
                    //   // setState(() {
                    //   //   fabIcon = Icons.edit;
                    //   // });
                    // });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        (context) => Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(.2),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Form(
                            key: formKey,
                            autovalidateMode: AutovalidateMode.always,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DefaultFormField(
                                  emailController: titleController,
                                  hint: "Task Title",
                                  label: "Title",
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Title must not be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  prefixIcon: Icons.title_outlined,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                DefaultFormField(
                                  emailController: timeController,
                                  hint: "Task Time",
                                  label: "Time",
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      if (value != null) {
                                        timeController.text =
                                            value.format(context);
                                      }
                                    });
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Time must not be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.none,
                                  prefixIcon: Icons.watch_later_outlined,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                DefaultFormField(
                                  emailController: dateController,
                                  hint: "Task Date",
                                  label: "Date",
                                  onTap: () {
                                    showDatePicker(
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2030),
                                      context: context,
                                    ).then((value) {
                                      if (value != null) {
                                        dateController.text =
                                            DateFormat.yMd().format(value);
                                      }
                                    });
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Date must not be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.none,
                                  prefixIcon: Icons.date_range_outlined,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                      isShow: false,
                      icon: Icons.edit,
                    );
                  });
                  cubit.changeBottomSheetState(
                    isShow: true,
                    icon: Icons.add,
                  );
                }
              },
              child: Icon(
                cubit.fabIcon,
                color: Colors.white,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                // currentIndex = index;
                // setState(() {});
                cubit.changeIndex(index);
              },
              currentIndex: cubit.currentIndex,
              type: BottomNavigationBarType.shifting,
              items: const [
                BottomNavigationBarItem(
                  backgroundColor: Colors.blue,
                  label: "Tasks",
                  icon: Icon(
                    Icons.article_outlined,
                  ),
                ),
                BottomNavigationBarItem(
                  backgroundColor: Colors.blue,
                  label: "Done",
                  icon: Icon(
                    Icons.check_box_outlined,
                  ),
                ),
                BottomNavigationBarItem(
                  backgroundColor: Colors.blue,
                  label: "Archive",
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
