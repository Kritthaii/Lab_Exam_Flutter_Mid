import 'package:flutter/material.dart';

void main() {
  // AI-ASSISTED: จุดเริ่มต้นของแอปพลิเคชัน
  runApp(const TodoApp());
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  // AI-ASSISTED: กำหนดตัวแปรสำหรับควบคุมสถานะ Dark/Light Mode 
  bool _isDarkMode = false;

  // ฟังก์ชันสำหรับสลับโหมดสี
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // กำหนดชื่อแอป
      title: 'Smart Todo App',
      // ตรวจสอบเงื่อนไขเพื่อเลือก Theme 
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      // หน้าแรกที่จะแสดงคือ Onboarding Screen 
      home: OnboardingScreen(onThemeChanged: _toggleTheme),
      // ปิดป้าย Debug มุมขวาบน
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- หน้า Onboarding (3 หน้าจอใช้ PageView)  ---
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onThemeChanged;
  const OnboardingScreen({super.key, required this.onThemeChanged});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // AI-ASSISTED: ตัวควบคุมหน้าปัจจุบัน
  int _currentPage = 0;

  // ข้อมูลหน้าต่างๆ
  final List<Map<String, dynamic>> _pages = [
    {
      'color': Colors.blue.shade100,
      'title': "Manage Tasks",
      'desc': "จัดระเบียบงานของคุณให้ง่ายขึ้น",
    },
    {
      'color': Colors.green.shade100,
      'title': "Swipe to Action",
      'desc': "ปัดซ้ายเพื่อลบ ปัดขวาเพื่อแก้ไข ",
    },
    {
      'color': Colors.orange.shade100,
      'title': "Get Started",
      'desc': "เริ่มสร้างรายการ Todo แรกของคุณเลย!",
      'isLast': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentPageData = _pages[_currentPage];
    return Scaffold(
      body: Container(
        color: currentPageData['color'],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentPageData['title'],
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                currentPageData['desc'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 50),
            // ปุ่ม navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentPage > 0)
                  ElevatedButton(
                    onPressed: _previousPage,
                    child: const Text("ก่อนหน้า"),
                  ),
                const SizedBox(width: 20),
                if (_currentPage < _pages.length - 1)
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: const Text("ถัดไป"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(onThemeChanged: widget.onThemeChanged),
                        ),
                      );
                    },
                    child: const Text("เข้าสู่หน้าหลัก"),
                  ),
              ],
            ),
            const SizedBox(height: 30),
            // Indicator dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.black : Colors.black26,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }
}





// --- ส่วนของ Model ข้อมูล ---
// AI-ASSISTED: สร้างคลาส Todo สำหรับเก็บข้อมูลงานแต่ละรายการ
class Todo {
  String id; // ไอดีอ้างอิง
  String title; // ชื่อรายการ
  String description; // รายละเอียด
  String priority; // ความสำคัญ (Low, Medium, High)
  bool isCompleted; // สถานะเสร็จสิ้น

  Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = 'Low',
    this.isCompleted = false,
  });
}

// --- หน้าหลัก (Home Screen) ---
class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeChanged; // เพิ่มตัวแปรรับฟังก์ชัน
  const HomeScreen({super.key, required this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // AI-ASSISTED: รายการ Todo เริ่มต้น (ข้อมูลสมมติ)
  List<Todo> _todos = [
    Todo(id: '1', title: 'ส่งการบ้าน Flutter', description: 'ส่งก่อนเที่ยงคืน', priority: 'High'),
    Todo(id: '2', title: 'ซื้อของเข้าบ้าน', description: 'ไข่ไก่, นมสด', priority: 'Medium'),
  ];

  // ตัวแปรสำหรับฟังก์ชัน Search
  String _searchQuery = '';

  // AI-ASSISTED: ฟังก์ชันกรองรายการ (Filter) ตามคำค้นหา
  List<Todo> get _filteredTodos {
    return _todos.where((todo) {
      return todo.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายการของฉัน"),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark 
                ? Icons.light_mode 
                : Icons.dark_mode,
            ),
            onPressed: widget.onThemeChanged,
            tooltip: 'เปลี่ยนธีม',
          ),
        ],
        // AI-ASSISTED: ช่องสำหรับ Search รายการ 
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: const InputDecoration(
                hintText: 'ค้นหารายการ...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                fillColor: Colors.white24,
                filled: true,
              ),
            ),
          ),
        ),
      ),
      // AI-ASSISTED: ใช้ ReorderableListView เพื่อจัดลำดับรายการได้ [cite: 15]
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final item = _todos.removeAt(oldIndex);
            _todos.insert(newIndex, item);
          });
        },
        children: _filteredTodos.map((todo) => _buildTodoItem(todo)).toList(),
      ),
      // ปุ่มเพิ่มรายการใหม่
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // จะทำ Navigator ใน Step ถัดไป เพื่อไปหน้า Add Screen 
final result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const AddEditScreen())
    );
    if (result != null) setState(() => _todos.add(result));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // AI-ASSISTED: Widget สำหรับแสดงรายการในลิสต์พร้อม Dismissible
  Widget _buildTodoItem(Todo todo) {
    return Dismissible(
      // การใช้ Key ที่มีความหมาย (ใช้ id ของข้อมูล) [cite: 15, 22]
      key: Key(todo.id),
      // ปัดขวา = แก้ไข (สีส้ม) 
      background: Container(
        color: Colors.orange,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      // ปัดซ้าย = ลบ (สีแดง) 
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      // ยืนยันการ dismiss
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // ปัดซ้าย = ลบ
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('ยืนยันการลบ'),
                content: const Text('คุณต้องการลบรายการนี้หรือไม่?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('ยกเลิก'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('ลบ'),
                  ),
                ],
              );
            },
          );
        } else {
          // ปัดขวา = แก้ไข
          final result = await Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => AddEditScreen(todo: todo))
          );
          if (result != null) {
            setState(() {
              int index = _todos.indexWhere((item) => item.id == todo.id);
              _todos[index] = result;
            });
          }
          return false; // ไม่ dismiss จริงๆ สำหรับ edit
        }
      },
      // ฟังก์ชันเมื่อมีการปัด (สำหรับ delete เท่านั้น)
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          setState(() => _todos.removeWhere((item) => item.id == todo.id));
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: (value) => setState(() => todo.isCompleted = value!),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text("ระดับความสำคัญ: ${todo.priority}"),
          onTap: () {
            // ไปหน้า Detail Screen เพื่อดูรายละเอียด 
          },
        ),
      ),
    );
  }
}

