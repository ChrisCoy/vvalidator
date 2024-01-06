import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vvalidator/vvalidator.dart';

void main() {
  runApp(MyApp());
}

class MySchema extends SchemaVV {
  var email = FieldVV(
      validator: V.string().email().require(), initial: "email@example.com");
  var password = FieldVV(validator: V.string().minLen(6).require());
  var confirm = FieldVV(
    validator: V.string().minLen(6).require(),
  );
  var number = FieldVV(
    validator:
        V.number().min(5).max(10).require(transform: (v) => num.parse(v)),
  );

  MySchema() : super(fillInitial: true) {
    refineField(confirm, (value) {
      if (value != password.value) {
        return "passwords do not match";
      }

      return null;
    });
  }

  @override
  Map<String, FieldVV> getFields() {
    return {
      "email": email,
      "password": password,
      "confirm": confirm,
      "number": number,
    };
  }
}

class MyApp extends StatelessWidget {
  final schema = MySchema();

  MyApp({super.key});

  _onValidate() {
    schema.flutterValidate();
  }

  Widget customTextFormField(FieldVV field) {
    return TextFormField(
      controller: field.controller,
      focusNode: field.focusNode,
      validator: field.validator,
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
              key: schema.formKey,
              child: Column(
                children: [
                  customTextFormField(schema.email),
                  customTextFormField(schema.password),
                  customTextFormField(schema.confirm),
                  customTextFormField(schema.number),
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
