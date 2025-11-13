import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 360;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 360 &&
        MediaQuery.of(context).size.width < 600;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isSmallScreen(context)) {
      return const EdgeInsets.all(12);
    } else if (isMediumScreen(context)) {
      return const EdgeInsets.all(16);
    } else {
      return const EdgeInsets.all(20);
    }
  }

  // Responsive font sizes
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    if (isSmallScreen(context)) {
      return baseSize * 0.9;
    } else if (isMediumScreen(context)) {
      return baseSize;
    } else {
      return baseSize * 1.1;
    }
  }

  // Responsive card width
  static double getCardWidth(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    if (isSmallScreen(context)) {
      return screenWidth * 0.85;
    } else if (isMediumScreen(context)) {
      return screenWidth * 0.8;
    } else {
      return 400;
    }
  }

  // Responsive spacing
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    if (isSmallScreen(context)) {
      return baseSpacing * 0.75;
    } else if (isMediumScreen(context)) {
      return baseSpacing;
    } else {
      return baseSpacing * 1.25;
    }
  }

  // Safe text widget that prevents overflow
  static Widget safeText(
    String text, {
    TextStyle? style,
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
  }) {
    return Text(
      text,
      style: style,
      maxLines: maxLines ?? 2,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
      softWrap: true,
    );
  }

  // Flexible container that adapts to screen size
  static Widget flexibleContainer({
    required Widget child,
    required BuildContext context,
    EdgeInsets? padding,
    double? maxWidth,
  }) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: maxWidth ?? getCardWidth(context)),
      padding: padding ?? getResponsivePadding(context),
      child: child,
    );
  }
}
