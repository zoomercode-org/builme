import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/expense.dart';
import '../core/mock/mock_data.dart';

class ExpenseNotifier extends StateNotifier<List<Expense>> {
  ExpenseNotifier() : super(MockData.expenses);

  void addExpense(Expense exp) {
    state = [exp, ...state];
  }
}

final expenseProvider = StateNotifierProvider<ExpenseNotifier, List<Expense>>((ref) {
  return ExpenseNotifier();
});
