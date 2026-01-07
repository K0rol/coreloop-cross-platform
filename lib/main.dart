import 'package:flutter/material.dart';
import 'dart:ui';

import 'pages/syntax_detail_page.dart';
import 'pages/widget_detail_page.dart';

void main() => runApp(const CoreLoopApp());

class CoreLoopApp extends StatelessWidget {
  const CoreLoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A), // 深邃蓝黑底色
        primaryColor: const Color(0xFF38BDF8),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: CustomScrollView(
            slivers: [
              // 1. 顶部高级感 AppBar
              SliverAppBar(
                expandedHeight: 120,
                floating: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  title: Row(
                    children: [
                      const Text(
                        "CoreLoop",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Spacer(),
                      _buildStatusBadge(),
                    ],
                  ),
                ),
              ),

              // 2. 搜索框
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 12),
                        Text("搜索组件或语法...", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. 核心卡片组
              SliverPadding(
                padding: const EdgeInsets.all(24.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildListDelegate([
                    _buildMainCard(
                      title: "组件库",
                      subtitle: "Widgets Library",
                      icon: Icons.widgets_outlined,
                      color: Colors.blueAccent,
                      onTap: () => _navigateToDetail(context, "Widgets"),
                    ),
                    _buildMainCard(
                      title: "语法进阶",
                      subtitle: "Dart Syntax",
                      icon: Icons.code_rounded,
                      color: Colors.purpleAccent,
                      onTap: () => _navigateToSyntaxDetail(context, "Syntax"),
                    ),
                    _buildMainCard(
                      title: "动效实验",
                      subtitle: "Animation Lab",
                      icon: Icons.auto_awesome_motion,
                      color: Colors.orangeAccent,
                      onTap: () {},
                    ),
                    _buildMainCard(
                      title: "实战模板",
                      subtitle: "Templates",
                      icon: Icons.dashboard_customize_outlined,
                      color: Colors.tealAccent,
                      onTap: () {},
                    ),
                  ]),
                ),
              ),

              // 4. 最近学习/更新
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    "最近更新",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              _buildRecentList(),
            ],
          ),
        ),
      ),
    );
  }

  // 构建状态徽章 (类似 Loop 进度)
  static Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 2),
      ),
      child: const Icon(Icons.bolt, size: 16, color: Colors.blueAccent),
    );
  }

  // 构建主入口卡片
  Widget _buildMainCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
              ),
              border: Border.all(color: color.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 32),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 底部最近列表
  Widget _buildRecentList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            tileColor: Colors.white.withOpacity(0.03),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            leading: const Icon(Icons.history, color: Colors.grey),
            title: Text("深入浅出 CustomPainter #$index"),
            subtitle: const Text("3小时前更新"),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
        childCount: 3,
      ),
    );
  }

  void _navigateToDetail(BuildContext context, String title) {
    // 实际项目中跳转二级页面
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WidgetDetailPage(title: title)),
    );
  }

  void _navigateToSyntaxDetail(BuildContext context, String title) {
    // 实际项目中跳转二级页面
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SyntaxDetailPage(title: title)),
    );
  }
}
