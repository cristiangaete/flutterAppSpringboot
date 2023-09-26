import "package:flutter/material.dart";
import "package:flutter_app_springboot/services/todo_service.dart";

class SendMailPage extends StatefulWidget {
  const SendMailPage({super.key});

  @override
  State<SendMailPage> createState() => _SendMailPageState();
}

class _SendMailPageState extends State<SendMailPage> {
  TextEditingController toController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  final GlobalKey<FormState> _formstate = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send email'), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: domwloadCsv,
        )
      ]),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
            key: _formstate,
            child: Column(
              children: [
                TextFormField(
                  controller: toController,
                  validator: (value) {
                    if (!value!.contains('@')) {
                      return 'email no valido';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: 'To'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: subjectController,
                  decoration: const InputDecoration(hintText: 'Subject'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: bodyController,
                  decoration: const InputDecoration(
                      hintText: 'Body'),
                ),
                Expanded(child: Container()),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: submitData, child: const Text('Enviar')),
                )
              ],
            )),
      ),
    );
  }

  Map get body {
    final email = toController.text;
    final subject = subjectController.text;
    final body = bodyController.text;
    return {"destinatario": email, "asunto": subject, "cuerpo": body};
  }

  Future<void> submitData() async {
    final isSuccess = await TodoService.sendMail(body);
    if (isSuccess) {
      toController.text = '';
      subjectController.text = '';
      bodyController.text = '';
    }
  }

  Future<void> domwloadCsv() async {
    await TodoService.domwloadCsv();
  }
}
