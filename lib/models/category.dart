import 'package:flutter/material.dart';

class Category {
  final String id;
  final String title;
  final Color color;
  final LinearGradient? gradient; // Yeni property
  
  const Category({
    required this.id,
    required this.title,
    required this.color,
    this.gradient, // Opsiyonel gradient
    
  });
}
