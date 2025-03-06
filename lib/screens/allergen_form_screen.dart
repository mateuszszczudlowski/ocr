import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/allergen.dart';

class AllergenFormScreen extends StatefulWidget {
  const AllergenFormScreen({super.key});

  @override
  State<AllergenFormScreen> createState() => _AllergenFormScreenState();
}

class _AllergenFormScreenState extends State<AllergenFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _allergenController = TextEditingController();
  late Box<Allergen> _allergensBox;

  @override
  void initState() {
    super.initState();
    _allergensBox = Hive.box<Allergen>('allergens');
  }

  @override
  void dispose() {
    _allergenController.dispose();
    super.dispose();
  }

  void _addAllergen() {
    if (_formKey.currentState!.validate()) {
      final allergen = Allergen(name: _allergenController.text.trim());
      _allergensBox.add(allergen);
      _allergenController.clear();
      setState(() {});
    }
  }

  void _removeAllergen(int index) {
    _allergensBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Allergens'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _allergenController,
                      decoration: const InputDecoration(
                        labelText: 'Enter allergen',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an allergen';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _addAllergen,
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _allergensBox.listenable(),
                builder: (context, Box<Allergen> box, _) {
                  if (box.isEmpty) {
                    return const Center(
                      child: Text('No allergens added yet'),
                    );
                  }
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final allergen = box.getAt(index)!;
                      return ListTile(
                        title: Text(allergen.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeAllergen(index),
                        ),
                      );
                    },
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
