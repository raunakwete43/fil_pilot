import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fil_pilot/features/admin/presentation/views/admin.dart';
import 'package:fil_pilot/features/login/presentation/bloc/login_cubit.dart';
import 'package:fil_pilot/features/login/presentation/bloc/login_state.dart';
import 'package:fil_pilot/features/production/presentation/views/production.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _empNoController = TextEditingController();

  void _handleLogin() async {
    final name = _nameController.text;
    final empNo = _empNoController.text;

    if (name.isEmpty || empNo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fields cannot be empty")));
    } else {
      await context.read<LoginCubit>().loginWithNameandNo(name, empNo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      builder: (context, state) {
        if (state is LoginLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is LoginSuccess) {
          _nameController.clear();
          _empNoController.clear();
          if (state.user.type.toLowerCase() == 'production') {
            return const ProductionScreen();
          } else if (state.user.type.toLowerCase() == 'admin') {
            return const AdminScreen();
          }
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.yellow, // Sky blue background
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'lib/common/icons/fil_logo.png', // Path to the logo
                fit: BoxFit.contain,
                height: 40, // Adjust height if needed
              ),
            ),
            elevation: 0, // Optional: remove shadow for a flat look
          ),
          body: Container(
            color: Colors.lightBlue, // Light blue background color
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.account_circle,
                          size: 100,
                          color: Colors.lightBlue, // Sky blue icon
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Employee Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue, // Sky blue text
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Employee Name',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _empNoController,
                          decoration: InputDecoration(
                            labelText: 'Employee Number',
                            prefixIcon: const Icon(Icons.badge),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.yellow, // Yellow button
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.lightBlue, // Sky blue text
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        print(state);
        if (state is LoginLogout) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _empNoController.dispose();
    super.dispose();
  }
}
