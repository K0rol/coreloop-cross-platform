import 'package:clcrossplatform/util/utils.dart';
import 'package:clcrossplatform/util/widget_previews.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

class WidgetDetailPage extends StatefulWidget {
  final String title;

  const WidgetDetailPage({super.key, required this.title});

  @override
  State<WidgetDetailPage> createState() => _WidgetDetailPageState();
}

class _WidgetDetailPageState extends State<WidgetDetailPage>
    with SingleTickerProviderStateMixin {
  final List<String> _alphabet = List.generate(
    26,
    (i) => String.fromCharCode(65 + i),
  );

  Map<String, List<Map<String, dynamic>>> _components = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    try {
      final String yamlString = await rootBundle.loadString(
        'assets/data/widgets.yaml',
      );
      final YamlMap yamlData = loadYaml(yamlString);

      final Map<String, List<Map<String, dynamic>>> loadedComponents = {};

      for (final key in yamlData.keys) {
        final value = yamlData[key];
        if (value is YamlList) {
          loadedComponents[key.toString()] = value.map((item) {
            final mapItem = Map<String, dynamic>.from(item as YamlMap);
            return mapItem;
          }).toList();
        }
      }

      setState(() {
        _components = loadedComponents;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading YAML: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return DefaultTabController(
      length: _alphabet.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("CoreLoop 组件库", style: TextStyle(fontSize: 18)),
          backgroundColor: const Color(0xFF0F172A),
          elevation: 0,
          // A-Z 字母 TabBar
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                indicatorColor: Colors.blueAccent,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.blueAccent,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 16),
                tabs: _alphabet.map((char) => Tab(text: char)).toList(),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: _alphabet.map((char) => _buildComponentList(char)).toList(),
        ),
      ),
    );
  }

  // 构建对应字母的组件列表
  Widget _buildComponentList(String char) {
    final list = _components[char] ?? [];
    if (list.isEmpty) {
      return const Center(
        child: Text("暂无该首字母组件", style: TextStyle(color: Colors.grey)),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Desktop / Wide Web Layout
        if (constraints.maxWidth > 900) {
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.6, // Adjust card aspect ratio for desktop
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return _itemWidget(item, isGrid: true);
            },
          );
        }

        // Mobile / Tablet Layout
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
            return _itemWidget(item);
          },
        );
      },
    );
  }

  Widget _itemWidget(Map<String, dynamic> item, {bool isGrid = false}) {
    return Card(
      color: Colors.white.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: isGrid ? EdgeInsets.zero : const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isGrid
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['name']! as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.play_circle_outline,
                              color: Colors.greenAccent,
                            ),
                            onPressed: () => _showLivePreview(
                                context, item['name']! as String),
                            tooltip: "演示",
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(
                              Icons.code,
                              color: Colors.orangeAccent,
                            ),
                            onPressed: () => _showCode(context, item),
                            tooltip: "查看代码",
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Text(
                      "${item['desc']}",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.white70),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Props: ${item['props']}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 左侧信息区
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name']! as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "用途: ${item['desc']}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "核心属性: ${item['props']}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 右侧操作区
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.play_circle_outline,
                          color: Colors.greenAccent,
                        ),
                        onPressed: () =>
                            _showLivePreview(context, item['name']! as String),
                        tooltip: "演示",
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.code,
                          color: Colors.orangeAccent,
                        ),
                        onPressed: () => _showCode(context, item),
                        tooltip: "查看代码",
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  void _showCode(BuildContext context, Map<String, dynamic> item) {
    String codeContent = '';
    if (item['code'] is List) {
      codeContent = (item['code'] as List).join('\n');
    } else if (item['code'] is String) {
      codeContent = item['code'] as String;
    }
    Utils().showCodeViewer(context, item['name']! as String, codeContent);
  }

  // 弹出交互预览窗 (Interactive Preview)
  void _showLivePreview(BuildContext context, String name) {
    final previewData = widgetPreviews[name];
    print("AnimatedContainer==>$previewData");
    final Map<String, dynamic> args = {};

    if (previewData != null) {
      for (var control in previewData.controls) {
        args[control.key] = control.defaultValue;
      }
    }

    // Special handling for AlertDialog
    if (name == 'AlertDialog' && previewData != null) {
      showDialog(
        context: context,
        builder: (context) => previewData.builder(context, args),
      );
      return;
    }

    // Web / Desktop: Use Dialog
    if (MediaQuery.of(context).size.width > 800) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: SizedBox(
              width: 900,
              height: 700,
              child: _buildPreviewContent(context, name, previewData, args, isDialog: true),
            ),
          );
        },
      );
      return;
    }

    // Mobile: Use BottomSheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: _buildPreviewContent(context, name, previewData, args, isDialog: false),
        );
      },
    );
  }

  Widget _buildPreviewContent(
    BuildContext context,
    String name,
    WidgetPreviewData? previewData,
    Map<String, dynamic> args,
    {required bool isDialog}
  ) {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: isDialog ? null : MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      "$name 实时演示",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const Divider(height: 32, color: Colors.white10),

              if (previewData == null)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.construction,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "该组件暂不支持交互演示\n(Coming Soon)",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                // Preview Area
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        child: previewData.builder(context, args),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Controls and Code Area (Row for Desktop, Column for Mobile)
                Expanded(
                  flex: 5,
                  child: isDialog
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Controls
                            Expanded(
                              flex: 3,
                              child: _buildControlsPanel(previewData, args, setModalState),
                            ),
                            const SizedBox(width: 16),
                            // Code
                            Expanded(
                              flex: 2,
                              child: _buildCodePanel(previewData, args),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildControlsPanel(previewData, args, setModalState),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              flex: 2,
                              child: _buildCodePanel(previewData, args),
                            ),
                          ],
                        ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildControlsPanel(
    WidgetPreviewData previewData,
    Map<String, dynamic> args,
    StateSetter setModalState,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView(
        children: [
          const Text(
            "属性控制",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          ...previewData.controls.map(
            (control) => _buildControl(control, args, setModalState),
          ),
        ],
      ),
    );
  }

  Widget _buildCodePanel(
    WidgetPreviewData previewData,
    Map<String, dynamic> args,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Text(
          previewData.codeBuilder(args),
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: Colors.greenAccent,
          ),
        ),
      ),
    );
  }

  Widget _buildControl(
    PreviewControl control,
    Map<String, dynamic> args,
    StateSetter setState,
  ) {
    switch (control.type) {
      case ControlType.double:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  control.label,
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  args[control.key].toStringAsFixed(1),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Slider(
              value: (args[control.key] as double).clamp(
                control.min ?? 0.0,
                control.max ?? 100.0,
              ),
              min: control.min ?? 0.0,
              max: control.max ?? 100.0,
              onChanged: (val) => setState(() => args[control.key] = val),
            ),
          ],
        );
      case ControlType.boolean:
        return SwitchListTile(
          title: Text(
            control.label,
            style: const TextStyle(color: Colors.white70),
          ),
          value: args[control.key] as bool,
          onChanged: (val) => setState(() => args[control.key] = val),
          contentPadding: EdgeInsets.zero,
        );
      case ControlType.enumeration:
      case ControlType.color:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                control.label,
                style: const TextStyle(color: Colors.white70),
              ),
              DropdownButton<dynamic>(
                value: args[control.key],
                dropdownColor: const Color(0xFF1E293B),
                style: const TextStyle(color: Colors.white),
                underline: Container(height: 1, color: Colors.blueAccent),
                items:
                    (control.options ?? []).map((opt) {
                      return DropdownMenuItem(
                        value: opt,
                        child: Text(
                          control.optionLabels?[opt] ??
                              opt.toString().split('.').last,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => args[control.key] = val);
                },
              ),
            ],
          ),
        );
      case ControlType.string:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: control.label,
              labelStyle: const TextStyle(color: Colors.white70),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              isDense: true,
            ),
            style: const TextStyle(color: Colors.white),
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: args[control.key] as String,
                selection: TextSelection.collapsed(
                  offset: (args[control.key] as String).length,
                ),
              ),
            ),
            onSubmitted: (val) => setState(() => args[control.key] = val),
          ),
        );
      default:
        return const SizedBox();
    }
  }
}
