class SyntaxItem {
  final String title;
  final String description;
  final String detailedExplanation;
  final String codeExample;
  final String usageScenario;
  final bool isBasic;

  const SyntaxItem({
    required this.title,
    required this.description,
    required this.detailedExplanation,
    required this.codeExample,
    required this.usageScenario,
    required this.isBasic,
  });
}

final List<SyntaxItem> syntaxData = [
  // ==================== Basic Syntax ====================
  const SyntaxItem(
    title: '变量声明 (Variables)',
    description: 'Dart 中的 var, final, const 使用详解',
    isBasic: true,
    detailedExplanation:
        'Dart 支持类型推断。\n\n'
        '1. **var**: 声明变量，类型由首次赋值决定。如果首次赋值后，后续不能改变类型。\n'
        '2. **final**: 运行时常量。只能赋值一次。通常用于实例变量或通过构造函数初始化的值。\n'
        '3. **const**: 编译时常量。值必须在编译期确定。const 变量也是 implicit final 的。\n'
        '4. **dynamic**: 动态类型，可以改变类型，但会失去类型检查，应谨慎使用。',
    codeExample: '''
void main() {
  // var: 类型推断
  var name = 'Dart'; 
  // name = 1; // Error: A value of type 'int' can't be assigned to a variable of type 'String'.

  // final: 运行时常量
  final now = DateTime.now(); 
  // now = DateTime.now(); // Error: The final variable 'now' can only be set once.

  // const: 编译时常量
  const pi = 3.14159;
  
  // dynamic: 动态类型
  dynamic value = 'Hello';
  value = 123; // OK
}
''',
    usageScenario: '在声明局部变量时首选 `var` 或 `final`。需要不可变性时使用 `final`。如果你知道值在编译时就是固定的（如数学常数、配置项），使用 `const`。',
  ),
  const SyntaxItem(
    title: '内建类型 (Built-in Types)',
    description: '常用数据类型：Numbers, Strings, Booleans, Lists, Sets, Maps',
    isBasic: true,
    detailedExplanation:
        'Dart 是强类型语言，但也支持类型推断。核心类型包括：\n'
        '- **int / double**: 数值类型。\n'
        '- **String**: 字符串，支持插值 (`\$variable`)。\n'
        '- **bool**: 布尔值 (true/false)。\n'
        '- **List**: 有序集合 (数组)。\n'
        '- **Set**: 无序且唯一的集合。\n'
        '- **Map**: 键值对集合。',
    codeExample: '''
void main() {
  // String interpolation
  String name = 'World';
  print('Hello, \$name!');

  // List
  List<int> numbers = [1, 2, 3];
  numbers.add(4);

  // Set (unique)
  Set<String> uniqueNames = {'Alice', 'Bob', 'Alice'};
  print(uniqueNames.length); // 2

  // Map
  Map<String, int> scores = {
    'Math': 90,
    'English': 85
  };
}
''',
    usageScenario: '用于存储和操作数据。List 用于有序列表，Set 用于去重，Map 用于键值关联。',
  ),
  const SyntaxItem(
    title: '函数 (Functions)',
    description: '参数传递、命名参数、可选参数及箭头函数',
    isBasic: true,
    detailedExplanation:
        'Dart 函数是一等公民。\n'
        '- **位置参数**: 必须按顺序传递。\n'
        '- **命名参数**: 使用 `{}` 包裹，调用时需指定名称，可读性高，通常配合 `required` 使用。\n'
        '- **可选位置参数**: 使用 `[]` 包裹。\n'
        '- **箭头函数**: `=>` 语法用于只有一行表达式的函数。',
    codeExample: '''
// 命名参数
void greet({required String name, String? message}) {
  print('\$name: \${message ?? "Hello"}');
}

// 可选位置参数
String join(String a, [String b = '']) {
  return a + b;
}

// 箭头函数
int add(int a, int b) => a + b;

void main() {
  greet(name: 'Alice', message: 'Hi');
  greet(name: 'Bob');
  
  print(join('A', 'B'));
  print(add(5, 3));
}
''',
    usageScenario: 'Flutter Widget 的构造函数大量使用命名参数，以提高代码可读性。简单的 getter 或回调函数常使用箭头函数。',
  ),
  const SyntaxItem(
    title: '控制流 (Control Flow)',
    description: 'if, for, while, switch 以及集合中的控制流',
    isBasic: true,
    detailedExplanation:
        '标准的控制流语句：\n'
        '- **if-else**: 条件判断。\n'
        '- **for / for-in**: 循环。\n'
        '- **while / do-while**: 循环。\n'
        '- **switch**: 多条件分支。\n\n'
        'Dart 特有的 **Collection if** 和 **Collection for** 可以在构建 List/Map 时直接使用条件和循环，非常适合构建 UI。',
    codeExample: '''
void main() {
  // Standard loop
  for (var i = 0; i < 3; i++) {
    print(i);
  }

  // Collection if
  bool isAdmin = true;
  List<String> menu = [
    'Home',
    'Profile',
    if (isAdmin) 'Admin Panel', // 只有 isAdmin 为 true 时才添加
  ];

  // Collection for
  List<int> source = [1, 2, 3];
  List<String> formatted = [
    'Header',
    for (var i in source) 'Item #\$i',
  ];
}
''',
    usageScenario: '在 Flutter 的 build 方法中，`Collection if` 和 `Collection for` 非常强大，用于根据状态动态构建 Widget 列表。',
  ),
  const SyntaxItem(
    title: '类与构造函数 (Classes)',
    description: '类定义、构造函数、命名构造函数',
    isBasic: true,
    detailedExplanation:
        'Dart 是面向对象的。\n'
        '- **构造函数**: 同名函数。\n'
        '- **命名构造函数**: `Class.name()` 形式。\n'
        '- **初始化列表**: 在构造函数体运行前初始化实例变量。\n'
        '- **this**: 指向当前实例。',
    codeExample: '''
class Point {
  final double x;
  final double y;

  // 标准构造函数 (Syntactic sugar)
  Point(this.x, this.y);

  // 命名构造函数
  Point.origin()
      : x = 0,
        y = 0; // 初始化列表

  @override
  String toString() => 'Point(\$x, \$y)';
}

void main() {
  var p1 = Point(10, 20);
  var p2 = Point.origin();
}
''',
    usageScenario: '几乎所有的 Flutter Widget 都是类。理解构造函数对于自定义 Widget 至关重要。',
  ),

  // ==================== Advanced Syntax ====================
  const SyntaxItem(
    title: '空安全 (Null Safety)',
    description: '?, !, late, required 关键字的使用',
    isBasic: false,
    detailedExplanation:
        'Dart 2.12+ 引入了健全的空安全。\n'
        '- **String?**: 可空类型，变量可以为 null。\n'
        '- **String**: 非空类型，变量永远不能为 null。\n'
        '- **!**: 非空断言，告诉编译器"我知道这个值不为空，请放心"。如果运行时为空会抛出异常。\n'
        '- **late**: 延迟初始化。承诺在访问前会初始化变量。\n'
        '- **?.**: 条件访问，如果对象不为空则访问属性，否则返回 null。',
    codeExample: '''
class User {
  String name; // Non-nullable, must be initialized
  String? nickname; // Nullable
  late int age; // Late initialization

  User(this.name);

  void setAge(int a) {
    age = a;
  }
}

void main() {
  String? input = null;
  // int len = input.length; // Error
  int? len = input?.length; // Safe, returns null
  
  // input = 'hello';
  // int l = input!.length; // Assertion
}
''',
    usageScenario: '避免 "Null Reference Exception"。在定义模型类或处理网络数据（可能缺失字段）时非常重要。',
  ),
  const SyntaxItem(
    title: '异步编程 (Async/Await)',
    description: 'Future, async, await 处理耗时操作',
    isBasic: false,
    detailedExplanation:
        'Dart 是单线程模型，通过 Event Loop 处理异步任务。\n'
        '- **Future**: 表示一个未来可能返回的值或错误。\n'
        '- **async**: 标记函数为异步，返回值自动包装为 Future。\n'
        '- **await**: 等待 Future 完成并获取结果，只能在 async 函数中使用。',
    codeExample: '''
Future<String> fetchUserOrder() async {
  // 模拟网络延迟
  await Future.delayed(const Duration(seconds: 2));
  return 'Cappuccino';
}

void main() async {
  print('Fetching order...');
  try {
    var order = await fetchUserOrder();
    print('Order: \$order');
  } catch (e) {
    print('Error: \$e');
  }
}
''',
    usageScenario: '网络请求、文件 I/O、数据库操作等耗时任务必须使用异步处理，以避免阻塞 UI 线程（导致应用卡顿）。',
  ),
  const SyntaxItem(
    title: '流 (Streams)',
    description: '处理异步事件序列',
    isBasic: false,
    detailedExplanation:
        'Stream 是一系列异步事件的序列（类似管道）。\n'
        '- **Single subscription**: 只能被监听一次（如文件读取）。\n'
        '- **Broadcast**: 可以被多个监听者监听（如鼠标事件）。\n'
        '- **async***: 生成器函数，使用 `yield` 发送数据到 Stream。',
    codeExample: '''
Stream<int> countSeconds(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(const Duration(seconds: 1));
    yield i;
  }
}

void main() async {
  // 监听流
  await for (final tick in countSeconds(3)) {
    print('\$tick seconds passed');
  }
}
''',
    usageScenario: 'WebSocket 连接、定时器、用户输入事件流。Flutter 中的 `StreamBuilder` Widget 专门用于根据 Stream 的最新数据重建 UI。',
  ),
  const SyntaxItem(
    title: '混入 (Mixins)',
    description: '使用 with 关键字复用类代码',
    isBasic: false,
    detailedExplanation:
        'Mixin 是一种在多个类层次结构中复用类代码的方法。\n'
        '使用 `mixin` 关键字定义，使用 `with` 关键字混入。\n'
        'Mixin 不能有构造函数，也不能实例化。',
    codeExample: '''
mixin Musical {
  void play() {
    print('Playing music...');
  }
}

class Performer {}

class Musician extends Performer with Musical {
  // Musician 拥有了 play 方法
}

void main() {
  var m = Musician();
  m.play();
}
''',
    usageScenario: '当你想在不同类之间共享行为（如动画控制 `SingleTickerProviderStateMixin`），但这些类不共享父类时使用。',
  ),
  const SyntaxItem(
    title: '扩展方法 (Extensions)',
    description: '向现有库添加功能',
    isBasic: false,
    detailedExplanation:
        'Extension methods 允许你向已有的类（甚至是你无法修改的第三方库的类）添加方法。\n'
        '使用 `extension on` 语法。',
    codeExample: '''
extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }
}

void main() {
  String s = "42";
  // 直接在 String 对象上调用新方法
  print(s.parseInt() + 10); 
}
''',
    usageScenario: '为 String 添加验证方法（如 `isEmail`），或为 Widget 添加快捷构建方法（如 `padding` 扩展）。',
  ),
];
