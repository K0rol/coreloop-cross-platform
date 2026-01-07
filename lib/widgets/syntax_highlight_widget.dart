import 'package:flutter/material.dart';

// 模拟语法高亮的简单组件
class SyntaxHighlightWidget extends StatelessWidget {
  final String code;
  const SyntaxHighlightWidget(this.code, {super.key});

  @override
  Widget build(BuildContext context) {
    // 这里简单模拟高亮逻辑，实际可使用 flutter_highlight 插件
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontFamily: 'monospace', fontSize: 14, height: 1.5, color: Colors.white70),
        children: _highlightDartCode(code),
      ),
    );
  }

  List<TextSpan> _highlightDartCode(String code) {
    // 简易高亮匹配（模拟）
    final List<TextSpan> spans = [];
    final keywords = ['Container', 'return', 'Widget', 'build', 'const', 'new'];
    
    code.split(' ').forEach((word) {
      if (keywords.contains(word.trim())) {
        spans.add(TextSpan(text: '$word ', style: const TextStyle(color: Color(0xFFF472B6)))); // 粉色关键字
      } else if (word.contains('(')) {
        spans.add(TextSpan(text: '$word ', style: const TextStyle(color: Color(0xFF60A5FA)))); // 蓝色函数
      } else {
        spans.add(TextSpan(text: '$word '));
      }
    });
    return spans;
  }
}

// 在 _ComponentLibraryPageState 中添加此方法
