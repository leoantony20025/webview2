import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  String url = "https://www.bolly2tolly.land";
  String urlHome = "https://www.bolly2tolly.land/category/tamil-movies";
  String urlLatest = "https://www.bolly2tolly.land/category/tamil-movies";
  String urlMostViewed = "https://www.bolly2tolly.land/category/tamil-movies";

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  CookieManager cookieManager = CookieManager.instance();
  final List<ContentBlocker> contentBlockers = [];
  bool isLoading = true;
  int progress = 0;
  int currentIndex = 0;
  String? lastUrl;
  bool toggle = false;
  bool isModalOpen = false;
  int resourceLoad = 0;
  bool serverToggle = true;

  @override
  void initState() {
    super.initState();

    lastUrl = null;

    final hurawatchUrlFilters = [
      ".*.whos.amung.us/.*",
      ".*.weepingcart.com/.*",
      ".*.l.sharethis.com/.*",
      ".*.count-server.sharethis.com/.*",
      ".*.mc.yandex.ru/.*",
      // ".*.be6721.rcr72.waw04.cdn112.com/.*",
      ".*.delivery.r2b2.cz/.*",
      ".*.cloudflareinsights.com/.*",
      ".*.pixfuture.com/.*",
      ".*.ping.gif/.*",
      ".*.cancriberths.com/.*",
      ".*.equalditchcentered.com/.*",
      ".*.stats.wp.com/.*",
      ".*.goingkinch.com/.*",
      ".*.fuckadblock.*",
      ".*.marazma.com/.*",
      ".*.popmansion.com/.*",
      ".*.videocdnmetrika.com/.*",
      ".*.s3.us-east-1.amazonaws.com/.*",
      ".*.amazonaws.com/.*",
      ".*.cloudfront.net/.*",
      ".*.parimatch.*",
      ".*.rz.systpelew.top/.*",
      ".*.win.pm-bet.in/.*",
      // ".*.funkiaproofed.shop/.*",
      // ".*.ak.itponytaa.com/.*",
      ".*.go-mpulse.net/.*",
      ".*.chennaiexch.online/.*",
      ".*.honourprecisionsuited.com/.*",
      ".*.creative-stat1.com/.*",
      ".*.exness.com/.*",
      ".*.use.typekit.net/.*",
      ".*.stats.wp.com/.*",
      ".*.oyohd.one/cdn-cgi/trace.*",
      ".*.profitableexactly.com/.*",
      ".*.oyohd.one/js/video.counters/.*",
      ".*.marazma.com/.*",
      ".*.dexpredict.com/.*",
      ".*.junkyadexchange.com/.*",
      ".*.rockiertaar.com/.*",
      ".*.www.exness.com/.*",
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

  @override
  Widget build(BuildContext context) {
    String latestJS = '''
      document.querySelector('main').style.display = 'none'
      document.querySelector('article').style.display = 'none'
      var aside = document.querySelector('aside')
      aside.style.display = 'initial'
      aside.lastElementChild.style.display = 'none'
      aside.firstElementChild.style.display = 'initial'
      aside.firstElementChild.style.color = 'white'

      document.querySelector('.Wdgt').style.width = '100vw'
      document.querySelector('.Wdgt').style.backgroundColor = 'white'

    ''';

    String mostViewedJS = '''
      document.querySelector(' main').style.display = 'none'
      document.querySelector('article').style.display = 'none'
      var aside = document.querySelector('aside')
      aside.style.display = 'initial'
      aside.firstElementChild.style.display = 'none'
      aside.lastElementChild.style.display = 'initial'
    
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
        }
      }

      if (currentIndex == 0) {
        webViewController?.evaluateJavascript(source: '''
          document.querySelector('aside').style.display = 'none'
          document.querySelectorAll('.Objf').forEach(e => e.style.borderRadius = '20px !important')
        ''');
      }

      if (currentIndex == 1) {
        webViewController?.evaluateJavascript(source: latestJS);
      }

      if (currentIndex == 2) {
        webViewController?.evaluateJavascript(source: mostViewedJS);
      }

      if (currentUrl.contains("/movie/")) {
        if (serverToggle) {
          await webViewController?.evaluateJavascript(source: '''
            var servers = document.querySelector('.TPlayerNv')
            servers.childNodes.forEach(e => {
              if (e.childNodes[0].innerText == 'Oyohd') {
                e.style.display = 'none'
              }
              if (e.childNodes[0].innerText == 'Neohd') {
                e.click()
                e.style.backgroundColor = '#8a00a6'
              } else {
                servers.childNodes[1].click()
                servers.childNodes[1].style.backgroundColor = '#8a00a6'
              }
            })
              
          ''');
          print("COUNTTTTTTTTTTTTTTTTTTTTTTTTTT2222222222");
        }

        webViewController?.evaluateJavascript(source: '''
          document.querySelector('.Footer').style.display = 'none'
          document.querySelector('#ads_singlem_top').style.display = 'none'
          document.querySelector('.Wdgt').style.display = 'none'
          var wng = document.querySelectorAll('.has-wpur-alert')
          wng.forEach(e => {
            e.style.display = 'none'
          })
        ''');
      }
    }

    updateNav();

    webViewController?.evaluateJavascript(source: '''
      document.querySelector('.TPlayerNv li.Current').style.backgroundColor = '#8a00a6'
      document.querySelector('.button').style.backgroundColor = 'grey'
    ''');

    webViewController?.evaluateJavascript(source: '''
      // window.addEventListener('focus', function() {
      //   window.blur();
      // });
      document.documentElement.style.setProperty('-webkit-tap-highlight-color', 'transparent');

      document.body.style.background = 'linear-gradient(#13001c, #0a000c)'
      document.body.style.backgroundAttachment = 'fixed'
      document.body.style.backgroundColor = 'transparent'
      document.body.style.color = 'white'
      
      document.querySelector('.Content').style.background = 'transparent'
      document.querySelector('.Content').style.backgroundColor = 'transparent'
      document.querySelector('footer').style.display = 'none'

      document.querySelector('.Header').style.display = 'none'

      var search = document.querySelector('.Search')
      search.style.position = 'fixed'
      search.style.top = '10px'
      search.style.left = '0'
      search.style.zIndex = '10'
      search.style.width = 'calc(100% - 40px)'
      search.style.margin = '20px'
      var inp = document.querySelector('.Search .Form-Icon input')
      inp.style.backgroundColor = '#3a003c'
      inp.style.border = '1px solid #730077'
      inp.style.borderRadius = '10px !important'
      inp.style.boxShadow = '5px 10px 20px 0e00114c #1800204c'
      document.body.appendChild(search)
      document.querySelector('#searchsubmit').style.boxShadow = 'none'

      document.querySelector('footer').style.display = 'none'

      var title = document.querySelector('.Title')
      title.style.color = '#fee4ff'
      title.style.fontSize = '22px'
      title.style.flex = 1

      document.querySelectorAll('.TPostMv .Title').forEach(e => e.style.color = '#fff8ff3b')

      if (window.location.pathname === '/category/tamil-movies') {
        document.querySelector('.AZList').style.display = 'none'
        var title = document.querySelector('.Title')
        title.innerText = "Tamil"
        document.querySelector('.Top').style.display = 'flex'
        document.querySelector('.Top').style.alignItems = 'center'
        document.querySelector('.Top').style.marginTop = '-30px'
        document.querySelector('.current').style.backgroundColor = '#8a00a6'
      }

      document.querySelector('.AZList').style.display = 'none'

    ''');

    void nav(int index) {
      // webViewController?.stopLoading();
      setState(() {
        currentIndex = index;
      });

      // if (index != 0) {
      //   webViewController?.evaluateJavascript(
      //       source: index == 1 ? latestJS : mostViewedJS);
      // } else {
      String urlChange = currentIndex == 0
          ? urlHome
          : currentIndex == 1
              ? urlLatest
              : currentIndex == 2
                  ? urlMostViewed
                  : urlHome;
      webViewController?.loadUrl(
          urlRequest: URLRequest(
              url: WebUri(urlChange),
              cachePolicy: URLRequestCachePolicy.RETURN_CACHE_DATA_ELSE_LOAD));
      // }
    }

    return WillPopScope(
      onWillPop: () async {
        if (await webViewController!.canGoBack()) {
          webViewController!.goBack();
          return false;
        }
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(41, 25, 1, 31),
            Color.fromARGB(163, 47, 1, 58)
          ])),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            selectedLabelStyle: const TextStyle(fontSize: 10),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            currentIndex: currentIndex,
            onTap: (value) => nav(value),
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Color.fromARGB(37, 219, 186, 232),
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
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                currentIndex != 3
                    ? InAppWebView(
                        key: webViewKey,
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
                          iframeAllowFullscreen: true,
                          isTextInteractionEnabled: false,
                          useHybridComposition: true,
                          hardwareAcceleration: true,
                        ),
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                        onReceivedError: (controller, request, error) {
                          if (error.type ==
                                  WebResourceErrorType.UNSUPPORTED_SCHEME ||
                              error.type ==
                                  WebResourceErrorType.BAD_SERVER_RESPONSE) {
                            controller.goBack();
                          }
                        },
                        onReceivedHttpError:
                            (controller, request, errorResponse) async {
                          WebUri? uri = await webViewController?.getUrl();
                          String? currentUrl = uri.toString();
                          if (currentUrl.contains("junkyadexchange") ||
                              currentUrl.contains("exness") ||
                              currentUrl.contains("win.pm-bet.in")) {
                            controller.goBack();
                          }
                        },
                        onLoadStop: (controller, url) {
                          setState(() {
                            isLoading = false;
                            resourceLoad = 0;
                          });
                        },
                        onTitleChanged: (controller, title) {
                          setState(() {
                            isLoading = false;
                          });
                        },
                        onProgressChanged: (controller, progress) {
                          if (progress == 100) {}
                          setState(() {
                            this.progress = progress;
                          });
                        },
                        onLoadResource: (controller, resource) {
                          if (resourceLoad < 5) {
                            // webViewController?.evaluateJavascript(source: closeJS);
                          }
                        },
                        onEnterFullscreen: (controller) {
                          setState(() {
                            serverToggle = false;
                          });
                        },
                      )
                    : Container(),
                progress < 100
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.874)),
                        child: const CircularProgressIndicator(
                            color: Color.fromARGB(255, 123, 2, 154)),
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
