import 'package:flutter/material.dart';

import '../services/todo_service.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final name = todo['nombres'];
      final lastname = todo['apellidos'];
      final age = todo['edad'] ;
      nameController.text = name;
      lastnameController.text = lastname;
      ageController.text = age.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit student' : 'add student'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Name'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: lastnameController,
            decoration: const InputDecoration(hintText: 'Last name'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: ageController,
            decoration: const InputDecoration(hintText: 'Age'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: isEdit? updateData : submitData,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(isEdit ? 'Update' : 'submit'),
              )),
        ],
      ),
    );
  }
  
   Map get body {
    final name = nameController.text;
    final lastname = lastnameController.text;
    final age = ageController.text;
    return {"nombres": name, "apellidos": lastname, "edad": age};
  }

   Future<void> submitData() async {
    // final isSuccess = 
    await TodoService.addTodo(body);
    // if (isSuccess) {
      nameController.text = '';
      lastnameController.text = '';
      ageController.text = '';
    // }
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      return;
    }
    final id = todo['id'];

    await TodoService.updateTodo(id, body);

  }



}
