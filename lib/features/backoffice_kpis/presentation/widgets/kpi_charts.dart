import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Graphique en Aires (Spline Area Chart) pour le Chiffre d'Affaires
class RevenueAreaChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;

  const RevenueAreaChart({
    super.key,
    required this.values,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 220,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: CustomPaint(
        size: Size.infinite,
        painter: _AreaChartPainter(
          values: values,
          labels: labels,
          lineColor: AppColors.gold,
          gradientStart: AppColors.gold.withValues(alpha: 0.28),
          gradientEnd: AppColors.gold.withValues(alpha: 0.0),
          isDark: isDark,
        ),
      ),
    );
  }
}

/// Graphique en Bâtons pour le Taux d'Occupation (%)
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 220,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: CustomPaint(
        size: Size.infinite,
        painter: _OccupancyBarChartPainter(
          values: values,
          labels: labels,
          barColor: isDark ? AppColors.goldLight2 : AppColors.gold,
          trackColor: isDark ? AppColors.darkBorder : AppColors.mist,
          isDark: isDark,
        ),
      ),
    );
  }
}

/// Graphique classique en bâtons de CA (Compatibilité Rétro)
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
    return RevenueAreaChart(values: values, labels: labels);
  }
}

// ── Custom Painter pour Spline Area Chart (CA) ───────────────────────────────
class _AreaChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color lineColor;
  final Color gradientStart;
  final Color gradientEnd;
  final bool isDark;

  _AreaChartPainter({
    required this.values,
    required this.labels,
    required this.lineColor,
    required this.gradientStart,
    required this.gradientEnd,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final double maxVal = values.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) return;

    final double width = size.width;
    final double height = size.height - 30.0; // Espace pour les étiquettes du bas
    final int count = values.length;
    final double stepX = width / (count > 1 ? count - 1 : 1);

    // 1. Grille de fond horizontale discrète (3 lignes)
    final Paint gridPaint = Paint()
      ..color = (isDark ? Colors.white10 : AppColors.mist)
      ..strokeWidth = 1.0;

    for (int i = 1; i <= 3; i++) {
      final yGrid = height * (i / 3);
      canvas.drawLine(Offset(0, yGrid), Offset(width, yGrid), gridPaint);
    }

    // 2. Construction des points de la courbe de Bézier
    final List<Offset> points = [];
    for (int i = 0; i < count; i++) {
      final x = i * stepX;
      final y = height - ((values[i] / maxVal) * (height - 20.0));
      points.add(Offset(x, y));
    }

    final Path path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlP1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlP2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      path.cubicTo(controlP1.dx, controlP1.dy, controlP2.dx, controlP2.dy, p1.dx, p1.dy);
    }

    // 3. Remplissage avec dégradé sous la courbe (Area Fill)
    final Path fillPath = Path.from(path);
    fillPath.lineTo(points.last.dx, height);
    fillPath.lineTo(points.first.dx, height);
    fillPath.close();

    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [gradientStart, gradientEnd],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawPath(fillPath, fillPaint);

    // 4. Ligne de contour dorée
    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, linePaint);

    // 5. Points d'ancrage et étiquettes textuelles
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final Paint dotOuterPaint = Paint()
      ..color = isDark ? AppColors.darkSurface : Colors.white
      ..style = PaintingStyle.fill;

    final Paint dotInnerPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < count; i++) {
      final pt = points[i];
      final val = values[i];

      // Point lumineux
      canvas.drawCircle(pt, 5.0, dotOuterPaint);
      canvas.drawCircle(pt, 3.5, dotInnerPaint);

      // Étiquette du mois en bas
      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          fontSize: 11,
          color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(pt.dx - textPainter.width / 2, height + 8.0));

      // Valeur formatée au-dessus du point (M / K FCFA)
      String valStr = val.toStringAsFixed(0);
      if (val >= 1000000) {
        valStr = '${(val / 1000000).toStringAsFixed(1)}M';
      } else if (val >= 1000) {
        valStr = '${(val / 1000).toStringAsFixed(0)}K';
      }

      textPainter.text = TextSpan(
        text: valStr,
        style: TextStyle(
          fontSize: 10,
          color: isDark ? AppColors.goldLight2 : AppColors.gold,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(pt.dx - textPainter.width / 2, pt.dy - 18.0));
    }
  }

  @override
  bool shouldRepaint(covariant _AreaChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.isDark != isDark;
  }
}

// ── Custom Painter pour Bar Chart (Occupation %) ────────────────────────────
class _OccupancyBarChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color barColor;
  final Color trackColor;
  final bool isDark;

  _OccupancyBarChartPainter({
    required this.values,
    required this.labels,
    required this.barColor,
    required this.trackColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final double maxVal = 100.0; // Pourcentage
    final double width = size.width;
    final double height = size.height - 30.0;
    final int count = values.length;
    final double pad = 16.0;
    final double barW = (width - pad * (count + 1)) / count;

    final Paint barPaint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    final Paint trackPaint = Paint()
      ..color = trackColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < count; i++) {
      final double val = values[i].clamp(0.0, 100.0);
      final double x = pad + i * (barW + pad);

      // Bar d'arrière-plan (Track)
      final Rect trackRect = Rect.fromLTWH(x, 0, barW, height);
      canvas.drawRRect(RRect.fromRectAndRadius(trackRect, const Radius.circular(6)), trackPaint);

      // Bar de remplissage effectif
      final double barH = (val / maxVal) * height;
      final double y = height - barH;
      final Rect barRect = Rect.fromLTWH(x, y, barW, barH);
      canvas.drawRRect(RRect.fromRectAndRadius(barRect, const Radius.circular(6)), barPaint);

      // Libellé en bas
      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          fontSize: 11,
          color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout(minWidth: barW, maxWidth: barW);
      textPainter.paint(canvas, Offset(x, height + 8.0));

      // Valeur en % au-dessus de la barre
      textPainter.text = TextSpan(
        text: '${val.toStringAsFixed(0)}%',
        style: TextStyle(
          fontSize: 10,
          color: isDark ? AppColors.white : AppColors.ink,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout(minWidth: barW, maxWidth: barW);
      final double valY = (barH > 24) ? (y + 4.0) : (y - 16.0);
      textPainter.paint(canvas, Offset(x, valY));
    }
  }

  @override
  bool shouldRepaint(covariant _OccupancyBarChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.isDark != isDark;
  }
}
