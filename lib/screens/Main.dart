import 'dart:async';

import 'package:dns_client/dns_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  String urlHome = "https://tamilian.io/movies/";
  String urlMovie = "https://tamilian.io/movies/";
  String urlTv = "https://tamilian.io/movies/";

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  CookieManager cookieManager = CookieManager.instance();
  late PullToRefreshController? pullToRefreshController;
  PullToRefreshSettings pullToRefreshSettings = PullToRefreshSettings(
      color: const Color.fromRGBO(0, 32, 58, 1), enabled: true);
  final List<ContentBlocker> contentBlockers = [];
  bool isLoading = true;
  int progress = 0;
  int currentIndex = 0;
  String? lastUrl;
  bool toggle = false;
  bool isModalOpen = false;
  int resourceLoad = 0;

  @override
  void initState() {
    super.initState();

    _resolveAndLoad();

    lastUrl = null;

    pullToRefreshController = PullToRefreshController(
      settings: pullToRefreshSettings,
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          webViewController?.reload();
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );

    final hurawatchUrlFilters = [
      ".*.whos.amung.us/.*",
      ".*.weepingcart.com/.*",
      ".*.l.sharethis.com/.*",
      ".*.count-server.sharethis.com/.*",
      ".*.mc.yandex.ru/.*",
      // ".*.be6721.rcr72.waw04.cdn112.com/.*",
      ".*.precedelaxative.com/.*",
      ".*.platform-cdn.sharethis.com/.*",
      ".*.lashahib.net/.*",
      ".*.histats.com/.*",
      ".*.prd.jwpltx.com/.*",
      ".*.icon_.*",
      ".*.instant.page/.*",
      ".*.imasdk.googleapis.com/.*",
      ".*.delivery.r2b2.cz/.*",
      ".*.pubfuture-ad.com/.*",
      ".*.netpub.media/.*",
      ".*.delivery.r2b2.cz/.*",
    ];
    final youtubeUrlFilters = [
      ".*.static.doubleclick.net/.*",
      ".*.play.google.com/.*",
      ".*.googleads.g.doubleclick.net/.*",
      ".*.youtube.com/ptracking/.*",
      ".*.doubleclick.net.*",
      ".*.youtube.com/youtubei.*",
      ".*.youtube.com/pagead.*",
      ".*.youtube.com/api/stats/qoe.*",
      ".*.doubleclick.net.*",
    ];
    final adUrlFilters = [
      ".*.doubleclick.net/.*",
      ".*.ads.pubmatic.com/.*",
      ".*.googlesyndication.com/.*",
      ".*.google-analytics.com/.*",
      ".*.adservice.google.*/.*",
      ".*.adbrite.com/.*",
      ".*.xvide/.*",
      ".*.redtube.com/.*",
      ".*.azvid.com/.*",
      ".*.piratebay.com/.*",
      ".*.youpo/.*",
      ".*.exponential.com/.*",
      ".*.quantserve.com/.*",
      ".*.scorecardresearch.com/.*",
      ".*.zedo.com/.*",
      ".*.adsafeprotected.com/.*",
      ".*.teads.tv/.*",
      ".*.outbrain.com/.*",
      ".*.googletagmanager.com/.*",
      ...hurawatchUrlFilters,
      ...youtubeUrlFilters
    ];
    // for each Ad URL filter, add a Content Blocker to block its loading.
    for (final adUrlFilter in adUrlFilters) {
      contentBlockers.add(ContentBlocker(
          trigger: ContentBlockerTrigger(
            urlFilter: adUrlFilter,
          ),
          action: ContentBlockerAction(
            type: ContentBlockerActionType.BLOCK,
          )));
    }

    // apply the "display: none" style to some HTML elements
    contentBlockers.add(ContentBlocker(
        trigger: ContentBlockerTrigger(
          urlFilter: ".*",
        ),
        action: ContentBlockerAction(
            type: ContentBlockerActionType.CSS_DISPLAY_NONE,
            selector:
                ".banner, .banners, .afs_ads, .ad-placement, .ads, .ad, .advert")));
  }

  Future<void> _resolveAndLoad() async {
    final dohResolver = DnsOverHttps('https://dns.google/resolve');

    try {
      setState(() {
        isLoading = true;
      });
      // Resolve the domain tamilian.io
      final response = await dohResolver.lookup('tamilian.io');
      print('Resolved IPs: ${response}');

      if (response.isNotEmpty) {
        // Load the WebView once DNS resolution is successful
        setState(() {
          isLoading = false;
        });
      } else {
        print('No IPs resolved for tamilian.io');
      }
    } catch (e) {
      print('Failed to resolve DNS: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String genreJS = '''
      var menu = document.querySelector('#menu')
      menu.classList.add('active')
      menu.style.height = '100vh'
      menu.style.paddingTop = '50px'
      menu.style.background = 'linear-gradient(black, #001111)'
      document.querySelector('#menu-item-44').style.display = 'none';
      document.querySelector('#menu-item-43').style.display = 'none';
      document.querySelector('#menu-item-11').style.display = 'initial';
      document.querySelector('#menu-item-11 a').style.color = 'white';
      document.querySelector('#menu-item-65').style.display = 'none';
      document.querySelector('#menu-item-120').style.display = 'none';

      var subContainer = document.querySelector('#menu-item-11 .sub-container')
      subContainer.style.marginTop = '20px'

       var li = document.querySelectorAll('#menu-item-11 .sub-container .sub-menu li')
      li.forEach(e => {
        e.style.background = '#001515'
        e.style.margin = '10px'
        e.style.padding = '10px'
        e.style.borderRadius = '10px'
        e.style.width = 'calc(33.333% - 20px)'
      })
    ''';

    String yearJS = '''
      var menu = document.querySelector('#menu')
      menu.classList.add('active')
      menu.style.height = '100vh'
      menu.style.paddingTop = '50px'
      menu.style.background = 'linear-gradient(black, #001111)'
      document.querySelector('#menu').classList.add('active')
      document.querySelector('#menu-item-44').style.display = 'none';
      document.querySelector('#menu-item-43').style.display = 'none';
      document.querySelector('#menu-item-11').style.display = 'none';
      document.querySelector('#menu-item-65').style.display = 'initial';
      document.querySelector('#menu-item-65 a').style.color = 'white';
      document.querySelector('#menu-item-120').style.display = 'none';

      var subContainer = document.querySelector('#menu-item-65 .sub-container')
      subContainer.style.marginTop = '20px'

      var li = document.querySelectorAll('#menu-item-65 .sub-container .sub-menu li')
      li.forEach(e => {
        e.style.background = '#001515'
        e.style.margin = '10px'
        e.style.padding = '10px'
        e.style.borderRadius = '10px'
        e.style.width = 'calc(33.333% - 20px)'
      })

    ''';

    String closeJS = '''
      var menu = document.querySelector('#menu')
      menu.classList.remove('active')
    ''';

    void updateNav() async {
      WebUri? uri = await webViewController?.getUrl();
      String? currentUrl = uri.toString();

      if (lastUrl != currentUrl) {
        lastUrl = currentUrl;
        if (currentUrl == urlHome) {
          setState(() {
            currentIndex = 0;
          });
        } else if (currentUrl == urlMovie) {
          setState(() {
            currentIndex = 1;
          });
        } else if (currentUrl == urlTv) {
          setState(() {
            currentIndex = 2;
          });
        }
      }

      if (currentUrl.contains("jimkimble")) {
        webViewController?.evaluateJavascript(source: '''
          document.body.style.background = 'linear-gradient(#0c0c0c, #001111)'
          document.body.style.backgroundAttachment = 'fixed'

          document.querySelector('.brand-logo').style.display = 'none'
          document.querySelector('#top_buttons').style.display = 'none'
          document.querySelector('#instructions').style.display = 'none'

          var main = document.querySelector('.main-container')
          main.lastElementChild.style.display = 'none'
          document.querySelector('.pb-6').style.display = 'none'
          document.querySelector('.brand-logo').style.display = 'none'

          document.querySelector('#left').style.marginTop = "50px"
          var list = document.querySelector('.list')
          list.lastElementChild.click()

        ''');
      }
    }

    updateNav();

    webViewController?.evaluateJavascript(source: '''
      // window.addEventListener('focus', function() {
      //   window.blur();
      // });
      document.documentElement.style.setProperty('-webkit-tap-highlight-color', 'transparent');

      document.body.style.background = 'linear-gradient(#030a00, #0e110d)'
      document.body.style.backgroundAttachment = 'fixed'

      var head = document.createElement('div')
      var header = document.querySelector('header')
      header.append(head)
      head.append(document.querySelector('header .container'))
      head.style.position = 'fixed'
      head.style.top = 0
      head.style.left = 0
      head.style.width = '100vw'
      head.style.height = '0px'
      head.style.background = '#151515'
      

      header.style.transform = "translateX('-100%')"
      header.style.height = '0px'
      head.style.transform = "translateX('-100%')"
      

      document.querySelector('.header-logo').style.display = 'none';
      document.querySelector('.mobile-menu').style.display = 'none';
      document.querySelector('.mobile-search').style.display = 'none'

      var searchForm = document.querySelector('#searchform')
      searchForm.style.padding = '10px'
      searchForm.style.background = '#011818'
      searchForm.style.borderRadius = '15px'
      var search = document.querySelector('#search')
      search.style.paddingTop = '15px'
      search.style.background = '#030a00'
      search.classList.add('active')
      search.style.marginTop = "-50px"
      var searchInput = document.querySelector('#search input')
      searchInput.style.background = "#011818"
      searchInput.style.borderRadius = "10px"
      document.querySelector('#searchform .fa').style.color = 'white'

      // var container = document.querySelector('.container')
      var pagination = document.querySelector('#pagination')
      pagination.style.marginTop = '30px'
      // container.append(pagination)


      document.querySelector('footer').style.display = 'none'

      document.querySelector('.comentarios').style.display = 'none'

      

    ''');

    void nav(int index) {
      // webViewController?.stopLoading();
      setState(() {
        currentIndex = index;
      });

      if (index != 0) {
        webViewController?.evaluateJavascript(
            source: index == 1 ? genreJS : yearJS);
      } else {
        webViewController?.loadUrl(
            urlRequest: URLRequest(
                url: WebUri(urlHome),
                cachePolicy:
                    URLRequestCachePolicy.RETURN_CACHE_DATA_ELSE_LOAD));
      }
    }

    return WillPopScope(
      onWillPop: () async {
        if (currentIndex != 0) {
          setState(() {
            currentIndex = 0;
            resourceLoad = 0;
          });
          webViewController?.evaluateJavascript(source: closeJS);
          return false;
        }
        if (await webViewController!.canGoBack()) {
          webViewController!.goBack();
          return false;
        }
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 0, 15, 15),
          selectedLabelStyle: const TextStyle(fontSize: 10),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          currentIndex: currentIndex,
          onTap: (value) => nav(value),
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: const Color.fromRGBO(53, 53, 53, 1),
          selectedItemColor: Colors.white,
          elevation: 20,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              activeIcon: Icon(
                Icons.home_filled,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.category_outlined,
              ),
              activeIcon: Icon(
                Icons.category_rounded,
              ),
              label: "Genres",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.timeline_outlined,
              ),
              activeIcon: Icon(
                Icons.timeline_rounded,
              ),
              label: "Years",
            ),
          ],
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  pullToRefreshController: pullToRefreshController,
                  initialUrlRequest: URLRequest(url: WebUri(urlHome)),
                  initialSettings: InAppWebViewSettings(
                    contentBlockers: contentBlockers,
                    allowBackgroundAudioPlaying: true,
                    allowsPictureInPictureMediaPlayback: true,
                    useOnLoadResource: true,
                    cacheEnabled: true,
                    cacheMode: CacheMode.LOAD_CACHE_ELSE_NETWORK,
                    verticalScrollBarEnabled: false,
                    horizontalScrollBarEnabled: false,
                    iframeAllowFullscreen: false,
                    isTextInteractionEnabled: false,
                  ),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      isLoading = true;
                    });
                  },
                  onReceivedError: (controller, request, error) {
                    pullToRefreshController?.endRefreshing();
                    if (error.type == WebResourceErrorType.UNSUPPORTED_SCHEME) {
                      controller.goBack();
                    }
                  },
                  onLoadStop: (controller, url) {
                    setState(() {
                      isLoading = false;
                      resourceLoad = 0;
                    });
                    pullToRefreshController?.endRefreshing();
                  },
                  onTitleChanged: (controller, title) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController?.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress;
                    });
                  },
                  onLoadResource: (controller, resource) {
                    if (resourceLoad < 5) {
                      // webViewController?.evaluateJavascript(source: closeJS);
                    }
                  },
                ),
                progress < 100
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.848)),
                        child: const CircularProgressIndicator(
                            color: Color.fromARGB(255, 5, 115, 91)),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ]),
      )),
    );
  }
}
