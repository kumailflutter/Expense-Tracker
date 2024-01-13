import 'package:expansetracker/modeldata/expense_list.dart';
import 'package:expansetracker/modeldata/expenses.dart';
import 'package:expansetracker/widgets/charts/chart.dart';
import 'package:expansetracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({
    super.key,
  });

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final List<Expense> _registerexpenses = [
    Expense(
      title: "Netflix",
      category: Category.leisure,
      amount: 19.99,
      date: DateTime.now(),
    ),
    Expense(
      title: "Flutter",
      category: Category.work,
      amount: 19.99,
      date: DateTime.now(),
    ),
    Expense(
        title: "Laptop",
        category: Category.work,
        amount: 100,
        date: DateTime.now())
  ];
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(
              onAddExpense: _addExpense,
            ));
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registerexpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registerexpenses.indexOf(expense);
    setState(() {
      _registerexpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 3),
      content: const Text("Expense deleted"),
      action: SnackBarAction(
          label: "undo",
          onPressed: () {
            setState(() {
              _registerexpenses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text("no selected item yet"),
    );
    if (_registerexpenses.isNotEmpty) {
      mainContent = ExpenseList(
          expenses: _registerexpenses, onRemoveExpense: _removeExpense);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Tracker"),
        actions: [
          IconButton(onPressed: _openAddExpenseOverlay, icon: Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registerexpenses),
          Expanded(
            child: mainContent,
          )
        ],
      ),
    );
  }
}