// AI-ASSISTED: หน้าสำหรับเพิ่มหรือแก้ไขรายการ Todo
class AddEditScreen extends StatefulWidget {
  final Todo? todo; // ถ้ามีข้อมูลส่งมาแสดงว่าเป็นโหมด "แก้ไข"

  const AddEditScreen({super.key, this.todo});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  // AI-ASSISTED: ใช้ GlobalKey สำหรับตรวจสอบความถูกต้องของฟอร์ม [cite: 14]
  final _formKey = GlobalKey<FormState>();
  
  // ตัวแปรสำหรับเก็บค่าจากฟอร์ม (3 Fields)
  late String _title;
  late String _description;
  late String _priority;

  // AI-ASSISTED: กำหนดค่าเริ่มต้นให้กับฟิลด์ต่างๆ
  @override
  void initState() {
    super.initState();
    _title = widget.todo?.title ?? '';
    _description = widget.todo?.description ?? '';
    _priority = widget.todo?.priority ?? 'Low';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.todo == null ? "เพิ่มรายการใหม่" : "แก้ไขรายการ")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // เชื่อมต่อ Key กับ Form
          child: ListView(
            children: [
              // Field 1: ชื่อรายการ พร้อม Validation 
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'ชื่อรายการ Todo'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'กรุณากรอกชื่อรายการ';
                  if (value.length < 3) return 'ต้องยาวอย่างน้อย 3 ตัวอักษร';
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 15),
              
              // Field 2: รายละเอียดรายการ [cite: 14]
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'รายละเอียดเพิ่มเติม'),
                maxLines: 3,
                onSaved: (value) => _description = value ?? '',
              ),
              const SizedBox(height: 15),

              // Field 3: ระดับความสำคัญ (Dropdown) [cite: 14]
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'ระดับความสำคัญ'),
                items: ['Low', 'Medium', 'High'].map((p) => 
                  DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (value) => setState(() => _priority = value!),
              ),
              const SizedBox(height: 30),

              // AI-ASSISTED: ปุ่มบันทึกพร้อม Animation (ScaleTransition เมื่อกด) 
              _buildAnimatedButton(),
            ],
          ),
        ),
      ),
    );
  }

  // AI-ASSISTED: ฟังก์ชันสร้างปุ่มที่มี Animation ตามโจทย์ 
  Widget _buildAnimatedButton() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 1.0, end: 1.0),
      duration: const Duration(milliseconds: 100),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.blueAccent,
            ),
            onPressed: _saveForm,
            child: const Text("บันทึกข้อมูล", style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        );
      },
    );
  }

  // ฟังก์ชันบันทึกข้อมูลและส่งกลับ 
  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // สร้าง Object Todo ใหม่หรืออัปเดตตัวเดิม
      final result = Todo(
        id: widget.todo?.id ?? DateTime.now().toString(),
        title: _title,
        description: _description,
        priority: _priority,
        isCompleted: widget.todo?.isCompleted ?? false,
      );
      // ส่งข้อมูลกลับไปยังหน้าก่อนหน้า (Navigator) 
      Navigator.pop(context, result);
    }
  }
}


// AI-ASSISTED: หน้ารายละเอียดรายการ (Detail Screen) แสดงข้อมูลแบบเต็ม [cite: 18, 19]
class DetailScreen extends StatelessWidget {
  final Todo todo;
  final Function(String) onDelete;

  const DetailScreen({super.key, required this.todo, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(todo.title)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // แสดงชื่อรายการ
            Text("หัวข้อ: ${todo.title}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            // แสดงระดับความสำคัญ
            Text("ความสำคัญ: ${todo.priority}", style: const TextStyle(fontSize: 18, color: Colors.blueGrey)),
            const SizedBox(height: 20),
            const Text("รายละเอียด:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            // แสดงรายละเอียดเพิ่มเติม
            Text(todo.description.isEmpty ? "-" : todo.description, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            // AI-ASSISTED: ปุ่มลบรายการ [cite: 31]
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  onDelete(todo.id); // เรียกฟังก์ชันลบ
                  Navigator.pop(context); // กลับหน้าหลัก
                },
                child: const Text("ลบรายการนี้", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}