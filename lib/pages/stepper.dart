import 'package:flutter/material.dart';

class StepperDemo extends StatefulWidget {
  const StepperDemo({super.key});

  @override
  _StepperDemoState createState() => _StepperDemoState();
}

class _StepperDemoState extends State<StepperDemo> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Flutter Stepper Demo'),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Stepper(
                  type: StepperType.horizontal,
                  physics: const ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  onStepContinue: continued,
                  onStepCancel: cancel,
                  steps: <Step>[
                    Step(
                      title: const Text('Area of Interest'),
                      subtitle: const Text('Polygonal Area'),
                      content: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Email Address'),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Password'),
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: const Text('Analysis Result'),
                      subtitle: const Text('Vegetation Health Index'),
                      content: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Home Address'),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Postcode'),
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 1
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: const Text('Are Identity'),
                      content: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Mobile Number'),
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 2
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
