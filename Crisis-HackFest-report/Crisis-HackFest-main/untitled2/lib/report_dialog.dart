import 'package:flutter/material.dart';

class ReportDialog extends StatefulWidget {
  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final _formKey = GlobalKey<FormState>();
  String _reportTo = '';
  String _issue = 'No response';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Report Issue'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Report to',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _reportTo = value!;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _issue,
                items: <String>['No response', 'Abusive']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _issue = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Issue',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              // Process the report here, e.g., send it to a server or database
              print('Reporting to: $_reportTo');
              print('Issue: $_issue');
              // Dismiss the dialog
              Navigator.of(context).pop();
            }
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
