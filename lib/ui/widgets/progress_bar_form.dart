import 'package:flutter/material.dart';

@immutable
class StepItem {
  final IconData icon;
  final String label;
  const StepItem({required this.icon, required this.label});
}

class StepProgressBar extends StatelessWidget {
  final List<StepItem> steps;
  final int currentIndex;

  // Estilos
  final Color activeColor;
  final Color inactiveColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final TextStyle? labelTextStyle;

  // Layout
  final double circleDiameter;
  final double trackHeight;
  final EdgeInsetsGeometry padding;

  // Animación
  final Duration animationDuration;

  const StepProgressBar({
    super.key,
    required this.steps,
    required this.currentIndex,
    this.activeColor = const Color(0xFF8B1E04),
    this.inactiveColor = const Color.fromRGBO(28, 27, 31, 0.55),
    this.activeTextColor = Colors.black,
    this.inactiveTextColor = const Color.fromRGBO(0, 0, 0, 0.55),
    this.labelTextStyle,
    this.circleDiameter = 44.0,
    this.trackHeight = 4.0,
    this.padding = EdgeInsets.zero,
    this.animationDuration = const Duration(milliseconds: 250),
  });

  int _clampedIndex() {
    if (steps.isEmpty) return 0;
    return currentIndex.clamp(0, steps.length - 1);
  }

  double _progress() {
    if (steps.length <= 1) return 1.0;
    return _clampedIndex() / (steps.length - 1);
  }

  (_Colors, TextStyle) _derivedStylesFor(int index) {
    final isActive = index == _clampedIndex();
    final isCompleted = index < _clampedIndex();

    final circleFill = (isActive || isCompleted) ? activeColor : Colors.white;
    final circleBorder = (isActive || isCompleted) ? activeColor : inactiveColor;
    final iconColor = isActive ? Colors.white : inactiveTextColor;
    final labelColor = isActive ? activeTextColor : inactiveTextColor;

    final textStyle = (labelTextStyle ??
            const TextStyle(fontSize: 10, fontWeight: FontWeight.w500))
        .copyWith(color: labelColor);

    return (_Colors(circleFill, circleBorder, iconColor), textStyle);
  }

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) return const SizedBox.shrink();

    final progress = _progress();
    // Altura suficiente para círculos + separación + etiqueta
    final labelFs = (labelTextStyle?.fontSize ?? 12.0);
    final totalHeight = circleDiameter + 6 + labelFs * 1.3;

    return Padding(
      padding: padding,
      child: SizedBox(
        height: totalHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            // Longitud útil de la pista de centro a centro
            final usableTrackWidth = (width - circleDiameter).clamp(0.0, double.infinity);
            final activeWidth = usableTrackWidth * progress;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Línea inactiva (al fondo), alineada al centro de los círculos
                Positioned(
                  left: circleDiameter / 2,
                  right: circleDiameter / 2,
                  top: circleDiameter / 2 - trackHeight / 2,
                  child: Container(height: trackHeight, color: inactiveColor),
                ),

                // Línea activa animada, creciendo de izquierda a derecha
                Positioned(
                  left: circleDiameter / 2,
                  top: circleDiameter / 2 - trackHeight / 2,
                  child: AnimatedContainer(
                    duration: animationDuration,
                    height: trackHeight,
                    width: activeWidth,
                    color: activeColor,
                  ),
                ),

                // Círculos (encima de la pista) + etiquetas (debajo de los círculos)
                Positioned.fill(
                  child: Row(
                    children: List.generate(steps.length, (i) {
                      final item = steps[i];
                      final (colors, textStyle) = _derivedStylesFor(i);

                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // CÍRCULO: su centro queda exactamente sobre la pista
                            AnimatedContainer(
                              duration: animationDuration,
                              width: circleDiameter,
                              height: circleDiameter,
                              decoration: BoxDecoration(
                                color: colors.circleFill,
                                shape: BoxShape.circle,
                                border: Border.all(color: colors.circleBorder, width: 2),
                                boxShadow: i == _clampedIndex()
                                    ? [
                                        BoxShadow(
                                          color: activeColor.withOpacity(0.25),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Icon(
                                item.icon,
                                size: circleDiameter * 0.5,
                                color: colors.iconColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Flexible (
                              child: Text(
                                item.label,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textStyle,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Colors {
  final Color circleFill;
  final Color circleBorder;
  final Color iconColor;
  const _Colors(this.circleFill, this.circleBorder, this.iconColor);
}
