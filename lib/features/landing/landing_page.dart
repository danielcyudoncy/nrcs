// features/landing/landing_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final isMobile = screenWidth < 600;

            // Responsive sizes
            final titleFontSize = screenWidth * 0.08; // 8% of width
            final descFontSize = screenWidth * 0.04; // 4% of width
            final buttonFontSize = isMobile
                ? screenWidth * 0.035
                : screenWidth * 0.02; // Smaller on mobile
            final buttonHeight = isMobile ? 50.0 : 80.0;
            final cardWidth = isMobile ? screenWidth * 0.8 : 420.0;
            final cardHeight = isMobile
                ? screenHeight * 0.3
                : 340.0; // 30% of height on mobile
            final iconSize = cardHeight * 0.3; // 30% of card height
            final paddingHorizontal = screenWidth * 0.06; // 6% of width
            final bottomFontSize = screenWidth * 0.04;

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontal,
                    ),
                    child: isMobile
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'NRCS',
                                      style: AppTheme.headingSmall.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: titleFontSize,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'A modern control room for live news rundowns.',
                                      textAlign: TextAlign.center,
                                      style: AppTheme.headingSmall.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: titleFontSize,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.05),
                              Center(
                                child: Card(
                                  color: AppColors.backgroundCard,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    width: cardWidth,
                                    height: cardHeight,
                                    padding: EdgeInsets.all(
                                      screenWidth * 0.045,
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.timeline,
                                            size: iconSize,
                                            color: AppColors.glassWhite,
                                          ),
                                          SizedBox(height: cardHeight * 0.05),
                                          Text(
                                            'Rundown editor, real-time updates and granular permissions.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: cardHeight * 0.08,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.05),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(
                                          double.infinity,
                                          buttonHeight,
                                        ),
                                      ),
                                      onPressed: () => Get.toNamed('/login'),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Log in',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: buttonFontSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(
                                          double.infinity,
                                          buttonHeight,
                                        ),
                                      ),
                                      onPressed: () =>
                                          Get.toNamed('/create-account'),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Sign up',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: buttonFontSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'NRCS',
                                        style: AppTheme.headingSmall.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: titleFontSize,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'A modern control room for live news rundowns.',
                                        style: TextStyle(
                                          fontSize: descFontSize,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.03),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size(
                                                double.infinity,
                                                buttonHeight,
                                              ),
                                            ),
                                            onPressed: () =>
                                                Get.toNamed('/login'),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                'Log in',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: buttonFontSize,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.03),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size(
                                                double.infinity,
                                                buttonHeight,
                                              ),
                                            ),
                                            onPressed: () =>
                                                Get.toNamed('/create-account'),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                'Sign up',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: buttonFontSize,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Card(
                                    color: AppColors.backgroundCard,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Container(
                                      width: cardWidth,
                                      height: cardHeight,
                                      padding: EdgeInsets.all(
                                        screenWidth * 0.045,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.timeline,
                                            size: iconSize,
                                            color: AppColors.glassWhite,
                                          ),
                                          SizedBox(height: screenHeight * 0.02),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              'Rundown editor, real-time updates and granular permissions.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: titleFontSize,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                Container(
                  color: AppColors.glassWhite10,
                  padding: EdgeInsets.all(screenWidth * 0.045),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Built for speed • Realtime • Collaborative',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: 'raleway',
                            fontSize: bottomFontSize,
                          ),
                        ),
                      ),
                    ],
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
