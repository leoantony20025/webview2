import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/prefs.dart';

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
    ".*.pb.bheestybaulk.top/.*",
    ".*.rz.systpelew.top/.*",
    ".*.diggingrebbes.com/.*",
    "rz.systpelew.top.*",
    ".*.pb.bheestybaulk.top.*",
    ".*.tz.lannycucujus.top.*",
    ".*.win.pm-bet.in.*",
    ".*.win.pm-5753.com.*",
    ".*.track.torarymor.world.*",
    ".*.www.exness.com.*",
    ".*.ixiadewaxed.click.*",
    ".*.dexpredict.com.*"
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
                ".banner, .banners, .afs_ads, .ad-placement, .ads, .bnr, .ad, .advert")));
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
    String language = languages[(lang ?? 1) - 1]['name'];
    String urlLatest = "https://www.bolly2tolly.land";

    String latestJS = '''

      var tle = document.querySelector('.Title')
      tle.style.marginTop = '-30px'

      document.querySelector('.Header').style.display = 'none'
      document.querySelector('.MovieListTopCn').style.display = 'none'
      document.querySelector('.wp-pagenavi').style.display = 'none'
      // document.querySelector('.Search').style.display = 'none'
      var aside = document.querySelector('aside').style.display = 'none'

      var title = document.querySelector('.Title')
      title.style.display = 'none'

      var list = document.querySelector('.TpSbList')
      list.style.maxWidth = '100%'
      var movies = document.querySelectorAll('.Wdgt>ul>li')
      movies.forEach(e => {
        // e.style.backgroundColor = "#322839c0"
        e.style.borderRadius = "0px"
        e.style.padding = "20px"
        e.style.margin = "0px"
        e.querySelector('a').style.color = 'white'
      })

      var movies = document.querySelectorAll('.TpSbList>.MovieList>li')
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
      wl.style.marginBottom = '30px'
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
        }
        lastUrl = currentUrl;
      }

      if (currentIndex == 0) {
        if (serverToggle) {
          await webViewController?.evaluateJavascript(source: '''
          document.querySelector('aside').style.display = 'none'
          
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
          inp.style.backgroundColor = '#1b001eda'
          inp.style.border = '1px solid #730077'
          inp.style.borderRadius = '10px !important'
          inp.style.boxShadow = '5px 10px 20px 0e00114c #1800204c'
          document.body.appendChild(search)
          document.querySelector('#searchsubmit').style.boxShadow = 'none'

          document.querySelector('.NoBrdRa input').style.borderRadius = '50px'

          // window.flutter_inappwebview.callHandler('homeHandler', name, photo, url, duration, quality, desc);
          document.querySelectorAll('.TPost').forEach(e => {e.style.position = 'relative'})

          if (document.querySelector('#homeBanner') == null) {
            var postCount = document.querySelectorAll('.TPostMv').length - 1
            var index = Math.floor(Math.random() * postCount) || 0
            var post = document.querySelectorAll('.TPostMv')[index]
            const queryString = new URLSearchParams(window.location.search).get("tr_post_type");
            var name = "";
            var year = "";
            if (queryString == 2) {
              name = post.querySelector('.Title').innerText
            } else {
              name = post.querySelector('.Title').innerText.split('(')[0] || post.querySelector('.Title').innerText
              var year = post.querySelector('.Title').innerHTML.toString().split('(')[1].split(')')[0] || ""
            }
            console.log("postttttt", name)
            var photo = post.querySelector('.attachment-thumbnail').src
            var url = post.querySelector('a').href
            var duration = post.querySelector('.Time').innerText
            var quality = post.querySelector('.Qlty').innerText
            var desc = post.querySelector('.Description').childNodes[0].innerText

            console.log("homeeeeeeeeeeeee ", url)
            
            var banner = document.createElement('div')
            banner.id = 'homeBanner'
            banner.style.position = 'absolute'
            banner.style.top = '80px'
            banner.style.left = '0'
            banner.style.width = '100vw'
            banner.style.height = '70vh'
            banner.style.backgroundImage = 'url(' + photo + ')'
            banner.style.backgroundSize = 'cover'
            banner.style.backgroundPosition = 'center'
            
            var grad = document.createElement('div')
            grad.style.width = '100vw'
            grad.style.height = '70vh'
            grad.style.marginTop = '-30px'
            grad.style.background = 'linear-gradient(#13001c, #17001ca8, #17001c8b, #0a000cdd,  #0a000c)'

            banner.appendChild(grad)

            var content = document.createElement('div')
            content.style.display = 'flex'
            content.style.flexDirection = 'column'
            content.style.gap = '10px'
            content.style.margin = '30px 20px'
            content.style.width = '80%'
            content.style.height = '60vh'
            content.style.alignItems = 'start'
            content.style.justifyContent = 'flex-end'
            var h2 = document.createElement('span')
            h2.innerText = name
            h2.style.fontWeight = '800'
            h2.style.fontSize = '24px'
            h2.style.lineHeight = '37px'
            h2.style.background = 'linear-gradient(120deg, #f782ff, #8000cf)'
            h2.style.backgroundClip = 'text'
            h2.style.webkitBackgroundClip = 'text'
            h2.style.color = 'transparent'
            content.appendChild(h2)
            var p = document.createElement('p')
            p.innerText = desc
            p.style.fontSize = 'small'
            p.style.margin = '0'
            content.appendChild(p)

            var row = document.createElement('div')
            row.style.display = 'flex'
            row.style.alignItems = 'center'
            row.style.justifyContent = 'center'

            var span = document.createElement('span')
            span.innerText = year
            span.style.marginRight = '10px'
            span.style.color = 'grey'
            row.appendChild(span)
            var span2 = document.createElement('span')
            span2.innerText = duration
            span2.style.marginRight = '10px'
            span2.style.color = 'grey'
            row.appendChild(span2)
            var span3 = document.createElement('span')
            span3.innerText = quality
            span3.style.marginRight = '10px'
            span3.style.color = 'grey'
            row.appendChild(span3)

            content.appendChild(row)

            var button = document.createElement('a')
            button.href = url
            button.innerText = "Watch Now"
            button.style.textDecoration = 'none'
            button.style.color = '#fab1ffc5'
            button.style.fontWeight = 'bold'
            button.style.fontSize = 'small'
            button.style.padding = '15px 40px'
            button.style.borderRadius = '50px'
            button.style.border = '1px solid #2c00318b'
            button.style.background = 'linear-gradient(120deg, #65006cc5, #1e002cc7)'
            button.style.margin = '10px 0 20px 0'
            button.style.zIndex = 10

            // button.addEventListener('click', () => window.location.href = url)

            content.append(button)

            grad.appendChild(content)

            document.body.appendChild(banner)
          }

          var titles = document.querySelectorAll('.TPost .Title')
          titles.forEach(e => {
            let mName = e.innerHTML.split('(')[0] || e.innerHTML.toString()
            e.innerHTML = mName
            e.style.color = 'grey'
            e.style.textAlign = 'left'
            // e.style.width = '150px'
            // e.style.overflow = 'hidden'

            
          })

        ''');
        }

        webViewController?.evaluateJavascript(source: '''
          var title = document.querySelector('.Top .Title')
          if (title != null) {
            title.style.color = '#fee4ff'
            title.style.fontSize = '20px'
            title.style.flex = 1
            title.style.fontWeight = '400'
            title.innerText = "$language"
          }
        ''');
      }

      if (currentIndex == 1) {
        webViewController?.evaluateJavascript(source: '''
          if (document.querySelector('#latestBanner') == null) {
            var index = Math.floor(Math.random() * 7) + 8
            console.log("homeeee randommm ", index)
            var post = document.querySelectorAll('.TPostMv')[index]
            var name = post.querySelector('.Title').innerHTML.toString().split('(')[0]
            var photo = post.querySelector('.attachment-thumbnail').src
            var url = post.querySelector('a').href
            var duration = post.querySelector('.Time').innerText
            var quality = post.querySelector('.Qlty').innerText
            var desc = post.querySelector('.Description').childNodes[0].innerText
            var year = post.querySelector('.Title').innerHTML.toString().split('(')[1].split(')')[0] || ""

            var banner = document.createElement('div')
            banner.id = 'latestBanner'
            banner.style.position = 'absolute'
            banner.style.top = '80px'
            banner.style.left = '0'
            banner.style.width = '100vw'
            banner.style.height = '70vh'
            banner.style.backgroundImage = 'url(' + photo + ')'
            banner.style.backgroundSize = 'cover'
            banner.style.backgroundPosition = 'center'
            
            var grad = document.createElement('div')
            grad.style.width = '100vw'
            grad.style.height = '70vh'
            grad.style.marginTop = '-30px'
            grad.style.background = 'linear-gradient(#13001c, #17001ca8, #17001c8b, #0a000cdd,  #0a000c)'

            banner.appendChild(grad)

            var content = document.createElement('div')
            content.style.display = 'flex'
            content.style.flexDirection = 'column'
            content.style.gap = '10px'
            content.style.margin = '30px 20px'
            content.style.width = '80%'
            content.style.height = '60vh'
            content.style.alignItems = 'start'
            content.style.justifyContent = 'flex-end'
            var h2 = document.createElement('span')
            h2.innerText = name
            h2.style.fontWeight = '800'
            h2.style.fontSize = '24px'
            h2.style.background = 'linear-gradient(120deg, #f782ff, #8000cf)'
            h2.style.backgroundClip = 'text'
            h2.style.webkitBackgroundClip = 'text'
            h2.style.color = 'transparent'
            content.appendChild(h2)
            var p = document.createElement('p')
            p.innerText = desc
            p.style.fontSize = 'small'
            p.style.margin = '0'
            content.appendChild(p)

            var row = document.createElement('div')
            row.style.display = 'flex'
            row.style.alignItems = 'center'
            row.style.justifyContent = 'center'

            var span = document.createElement('span')
            span.innerText = year
            span.style.marginRight = '10px'
            span.style.color = 'grey'
            row.appendChild(span)
            var span2 = document.createElement('span')
            span2.innerText = duration
            span2.style.marginRight = '10px'
            span2.style.color = 'grey'
            row.appendChild(span2)
            var span3 = document.createElement('span')
            span3.innerText = quality
            span3.style.marginRight = '10px'
            span3.style.color = 'grey'
            row.appendChild(span3)

            content.appendChild(row)

            var button = document.createElement('a')
            button.href = url
            button.innerText = "Watch Now"
            button.style.textDecoration = 'none'
            button.style.color = '#fab1ffc5'
            button.style.fontWeight = 'bold'
            button.style.fontSize = 'small'
            button.style.padding = '15px 40px'
            button.style.borderRadius = '50px'
            button.style.border = '1px solid #2c00318b'
            button.style.background = 'linear-gradient(120deg, #65006cc5, #1e002cc7)'
            button.style.margin = '10px 0 20px 0'
            button.style.zIndex = 10

            // button.addEventListener('click', () => window.location.href = url)

            content.append(button)

            grad.appendChild(content)

            document.body.appendChild(banner)
          }
        ''');

        webViewController?.evaluateJavascript(source: latestJS);
      }

      if (currentUrl.contains("/movie/")) {
        if (serverToggle) {
          webViewController?.evaluateJavascript(source: '''
            var servers = document.querySelector('.TPlayerNv')
            var count = 1
            var isSel = false
            servers.childNodes.forEach(e => {
              e.style.backgroundColor = '#320039'
              // if (e.childNodes[0].innerText == 'Oyohd') {
              //   e.style.display = 'none'
              // }
              e.style.borderRadius = '10px'
              e.childNodes[1].style.fontSize = '9px'
              if (e.childNodes[0].innerText == 'Neohd') {
                e.click()
                isSel = true
              }
              // if (e.childNodes[0].innerText != 'Oyohd') {
                e.childNodes[0].innerText = "Server " + count
                count++
              // }
            })

            if (!isSel) {
              servers.childNodes[1].click()
              isSel = true
            }
            
          ''');
        }

        webViewController?.evaluateJavascript(source: '''
          var servers = document.querySelector('.TPlayerNv')
          document.querySelector('.Search').style.display = 'none'
          // servers.style.display = 'none'
          // document.querySelector('.TPlayerCn').style.display = 'none'
          document.querySelector('.Search').style.display = 'none'
          document.querySelector('.VotesCn').style.display = 'none'
          document.querySelector('.report-post-custom-link').style.display = 'none'
          document.querySelector('.AAIco-remove_red_eye').style.display = 'none'
           
          // document.querySelector('.Button.STPb.Current').style.backgroundColor = '#c701ee'
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

          document.body.style.background = 'linear-gradient(#0a000c, #000000)'
          var bg = document.querySelector('.TPostBg img').src
          var body = document.createElement('div')
          body.style.backgroundImage = 'url(' + bg + ')'
          body.style.width = '100vw'
          body.style.height = '60vh'
          body.style.position = 'absolute'
          body.style.top = '0'
          body.style.left = '0'
          body.style.backgroundRepeat = 'no-repeat'
          body.style.backgroundPosition = 'top'
          body.style.backgroundSize = 'cover'

          document.querySelector('.Objf').style.display = 'none'
          document.querySelector('.Image').style.display = 'none'
          
          if (document.querySelector('#movieGrad') == null) {
            var grad = document.createElement('div')
            grad.id = "movieGrad"
            grad.style.width = '100vw'
            grad.style.height = '100vh'
            grad.style.background = 'linear-gradient( transparent, #17001ca8, #14001de9, #0a000c, #0a000c, #000000, #000000, #000000, #000000)'

            body.appendChild(grad)
            document.body.appendChild(body)

            var desc = document.querySelector('.Description')
            desc.style.marginBottom = '-20px'
            var descri = document.querySelector('.Description p').innerText
            document.querySelector('.Description p').innerText = descri.split(',').slice(1).join()
            descri.style.margin = '20px 0'
          }

          document.querySelector('.Title').style.display = 'none'
          var sub = document.querySelector('.SubTitle')
          sub.style.fontSize = '24px'
          sub.style.lineHeight = '26px'
          sub.style.fontWeight = '800'
          sub.style.background = 'linear-gradient(120deg, #f782ff, #8000cf)'
          sub.style.backgroundClip = 'text'
          sub.style.webkitBackgroundClip = 'text'
          sub.style.color = 'transparent'
          sub.style.width = 'max-content'
          document.querySelector('.SubTitle').style.marginTop = '10vh'
          document.querySelector('.ClFx').style.paddingTop = '10px'
          document.querySelector('article').style.margin = '0'
          document.querySelector('article').style.padding = '0'

        ''');
      }

      if (currentUrl.contains("/serie/")) {
        webViewController?.evaluateJavascript(source: '''
            // var servers = document.querySelector('.TPlayerNv')
            document.querySelector('.Search').style.display = 'none'
            // servers.style.display = 'none'
            // document.querySelector('.TPlayerCn').style.display = 'none'
            document.querySelector('.Search').style.display = 'none'
            document.querySelector('.VotesCn').style.display = 'none'
            document.querySelector('.Qlty').style.display = 'none'
            
            document.querySelector('main').style.display = 'inherit'
            document.querySelector('article').style.display = 'inherit'
            document.querySelector('aside').style.display = 'none'
            document.querySelector('.Footer').style.display = 'none'
            // document.querySelector('.Wdgt').style.display = 'initial'

            document.querySelector('.TPost').style.background = 'transparent'
            document.querySelector('.TPost').style.backgroundColor = 'transparent'


            document.body.style.background = 'linear-gradient(#0a000c, #000000)'
            var bg = document.querySelector('.attachment-thumbnail').src
            console.log("posttttttttt ", bg)
            var body = document.createElement('div')
            body.style.backgroundImage = 'url(' + bg + ')'
            body.style.width = '100vw'
            body.style.height = '60vh'
            body.style.position = 'absolute'
            body.style.top = '0'
            body.style.left = '0'
            body.style.backgroundRepeat = 'no-repeat'
            body.style.backgroundPosition = 'top'
            body.style.backgroundSize = 'cover'

            document.querySelector('.Image').style.display = 'none'
            
            if (document.querySelector('#movieGrad') == null) {
              var grad = document.createElement('div')
              grad.id = "movieGrad"
              grad.style.width = '100vw'
              grad.style.height = '100vh'
              grad.style.background = 'linear-gradient( transparent, #17001ca8, #14001de9, #0a000c, #0a000c, #000000, #000000, #000000, #000000)'

              body.appendChild(grad)
              document.body.appendChild(body)

              var desc = document.querySelector('.Description')
              desc.style.marginBottom = '-20px'
              var descri = document.querySelector('.Description p').innerText
              console.log("desccccccccccccccccc", descri)
              document.querySelector('.Description p').innerText = descri.split(',').slice(1).join()
              descri.style.margin = '20px 0'
            }

            var title = document.querySelector('.Title')
            title.style.fontSize = '28px'
            title.style.lineHeight = '35px'
            title.style.fontWeight = '800'
            title.style.background = 'linear-gradient(120deg, #f782ff, #8000cf)'
            title.style.backgroundClip = 'text'
            title.style.webkitBackgroundClip = 'text'
            title.style.color = 'transparent'
            title.style.width = 'max-content'
            document.querySelector('.ClFx').style.paddingTop = '10px'
            document.querySelector('.Info').style.margin = '0'
            document.querySelector('article').style.margin = '20px 0'
            document.querySelector('article').style.padding = '20px'
            document.querySelector('article').style.marginTop = '20vh'
            document.querySelector('#addToWishList').style.margin = '20px 0 0 0'

            document.querySelector('.Wdgt').style.padding = '40px'


          ''');

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
          // document.querySelector('.Wdgt').style.display = 'none'
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
            var count = 1
            var isSel = false
            servers.childNodes.forEach(e => {
              e.style.backgroundColor = '#320039'
              // if (e.childNodes[0].innerText == 'Oyohd') {
              //   e.style.display = 'none'
              // }
              if (e.childNodes[0].innerText == 'Neohd') {
                e.click()
                isSel = true
              }
              // if (e.childNodes[0].innerText != 'Oyohd') {
                e.childNodes[0].innerText = "Server " + count
                count++
              // }
            })

            if (!isSel) {
              servers.childNodes[1].click()
              isSel = true
            }

            // servers.style.display = 'none'
            // document.querySelector('.TPlayerCn').style.display = 'none'
              
          ''');
        }

        webViewController?.evaluateJavascript(source: '''
          // var servers = document.querySelector('.TPlayerNv')
          document.querySelector('.Search').style.display = 'none'
          // servers.style.display = 'none'
          // document.querySelector('.TPlayerCn').style.display = 'none'
          document.querySelector('.Search').style.display = 'none'
          document.querySelector('.VotesCn').style.display = 'none'
          document.querySelector('.Qlty').style.display = 'none'
          
          document.querySelector('main').style.display = 'inherit'
          document.querySelector('article').style.display = 'inherit'
          document.querySelector('aside').style.display = 'none'
          document.querySelector('.Footer').style.display = 'none'
          // document.querySelector('.Wdgt').style.display = 'initial'

          document.querySelector('.TPost').style.background = 'transparent'
          document.querySelector('.TPost').style.backgroundColor = 'transparent'


          document.body.style.background = 'linear-gradient(#0a000c, #000000)'
          var bg = document.querySelector('.TpMvPlay img').src
          console.log("posttttttttt ", bg)
          var body = document.createElement('div')
          body.style.backgroundImage = 'url(' + bg + ')'
          body.style.width = '100vw'
          body.style.height = '60vh'
          body.style.position = 'absolute'
          body.style.top = '0'
          body.style.left = '0'
          body.style.backgroundRepeat = 'no-repeat'
          body.style.backgroundPosition = 'top'
          body.style.backgroundSize = 'cover'

          document.querySelector('.Image').style.display = 'none'
          
          if (document.querySelector('#movieGrad') == null) {
            var grad = document.createElement('div')
            grad.id = "movieGrad"
            grad.style.width = '100vw'
            grad.style.height = '100vh'
            grad.style.background = 'linear-gradient( transparent, #17001ca8, #14001de9, #0a000c, #0a000c, #000000, #000000, #000000, #000000)'

            body.appendChild(grad)
            document.body.appendChild(body)

            var desc = document.querySelector('.Description')
            desc.style.marginBottom = '20px'
            var descri = document.querySelector('.Description p').innerText
            console.log("desccccccccccccccccc", descri)
            document.querySelector('.Description p').innerText = descri.split(',').slice(1).join()
            descri.style.margin = '20px 0'
          }

          var title = document.querySelector('.Title')
          title.style.fontSize = '18px'
          title.style.lineHeight = '35px'
          title.style.fontWeight = '800'
          title.style.background = 'linear-gradient(120deg, #f782ff, #8000cf)'
          title.style.backgroundClip = 'text'
          title.style.webkitBackgroundClip = 'text'
          title.style.color = 'transparent'
          title.style.width = 'max-content'
          document.querySelector('.ClFx').style.paddingTop = '10px'
          document.querySelector('.Info').style.margin = '20px 0'
          document.querySelector('article').style.margin = '20px 0'
          document.querySelector('article').style.padding = '20px'
          document.querySelector('article').style.marginTop = '20vh'

          document.querySelector('.Wdgt').style.padding = '40px'

          document.querySelector('.ClB').style.border = '1px solid #610068'
          document.querySelector('.ClB').style.borderRadius = '7px'


        ''');

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

    webViewController?.addJavaScriptHandler(
        handlerName: 'homeHandler',
        callback: (args) async {
          // print("homeeeeeeeeeeee " + args[3]);
        });

    webViewController?.addJavaScriptHandler(
        handlerName: 'wishHandler',
        callback: (args) async {
          WebUri? uri = await webViewController?.getUrl();
          String? currentUrl = uri.toString();
          Movie movie = Movie(
              name: args[0] ?? "",
              photo: args[1] ?? "",
              language: args[2] ?? "",
              url: currentUrl,
              duration: args[4] ?? "",
              year: args[5] ?? "");

          await addToWishList(movie);
          wishList = await getWishList();
          await webViewController?.evaluateJavascript(source: removeWishJS);
        });

    webViewController?.evaluateJavascript(source: '''
      // document.body.style.pointerEvents = 'none';
      var posts = document.querySelectorAll('.NoBrdRa .TPost .Image figure img')
      posts.forEach(e => {
        e.setAttribute('style', "border-radius: 20px !important;")
      })
      document.getElementById('tr_live_search').setAttribute('style', "border-radius: 50px  !important;")


      document.documentElement.style.setProperty('-webkit-tap-highlight-color', 'transparent');
      document.body.style.background = 'linear-gradient(#13001c, #0a000c)'
      document.body.style.backgroundAttachment = 'fixed'
      // document.body.style.backgroundColor = 'transparent'
      document.body.style.color = 'white'
      
      document.querySelector('.Content').style.background = 'transparent'
      document.querySelector('.Content').style.backgroundColor = 'transparent'
      document.querySelector('.Header').style.display = 'none'
      document.querySelector('.Footer').style.display = 'none'

      var az = document.querySelector('.AZList')
      if (az != null) {
        az.style.display = 'none'
      }

      document.querySelector('.Top').style.display = 'flex'
      document.querySelector('.Top').style.alignItems = 'center'
      document.querySelector('.Top').style.marginTop = '60vh'

      var pg = document.querySelectorAll('.page-numbers')
      if (pg != null) {
        pg.forEach(e => {
          e.style.color = '#f9b8ffda'
          e.style.fontWeight = '400'
          e.style.backgroundColor = '#000000'
          e.style.fontSize = 'small'
          e.style.minWidth = '35px'
          e.style.margin = '0px'
          e.style.borderRadius = '3px'
        })
      }
      document.querySelector('.current').style.backgroundColor = '#3c0041'

      var result = document.querySelector('.Result')
      result.style.background = "linear-gradient(120deg, #13001c, #0a000c)"
      result.style.borderTop = 'none'
      result.style.borderRadius = '10px'
      result.style.width = '91%'
      result.style.marginRight = '5%'
      if (result.classList.contains('On')) {
        console.log("yess")
        result.querySelector('a.Button').style.backgroundColor = '#370039c9'
      }
      console.log("yess end")
      // document.querySelector('.Button').style.backgroundColor = '#370039c9'
      var pzew = document.querySelector('.pzeWz')
      if (pzew) {
        pzew.style.display = 'none'
      }
      var curr = document.querySelector('.Button.STPb.Current')
      if (curr != null) {
        curr.style.backgroundColor = '#8d0092'
      }
      
      var no = document.querySelector('.Title-404')
      if (no != null) {
        no.style.fontSize = '20px'
        no.style.fontWeight = '400'
      }
      var pop = document.querySelector('.-o50L') 
      if (pop != null) {
        pop.style.display = 'none'
      }
      var pop2 = document.querySelector('.pzeWz')
      if (pop2 != null) {
        pop2.style.display = 'none'
      }
      var obj = document.querySelectorAll('.Objf')
      if (obj != null) {
        obj.forEach(e => e.style.borderRadius = '20px !important')
      }
      
    ''');
    updateNav();

    void nav(int index) {
      webViewController?.stopLoading();
      setState(() {
        currentIndex = index;
      });

      String urlChange = currentIndex == 0
          ? urlHome
          : currentIndex == 1
              ? urlLatest
              : "";
      if (currentIndex < 2) {
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
        if (currentIndex > 1) {
          setState(() {
            currentIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
            // iconSize: 30,
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
                  Icons.playlist_play_rounded,
                ),
                activeIcon: Icon(
                  Icons.playlist_play_rounded,
                ),
                label: "Watchlist",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.translate_outlined,
                ),
                activeIcon: Icon(
                  Icons.translate_rounded,
                ),
                label: "Language",
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
                    // useHybridComposition: true,
                    hardwareAcceleration: true,
                    useShouldOverrideUrlLoading: true,
                  ),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    final uri = navigationAction.request.url!;
                    // print('hostttttTTTTTTTTTTT' + uri.host);
                    var whiteList = ["www.bolly2tolly.land"];
                    if (whiteList.contains(uri.host)) {
                      return NavigationActionPolicy.ALLOW;
                    }
                    return NavigationActionPolicy.CANCEL;
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
                  onPageCommitVisible: (controller, url) async {
                    // WebUri? uri = await controller.getUrl();
                    // String? currentUrl = uri.toString();
                    // if (currentUrl.contains("/movie/") ||
                    //     currentUrl.contains("/episode/")) {
                    setState(() {
                      serverToggle = true;
                    });
                    await Future.delayed(
                      const Duration(seconds: 5),
                      () {
                        setState(() {
                          serverToggle = false;
                        });
                      },
                    );
                    // }
                  },
                  onTitleChanged: (controller, title) async {
                    WebUri? uri = await webViewController?.getUrl();
                    String? url = uri.toString();
                    if (url.contains("/movie/") || url.contains("/serie/")) {
                      if (wishList.isNotEmpty) {
                        bool movieExists = wishList.any((movie) {
                          // print("existtttttttttttttt" + movie.url);
                          return movie.url == url;
                        });
                        // print("existtttttttttttttt" + movieExists.toString());

                        if (!movieExists) {
                          await webViewController?.evaluateJavascript(
                              source: wishJS);
                          // print("existtttttttttttttt DONE ");
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
                  // onEnterFullscreen: (controller) {
                  //   setState(() {
                  //     serverToggle = false;
                  //   });
                  // },
                ),
                currentIndex == 2
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 20),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "Watchlist",
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
                                              30,
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
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2) -
                                                    30,
                                                height: 250,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(15)),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        movie.photo),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                child: Container(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  decoration: const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15)),
                                                      gradient: LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            Color.fromARGB(
                                                                70, 66, 0, 97),
                                                            Color.fromARGB(
                                                                255, 19, 0, 21)
                                                          ])),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
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
                                                                        TextOverflow
                                                                            .ellipsis),
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
                                                                  movie.year,
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
                                                await removeFromWishList(movie);
                                                List<Movie> updatedWishlist =
                                                    await getWishList();
                                                setState(() {
                                                  wishList = updatedWishlist;
                                                });
                                              },
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  margin:
                                                      const EdgeInsets.all(8),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      color:
                                                          const Color
                                                              .fromARGB(95, 29,
                                                              0, 33),
                                                      border:
                                                          Border.all(
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
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height -
                                              200,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                        ),
                      )
                    : const SizedBox(),
                currentIndex == 3
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.only(top: 50),
                        alignment: Alignment.topCenter,
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
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      height: 120,
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
