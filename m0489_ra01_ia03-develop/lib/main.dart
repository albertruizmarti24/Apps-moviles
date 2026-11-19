import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M0489 - Apps - Form (B)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String title = 'Albert Ruiz curs 26/27';

  final _formKey = GlobalKey<FormBuilderState>();

  int _currentStep = 0;

  void _onStepContinue() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      final state = _formKey.currentState;
      if (state != null && state.saveAndValidate()) {
        alertDialog(context, state.value.toString());
      }
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  StepState _stateOf(int index) =>
      _currentStep > index ? StepState.complete : StepState.indexed;

  Widget _infoStep(BuildContext context, String heading, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(heading, style: Theme.of(context).textTheme.displaySmall),
        ),
        Text(text, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget _uploadStep() {
    return Column(
      children: [
        FormBuilderTextField(
          name: 'Email',
          keyboardType: TextInputType.emailAddress,
          decoration: _fieldDecoration('Email', Icons.email),
        ),
        const SizedBox(height: 8),
        FormBuilderTextField(
          name: 'Address',
          maxLines: 4,
          decoration: _fieldDecoration('Address', Icons.home),
        ),
        const SizedBox(height: 8),
        FormBuilderTextField(
          name: 'Mobile',
          keyboardType: TextInputType.phone,
          decoration: _fieldDecoration('Mobile No', Icons.phone),
        ),
      ],
    );
  }

  InputDecoration _fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          onStepTapped: (index) => setState(() => _currentStep = index),
          steps: [
            Step(
              title: const Text('Pers.'),
              isActive: _currentStep >= 0,
              state: _stateOf(0),
              content: _infoStep(
                context,
                'Personal',
                'Pulsi "Contact" o pulsi el botó de "Continue".',
              ),
            ),
            Step(
              title: const Text('Contact'),
              isActive: _currentStep >= 1,
              state: _stateOf(1),
              content: _infoStep(
                context,
                'Contact',
                'Pulsi "Upload" o pulsi el botó de "Continue".',
              ),
            ),
            Step(
              title: const Text('Upload'),
              isActive: _currentStep >= 2,
              state: _stateOf(2),
              content: _uploadStep(),
            ),
          ],
        ),
      ),
    );
  }
}

void alertDialog(BuildContext context, String contentText) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      icon: const Icon(Icons.check_circle),
      title: const Text('Submission Completed'),
      content: Text(contentText),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Close'),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
