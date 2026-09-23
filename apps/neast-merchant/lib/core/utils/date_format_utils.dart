import 'package:intl/intl.dart';

/// 日期格式化工具类
class DateFormatUtils {
  /// 将日期字符串转换为 "At 3:30 pm on March 15th, 2025" 格式
  /// 
  /// 输入格式: "2024-01-01 12:00:00" 或 "2024-01-01T12:00:00"
  /// 输出格式: "At 3:30 pm on March 15th, 2025"
  static String formatToReadableDateTime(String dateTimeStr) {
    try {
      // 解析日期字符串
      DateTime dateTime = DateTime.parse(dateTimeStr);
      
      // 格式化时间部分 (3:30 pm)
      String hour = dateTime.hour > 12 ? (dateTime.hour - 12).toString() : dateTime.hour.toString();
      if (dateTime.hour == 0) hour = '12';
      String minute = dateTime.minute.toString().padLeft(2, '0');
      String period = dateTime.hour >= 12 ? 'pm' : 'am';
      String time = '$hour:$minute $period';
      
      // 格式化日期部分 (March 15th, 2025)
      String month = DateFormat('MMMM').format(dateTime); // March
      String day = _getDayWithSuffix(dateTime.day); // 15th
      String year = dateTime.year.toString(); // 2025
      
      return 'At $time on $month $day, $year';
    } catch (e) {
      // 如果解析失败，返回原字符串
      return dateTimeStr;
    }
  }
  
  /// 获取带序数后缀的日期 (1st, 2nd, 3rd, 4th, etc.)
  static String _getDayWithSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }
  
  /// 将日期字符串转换为相对时间 (1 hour ago, 2 days ago, etc.)
  static String formatToRelativeTime(String dateTimeStr) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeStr);
      DateTime now = DateTime.now();
      Duration difference = now.difference(dateTime);
      
      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        int minutes = difference.inMinutes;
        return '$minutes ${minutes == 1 ? "minute" : "minutes"} ago';
      } else if (difference.inHours < 24) {
        int hours = difference.inHours;
        return '$hours ${hours == 1 ? "hour" : "hours"} ago';
      } else if (difference.inDays < 7) {
        int days = difference.inDays;
        return '$days ${days == 1 ? "day" : "days"} ago';
      } else if (difference.inDays < 30) {
        int weeks = (difference.inDays / 7).floor();
        return '$weeks ${weeks == 1 ? "week" : "weeks"} ago';
      } else if (difference.inDays < 365) {
        int months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? "month" : "months"} ago';
      } else {
        int years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? "year" : "years"} ago';
      }
    } catch (e) {
      return dateTimeStr;
    }
  }
  
  /// 简单的日期格式化 (Jan 1, 2025)
  static String formatToSimpleDate(String dateTimeStr) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('MMM d, yyyy').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }
}

