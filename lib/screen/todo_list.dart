import "package:flutter/material.dart";
import 'package:flutter_app_springboot/screen/send_mail_page.dart';
import "package:flutter_app_springboot/widget/slidable_actions.dart";

import "../services/todo_service.dart";
import "add_page.dart";
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List students = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students list'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.mail),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SendMailPage()),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index] as Map;
          final id = student['id'] as int;
          final name = student['nombres'] as String;
          final lastname = student['apellidos'] as String;
          final age = student['edad'] as int;
          return SlidableWidget(index: index, student: student, navigateToEditPage: navigateToEditPage, deleteById: deleteById);
        //   Slidable(
        //     startActionPane: ActionPane(
        //       motion: const StretchMotion(),
        //       children: [
        //          SlidableAction(
        //           onPressed: ((context)=> navigateToEditPage(student)),
        //           backgroundColor: Colors.green,
        //           icon: Icons.update,
        //           label: 'Update',
        //         ),
        //         SlidableAction(
        //           onPressed: ((context) => deleteById(id)),
        //           backgroundColor: Colors.red,
        //           icon: Icons.delete,
        //           label: 'Delete',
        //         ),
               
        //       ],
        //     ),
        //     child: ListTile(
        //       title: Text("Nombre: $name"),
        //       subtitle: Text("Apellido: $lastname" " Edad: $age"),
        //       leading: const CircleAvatar(
        //         backgroundImage: NetworkImage(
        //             "https://images.unsplash.com/photo-1547721064-da6cfb341d50"),
        //       ),
        //     ),
        //   );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAppPage,
        label: const Text('Add'),
      ),
    );
  }

  Future<void> navigateToAppPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

   Future <void> navigateToEditPage(Map student) async{
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: student),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodos();
    if (response != null) {
      setState(() {
        students = response;
      });
    } else {
      // showErrorMessage(context, message: 'Something wrong error');
    }
  }

  Future<void> deleteById(int id) async {
    final isSucces = await TodoService.deleteById(id);
    if (isSucces) {
      final filtered =
          students.where((element) => element['id'] != id).toList();
      setState(() {
        students = filtered;
      });
    }
  }
}
