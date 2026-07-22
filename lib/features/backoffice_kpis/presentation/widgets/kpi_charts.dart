import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

class RevenueBarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;

  const RevenueBarChart({
    super.key,
    required this.values,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: CustomPaint(
        size: Size.infinite,
        painter: _BarChartPainter(
          values: values,
          labels: labels,
          barColor: AppColors.champagneGold,
        ),
      ),
    );
  }
}

class OccupancyBarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;

  const OccupancyBarChart({
    super.key,
    required this.values,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: CustomPaint(
        size: Size.infinite,
        painter: _BarChartPainter(
          values: values,
          labels: labels,
          barColor: const Color(0xFF1D4ED8), // Deep Blue from web
        ),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color barColor;

  _BarChartPainter({
    required this.values,
    required this.labels,
    required this.barColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final double maxVal = values.reduce((curr, next) => curr > next ? curr : next);
    if (maxVal == 0) return;

    final double width = size.width;
    final double height = size.height - 24.0; // Space for labels at bottom

    final double pad = 12.0;
    final int count = values.length;
    final double barW = (width - pad * (count + 1)) / count;

    final Paint paint = Paint()
      ..color = barColor.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 1.0;

    // Draw baseline
    canvas.drawLine(Offset(0, height), Offset(width, height), linePaint);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < count; i++) {
      final double val = values[i];
      final double barH = (val / maxVal) * height;
      final double x = pad + i * (barW + pad);
      final double y = height - barH;

      // Draw bar rectangle
      final Rect rect = Rect.fromLTWH(x, y, barW, barH);
      final RRect rrect = RRect.fromRectAndCorners(
        rect,
        topLeft: const Radius.circular(3),
        topRight: const Radius.circular(3),
      );
      canvas.drawRRect(rrect, paint);

      // Draw label below bar
      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(
          fontSize: 10.5,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout(minWidth: barW, maxWidth: barW);
      textPainter.paint(canvas, Offset(x, height + 6.0));

      // Draw short value text on top of the bar
      String valStr = val.toStringAsFixed(0);
      if (val >= 1000000) {
        valStr = '${(val / 1000000).toStringAsFixed(1)}M';
      } else if (val >= 1000) {
        valStr = '${(val / 1000).toStringAsFixed(0)}K';
      } else if (barColor != AppColors.champagneGold) {
        valStr = '${val.toStringAsFixed(0)}%'; // Occupancy percentage
      }
      
      textPainter.text = TextSpan(
        text: valStr,
        style: TextStyle(
          fontSize: 8.5,
          color: barColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout(minWidth: barW, maxWidth: barW);
      final double valY = (barH > 20) ? (y + 4.0) : (y - 12.0);
      textPainter.paint(canvas, Offset(x, valY));
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.barColor != barColor;
  }
}
