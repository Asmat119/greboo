import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grebooo/core/service/googleAdd/addHandler.dart';


// class GoogleAddService {
//   static late BannerAd bannerAd;
//   static Future<Widget> getBannerWidget() async {
//     bannerAd = BannerAd(
//       adUnitId: GoogleAddHandler.bannerAdUnitId,
//       size: AdSize.banner,
//       request: AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (Ad ad) {
//           debugPrint('Ad loaded.');
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//           debugPrint('Ad failed to load: $error');
//         },
//         onAdOpened: (Ad ad) {
//           debugPrint('Ad opened.');
//         },
//         onAdClosed: (Ad ad) {
//           debugPrint('Ad closed.');
//         },
//       ),
//     );
//
//     await bannerAd.load();
//
//     return Container(
//       child: AdWidget(
//         ad: bannerAd,
//         key: UniqueKey(),
//       ),
//       constraints: BoxConstraints(
//         maxHeight: 50,
//         maxWidth: Get.width,
//         minHeight: 50,
//         minWidth: Get.width,
//       ),
//     );
//   }
//
//   static disposeBannerAdd() {
//     bannerAd.dispose();
//   }
//
//   static InterstitialAd? _interstitialAd;
//   static bool isAdLoaded = false;
//   // static Future createInterstitialAd() async {
//   //   int _interstitialLoadAttempts = -1;
//   //   isAdLoaded = false;
//   //   await InterstitialAd.load(
//   //     adUnitId: GoogleAddHandler.interstitialAdUnitId,
//   //     request: AdRequest(),
//   //     adLoadCallback: InterstitialAdLoadCallback(
//   //       onAdLoaded: (InterstitialAd ad) {
//   //         isAdLoaded = true;
//   //         _interstitialAd = ad;
//   //         _interstitialLoadAttempts = 0;
//   //       },
//   //       onAdFailedToLoad: (LoadAdError error) {
//   //         _interstitialLoadAttempts += 1;
//   //         _interstitialAd = null;
//   //         isAdLoaded = false;
//   //         if (_interstitialLoadAttempts <= 2) {
//   //           createInterstitialAd();
//   //         }
//   //       },
//   //     ),
//   //   );
//   // }
//
//   // static void showInterstitialAd() {
//   //   if (_interstitialAd != null && isAdLoaded) {
//   //     _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//   //       onAdDismissedFullScreenContent: (InterstitialAd ad) {
//   //         ad.dispose();
//   //         createInterstitialAd();
//   //       },
//   //       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//   //         ad.dispose();
//   //         createInterstitialAd();
//   //       },
//   //     );
//   //     _interstitialAd!.show();
//   //   }
//   // }
// }
