import 'package:flutter/widgets.dart';

// Responsive breakpoints and helpers
const double kBreakpointMobile = 600; // < 600 = mobile
const double kBreakpointDesktop = 900; // >=900 = desktop
const double kBreakpointLarge = 1000; // larger desktop
const double kBreakpointWide = 1400; // extra-wide screens

bool isMobileWidth(double w) => w < kBreakpointMobile;
bool isDesktopWidth(double w) => w >= kBreakpointDesktop && w < kBreakpointWide;
bool isWideWidth(double w) => w >= kBreakpointWide;

bool isAtLeastDesktopWidth(double w) => w >= kBreakpointDesktop;

// Context helpers
bool isMobile(BuildContext context) =>
    isMobileWidth(MediaQuery.of(context).size.width);
bool isDesktop(BuildContext context) =>
    isDesktopWidth(MediaQuery.of(context).size.width);
bool isWide(BuildContext context) =>
    isWideWidth(MediaQuery.of(context).size.width);

bool isAtLeastDesktop(BuildContext context) =>
    isAtLeastDesktopWidth(MediaQuery.of(context).size.width);
