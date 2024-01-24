import 'package:flutter/material.dart';

// Define a custom Form widget.
class NameForm extends StatefulWidget {
  @override
  _NameFormState createState() => _NameFormState();
}

// Define a corresponding State class.
// This class holds data related to the form.
class _NameFormState extends State<NameForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  // Function to validate the name
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    // Add advanced validation logic here
    // For example, check if the name contains only letters
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'Please enter a valid name';
    }
    return null; // Return null if the input is valid
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your full name',
            ),
            validator: validateName, // Use the separate validation function
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a Snackbar.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: NameForm()));
