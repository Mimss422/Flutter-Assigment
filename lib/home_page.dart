import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'item_cubit.dart';
import 'item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.task_alt, size: 28),
            SizedBox(width: 12),
            Text("My Tasks"),
          ],
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 4,
      ),
      body: Column(
        children: [
          // Add Item Input Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.blue.shade200, width: 2),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.add_circle, color: Colors.blue.shade700, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Add a new task...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.blue.shade700,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      prefixIcon: Icon(
                        Icons.edit,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.extended(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      context.read<ItemCubit>().addItem(controller.text);
                      controller.clear();
                    }
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Add"),
                  backgroundColor: Colors.green.shade600,
                ),
              ],
            ),
          ),

          // List of Items
          Expanded(
            child: BlocBuilder<ItemCubit, List<Item>>(
              builder: (context, items) {
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No tasks yet!",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Add a task to get started",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: Checkbox(
                          value: item.isDone,
                          onChanged: (_) {
                            context.read<ItemCubit>().toggleItem(index);
                          },
                          activeColor: Colors.green.shade600,
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            decoration: item.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: item.isDone
                                ? Colors.grey.shade500
                                : Colors.black87,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red.shade600,
                          ),
                          onPressed: () {
                            context.read<ItemCubit>().deleteItem(index);
                          },
                        ),
                        tileColor: item.isDone
                            ? Colors.grey.shade100
                            : Colors.white,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
