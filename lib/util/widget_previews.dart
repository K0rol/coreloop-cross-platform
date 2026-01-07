import 'package:flutter/material.dart';

enum ControlType { double, integer, boolean, enumeration, string, color }

class PreviewControl {
  final String key;
  final String label;
  final ControlType type;
  final dynamic defaultValue;
  final double? min;
  final double? max;
  final List<dynamic>? options; // For enumeration
  final Map<dynamic, String>? optionLabels; // Display labels for options

  PreviewControl({
    required this.key,
    required this.label,
    required this.type,
    required this.defaultValue,
    this.min,
    this.max,
    this.options,
    this.optionLabels,
  });
}

class WidgetPreviewData {
  final Widget Function(BuildContext context, Map<String, dynamic> args)
  builder;
  final String Function(Map<String, dynamic> args) codeBuilder;
  final List<PreviewControl> controls;

  WidgetPreviewData({
    required this.builder,
    required this.codeBuilder,
    required this.controls,
  });
}

// Helper for generating code string properties

String _enumName(dynamic enumValue) {
  return enumValue.toString().split('.').last;
}

final Map<String, WidgetPreviewData> widgetPreviews = {
  'Container': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'width',
        label: 'Width',
        type: ControlType.double,
        defaultValue: 100.0,
        min: 50,
        max: 300,
      ),
      PreviewControl(
        key: 'height',
        label: 'Height',
        type: ControlType.double,
        defaultValue: 100.0,
        min: 50,
        max: 300,
      ),
      PreviewControl(
        key: 'color',
        label: 'Color',
        type: ControlType.color,
        defaultValue: Colors.blue,
        options: [Colors.blue, Colors.red, Colors.green, Colors.amber],
        optionLabels: {
          Colors.blue: 'Blue',
          Colors.red: 'Red',
          Colors.green: 'Green',
          Colors.amber: 'Amber',
        },
      ),
      PreviewControl(
        key: 'radius',
        label: 'Border Radius',
        type: ControlType.double,
        defaultValue: 8.0,
        min: 0,
        max: 50,
      ),
    ],
    builder: (context, args) => Container(
      width: args['width'],
      height: args['height'],
      decoration: BoxDecoration(
        color: args['color'],
        borderRadius: BorderRadius.circular(args['radius']),
      ),
      child: const Center(
        child: Text("Box", style: TextStyle(color: Colors.white)),
      ),
    ),
    codeBuilder: (args) =>
        '''
Container(
  width: ${args['width'].toStringAsFixed(1)},
  height: ${args['height'].toStringAsFixed(1)},
  decoration: BoxDecoration(
    color: ${_colorName(args['color'])},
    borderRadius: BorderRadius.circular(${args['radius'].toStringAsFixed(1)}),
  ),
)''',
  ),
  'Align': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'alignment',
        label: 'Alignment',
        type: ControlType.enumeration,
        defaultValue: Alignment.center,
        options: [
          Alignment.topLeft,
          Alignment.topCenter,
          Alignment.topRight,
          Alignment.centerLeft,
          Alignment.center,
          Alignment.centerRight,
          Alignment.bottomLeft,
          Alignment.bottomCenter,
          Alignment.bottomRight,
        ],
        optionLabels: {
          Alignment.topLeft: 'Alignment.topLeft',
          Alignment.topCenter: 'Alignment.topCenter',
          Alignment.topRight: 'Alignment.topRight',
          Alignment.centerLeft: 'Alignment.centerLeft',
          Alignment.center: 'Alignment.center',
          Alignment.centerRight: 'Alignment.centerRight',
          Alignment.bottomLeft: 'Alignment.bottomLeft',
          Alignment.bottomCenter: 'Alignment.bottomCenter',
          Alignment.bottomRight: 'Alignment.bottomRight',
        },
      ),
    ],
    builder: (context, args) => Container(
      color: Colors.grey[200],
      width: 200,
      height: 200,
      child: Align(
        alignment: args['alignment'],
        child: const FlutterLogo(size: 40),
      ),
    ),
    codeBuilder: (args) =>
        '''
Align(
  alignment: ${args['optionLabels']?[args['alignment']] ?? args['alignment'].toString()},
  child: const FlutterLogo(size: 40),
)''',
  ),
  'AnimatedContainer': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'width',
        label: 'Width',
        type: ControlType.double,
        defaultValue: 100.0,
        min: 50,
        max: 300,
      ),
      PreviewControl(
        key: 'height',
        label: 'Height',
        type: ControlType.double,
        defaultValue: 100.0,
        min: 50,
        max: 300,
      ),
      PreviewControl(
        key: 'color',
        label: 'Color',
        type: ControlType.color,
        defaultValue: Colors.blue,
        options: [Colors.blue, Colors.red, Colors.green, Colors.amber],
        optionLabels: {
          Colors.blue: 'Blue',
          Colors.red: 'Red',
          Colors.green: 'Green',
          Colors.amber: 'Amber',
        },
      ),
    ],
    builder: (context, args) => AnimatedContainer(
      duration: const Duration(seconds: 1),
      width: args['width'],
      height: args['height'],
      color: args['color'],
      curve: Curves.easeInOut,
      child: const Center(
          child: Text("Animate", style: TextStyle(color: Colors.white))),
    ),
    codeBuilder: (args) => '''
AnimatedContainer(
  duration: const Duration(seconds: 1),
  curve: Curves.easeInOut,
  width: ${args['width'].toStringAsFixed(1)},
  height: ${args['height'].toStringAsFixed(1)},
  color: ${_colorName(args['color'])},
  child: const Center(child: Text("Animate", style: TextStyle(color: Colors.white))),
)''',
  ),
  'Text': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'text',
        label: 'Content',
        type: ControlType.string,
        defaultValue: 'Hello Flutter',
      ),
      PreviewControl(
        key: 'fontSize',
        label: 'Font Size',
        type: ControlType.double,
        defaultValue: 24.0,
        min: 12,
        max: 48,
      ),
      PreviewControl(
        key: 'color',
        label: 'Color',
        type: ControlType.color,
        defaultValue: Colors.blue,
        options: [Colors.blue, Colors.black, Colors.red],
        optionLabels: {
          Colors.blue: 'Blue',
          Colors.black: 'Black',
          Colors.red: 'Red',
        },
      ),
      PreviewControl(
        key: 'bold',
        label: 'Bold',
        type: ControlType.boolean,
        defaultValue: false,
      ),
    ],
    builder: (context, args) => Text(
      args['text'],
      style: TextStyle(
        fontSize: args['fontSize'],
        color: args['color'],
        fontWeight: args['bold'] ? FontWeight.bold : FontWeight.normal,
      ),
    ),
    codeBuilder: (args) =>
        '''
Text(
  "${args['text']}",
  style: TextStyle(
    fontSize: ${args['fontSize'].toStringAsFixed(1)},
    color: ${_colorName(args['color'])},
    fontWeight: ${args['bold'] ? 'FontWeight.bold' : 'FontWeight.normal'},
  ),
)''',
  ),
  'Row': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'mainAxis',
        label: 'Main Axis',
        type: ControlType.enumeration,
        defaultValue: MainAxisAlignment.start,
        options: MainAxisAlignment.values,
        optionLabels: {
          for (var v in MainAxisAlignment.values)
            v: 'MainAxisAlignment.${_enumName(v)}',
        },
      ),
      PreviewControl(
        key: 'crossAxis',
        label: 'Cross Axis',
        type: ControlType.enumeration,
        defaultValue: CrossAxisAlignment.center,
        options: CrossAxisAlignment.values,
        optionLabels: {
          for (var v in CrossAxisAlignment.values)
            v: 'CrossAxisAlignment.${_enumName(v)}',
        },
      ),
    ],
    builder: (context, args) => Container(
      color: Colors.grey[200],
      height: 100,
      child: Row(
        mainAxisAlignment: args['mainAxis'],
        crossAxisAlignment: args['crossAxis'],
        children: const [
          Icon(Icons.star, size: 20, color: Colors.red),
          Icon(Icons.star, size: 40, color: Colors.green),
          Icon(Icons.star, size: 30, color: Colors.blue),
        ],
      ),
    ),
    codeBuilder: (args) =>
        '''
Row(
  mainAxisAlignment: MainAxisAlignment.${_enumName(args['mainAxis'])},
  crossAxisAlignment: CrossAxisAlignment.${_enumName(args['crossAxis'])},
  children: const [
    Icon(Icons.star, size: 20, color: Colors.red),
    Icon(Icons.star, size: 40, color: Colors.green),
    Icon(Icons.star, size: 30, color: Colors.blue),
  ],
)''',
  ),
  'Column': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'mainAxis',
        label: 'Main Axis',
        type: ControlType.enumeration,
        defaultValue: MainAxisAlignment.start,
        options: MainAxisAlignment.values,
        optionLabels: {
          for (var v in MainAxisAlignment.values)
            v: 'MainAxisAlignment.${_enumName(v)}',
        },
      ),
      PreviewControl(
        key: 'crossAxis',
        label: 'Cross Axis',
        type: ControlType.enumeration,
        defaultValue: CrossAxisAlignment.center,
        options: CrossAxisAlignment.values,
        optionLabels: {
          for (var v in CrossAxisAlignment.values)
            v: 'CrossAxisAlignment.${_enumName(v)}',
        },
      ),
    ],
    builder: (context, args) => Container(
      color: Colors.grey[200],
      width: 200,
      height: 300,
      child: Column(
        mainAxisAlignment: args['mainAxis'],
        crossAxisAlignment: args['crossAxis'],
        children: const [
          Icon(Icons.star, size: 20, color: Colors.red),
          Icon(Icons.star, size: 40, color: Colors.green),
          Icon(Icons.star, size: 30, color: Colors.blue),
        ],
      ),
    ),
    codeBuilder: (args) =>
        '''
Column(
  mainAxisAlignment: MainAxisAlignment.${_enumName(args['mainAxis'])},
  crossAxisAlignment: CrossAxisAlignment.${_enumName(args['crossAxis'])},
  children: const [
    Icon(Icons.star, size: 20, color: Colors.red),
    Icon(Icons.star, size: 40, color: Colors.green),
    Icon(Icons.star, size: 30, color: Colors.blue),
  ],
)''',
  ),
  'ElevatedButton': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'label',
        label: 'Label',
        type: ControlType.string,
        defaultValue: 'Click Me',
      ),
      PreviewControl(
        key: 'enabled',
        label: 'Enabled',
        type: ControlType.boolean,
        defaultValue: true,
      ),
    ],
    builder: (context, args) => ElevatedButton(
      onPressed: args['enabled'] ? () {} : null,
      child: Text(args['label']),
    ),
    codeBuilder: (args) =>
        '''
ElevatedButton(
  onPressed: ${args['enabled'] ? '() {}' : 'null'},
  child: Text("${args['label']}"),
)''',
  ),
  'Switch': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'value',
        label: 'Value',
        type: ControlType.boolean,
        defaultValue: true,
      ),
      PreviewControl(
        key: 'activeColor',
        label: 'Active Color',
        type: ControlType.color,
        defaultValue: Colors.green,
        options: [Colors.green, Colors.red, Colors.blue],
        optionLabels: {
          Colors.green: 'Green',
          Colors.red: 'Red',
          Colors.blue: 'Blue',
        },
      ),
    ],
    builder: (context, args) => Switch(
      value: args['value'],
      activeColor: args['activeColor'],
      onChanged:
          (
            v,
          ) {}, // Demo only, value controlled by slider usually, but here we can't self-update easily inside builder without state.
      // Actually in the preview page we will bind the control to the state, so it works.
    ),
    codeBuilder: (args) =>
        '''
Switch(
  value: ${args['value']},
  activeColor: ${_colorName(args['activeColor'])},
  onChanged: (val) {},
)''',
  ),
  'Stack': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'alignment',
        label: 'Alignment',
        type: ControlType.enumeration,
        defaultValue: Alignment.center,
        options: [
          Alignment.topLeft,
          Alignment.topRight,
          Alignment.center,
          Alignment.bottomLeft,
          Alignment.bottomRight,
        ],
        optionLabels: {
          Alignment.topLeft: 'Alignment.topLeft',
          Alignment.topRight: 'Alignment.topRight',
          Alignment.center: 'Alignment.center',
          Alignment.bottomLeft: 'Alignment.bottomLeft',
          Alignment.bottomRight: 'Alignment.bottomRight',
        },
      ),
    ],
    builder: (context, args) => Container(
      width: 200,
      height: 200,
      color: Colors.grey[300],
      child: Stack(
        alignment: args['alignment'],
        children: [
          Container(width: 150, height: 150, color: Colors.red),
          Container(width: 100, height: 100, color: Colors.green),
          Container(width: 50, height: 50, color: Colors.blue),
        ],
      ),
    ),
    codeBuilder: (args) =>
        '''
Stack(
  alignment: ${args['optionLabels']?[args['alignment']] ?? args['alignment'].toString()},
  children: [
    Container(width: 150, height: 150, color: Colors.red),
    Container(width: 100, height: 100, color: Colors.green),
    Container(width: 50, height: 50, color: Colors.blue),
  ],
)''',
  ),
  'Card': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'elevation',
        label: 'Elevation',
        type: ControlType.double,
        defaultValue: 4.0,
        min: 0,
        max: 20,
      ),
      PreviewControl(
        key: 'color',
        label: 'Color',
        type: ControlType.color,
        defaultValue: Colors.white,
        options: [Colors.white, Colors.blueAccent, Colors.redAccent],
        optionLabels: {
          Colors.white: 'White',
          Colors.blueAccent: 'Blue',
          Colors.redAccent: 'Red',
        },
      ),
      PreviewControl(
        key: 'radius',
        label: 'Radius',
        type: ControlType.double,
        defaultValue: 12.0,
        min: 0,
        max: 32,
      ),
    ],
    builder: (context, args) => SizedBox(
      width: 200,
      height: 120,
      child: Card(
        elevation: args['elevation'],
        color: args['color'],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(args['radius']),
        ),
        child: const Center(child: Text("Card Widget")),
      ),
    ),
    codeBuilder: (args) =>
        '''
Card(
  elevation: ${args['elevation'].toStringAsFixed(1)},
  color: ${_colorName(args['color'])},
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(${args['radius'].toStringAsFixed(1)}),
  ),
  child: const Center(child: Text("Card Widget")),
)''',
  ),
  'Padding': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'padding',
        label: 'Padding',
        type: ControlType.double,
        defaultValue: 16.0,
        min: 0,
        max: 50,
      ),
      PreviewControl(
        key: 'color',
        label: 'Bg Color',
        type: ControlType.color,
        defaultValue: Colors.blue,
        options: [Colors.blue, Colors.green],
        optionLabels: {Colors.blue: 'Blue', Colors.green: 'Green'},
      ),
    ],
    builder: (context, args) => Container(
      color: Colors.grey[300],
      child: Padding(
        padding: EdgeInsets.all(args['padding']),
        child: Container(color: args['color'], width: 100, height: 100),
      ),
    ),
    codeBuilder: (args) =>
        '''
Padding(
  padding: EdgeInsets.all(${args['padding'].toStringAsFixed(1)}),
  child: Container(color: ${_colorName(args['color'])}, width: 100, height: 100),
)''',
  ),
  'Icon': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'size',
        label: 'Size',
        type: ControlType.double,
        defaultValue: 48.0,
        min: 24,
        max: 100,
      ),
      PreviewControl(
        key: 'color',
        label: 'Color',
        type: ControlType.color,
        defaultValue: Colors.blue,
        options: [Colors.blue, Colors.red, Colors.green, Colors.black],
        optionLabels: {
          Colors.blue: 'Blue',
          Colors.red: 'Red',
          Colors.green: 'Green',
          Colors.black: 'Black',
        },
      ),
    ],
    builder: (context, args) =>
        Icon(Icons.favorite, size: args['size'], color: args['color']),
    codeBuilder: (args) =>
        '''
Icon(
  Icons.favorite,
  size: ${args['size'].toStringAsFixed(1)},
  color: ${_colorName(args['color'])},
)''',
  ),
  'Center': WidgetPreviewData(
    controls: [],
    builder: (context, args) => Container(
      color: Colors.grey[200],
      width: 200,
      height: 200,
      child: const Center(child: Text("Centered")),
    ),
    codeBuilder: (args) => '''
Center(
  child: Text("Centered"),
)''',
  ),
  'SizedBox': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'width',
        label: 'Width',
        type: ControlType.double,
        defaultValue: 100.0,
        min: 0,
        max: 200,
      ),
      PreviewControl(
        key: 'height',
        label: 'Height',
        type: ControlType.double,
        defaultValue: 50.0,
        min: 0,
        max: 200,
      ),
    ],
    builder: (context, args) => Container(
      color: Colors.grey[300],
      child: Center(
        child: SizedBox(
          width: args['width'],
          height: args['height'],
          child: Container(color: Colors.blue),
        ),
      ),
    ),
    codeBuilder: (args) =>
        '''
SizedBox(
  width: ${args['width'].toStringAsFixed(1)},
  height: ${args['height'].toStringAsFixed(1)},
  child: Container(color: Colors.blue),
)''',
  ),
  'FloatingActionButton': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'mini',
        label: 'Mini',
        type: ControlType.boolean,
        defaultValue: false,
      ),
      PreviewControl(
        key: 'elevation',
        label: 'Elevation',
        type: ControlType.double,
        defaultValue: 6.0,
        min: 0,
        max: 20,
      ),
    ],
    builder: (context, args) => FloatingActionButton(
      onPressed: () {},
      mini: args['mini'],
      elevation: args['elevation'],
      child: const Icon(Icons.add),
    ),
    codeBuilder: (args) =>
        '''
FloatingActionButton(
  onPressed: () {},
  mini: ${args['mini']},
  elevation: ${args['elevation'].toStringAsFixed(1)},
  child: const Icon(Icons.add),
)''',
  ),
  'CircleAvatar': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'radius',
        label: 'Radius',
        type: ControlType.double,
        defaultValue: 24.0,
        min: 10,
        max: 60,
      ),
      PreviewControl(
        key: 'color',
        label: 'Background',
        type: ControlType.color,
        defaultValue: Colors.blue,
        options: [Colors.blue, Colors.red, Colors.green],
        optionLabels: {
          Colors.blue: 'Blue',
          Colors.red: 'Red',
          Colors.green: 'Green',
        },
      ),
    ],
    builder: (context, args) => CircleAvatar(
      radius: args['radius'],
      backgroundColor: args['color'],
      child: const Text("A"),
    ),
    codeBuilder: (args) =>
        '''
CircleAvatar(
  radius: ${args['radius'].toStringAsFixed(1)},
  backgroundColor: ${_colorName(args['color'])},
  child: const Text("A"),
)''',
  ),
  'AlertDialog': WidgetPreviewData(
    controls: [],
    builder: (context, args) => AlertDialog(
      icon: const Icon(Icons.warning_amber),
      iconPadding: EdgeInsets.all(10),
      title: const Text('Basic AlertDialog'),
      content: const Text('This is a standard Material Design alert dialog.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
    codeBuilder: (args) => '''AlertDialog(
  title: const Text('Basic AlertDialog'),
  content: const Text('This is a standard Material Design alert dialog.'),
  actions: [
    TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Cancel'),
    ),
    TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('OK'),
    ),
  ],
)''',
  ),
  'AppBar': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'title',
        label: 'Title',
        type: ControlType.string,
        defaultValue: 'App Bar',
      ),
      PreviewControl(
        key: 'elevation',
        label: 'Elevation',
        type: ControlType.double,
        defaultValue: 4.0,
        min: 0,
        max: 10,
      ),
    ],
    builder: (context, args) => SizedBox(
      height: kToolbarHeight,
      child: AppBar(
        title: Text(args['title']),
        elevation: args['elevation'],
        backgroundColor: Colors.blue,
      ),
    ),
    codeBuilder: (args) => '''AppBar(
  title: const Text('${args['title']}'),
  elevation: ${args['elevation']},
  backgroundColor: Colors.blue,
)''',
  ),
  'AspectRatio': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'ratio',
        label: 'Ratio',
        type: ControlType.double,
        defaultValue: 1.7,
        min: 0.5,
        max: 3.0,
      ),
    ],
    builder: (context, args) => AspectRatio(
      aspectRatio: args['ratio'],
      child: Container(color: Colors.green),
    ),
    codeBuilder: (args) => '''AspectRatio(
  aspectRatio: ${args['ratio'].toStringAsFixed(2)},
  child: Container(color: Colors.green),
)''',
  ),
  'Checkbox': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'value',
        label: 'Checked',
        type: ControlType.boolean,
        defaultValue: true,
      ),
    ],
    builder: (context, args) => Checkbox(
      value: args['value'],
      onChanged: (v) {},
    ),
    codeBuilder: (args) => '''Checkbox(
  value: ${args['value']},
  onChanged: (val) {},
)''',
  ),
  'CircularProgressIndicator': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'value',
        label: 'Value',
        type: ControlType.double,
        defaultValue: 0.7,
        min: 0.0,
        max: 1.0,
      ),
    ],
    builder: (context, args) => CircularProgressIndicator(
      value: args['value'],
    ),
    codeBuilder: (args) => '''CircularProgressIndicator(
  value: ${args['value'].toStringAsFixed(2)},
)''',
  ),
  'ClipRRect': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'radius',
        label: 'Radius',
        type: ControlType.double,
        defaultValue: 16.0,
        min: 0,
        max: 50,
      ),
    ],
    builder: (context, args) => ClipRRect(
      borderRadius: BorderRadius.circular(args['radius']),
      child: Container(width: 100, height: 100, color: Colors.orange),
    ),
    codeBuilder: (args) => '''ClipRRect(
  borderRadius: BorderRadius.circular(${args['radius']}),
  child: Container(width: 100, height: 100, color: Colors.orange),
)''',
  ),
  'Divider': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'height',
        label: 'Height',
        type: ControlType.double,
        defaultValue: 20.0,
        min: 1,
        max: 50,
      ),
      PreviewControl(
        key: 'thickness',
        label: 'Thickness',
        type: ControlType.double,
        defaultValue: 2.0,
        min: 1,
        max: 10,
      ),
    ],
    builder: (context, args) => Container(
      width: 200,
      color: Colors.grey[200],
      child: Column(
        children: [
          const Text('Above'),
          Divider(
            height: args['height'],
            thickness: args['thickness'],
            color: Colors.black,
          ),
          const Text('Below'),
        ],
      ),
    ),
    codeBuilder: (args) => '''Divider(
  height: ${args['height']},
  thickness: ${args['thickness']},
  color: Colors.black,
)''',
  ),
  'Drawer': WidgetPreviewData(
    controls: [],
    builder: (context, args) => SizedBox(
      width: 200,
      height: 400,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Header', style: TextStyle(color: Colors.white)),
            ),
            ListTile(title: Text('Item 1')),
          ],
        ),
      ),
    ),
    codeBuilder: (args) => '''Drawer(
  child: ListView(
    children: [
      DrawerHeader(child: Text('Header')),
      ListTile(title: Text('Item 1')),
    ],
  ),
)''',
  ),
  'DropdownButton': WidgetPreviewData(
    controls: [],
    builder: (context, args) => DropdownButton<String>(
      value: 'One',
      items: ['One', 'Two']
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) {},
    ),
    codeBuilder: (args) => '''DropdownButton<String>(
  value: 'One',
  items: ['One', 'Two'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
  onChanged: (v) {},
)''',
  ),
  'Expanded': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'flex',
        label: 'Flex',
        type: ControlType.integer,
        defaultValue: 1,
        min: 1,
        max: 5,
      ),
    ],
    builder: (context, args) => Row(
      children: [
        Container(width: 50, height: 50, color: Colors.red),
        Expanded(
          flex: args['flex'],
          child: Container(
            height: 50,
            color: Colors.green,
            child: Center(child: Text('Flex: ${args['flex']}')),
          ),
        ),
        Container(width: 50, height: 50, color: Colors.blue),
      ],
    ),
    codeBuilder: (args) => '''Row(
  children: [
    Container(width: 50, height: 50, color: Colors.red),
    Expanded(
      flex: ${args['flex']},
      child: Container(height: 50, color: Colors.green),
    ),
    Container(width: 50, height: 50, color: Colors.blue),
  ],
)''',
  ),
  'GestureDetector': WidgetPreviewData(
    controls: [],
    builder: (context, args) => GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.blue[100],
        child: const Text('Tap Me'),
      ),
    ),
    codeBuilder: (args) => '''GestureDetector(
  onTap: () { print('Tapped'); },
  child: Container(color: Colors.blue[100], child: Text('Tap Me')),
)''',
  ),
  'GridView': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'crossAxisCount',
        label: 'Columns',
        type: ControlType.integer,
        defaultValue: 3,
        min: 2,
        max: 5,
      ),
    ],
    builder: (context, args) => SizedBox(
      height: 200,
      width: 300,
      child: GridView.count(
        crossAxisCount: args['crossAxisCount'],
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: List.generate(
          6,
          (index) => Container(
            color: Colors.primaries[index % Colors.primaries.length],
          ),
        ),
      ),
    ),
    codeBuilder: (args) => '''GridView.count(
  crossAxisCount: ${args['crossAxisCount']},
  children: List.generate(6, (index) => Container(color: Colors.primaries[index])),
)''',
  ),
  'Hero': WidgetPreviewData(
    controls: [],
    builder: (context, args) => const Hero(
      tag: 'tag',
      child: Icon(Icons.star, size: 50, color: Colors.orange),
    ),
    codeBuilder: (args) => '''Hero(
  tag: 'tag',
  child: Icon(Icons.star, size: 50, color: Colors.orange),
)''',
  ),
  'IconButton': WidgetPreviewData(
    controls: [],
    builder: (context, args) => IconButton(
      icon: const Icon(Icons.thumb_up),
      onPressed: () {},
    ),
    codeBuilder: (args) => '''IconButton(
  icon: const Icon(Icons.thumb_up),
  onPressed: () {},
)''',
  ),
  'Image': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'width',
        label: 'Width',
        type: ControlType.double,
        defaultValue: 100.0,
        min: 50,
        max: 200,
      ),
    ],
    builder: (context, args) => Image.network(
      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      width: args['width'],
    ),
    codeBuilder: (args) => '''Image.network(
  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
  width: ${args['width']},
)''',
  ),
  'InkWell': WidgetPreviewData(
    controls: [],
    builder: (context, args) => Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(20),
          child: const Text('Tap for Ripple'),
        ),
      ),
    ),
    codeBuilder: (args) => '''InkWell(
  onTap: () {},
  child: Text('Tap for Ripple'),
)''',
  ),
  'LinearProgressIndicator': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'value',
        label: 'Value',
        type: ControlType.double,
        defaultValue: 0.5,
        min: 0.0,
        max: 1.0,
      ),
    ],
    builder: (context, args) => SizedBox(
      width: 200,
      child: LinearProgressIndicator(value: args['value']),
    ),
    codeBuilder: (args) => '''LinearProgressIndicator(
  value: ${args['value'].toStringAsFixed(2)},
)''',
  ),
  'ListTile': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'title',
        label: 'Title',
        type: ControlType.string,
        defaultValue: 'List Item',
      ),
      PreviewControl(
        key: 'subtitle',
        label: 'Subtitle',
        type: ControlType.string,
        defaultValue: 'Description',
      ),
    ],
    builder: (context, args) => SizedBox(
      width: 300,
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.person),
          title: Text(args['title']),
          subtitle: Text(args['subtitle']),
        ),
      ),
    ),
    codeBuilder: (args) => '''ListTile(
  leading: const Icon(Icons.person),
  title: Text('${args['title']}'),
  subtitle: Text('${args['subtitle']}'),
)''',
  ),
  'ListView': WidgetPreviewData(
    controls: [],
    builder: (context, args) => SizedBox(
      height: 200,
      width: 300,
      child: ListView(
        children: List.generate(
          5,
          (i) => ListTile(title: Text('Item \$i')),
        ),
      ),
    ),
    codeBuilder: (args) => '''ListView(
  children: List.generate(5, (i) => ListTile(title: Text('Item \$i'))),
)''',
  ),
  'Opacity': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'opacity',
        label: 'Opacity',
        type: ControlType.double,
        defaultValue: 0.5,
        min: 0.0,
        max: 1.0,
      ),
    ],
    builder: (context, args) => Opacity(
      opacity: args['opacity'],
      child: Container(width: 100, height: 100, color: Colors.blue),
    ),
    codeBuilder: (args) => '''Opacity(
  opacity: ${args['opacity'].toStringAsFixed(2)},
  child: Container(width: 100, height: 100, color: Colors.blue),
)''',
  ),
  'OutlinedButton': WidgetPreviewData(
    controls: [],
    builder: (context, args) => OutlinedButton(
      onPressed: () {},
      child: const Text('Outlined'),
    ),
    codeBuilder: (args) => '''OutlinedButton(
  onPressed: () {},
  child: const Text('Outlined'),
)''',
  ),
  'PageView': WidgetPreviewData(
    controls: [],
    builder: (context, args) => SizedBox(
      height: 200,
      width: 300,
      child: PageView(
        children: [
          Container(color: Colors.red),
          Container(color: Colors.green),
          Container(color: Colors.blue),
        ],
      ),
    ),
    codeBuilder: (args) => '''PageView(
  children: [
    Container(color: Colors.red),
    Container(color: Colors.green),
    Container(color: Colors.blue),
  ],
)''',
  ),
  'Positioned': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'top',
        label: 'Top',
        type: ControlType.double,
        defaultValue: 10,
        min: 0,
        max: 100,
      ),
      PreviewControl(
        key: 'left',
        label: 'Left',
        type: ControlType.double,
        defaultValue: 10,
        min: 0,
        max: 100,
      ),
    ],
    builder: (context, args) => Container(
      width: 200,
      height: 200,
      color: Colors.grey[300],
      child: Stack(
        children: [
          Positioned(
            top: args['top'],
            left: args['left'],
            child: const Icon(Icons.star, color: Colors.red),
          ),
        ],
      ),
    ),
    codeBuilder: (args) => '''Stack(
  children: [
    Positioned(
      top: ${args['top']},
      left: ${args['left']},
      child: const Icon(Icons.star, color: Colors.red),
    ),
  ],
)''',
  ),
  'Radio': WidgetPreviewData(
    controls: [],
    builder: (context, args) => Row(
      children: [
        Radio(value: 1, groupValue: 1, onChanged: (v) {}),
        const Text('Option 1'),
      ],
    ),
    codeBuilder: (args) => '''Radio(
  value: 1,
  groupValue: 1,
  onChanged: (val) {},
)''',
  ),
  'Scaffold': WidgetPreviewData(
    controls: [],
    builder: (context, args) => SizedBox(
      width: 300,
      height: 400,
      child: Scaffold(
        appBar: AppBar(title: const Text('Scaffold')),
        body: const Center(child: Text('Body')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    ),
    codeBuilder: (args) => '''Scaffold(
  appBar: AppBar(title: const Text('Scaffold')),
  body: const Center(child: Text('Body')),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: const Icon(Icons.add),
  ),
)''',
  ),
  'SingleChildScrollView': WidgetPreviewData(
    controls: [],
    builder: (context, args) => SizedBox(
      height: 150,
      width: 200,
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(20, (i) => Text('Item \$i')),
        ),
      ),
    ),
    codeBuilder: (args) => '''SingleChildScrollView(
  child: Column(
    children: List.generate(20, (i) => Text('Item \$i')),
  ),
)''',
  ),
  'Slider': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'value',
        label: 'Value',
        type: ControlType.double,
        defaultValue: 0.5,
        min: 0.0,
        max: 1.0,
      ),
    ],
    builder: (context, args) => Slider(
      value: args['value'],
      onChanged: (v) {},
    ),
    codeBuilder: (args) => '''Slider(
  value: ${args['value'].toStringAsFixed(2)},
  onChanged: (val) {},
)''',
  ),
  'SnackBar': WidgetPreviewData(
    controls: [],
    builder: (context, args) => Container(
      padding: const EdgeInsets.all(10),
      color: Colors.black87,
      child: const Text(
        'This is a SnackBar',
        style: TextStyle(color: Colors.white),
      ),
    ),
    codeBuilder: (args) => '''SnackBar(
  content: Text('This is a SnackBar'),
)''',
  ),
  'TabBar': WidgetPreviewData(
    controls: [],
    builder: (context, args) => Container(
      color: Colors.blue,
      child: const DefaultTabController(
        length: 3,
        child: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.car_rental)),
            Tab(icon: Icon(Icons.transit_enterexit)),
            Tab(icon: Icon(Icons.bike_scooter)),
          ],
        ),
      ),
    ),
    codeBuilder: (args) => '''TabBar(
  tabs: [
    Tab(icon: Icon(Icons.car_rental)),
    Tab(icon: Icon(Icons.transit_enterexit)),
    Tab(icon: Icon(Icons.bike_scooter)),
  ],
)''',
  ),
  'TextButton': WidgetPreviewData(
    controls: [],
    builder: (context, args) => TextButton(
      onPressed: () {},
      child: const Text('Text Button'),
    ),
    codeBuilder: (args) => '''TextButton(
  onPressed: () {},
  child: const Text('Text Button'),
)''',
  ),
  'TextField': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'label',
        label: 'Label',
        type: ControlType.string,
        defaultValue: 'Username',
      ),
    ],
    builder: (context, args) => TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: args['label'],
      ),
    ),
    codeBuilder: (args) => '''TextField(
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: '${args['label']}',
  ),
)''',
  ),
  'Wrap': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'spacing',
        label: 'Spacing',
        type: ControlType.double,
        defaultValue: 8.0,
        min: 0,
        max: 20,
      ),
    ],
    builder: (context, args) => Wrap(
      spacing: args['spacing'],
      children: const [
        Chip(label: Text('A')),
        Chip(label: Text('B')),
        Chip(label: Text('C')),
        Chip(label: Text('D')),
      ],
    ),
    codeBuilder: (args) => '''Wrap(
  spacing: ${args['spacing']},
  children: const [Chip(label: Text('A')), Chip(label: Text('B')), Chip(label: Text('C'))],
)''',
  ),
  'YearPicker': WidgetPreviewData(
    controls: [],
    builder: (context, args) => SizedBox(
      height: 300,
      child: YearPicker(
        firstDate: DateTime(2000),
        lastDate: DateTime(2030),
        selectedDate: DateTime.now(),
        onChanged: (d) {},
      ),
    ),
    codeBuilder: (args) => '''YearPicker(
  firstDate: DateTime(2000),
  lastDate: DateTime(2030),
  selectedDate: DateTime.now(),
  onChanged: (d) {},
)''',
  ),
  'BottomNavigationBar': WidgetPreviewData(
    controls: [
      PreviewControl(
        key: 'currentIndex',
        label: 'Current Index',
        type: ControlType.integer,
        defaultValue: 0,
        min: 0,
        max: 2,
      ),
    ],
    builder: (context, args) => BottomNavigationBar(
      currentIndex: args['currentIndex'],
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    ),
    codeBuilder: (args) => '''BottomNavigationBar(
  currentIndex: ${args['currentIndex']},
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ],
)''',
  ),
  'BottomSheet': WidgetPreviewData(
    controls: [],
    builder: (context, args) => Container(
      height: 200,
      color: Colors.white,
      child: const Center(child: Text('Bottom Sheet Content')),
    ),
    codeBuilder: (args) => '''Container(
  height: 200,
  color: Colors.white,
  child: const Center(child: Text('Bottom Sheet Content')),
)''',
  ),
};

String _colorName(Color color) {
  if (color == Colors.blue) return 'Colors.blue';
  if (color == Colors.red) return 'Colors.red';
  if (color == Colors.green) return 'Colors.green';
  if (color == Colors.amber) return 'Colors.amber';
  if (color == Colors.black) return 'Colors.black';
  return 'Colors.custom';
}
