import 'dart:convert';

import 'package:fil_pilot/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({Key? key}) : super(key: key);

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  // Controllers for text fields
  final TextEditingController employeeNameController = TextEditingController();
  final TextEditingController employeeNumberController =
      TextEditingController();

  // Dropdown menu for employee type
  final List<String> employeeTypes = [
    'Admin',
    'Production',
    'Quality',
    'Maintenance'
  ];
  String? selectedEmployeeType;

  // List to store added users
  final List<Map<String, String>> users = [];

  // Method to add a user
  void _addUser() async {
    final String name = employeeNameController.text.trim();
    final String number = employeeNumberController.text.trim();

    if (name.isEmpty || number.isEmpty || selectedEmployeeType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required to add a user.')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/add_user"),
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json"
        },
        body: jsonEncode(
          {
            "name": name,
            "empNo": number,
            "type": selectedEmployeeType,
          },
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User added successfully.')),
        );
        employeeNameController.clear();
        employeeNumberController.clear();
        setState(() {
          selectedEmployeeType = null;
        });
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add user')),
        );
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Method to delete a user
  void _deleteUser() async {
    final String name = employeeNameController.text.trim();
    final String number = employeeNumberController.text.trim();

    if (name.isEmpty || number.isEmpty || selectedEmployeeType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('All fields are required to delete a user.')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/delete_user"),
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json"
        },
        body: jsonEncode(
          {
            "name": name,
            "empNo": number,
            "type": selectedEmployeeType,
          },
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully.')),
        );
        employeeNameController.clear();
        employeeNumberController.clear();
        setState(() {
          selectedEmployeeType = null;
        });
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete user')),
        );
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Employee Name
            TextField(
              controller: employeeNameController,
              decoration: const InputDecoration(
                labelText: 'Employee Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Employee Number
            TextField(
              controller: employeeNumberController,
              decoration: const InputDecoration(
                labelText: 'Employee Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            // Dropdown for Employee Type
            DropdownButtonFormField<String>(
              value: selectedEmployeeType,
              items: employeeTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedEmployeeType = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Employee Type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Add User'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _deleteUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete User'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Display added users

            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user['name']!),
                    subtitle: Text(
                        'Number: ${user['number']} | Type: ${user['type']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
