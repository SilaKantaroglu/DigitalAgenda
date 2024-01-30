import 'package:digital_agenda/pages/components/colors.dart';
import 'package:digital_agenda/pages/gorevler/gorev_database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  TasksPageState createState() => TasksPageState();
}

class TasksPageState extends State<TasksPage> {
  late Future<Database> database;
  final TextEditingController _textEditingController = TextEditingController();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'tasks_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, completed INTEGER)',
        );
      },
      version: 1,
    );
    refreshTasks();
  }

  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    refreshTasks();
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    refreshTasks();
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    refreshTasks();
  }

  Future<void> refreshTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    setState(() {
      tasks = List.generate(
        maps.length,
        (i) => Task(
          id: maps[i]['id'],
          title: maps[i]['title'],
          completed: maps[i]['completed'] == 1,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50]!,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
            child: Text(
          'Yapılacaklar Listesi',
          style: TextStyle(
            color: ColorUtility.defaultWhiteColor,
            fontSize: 20,
          ),
        )),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final color = index % 2 == 0 ? Colors.grey[200] : Colors.grey[300];
                return Container(
                  color: color,
                  child: Dismissible(
                    key: Key(task.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: const Color.fromARGB(255, 238, 59, 65),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 19.0),
                      child: const Icon(Icons.delete, color: ColorUtility.defaultWhiteColor),
                    ),
                    confirmDismiss: (direction) async {
                      bool confirmDelete = await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Sil'),
                          content: const Text('Emin misiniz?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Vazgeç'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Sil'),
                            ),
                          ],
                        ),
                      );

                      return confirmDelete;
                    },
                    onDismissed: (direction) {
                      deleteTask(task.id);
                    },
                    child: ListTile(
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.completed ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        trailing: Checkbox(
                          value: task.completed,
                          onChanged: (bool? value) {
                            setState(() {
                              task.completed = value!;
                              updateTask(task);
                            });
                          },
                        )),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      labelText: '..',
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final title = _textEditingController.text.trim();
                    if (title.isNotEmpty) {
                      final newTask = Task(
                        id: DateTime.now().microsecondsSinceEpoch,
                        title: title,
                        completed: false,
                      );
                      insertTask(newTask);
                      _textEditingController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorUtility.buttonColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Ekle',
                    style: TextStyle(fontSize: 18, color: ColorUtility.defaultWhiteColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
