import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:queue/customer.dart';
import 'package:queue/widgets/CustomButton.dart';
import 'package:queue/widgets/CustomFormTextField.dart';

class CustomerFormPage extends StatefulWidget {
  const CustomerFormPage({super.key});

  @override
  State<CustomerFormPage> createState() => _CustomerFormPage();
}

class _CustomerFormPage extends State<CustomerFormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobile1Controller = TextEditingController();
  final TextEditingController mobile2Controller = TextEditingController();
  final TextEditingController numberOfPeople = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    mobile1Controller.dispose();
    mobile2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Scrollable form first
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    Text(
                      'Add Customer',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF287470),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomFormTextField(
                      label: 'Name',
                      hint: 'Enter name',
                      controller: nameController,
                    ),
                    const SizedBox(height: 10),
                    CustomFormTextField(
                      label: 'Mobile Number 1',
                      hint: 'Enter mobile number',
                      controller: mobile1Controller,
                    ),
                    const SizedBox(height: 10),
                    CustomFormTextField(
                      label: 'Mobile Number 2',
                      hint: 'Enter mobile number',
                      controller: mobile2Controller,
                    ),
                    const SizedBox(height: 10),
                    CustomFormTextField(
                      label: 'Number of People',
                      hint: 'Enter number of people',
                      controller: numberOfPeople,
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      btnText: 'Submit',
                      widthPercentage: 0.7,
                      backgroundColor: Color(0xFF287470),
                      foregroundColor: Colors.white,
                      onPressed: () async {
                        var box = Hive.box('myBox');
                        var customers = box.get('customers', defaultValue: []);

                        customers.add(
                          Customer(
                            name: nameController.text,
                            mobile1: mobile1Controller.text,
                            mobile2: mobile2Controller.text.isNotEmpty
                                ? mobile2Controller.text
                                : null,
                            numberOfPeople: int.parse(numberOfPeople.text),
                          ).toMap(),
                        );
                        await box.put('customers', customers);

                        if (!mounted) return;
                        Navigator.pop(context);
                      },
                      fontSize: 16,
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xFF287470)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
