import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const String _initialUrl = 'https://barqidrama.biz.id';

  static const List<String> _urls = [
    'https://barqidrama.biz.id/movies',
    'https://barqidrama.biz.id/drama',
    'https://barqidrama.biz.id/tvchannel',
    'https://barqidrama.biz.id/profile',
  ];

  late final WebViewController _controller;
  late final BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    MobileAds.instance.initialize();
    _loadBannerAd();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(_initialUrl));
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: '<YOUR_ADMOB_BANNER_UNIT_ID>',
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _controller.loadRequest(Uri.parse(_urls[index]));
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BarqiDrama'),
      ),
      body: Column(
        children: [
          Expanded(
            child: WebViewWidget(
              controller: _controller,
            ),
          ),
          if (_isBannerAdLoaded)
            Container(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: 'Drama',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'TV Channel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
