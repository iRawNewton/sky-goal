import 'package:flutter/material.dart';

enum CategoryType { foodDining, shopping, entertainment, billsUtilities, transportation, healthMedical, travel, others }

CategoryType getCategoryType(String category) {
  switch (category) {
    case 'Food & Dining':
      return CategoryType.foodDining;
    case 'Shopping':
      return CategoryType.shopping;
    case 'Entertainment':
      return CategoryType.entertainment;
    case 'Bills & Utilities':
      return CategoryType.billsUtilities;
    case 'Transportation':
      return CategoryType.transportation;
    case 'Health & Medical':
      return CategoryType.healthMedical;
    case 'Travel':
      return CategoryType.travel;
    default:
      return CategoryType.others;
  }
}

Map<CategoryType, IconData> categoryIcons = {
  CategoryType.foodDining: Icons.restaurant,
  CategoryType.shopping: Icons.shopping_cart,
  CategoryType.entertainment: Icons.movie,
  CategoryType.billsUtilities: Icons.receipt_long,
  CategoryType.transportation: Icons.directions_car,
  CategoryType.healthMedical: Icons.local_hospital,
  CategoryType.travel: Icons.flight,
  CategoryType.others: Icons.category,
};

Map<CategoryType, Color> categoryColors = {
  CategoryType.foodDining: Color(0xFFEF4444),
  CategoryType.shopping: Color(0xFFFFB020),
  CategoryType.entertainment: Color(0xFF6366F1),
  CategoryType.billsUtilities: Color(0xFF8B5CF6),
  CategoryType.transportation: Color(0xFF10B981),
  CategoryType.healthMedical: Color(0xFF10B981),
  CategoryType.travel: Color(0xFF6366F1),
  CategoryType.others: Color(0xFF6366F1),
};
