import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/employee.dart';
import '../core/mock/mock_data.dart';

class EmployeeNotifier extends StateNotifier<List<Employee>> {
  EmployeeNotifier() : super(MockData.employees);

  void addEmployee(Employee emp) {
    state = [emp, ...state];
  }
}

final employeeProvider = StateNotifierProvider<EmployeeNotifier, List<Employee>>((ref) {
  return EmployeeNotifier();
});

final employeeSearchQueryProvider = StateProvider<String>((ref) => '');
final employeeRoleFilterProvider = StateProvider<String>((ref) => 'All Roles');
