import 'package:appwrite_employee/Appwrite_Service.dart';
import 'package:appwrite_employee/appwrite_model.dart';
import 'package:flutter/material.dart';

class EmployeeApp extends StatefulWidget {
  const EmployeeApp({super.key});

  @override
  State<EmployeeApp> createState() => _EmployeeAppState();
}

class _EmployeeAppState extends State<EmployeeApp> {
  late AppwriteService _appwriteService;
  late List<Employee> _employee;

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    _employee = [];
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    try {
      final tasks = await _appwriteService.getTasks();
      setState(() {
        _employee = tasks.map((e) => Employee.fromDocument(e)).toList();
      });
    } catch (e) {
      print('Error loading tasks:$e');
    }
  }

  Future<void> _addEmployee() async {
    final name = nameController.text;
    final age = ageController.text;
    final location = locationController.text;

    if (name.isNotEmpty && age.isNotEmpty && location.isNotEmpty) {
      try {
        await _appwriteService.addEmployee(name, age, location);
        nameController.clear();
        ageController.clear();
        locationController.clear();
        _loadEmployees();
      } catch (e) {
        print("Error adding task:$e");
      }
    }
  }

  Future<void> _deleteEmployee(String taskId) async {
    try {
      await _appwriteService.deleteemployee(taskId);
      _loadEmployees();
    } catch (e) {
      print("Error  deleting task:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee APP"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              width: 300,
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Name")),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 60,
              width: 300,
              child: TextField(
                controller: ageController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Age")),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 60,
              width: 300,
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Location")),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: _addEmployee, child: Text("Add")),
            Expanded(
                child: ListView.builder(
                    itemCount: _employee.length,
                    itemBuilder: (context, index) {
                      final employees = _employee[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 120,
                            width: 130,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.yellow),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(employees.name),
                                  Text(employees.age),
                                  Text(employees.location),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () =>
                                        _deleteEmployee(employees.id),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
