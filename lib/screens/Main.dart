import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:theater/components/WatchList.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/prefs.dart';
import 'package:theater/screens/WatchList.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  CookieManager cookieManager = CookieManager.instance();
  final List<ContentBlocker> contentBlockers = [];
  bool isLoading = true;
  int progress = 0;
  int currentIndex = 0;
  String? lastUrl;
  bool serverToggle = true;
  // int wishCount = 0;
  List<Movie> wishList = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!prefs.containsKey("lang")) {
        Navigator.pushNamed(context, '/language');
      }
      wishList = await getWishList();
    });

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
    int? lang = prefs.getInt("lang");
    List languages = [
      {
        "name": "Tamil",
        "isSelected": lang == 1,
        "value": 1,
        "path": "/category/tamil-movies"
      },
      {
        "name": "English",
        "isSelected": lang == 2,
        "value": 2,
        "path": "/category/english-movies"
      },
      {
        "name": "Malayalam",
        "isSelected": lang == 3,
        "value": 3,
        "path": "/category/malayalam-movies"
      },
      {
        "name": "Telugu",
        "isSelected": lang == 4,
        "value": 4,
        "path": "/category/telugu-movies"
      },
      {
        "name": "Kannada",
        "isSelected": lang == 5,
        "value": 5,
        "path": "/category/kannada-movies"
      },
      {
        "name": "Hindi",
        "isSelected": lang == 6,
        "value": 6,
        "path": "/category/hindi-movies"
      }
    ];
    String url = "https://www.bolly2tolly.land";
    String urlHome = url + languages[(lang ?? 1) - 1]['path'];
    String urlLatest = "https://www.bolly2tolly.land/category/tv-shows";
    String urlMostViewed =
        "https://www.bolly2tolly.land/category/bengali-movies";

    print("WHISHHHHHHHHHHHHH " + wishList.length.toString());

    String latestJS = '''
      document.querySelector('main').style.display = 'none'
      document.querySelector('article').style.display = 'none'
      var aside = document.querySelector('aside')
      aside.style.display = 'inherit'
      aside.lastElementChild.style.display = 'none'
      aside.firstElementChild.style.display = 'inherit'
      aside.firstElementChild.style.color = 'white'

      var title = document.querySelector('.Wdgt .Title')
      title.style.color = '#fee4ff'
      title.style.fontSize = '22px'

      var list = document.querySelector('.TpSbList')
      list.style.maxWidth = '100%'
      var movies = document.querySelectorAll('.MovieList li')
      movies.forEach(e => {
        // e.style.backgroundColor = "#322839c0"
        e.style.borderRadius = "0px"
        e.style.padding = "20px"
        e.style.margin = "0px"
        e.querySelector('a').style.color = 'white'
      })

      document.querySelector('.Wdgt').style.backgroundColor = 'transparent'


    ''';

    String mostViewedJS = '''
      document.querySelector('main').style.display = 'none'
      document.querySelector('article').style.display = 'none'
      var aside = document.querySelector('aside')
      aside.style.display = 'inherit'
      aside.firstElementChild.style.display = 'none'
      aside.lastElementChild.style.display = 'inherit'

      var title = aside.lastElementChild.querySelector('.Title')
      title.style.color = '#fee4ff'
      title.style.fontSize = '22px'

      var list = document.querySelector('.TpSbList')
      list.style.maxWidth = '100%'
      var movies = document.querySelectorAll('.MovieList li')
      movies.forEach(e => {
        e.style.backgroundColor = "#322839c0"
        e.style.borderRadius = "0px"
        e.style.padding = "0px"
        e.style.margin = "8%"
      })

      document.querySelector('.Wdgt').style.backgroundColor = 'transparent'

    
    ''';

    String wishJS = '''
      var wl = document.createElement('div')
      wl.id = 'addToWishList'
      wl.style.width = '100%'
      wl.style.height = '50px'
      wl.style.background = 'linear-gradient(120deg, #36014e8b, #2c00318b)'
      wl.style.display = 'flex'
      wl.style.alignItems = 'center'
      wl.style.justifyContent = 'center'
      wl.style.margin = '10px 0px'
      wl.style.borderRadius = '10px'
      
      var img = document.createElement('img');
      img.src = "https://img.icons8.com/ios-glyphs/20/FFEFFF/plus-math.png"
      img.style.margin = '0 10px'
      var h6 = document.createElement('h5');
      h6.innerText = "Add To Watchlist"
      h6.style.margin = '0'
      wl.appendChild(img)
      wl.appendChild(h6)

      var currentUrl = document.location.href
      var isMovie = currentUrl.includes('/movie/')
      var isSeries = currentUrl.includes('/serie/')

      if (isMovie){
        var name = document.querySelector('.SubTitle').innerHTML.toString()
        var photo = document.querySelector('.attachment-thumbnail').src
        var language = document.querySelectorAll('td')[3].querySelector('span').innerText
        var url = window.location.href
        var duration = document.querySelector('.Time').innerText
        var year = document.querySelector('.Date').innerText
      }

      if (isSeries) {
        var name = document.querySelector('.Title').innerHTML.toString()
        var photo = document.querySelector('.attachment-thumbnail').src
        var language = ""
        var url = window.location.href
        var duration = ""
        var year = ""
      }

      // AAIco-adjust

      wl.addEventListener('click', () => {
        window.flutter_inappwebview.callHandler('wishHandler', name, photo, language, url, duration, year);
      })

      var article = document.querySelector('article')
      article.append(wl)

    ''';

    String removeWishJS = '''
      document.querySelector('#addToWishList').style.display = 'none'
    ''';

    webViewController?.addJavaScriptHandler(
        handlerName: 'wishHandler',
        callback: (args) async {
          Movie movie = Movie(
              name: args[0] ?? "",
              photo: args[1] ?? "",
              language: args[2] ?? "",
              url: args[3] ?? "",
              duration: args[4] ?? "",
              year: args[5] ?? "");

          await addToWishList(movie);
          wishList = await getWishList();
          await webViewController?.evaluateJavascript(source: removeWishJS);
        });

    void updateNav() async {
      WebUri? uri = await webViewController?.getUrl();
      String? currentUrl = uri.toString();

      if (lastUrl != currentUrl) {
        if (currentUrl == urlHome) {
          setState(() {
            currentIndex = 0;
          });
        } else if (currentUrl == urlLatest) {
          setState(() {
            currentIndex = 1;
          });
        } else if (currentUrl == urlMostViewed) {
          setState(() {
            currentIndex = 2;
          });
        }
        lastUrl = currentUrl;
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

            // servers.style.display = 'none'
            // document.querySelector('.TPlayerCn').style.display = 'none'
              
          ''');
        }

        webViewController?.evaluateJavascript(source: '''
          document.querySelector('main').style.display = 'inherit'
          document.querySelector('article').style.display = 'inherit'
          document.querySelector('aside').style.display = 'none'
          document.querySelector('.Footer').style.display = 'none'
          document.querySelector('#ads_singlem_top').style.display = 'none'
          document.querySelector('.Wdgt').style.display = 'none'
          var wng = document.querySelectorAll('.has-wpur-alert')
          wng.forEach(e => {
            e.style.display = 'none'
          })
        ''');
      }

      if (currentUrl.contains("/serie/")) {
        if (serverToggle) {
          await webViewController?.evaluateJavascript(source: '''
            // var servers = document.querySelector('.TPlayerNv')
            // servers.childNodes.forEach(e => {
            //   if (e.childNodes[0].innerText == 'Oyohd') {
            //     e.style.display = 'none'
            //   }
            //   if (e.childNodes[0].innerText == 'Neohd') {
            //     e.click()
            //     e.style.backgroundColor = '#8a00a6'
            //   } else {
            //     servers.childNodes[1].click()
            //     servers.childNodes[1].style.backgroundColor = '#8a00a6'
            //   }
            // })

            // servers.style.display = 'none'
            // document.querySelector('.TPlayerCn').style.display = 'none'
              
          ''');
        }

        webViewController?.evaluateJavascript(source: '''
          document.querySelector('main').style.display = 'inherit'
          document.querySelector('article').style.display = 'inherit'
          document.querySelector('aside').style.display = 'none'
          document.querySelector('.ListPOpt').style.display = 'none'
          document.querySelector('.AA-Season').style.color = 'white'
          document.querySelector('.Footer').style.display = 'none'
          var titles = document.querySelectorAll('.MvTbTtl a')
          titles.forEach(e => {
            e.style.color = 'white'
          })
          document.querySelector('#ads_singlem_top').style.display = 'none'
          document.querySelector('.Wdgt').style.display = 'none'
          var wng = document.querySelectorAll('.has-wpur-alert')
          wng.forEach(e => {
            e.style.display = 'none'
          })
        ''');
      }

      if (currentUrl.contains("/episode/")) {
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

            // servers.style.display = 'none'
            // document.querySelector('.TPlayerCn').style.display = 'none'
              
          ''');
        }

        webViewController?.evaluateJavascript(source: '''
          document.querySelector('main').style.display = 'inherit'
          document.querySelector('article').style.display = 'inherit'
          document.querySelector('aside').style.display = 'none'
          document.querySelector('.Footer').style.display = 'none'
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
      search.style.top = '0px'
      search.style.left = '0'
      search.style.zIndex = '10'
      search.style.width = '100%'
      search.style.padding = '25px 20px 0px 20px'
      search.style.backgroundColor = '#13001c'
      search.style.backdropFilter = 'blur(20px)'
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

      var url = window.location.pathname

      if (url.includes('/category/tamil-movies')) {
        var title = document.querySelector('.Title')
        title.innerText = "Tamil"
      }
      if (url.includes('/category/english-movies')) {
        title.innerText = "English"
      }
      if (url.includes('/category/malayalam-movies')) {
        var title = document.querySelector('.Title')
        title.innerText = "Malayalam"
      }
      if (url.includes('/category/telugu-movies')) {
        var title = document.querySelector('.Title')
        title.innerText = "Telugu"
      }
      if (url.includes('/category/kannada-movies')) {
        var title = document.querySelector('.Title')
        title.innerText = "Kannada"
      }
      if (url.includes('/category/hindi-movies')) {
        var title = document.querySelector('.Title')
        title.innerText = "Hindi"
      }

      document.querySelector('.Top').style.display = 'flex'
      document.querySelector('.Top').style.alignItems = 'center'
      document.querySelector('.Top').style.marginTop = '-30px'
      document.querySelector('.current').style.backgroundColor = '#8a00a6'

      document.querySelector('.AZList').style.display = 'none'
      var result = document.querySelector('.Result')
      result.style.background = "linear-gradient(120deg, #13001c, #0a000c)"
      result.style.borderTop = 'none'
      result.style.borderRadius = '10px'
      result.style.width = '91%'
      result.style.marginRight = '5%'
      result.style.backdropFilter = 'blur(20px)'
      document.querySelector('a.Button').style.backgroundColor = '#370039c9'
      document.querySelector('a.Button').style.borderRadius = '10px'

      var titles = document.querySelectorAll('.Title')
      titles.forEach(e => {
        e.style.color = 'white'
      })


    ''');

    void nav(int index) {
      webViewController?.stopLoading();
      setState(() {
        currentIndex = index;
      });

      String urlChange = currentIndex == 0
          ? urlHome
          : currentIndex == 1
              ? urlLatest
              : currentIndex == 2
                  ? urlMostViewed
                  : "";
      if (currentIndex != 3) {
        webViewController?.loadUrl(
            urlRequest: URLRequest(
                url: WebUri(urlChange),
                cachePolicy:
                    URLRequestCachePolicy.RETURN_CACHE_DATA_ELSE_LOAD));
      } else {
        print("333333333333333333333333");
        // webViewController?.pause();
      }
    }

    return WillPopScope(
      onWillPop: () async {
        if (await webViewController!.canGoBack()) {
          webViewController!.goBack();
          return false;
        }
        if (currentIndex == 3) {
          setState(() {
            currentIndex = 0;
          });
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: Container(
          height: 70,
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
            unselectedItemColor: const Color.fromARGB(37, 219, 186, 232),
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
                label: "New Release",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.timeline_outlined,
                ),
                activeIcon: Icon(
                  Icons.timeline_rounded,
                ),
                label: "Most Viewed",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings_outlined,
                ),
                activeIcon: Icon(
                  Icons.settings_rounded,
                ),
                label: "Options",
              ),
            ],
          ),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
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
                    if (error.type == WebResourceErrorType.UNSUPPORTED_SCHEME ||
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
                    });
                  },
                  onTitleChanged: (controller, title) async {
                    setState(() {
                      isLoading = false;
                      serverToggle = true;
                    });
                    WebUri? uri = await webViewController?.getUrl();
                    String? url = uri.toString();
                    if (url.contains("/movie/") || url.contains("/serie/")) {
                      if (wishList.isNotEmpty) {
                        bool movieExists =
                            wishList.any((movie) => movie.url == url);
                        if (!movieExists) {
                          await webViewController?.evaluateJavascript(
                              source: wishJS);
                        }
                      } else {
                        await webViewController?.evaluateJavascript(
                            source: wishJS);
                      }
                    }
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {}
                    setState(() {
                      this.progress = progress;
                    });
                  },
                  onEnterFullscreen: (controller) {
                    setState(() {
                      serverToggle = false;
                    });
                  },
                ),
                currentIndex == 3
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.topLeft,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Color.fromARGB(255, 23, 0, 28),
                              Colors.black
                            ])),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Language",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Wrap(
                                spacing: 20,
                                children: languages.map((e) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (!e['isSelected']) {
                                        prefs.setInt("lang", e['value']);
                                        setState(() {
                                          lang = prefs.getInt("lang");
                                          urlHome = url + e['path'];
                                        });
                                      }
                                    },
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  2) -
                                              40,
                                      height: 100,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          gradient: e['isSelected']
                                              ? const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                      Color.fromARGB(
                                                          70, 86, 0, 198),
                                                      Color.fromARGB(
                                                          217, 134, 0, 151)
                                                    ])
                                              : const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                      Color.fromARGB(
                                                          70, 42, 0, 97),
                                                      Color.fromARGB(
                                                          217, 31, 0, 35)
                                                    ])),
                                      child: Text(
                                        e['name'],
                                        style: TextStyle(
                                          color: e['isSelected']
                                              ? Colors.white
                                              : const Color.fromARGB(
                                                  140, 182, 144, 247),
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

                              // WatchListComponent(watchList: wishList),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    "Watch List",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  wishList.isNotEmpty
                                      ? Wrap(
                                          runSpacing: 20,
                                          spacing: 20,
                                          children: wishList.map((movie) {
                                            return SizedBox(
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2) -
                                                  40,
                                              height: 250,
                                              child: Stack(children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      currentIndex = 0;
                                                      webViewController?.loadUrl(
                                                          urlRequest: URLRequest(
                                                              url: WebUri(
                                                                  movie.url)));
                                                    });
                                                  },
                                                  child: Container(
                                                    width:
                                                        (MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2) -
                                                            40,
                                                    height: 250,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  15)),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            movie.photo),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    child: Container(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                          gradient: LinearGradient(
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter,
                                                              colors: [
                                                                Color.fromARGB(
                                                                    70,
                                                                    66,
                                                                    0,
                                                                    97),
                                                                Color.fromARGB(
                                                                    255,
                                                                    19,
                                                                    0,
                                                                    21)
                                                              ])),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: 100,
                                                                  child: Text(
                                                                    movie.name,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        overflow:
                                                                            TextOverflow.ellipsis),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      movie
                                                                          .language,
                                                                      style: const TextStyle(
                                                                          color: Color.fromARGB(
                                                                              73,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                          fontSize:
                                                                              10),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      movie
                                                                          .year,
                                                                      style: const TextStyle(
                                                                          color: Color.fromARGB(
                                                                              73,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                          fontSize:
                                                                              10),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    await removeFromWishList(
                                                        movie);
                                                    List<Movie>
                                                        updatedWishlist =
                                                        await getWishList();
                                                    setState(() {
                                                      wishList =
                                                          updatedWishlist;
                                                    });
                                                  },
                                                  child: Container(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius.all(
                                                                  Radius.circular(
                                                                      10)),
                                                          color:
                                                              const Color.fromARGB(
                                                                  95,
                                                                  29,
                                                                  0,
                                                                  33),
                                                          border: Border.all(
                                                              color: const Color
                                                                  .fromARGB(255,
                                                                  48, 0, 62),
                                                              width: 1)),
                                                      child: const Icon(
                                                        Icons
                                                            .delete_outline_rounded,
                                                        color: Color.fromARGB(
                                                            87, 249, 131, 255),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ]),
                                            );
                                          }).toList(),
                                        )
                                      : Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 30),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "lib/assets/images/wish.png",
                                                opacity:
                                                    const AlwaysStoppedAnimation(
                                                        .8),
                                              ),
                                              const Text(
                                                "Add movies to your watchlist",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        75, 235, 199, 255)),
                                              ),
                                            ],
                                          ),
                                        )
                                ],
                              ),
                            ],
                          ),
                        ))
                    : const SizedBox(),
                progress < 100
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Color.fromARGB(255, 23, 0, 28),
                              Colors.black
                            ])),
                        child: const CircularProgressIndicator(
                            color: Color.fromARGB(255, 123, 2, 154)),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
