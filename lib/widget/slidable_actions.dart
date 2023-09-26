import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableWidget extends StatelessWidget {
  final int index;
  final Map student;
  final Function(Map) navigateToEditPage;
  final Function(int) deleteById;
  const SlidableWidget(
      {super.key,
      required this.index,
      required this.student,
      required this.navigateToEditPage,
      required this.deleteById });

  @override
  Widget build(BuildContext context) {
    final id = student['id'] as int;
    final name = student['nombres'] as String;
    final lastname = student['apellidos'] as String;
    final age = student['edad'] as int;
    return Slidable(
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: ((context) => navigateToEditPage(student)),
            backgroundColor: Colors.green,
            icon: Icons.update,
            label: 'Update',
          ),
          SlidableAction(
            onPressed: ((context) => deleteById(id)),
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text("Nombre: $name"),
        subtitle: Text("Apellido: $lastname" " Edad: $age"),
        leading: const CircleAvatar(
          backgroundImage: NetworkImage(
              "https://images.unsplash.com/photo-1547721064-da6cfb341d50"),
        ),
      ),
    );
  }
}
