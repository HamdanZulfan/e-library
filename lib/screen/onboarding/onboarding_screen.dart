import 'package:e_library/screen/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../../providers/onboarding_provider.dart';
import '../../utils/theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  //int currentIndex = 0;
  CarouselSliderController carouselController = CarouselSliderController();

  List<String> titles = [
    'Eksplorasi Buku Tanpa Batas',
    'Koleksi Buku Favorit Anda',
    'Upload & Nikmati Koleksi Anda',
  ];

  List<String> subTitles = [
    'Jelajahi berbagai buku dengan e-library kami, semuanya mudah diakses!',
    'Simpan buku favoritmu dan nikmati kapan saja hanya dengan satu klik!',
    'Unggah buku Anda dan bagikan koleksi bacaan dengan pengguna lain!',
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: provider.currentIndex == 0 ? 44 : 12,
                      height: 12,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            provider.currentIndex == 0 ? navyColor : snugYellow,
                      ),
                    ),
                    Container(
                      width: provider.currentIndex == 1 ? 44 : 12,
                      height: 12,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            provider.currentIndex == 1 ? navyColor : snugYellow,
                      ),
                    ),
                    Container(
                      width: provider.currentIndex == 2 ? 44 : 12,
                      height: 12,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            provider.currentIndex == 2 ? navyColor : snugYellow,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        provider.currentIndex == 2 ? '' : 'Lewati',
                        style: snugYellowTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: semiBold,
                        ),
                      ),
                    ),
                  ],
                ),
                CarouselSlider(
                  items: [
                    SizedBox(
                      height: 280,
                      width: 280,
                      child: Image.asset(
                        'assets/onboarding_1.png',
                      ),
                    ),
                    SizedBox(
                      height: 280,
                      width: 280,
                      child: Image.asset(
                        'assets/onboarding_2.png',
                      ),
                    ),
                    SizedBox(
                      height: 280,
                      width: 280,
                      child: Image.asset(
                        'assets/onboarding_3.png',
                      ),
                    ),
                  ],
                  options: CarouselOptions(
                    height: 331,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      // setState(() {
                      //   currentIndex = index;
                      // });
                      provider.updateScreenIndex(index);
                    },
                  ),
                  carouselController: carouselController,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  titles[provider.currentIndex],
                  style: whiteTextStyle.copyWith(
                    fontSize: 34,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  subTitles[provider.currentIndex],
                  style: lightYellowTextStyle,
                ),
                const SizedBox(
                  height: 50,
                ),
                provider.currentIndex == 2
                    ? SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return const LoginScreen();
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  final tween = Tween(
                                    begin: 0.0,
                                    end: 1.0,
                                  );
                                  return FadeTransition(
                                    opacity: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: yellowColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Mulai',
                            style: darkGreyTextStyle.copyWith(
                              fontWeight: semiBold,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            carouselController.nextPage();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: yellowColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Lanjutkan',
                            style: darkGreyTextStyle.copyWith(
                              fontWeight: semiBold,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
