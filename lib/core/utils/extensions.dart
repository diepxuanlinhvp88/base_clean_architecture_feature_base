import 'dart:math';

import 'package:flutter/material.dart';

/// String extensions
extension StringExtensions on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalize each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Check if string is email
  bool get isEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is phone number
  bool get isPhoneNumber {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    return phoneRegex.hasMatch(this);
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Check if string is numeric
  bool get isNumeric => double.tryParse(this) != null;

  /// Convert to int safely
  int? get toIntOrNull => int.tryParse(this);

  /// Convert to double safely
  double? get toDoubleOrNull => double.tryParse(this);

  /// Check if string is empty or null
  bool get isNullOrEmpty => isEmpty;

  /// Check if string is not empty and not null
  bool get isNotNullOrEmpty => isNotEmpty;
}

/// DateTime extensions
extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && 
           month == yesterday.month && 
           day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && 
           month == tomorrow.month && 
           day == tomorrow.day;
  }

  /// Format as 'dd/MM/yyyy'
  String get formatDate {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  /// Format as 'HH:mm'
  String get formatTime {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Format as 'dd/MM/yyyy HH:mm'
  String get formatDateTime {
    return '$formatDate $formatTime';
  }

  /// Get time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

/// BuildContext extensions
extension BuildContextExtensions on BuildContext {
  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Get theme
  ThemeData get theme => Theme.of(this);

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Check if device is mobile
  bool get isMobile => screenWidth < 768;

  /// Check if device is tablet
  bool get isTablet => screenWidth >= 768 && screenWidth < 1024;

  /// Check if device is desktop
  bool get isDesktop => screenWidth >= 1024;

  /// Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
      ),
    );
  }

  /// Hide keyboard
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
}

/// List extensions
extension ListExtensions<T> on List<T> {
  /// Get element at index safely
  T? elementAtOrNull(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }

  /// Check if list is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Check if list is not null and not empty
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Get first element safely
  T? get firstOrNull => isNotEmpty ? first : null;

  /// Get last element safely
  T? get lastOrNull => isNotEmpty ? last : null;
}

/// Map extensions
extension MapExtensions<K, V> on Map<K, V> {
  /// Get value safely
  V? getOrNull(K key) => containsKey(key) ? this[key] : null;

  /// Check if map is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Check if map is not null and not empty
  bool get isNotNullOrEmpty => isNotEmpty;
}

/// Double extensions
extension DoubleExtensions on double {
  /// Round to specific decimal places
  double roundToDecimalPlaces(int decimalPlaces) {
    final factor = pow(10, decimalPlaces).toDouble();
    return (this * factor).round() / factor;
  }

  /// Convert to currency format
  String get toCurrency => '\$${toStringAsFixed(2)}';
}

/// Int extensions
extension IntExtensions on int {
  /// Convert to currency format
  String get toCurrency => '\$${toStringAsFixed(2)}';

  /// Convert to ordinal (1st, 2nd, 3rd, etc.)
  String get toOrdinal {
    if (this >= 11 && this <= 13) {
      return '${this}th';
    }
    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }
}
