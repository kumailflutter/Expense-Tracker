import 'package:flutter/material.dart';

import 'package:expansetracker/modeldata/expenses.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selecteddate;
  Category _selectedCategory = Category.leisure;
  void _presentDatepicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickeddate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: now);
    setState(() {
      _selecteddate = pickeddate;
    });
  }

  void _submitExpenseData() {
    final enteramount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteramount == null || enteramount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selecteddate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Invalid Input"),
                content: const Text("Please enter a valid title and content"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text("Ok"))
                ],
              ));
      return;
    }
    widget.onAddExpense(Expense(
        title: _titleController.text,
        category: _selectedCategory,
        amount: enteramount,
        date: _selecteddate!));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            keyboardType: TextInputType.text,
            maxLength: 50,
            decoration: InputDecoration(label: Text("Title")),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(prefixText: "\$", label: Text("Amount")),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(_selecteddate == null
                      ? " no Selected Date"
                      : formater.format(_selecteddate!)),
                  IconButton(
                      onPressed: _presentDatepicker,
                      icon: Icon(Icons.calculate_outlined))
                ],
              ))
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              DropdownButton(
                  value: _selectedCategory,
                  items: Category.values
                      .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.name.toUpperCase(),
                          )))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      if (value == null) {
                        return;
                      }
                      _selectedCategory = value;
                    });
                  }),
              Spacer(),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("cancel")),
              ElevatedButton(
                  onPressed: _submitExpenseData, child: const Text("Submit"))
            ],
          )
        ],
      ),
    );
  }
}
