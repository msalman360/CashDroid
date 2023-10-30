import 'package:flutter/material.dart';

class CategoryManagementPage extends StatefulWidget {
  @override
  _CategoryManagementPageState createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  List<CategoryItem> categories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Management'),
      ),
      body: ListView(
        children: [
          for (CategoryItem category in categories) CategoryTile(category: category),
          AddCategoryButton(onCategoryAdded: (category) {
            setState(() {
              categories.add(category);
            });
          }),
        ],
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final CategoryItem category;

  CategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(category.icon),
      title: Text(category.name),
    );
  }
}

class AddCategoryButton extends StatelessWidget {
  final Function(CategoryItem) onCategoryAdded;

  AddCategoryButton({required this.onCategoryAdded});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.add),
      title: Text('Add Category'),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            CategoryItem newCategory = CategoryItem('New Category', Icons.category); // Default values
            return AlertDialog(
              title: Text('Add a Category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Category Name'),
                    onChanged: (value) {
                      newCategory.name = value;
                    },
                  ),
                  SizedBox(height: 10),
                  IconPicker(
                    selectedIcon: newCategory.icon,
                    onIconSelected: (icon) {
                      newCategory.icon = icon;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    onCategoryAdded(newCategory);
                    Navigator.of(context).pop();
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class CategoryItem {
  String name;
  IconData icon;

  CategoryItem(this.name, this.icon);
}

class IconPicker extends StatelessWidget {
  final IconData selectedIcon;
  final Function(IconData) onIconSelected;

  IconPicker({required this.selectedIcon, required this.onIconSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Select an Icon:'),
        Wrap(
          children: [
            for (var iconData in _iconDataList)
              GestureDetector(
                onTap: () {
                  onIconSelected(iconData);
                },
                child: Icon(iconData, size: 40, color: iconData == selectedIcon ? Colors.blue : Colors.black),
              ),
          ],
        ),
      ],
    );
  }

  static const List<IconData> _iconDataList = [
    Icons.category,
    Icons.star,
    Icons.work,
    Icons.home,
    Icons.school,
    Icons.shopping_cart,
    Icons.fastfood,
    Icons.local_cafe,
    Icons.directions_car,
  ];
}
