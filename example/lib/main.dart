import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vvalidator/vvalidator.dart';

void main() {
  // runApp(MyApp());
  runApp(_MyAppState());
}

// TODO - create a class wich the schema will extend, and in that class will be the formKey
// the validate function, and the signature of the refine function
class MySchema {
  // TODO - put on the father class
  var errors = <String, String>{};

  // TODO - put on the father class
  var formKey = GlobalKey<FormState>();

  var email = FieldVV(validator: V.string().email().require());
  var password = FieldVV(validator: V.string().minLen(6).require());
  var confirm = FieldVV(
    validator: V.string().minLen(6).require(),
  );
  var number = FieldVV(
    validator:
        V.number().min(5).max(10).require(transform: (v) => num.parse(v)),
  );

  MySchema() {
    _refineField(confirm, (value) {
      if (value != password.value) {
        return "passwords do not match";
      }

      return null;
    });
  }

  // or the refine function can be called in the constructor passing the field and the rule
  _refineField(FieldVV field, String? Function(String?) rule) {
    var oldValidator = field.validator;

    field.validator = (v) {
      var error = rule(v);

      if (error != null) {
        return error;
      }

      return oldValidator(v);
    };
  }

  // // TODO - create a better way to refine fields
  // refine() {
  //   confirm.validator = (v) {
  //     if (v != password.value) {
  //       return "passwords do not match";
  //     }

  //     return confirm.validator(v);
  //   };
  // }

  validate() {
    if (!formKey.currentState!.validate()) {
      print("invalid form");
      print(formKey.currentState);
    }
  }
}

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

class _MyAppState extends StatelessWidget {
  final schema = MySchema();

  // OLD WAY
  // final SchemaVV schema = SchemaVV({
  //   "email": FieldVV(
  //     validator: V.string().email().require(),
  //   ),
  //   "password": FieldVV(validator: V.string().minLen(6).require()),
  //   "confirm": FieldVV(
  //     validator: V.string().minLen(6).require(),
  //   ),
  //   "number": FieldVV(
  //     validator:
  //         V.number().min(5).max(10).require(transform: (v) => num.parse(v)),
  //   ),
  // }).refine(
  //     field: "confirm",
  //     rule: (f) {
  //       if (f["confirm"]?.value != f["password"]?.value) {
  //         return "passwords do not match";
  //       }
  //       return null;
  //     });

  //TODO - better form of making component updates
  _onValidate() {
    schema.validate();
  }

  Widget customTextFormField(FieldVV field) {
    return TextFormField(
      controller: field.controller,
      focusNode: field.focusNode,
      validator: field.validator,
      // decoration: InputDecoration(
      //   // TODO - add a way to pass the error text
      //   errorText: "deu ruim man",
      //   label: Text("algumlabellol"),
      // ),
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
