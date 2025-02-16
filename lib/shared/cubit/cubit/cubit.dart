import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_list_app/shared/cubit/states/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../moduls/archived_tasks/archived_tasks_screen.dart';
import '../../../moduls/done_tasks/done_tasks_screen.dart';
import '../../../moduls/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  List<Widget> screens = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  final List<String> titles = const [
    "Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  // to create the database you must do this steps:
  // 1) create database
  // 2) create tables
  // 3) open database
  // 4) insert to database
  // 5) get from database
  // 6) update in database
  // 7) delete from database

  late Database database;

  void createDatabase() {
    openDatabase(
      "todo.db",
      version: 1,
      onCreate: (database, version) {
        // id integer
        // title String
        // date String
        // time String
        // status String

        print("database created");
        database.execute(
            // how to create the things inside the table
            // first thing you create the taple
            // then put the name of the variables
            // then put the type for the variable in caps
            // PRIMARY KEY : mean its auto generated
            //////////////////////////////////////
            // TEXT mean String

            

"CREATE TABLE tasks(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, title TEXT, time TEXT, date TEXT, status TEXT)"
).then(
          (value) {
            print(
              "table created",
            );
          },
        ).catchError(
          (error) {
            print(
              "Error when Creating Table ${error.toString()}",
            );
          },
        );
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print("database opened");
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction(
      (txn) async {
        txn
            .rawInsert(
          'INSERT INTO tasks (title, date, time, status) VALUES("$title", "$date", "$time", "new")',
        )
            .then((value) {
          print("$value inserted successfully");
          emit(AppInsertDatabaseState());
          

          getDataFromDatabase(database);
        }).catchError(
          (error) {
            print("Error when inserting new record ${error.toString()}");
          },
        );
        return null;
      },
    );
  }

// * mean all
  void getDataFromDatabase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then(
      (value) {
        value.forEach((element) {
          if (element["status"] == "new") {
            newTasks.add(element);
          } else if (element["status"] == "done") {
            doneTasks.add(element);
          } else {
            archivedTasks.add(element);
          }
        });
        emit(AppGetDatabaseState());
      },
    );
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    // database.rawUpdate(
    //   // the first ? take the first thing in the list [update name]
    //   // second ? take the second thing in the list [9876]
    // 'UPDATE tasks SET status = ?, WHERE id = ?',
    // ['$status', '$id']).then((value){
    //   emit(AppUpdateDatabaseState());
    //   // ['updated name', '9876']);

    // });
    // database
    //     .rawUpdate(
    //   'UPDATE tasks SET status = ?, id = ?'
    //    ['$status',id ]
    // )

    database.rawUpdate('''
          UPDATE tasks SET
          status = "$status"
          WHERE id = $id
    ''').then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
  
  void deleteData({
    required int id,
  }) async {
    
    database.rawDelete(
         'DELETE FROM tasks WHERE id = $id'
   ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }
}
