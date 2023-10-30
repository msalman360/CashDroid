// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../model/category.dart';
//
//
//
// class CategoryPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final categoryProvider = Provider.of<CategoryProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Categories'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: categoryProvider.categories.length,
//               itemBuilder: (context, index) {
//                 final category = categoryProvider.categories[index];
//                 return ListTile(
//                   leading: Icon(Icons.category), // Default category icon
//                   title: Text(category.name),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) {
//                     final _categoryNameController = TextEditingController();
//
//                     return AlertDialog(
//                       title: Text('Add Category'),
//                       content: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           TextFormField(
//                             controller: _categoryNameController,
//                             decoration: InputDecoration(
//                               labelText: 'Category Name',
//                             ),
//                           ),
//                         ],
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             if (_categoryNameController.text.isNotEmpty) {
//                               final newCategory = Category(
//                                 name: _categoryNameController.text,
//                                 icon: Icons.category, // Default category icon
//                               );
//
//                               categoryProvider.addCategory(newCategory); // Pass the newCategory object
//
//                               _categoryNameController.clear();
//                               Navigator.pop(context);
//                             }
//                           },
//                           child: Text('Add'),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             _categoryNameController.clear();
//                             Navigator.pop(context);
//                           },
//                           child: Text('Cancel'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//               child: Icon(Icons.add), // Use the default "add" icon
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class CategoryProvider with ChangeNotifier {
//   List<Category> _categories = [];
//
//   List<Category> get categories => _categories;
//
//   // Other properties and methods
//
//   // Add a new category
//   void addCategory(Category category) {
//     _categories.add(category);
//     notifyListeners();
//   }
// }
//
