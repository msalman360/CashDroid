import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:cash_droid/scoped_model/expenseScope.dart';
import 'package:cash_droid/theme/colors.dart';
import 'package:scoped_model/scoped_model.dart';

class NewEntryLog extends StatefulWidget {
  @override
  _NewEntryLogState createState() => _NewEntryLogState();
}

class _NewEntryLogState extends State<NewEntryLog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController _itemEditor = TextEditingController();
  TextEditingController _personEditor = TextEditingController();
  TextEditingController _amountEditor = TextEditingController();
  TextEditingController _dateEditor = TextEditingController(text: DateTime.now().toString());
  TextEditingController _categoryEditor = TextEditingController();
  late List<TextEditingController> _shareController;

  late Map<String, String> shareList;
  late ExpenseModel model;
  bool showError = false;
  late List<String> _users;
  late List<double> _sharedRatio;

  late bool editRecord;

  @override
  void dispose() {
    super.dispose();
    _itemEditor.dispose();
    _personEditor.dispose();
    _amountEditor.dispose();
    _dateEditor.dispose();
    _categoryEditor.dispose();
    _shareController.forEach((element) {
      element.dispose();
    });
  }

  @override
  void initState() {
    model = ScopedModel.of<ExpenseModel>(context);
    super.initState();
    editRecord = false; // Set your condition here
    _users = model.getUsers;

    if (editRecord) {
      Map<String, dynamic> data = {...model.getExpenses[0]}; // Replace this with your edit logic
      _itemEditor.text = data['item'];
      _personEditor.text = data['person'];
      _amountEditor.text = data['amount'];
      _dateEditor.text = DateFormat("dd-MM-yyyy").format(DateFormat('yyyy-MM-dd').parse(data['date']));
      _categoryEditor.text = data['category'];
      shareList = Map<String, String>.from(data["shareBy"]);

      // fill users if not present
      if (_users.length != shareList.length) {
        for (String u in _users) {
          if (!shareList.containsKey(u)) {
            shareList[u] = "0.00";
          }
        }
      }
      _sharedRatio = _users
          .map((e) => double.parse(
          (double.parse(shareList[e] ?? "0.0") * _users.length / double.parse(data['amount'])).toStringAsFixed(2)))
          .toList();
    } else {
      shareList = {for (var u in _users) u: "0.00"};
      _sharedRatio = _users.map((e) => 1.0).toList();
    }
    _shareController = _users.map((e) => TextEditingController(text: shareList[e])).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondary,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (editRecord) model.deleteExpense(0); // Replace the index with your logic
              Navigator.pop(context);
            },
            icon: Icon(Icons.delete),
            color: Colors.white,
            tooltip: "Delete",
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: (model.getUsers.length == 0 || model.getCategories.length == 0)
            ? Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "No users or categories added",
                style: TextStyle(fontSize: 21),
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Go to settings"),
              )
            ],
          ),
        )
            : Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autovalidateMode: AutovalidateMode.disabled,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.shopping_cart_outlined),
                    hintText: 'Where did you spend the money?',
                    labelText: 'Item',
                  ),
                  controller: _itemEditor,
                  validator: (value) => value!.isEmpty ? "Required field *" : null,
                ),
                SizedBox(height: 9),
                SelectFormField(
                  icon: Icon(Icons.person_outline),
                  labelText: 'Spent By',
                  controller: _personEditor,
                  items: model.getUsers
                      .map((e) => {
                    "value": e,
                    "label": e,
                  })
                      .map(
                        (e) => Map<String, dynamic>.from(e),
                  )
                      .toList(),
                  validator: (value) => value!.isEmpty ? "Required field *" : null,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.disabled,
                  keyboardType: TextInputType.number,
                  controller: _amountEditor,
                  onChanged: (value) {
                    updateSharingDetails();
                  },
                  decoration: const InputDecoration(
                    icon: Icon(Icons.account_balance_wallet_outlined),
                    hintText: 'How much money is spent?',
                    labelText: "Amount",
                  ),
                  validator: (val) {
                    if (val!.isEmpty) return "Required field *";
                    if (double.tryParse(val) == null) {
                      return "Enter a valid number ";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 9),
                DateTimePicker(
                  controller: _dateEditor,
                  type: DateTimePickerType.date,
                  dateMask: 'd MMM, yyyy',
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.event),
                  dateLabelText: 'Date',
                  validator: (value) => value!.isEmpty ? "Required field *" : null,
                ),
                SizedBox(height: 9),
                SelectFormField(
                  autovalidate: false,
                  type: SelectFormFieldType.dropdown,
                  controller: _categoryEditor,
                  icon: Icon(Icons.category),
                  hintText: 'Category of the spend',
                  labelText: 'Category',
                  items: model.getCategories
                      .map((e) => {
                    "value": e,
                    "label": e,
                  })
                      .map((e) => Map<String, dynamic>.from(e))
                      .toList(),
                  validator: (value) => value!.isEmpty ? "Required field *" : null,
                ),
                SizedBox(height: 9),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: clearForm,
              child: Text(
                "Save & Add another",
                style: TextStyle(fontSize: 18, color: Colors.deepPurple),
              ),
            ),
            TextButton(
              onPressed: () {
                bool saved = saveRecord();
                if (saved) {
                  // Handle the navigation logic as needed
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Save",
                style: TextStyle(fontSize: 18, color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }

  saveRecord() {
    if (formKey.currentState!.validate() && sharedProperly()) {
      Map<String, dynamic> data = {
        "date": DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(_dateEditor.text)),
        "person": _personEditor.text,
        "item": _itemEditor.text,
        "category": _categoryEditor.text,
        "amount": _amountEditor.text,
        "shareBy": shareList
      };
      editRecord ? model.editExpense(0, data) : model.addExpense(data); // Replace the index with your logic
      return true;
    }
    return false;
  }

  clearForm() {
    bool saved = saveRecord();
    if (!saved) return;
    formKey.currentState!.reset();
    _itemEditor.clear();
    _amountEditor.clear();
    // Keep the person selector, category selector, and date as they are while clearing the form
    shareList = {for (var u in model.getUsers) u: "0.00"};
    _sharedRatio = _users.map((e) => 1.0).toList();
    for (TextEditingController e in _shareController) {
      e.clear();
    }
    _shareController = _users.map((e) => TextEditingController(text: shareList[e])).toList();
    editRecord = false; // Set your edit logic here
    setState(() {});
  }

  sharedProperly() {
    double val = double.parse(_amountEditor.text);
    if (val == null) return false;

    for (int i = 0; i < _users.length; i++) {
      shareList[_users[i]] = double.parse(_shareController[i].text).toStringAsFixed(2);
    }

    List<double> sharedAmount = _users.map((e) => double.parse(shareList[e] ?? "0.0")).toList();
    double summed = sharedAmount.fold(0, (previous, current) => previous + current);
    int len = _users.length;

    if (summed == val) {
      _sharedRatio = sharedAmount.map((e) => double.parse((e * len / summed).toStringAsFixed(2))).toList();
      showError = false;
      setState(() {});

      return true;
    } else {
      showError = true;
      setState(() {});

      return false;
    }
  }

  updateSharingDetails() {
    if (_amountEditor.text.trim().isEmpty) {
      return;
    }
    double value = double.parse(_amountEditor.text);

    List<double> iAmount =
    _sharedRatio.map((e) => double.parse((value * e / _sharedRatio.fold(0, (previous, current) => previous + current)).toStringAsFixed(2))).toList();

    double diff = value;
    for (double e in iAmount) {
      diff -= e;
    }

    if (diff != 0) {
      for (int i = 0; i < _users.length; i++) {
        if (_sharedRatio[i] != 0) {
          iAmount[i] += diff;
          break;
        }
      }
    }
    for (int i = 0; i < _users.length; i++) {
      _shareController[i].text = iAmount[i].toStringAsFixed(2);
      shareList[_users[i]] = iAmount[i].toStringAsFixed(2);
    }
    setState(() {});
  }
}
