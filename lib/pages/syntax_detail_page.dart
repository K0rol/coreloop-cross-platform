import 'package:clcrossplatform/data/syntax_data.dart';
import 'package:clcrossplatform/widgets/syntax_highlight_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SyntaxDetailPage extends StatefulWidget {
  final String title;

  const SyntaxDetailPage({super.key, required this.title});

  @override
  State<SyntaxDetailPage> createState() => _SyntaxDetailPageState();
}

class _SyntaxDetailPageState extends State<SyntaxDetailPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dart 语法详解", style: TextStyle(fontSize: 18)),
          backgroundColor: const Color(0xFF0F172A),
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Colors.blueAccent,
            indicatorWeight: 3,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: [
              Tab(text: "基础语法"),
              Tab(text: "进阶语法"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSyntaxList(isBasic: true),
            _buildSyntaxList(isBasic: false),
          ],
        ),
      ),
    );
  }

  Widget _buildSyntaxList({required bool isBasic}) {
    final list = syntaxData.where((item) => item.isBasic == isBasic).toList();

    if (list.isEmpty) {
      return const Center(
        child: Text("暂无数据", style: TextStyle(color: Colors.grey)),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Desktop / Wide Web Layout
        if (constraints.maxWidth > 900) {
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 500,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 2.0,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return _itemWidget(list[index], isGrid: true);
            },
          );
        }

        // Mobile / Tablet Layout
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _itemWidget(list[index]);
          },
        );
      },
    );
  }

  Widget _itemWidget(SyntaxItem item, {bool isGrid = false}) {
    return Card(
      color: Colors.white.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: isGrid ? EdgeInsets.zero : const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showDetail(context, item),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white24,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.description,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, SyntaxItem item) {
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
              child: _buildDetailContent(context, item, isDialog: true),
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
          height: MediaQuery.of(context).size.height * 0.9,
          child: _buildDetailContent(context, item, isDialog: false),
        );
      },
    );
  }

  Widget _buildDetailContent(
    BuildContext context,
    SyntaxItem item, {
    required bool isDialog,
  }) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
        const Divider(height: 1, color: Colors.white10),

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("详细解释"),
                const SizedBox(height: 8),
                Text(
                  item.detailedExplanation,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle("代码演示"),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Stack(
                    children: [
                      SyntaxHighlightWidget(item.codeExample),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.copy_rounded,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: item.codeExample),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("代码已复制到剪贴板"),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle("使用场景"),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blueAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.usageScenario,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.greenAccent,
      ),
    );
  }
}
