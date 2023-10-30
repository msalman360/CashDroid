// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class TransactionForm extends StatefulWidget {
//   final void Function(String, double, DateTime) onSubmit;
//
//   TransactionForm({required this.onSubmit});
//
//   @override
//   _TransactionFormState createState() => _TransactionFormState();
// }
//
// class _TransactionFormState extends State<TransactionForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _amountController = TextEditingController();
//   String? _selectedCategory = 'Category 1';
//   DateTime _selectedDate = DateTime.now();
//
//   @override
//
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 5,
//       child: Container(
//         padding: EdgeInsets.all(10),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               TextFormField(
//                 controller: _amountController,
//                 decoration: InputDecoration(labelText: 'Amount'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter an amount.';
//                   }
//                   if (double.tryParse(value) == null) {
//                     return 'Please enter a valid number.';
//                   }
//                   return null;
//                 },
//               ),
//               DropdownButtonFormField<String>(
//                 value: _selectedCategory,
//                 items: ['Category 1', 'Category 2', 'Category 3']
//                     .map((category) {
//                   return DropdownMenuItem(
//                     value: category,
//                     child: Text(category),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedCategory = value!;
//                   });
//                 },
//                 decoration: InputDecoration(labelText: 'Category'),
//               ),
//               Row(
//                 children: [
//                   Text(
//                     'Date: ${DateFormat('MM/dd/yyyy').format(_selectedDate)}',
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       _selectDate(context);
//                     },
//                     child: Text(
//                       'Select Date',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: Text('Add Transaction'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       final amount = double.parse(_amountController.text);
//       widget.onSubmit(_selectedCategory!, amount, _selectedDate);
//       _amountController.clear();
//       setState(() {
//         _selectedCategory = 'Select Category';
//         _selectedDate = DateTime.now();
//       });
//     }
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (pickedDate != null && pickedDate != _selectedDate) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }
// }
