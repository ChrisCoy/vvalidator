import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vvalidator/vvalidator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  final SchemaVV schema = SchemaVV({
    "email": FieldVV(
      validator: V.string().email().require(),
    ),
    "password": FieldVV(validator: V.string().minLen(6).require()),
    "confirm": FieldVV(
      validator: V.string().minLen(6).require(),
    ),
    "number": FieldVV(
      validator:
          V.number().min(5).max(10).require(transform: (v) => num.parse(v)),
    ),
  }).refine(
      field: "confirm",
      rule: (f) {
        if (f["confirm"]?.value != f["password"]?.value) {
          return "passwords do not match";
        }
        return null;
      });

  _onValidate() {
    if (!schema.validate()) {
      print("invalid form");
      print(schema.errors);
    }
    setState(() {});
  }

  Widget customTextFormField(String label) {
    return TextFormField(
      controller: schema.get(label)?.controller,
      focusNode: schema.get(label)?.focusNode,
      validator: schema.get(label)?.validator,
      decoration: InputDecoration(
        errorText: schema.errors[label],
        label: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('VValidator'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  customTextFormField("email"),
                  customTextFormField("password"),
                  customTextFormField("confirm"),
                  customTextFormField("number"),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _onValidate,
                      child: const Text("validate"),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
