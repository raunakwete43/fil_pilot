import 'package:fil_pilot/features/admin/presentation/views/add_delete_user.dart';
import 'package:fil_pilot/features/admin/presentation/views/view_data.dart';
import 'package:fil_pilot/features/login/presentation/bloc/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Page'),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Admin Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('View Data'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewData()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Add/Delete User'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserManagementPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  context.read<LoginCubit>().logout();
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Text(
            'Welcome to the Admin Page!',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
