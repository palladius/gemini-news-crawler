
# require_relative '../_env_gaic.rb'

ProgVersion = '0.2'

CHANGELOG = {
  '0.1': 'initial stesure.',
  '0.2': 'integrating with Rails app. Adding more 2-level news',
}

NEWS_BY_REGION ={
  'Italy': {
    ########################################################################################################
    # Best italian RSSs: https://www.internetto.it/lista-aggiornata-dei-migliori-feed-rss-italiani/
    ########################################################################################################
    # Example from https://github.com/feedjira/feedjira
    'Repubblica - Home': 'https://www.repubblica.it/rss/homepage/rss2.0.xml', # homepage
    'Repubblica - Esteri': 'https://www.repubblica.it/rss/esteri/rss2.0.xml', # esteri
    'Il Fatto': 'https://www.ilfattoquotidiano.it/feed/', # generic
    # See more here: https://www.adnkronos.com/rss
    'AdKronos - Primapagina': 'https://www.adnkronos.com/RSS_PrimaPagina.xml',
    'AdKronos - Ultim ora': 'https://www.adnkronos.com/RSS_Ultimora.xml',
    # Ansa https://www.ansa.it/sito/static/ansa_rss.html
    'Ansa - all': 'https://www.ansa.it/sito/ansait_rss.xml',
    'Ansa - Mondo News': 'https://www.ansa.it/sito/notizie/mondo/mondo_rss.xml',
    # Corriere meta RSS: https://www.corriere.it/rss/
    'Corriere - Home': 'https://xml2.corriereobjects.it/rss/homepage.xml',
    'Google News - Italian': 'https://news.google.com/rss?hl=it&gl=IT&ceid=IT:it',
    # US English
    'Google News - US': 'https://news.google.com/rss?hl=en-US&gl=US&ceid=US:en',
    #######################
  },
  'Europe': {
    'BCC Europe': 'https://feeds.bbci.co.uk/news/world/europe/rss.xml',
    'BBC Science': 'https://feeds.bbci.co.uk/news/science_and_environment/rss.xml',
    'BBC Politics': 'https://feeds.bbci.co.uk/news/politics/rss.xml',
    'BBC Science and Environment': 'https://feeds.bbci.co.uk/news/science_and_environment/rss.xml',
    # seems fishy but: https://www.ajplus.net/stories?format=rss
    'Al Jazeera - News': 'https://www.aljazeera.com/xml/rss/all.xml',
    'CNN money': 'http://rss.cnn.com/rss/money_latest.rss',
    #'CNN Worls HTML': 'https://edition.cnn.com/world',


    # Copied frm here: https://rss.feedspot.com/european_news_rss_feeds/
    'Politico EU': 'https://www.politico.eu/feed/',
    'Feedburner Euronews': 'https://feeds.feedburner.com/euronews/en/home/',
    # add more if nice.
  },
  'USA': {    # WOWOWOW    # https://about.fb.com/wp-content/uploads/2016/05/rss-urls-1.pdf
    'ABC News: US': 'http://feeds.abcnews.com/abcnews/usheadlines',
    'CNN.com Top Stories': 'http://rss.cnn.com/rss/cnn_topstories.rss',
    'CBSNews.com': 'http://www.cbsnews.com/latest/rss/main',

    # NYT RSS: https://www.nytimes.com/rss
    'NYT - World': 'https://rss.nytimes.com/services/xml/rss/nyt/World.xml',
    'NYT - Europe': 'https://rss.nytimes.com/services/xml/rss/nyt/Europe.xml',
    'NYT - Business and Economy': 'https://rss.nytimes.com/services/xml/rss/nyt/Economy.xml',
    # NYT Jobs: https://rss.nytimes.com/services/xml/rss/nyt/Jobs.xml
    # /NYT

    # WSJ: https://www.wsj.com/news/rss-news-and-feeds
    'WallStreetJournal - World': 'https://feeds.a.dj.com/rss/RSSWorldNews.xml',
    'WallStreetJournal - Markets': 'https://feeds.a.dj.com/rss/RSSMarketsMain.xml',
    # /WSJ: https://www.wsj.com/news/rss-news-and-feeds

    'The Christian Science Monitor': 'http://rss.csmonitor.com/feeds/usa',
    'NBC News - Top Stories': 'http://feeds.nbcnews.com/feeds/topstories',
    'NBC News - World': 'http://feeds.nbcnews.com/feeds/worldnews',
    # 'US general10': 'http://feeds.reuters.com/Reuters/worldNews',
    # 'US general11': 'http://feeds.reuters.com/Reuters/domesticNews',
    # 'US general12': 'http://hosted.ap.org/lineups/USHEADS.rss',
    # 'US general13': 'http://hosted.ap.org/lineups/WORLDHEADS.rss',
    'US general14': 'http://www.huffingtonpost.com/feeds/verticals/world/index.xml',
    'US general15': 'http://feeds.bbci.co.uk/news/world/us_and_canada/rss.xml',
    'US general16': 'http://news.yahoo.com/rss/us',
    'US general17': 'http://rss.news.yahoo.com/rss/world',

    #  'US general19': 'http://feeds.feedburner.com/thedailybeast/articles',
    #'US general20': 'http://qz.com/feed', # lags
    'US general21': 'http://www.theguardian.com/world/usa/rss',
    'Politico': 'http://www.politico.com/rss/politicopicks.xml',
    'The NewYorker': 'http://www.newyorker.com/feed/news',
    'Nation – PBS NewsHour': 'http://feeds.feedburner.com/NationPBSNewsHour',
    'World – PBS NewsHour': 'http://feeds.feedburner.com/NewshourWorld',
#    'US general26': 'http://www.usnews.com/rss/news',
#'US general29': 'http://feeds.feedburner.com/AtlanticNational',
    'US - The Atlantic': 'http://feeds.feedburner.com/TheAtlanticWire',
    'US - LA Times Nation': 'http://www.latimes.com/nation/rss2.0.xml',
    'US - LA Times World': 'http://www.latimes.com/world/rss2.0.xml',
    'US - Vice': 'https://news.vice.com/rss',
    'US - Salon': 'http://www.salon.com/category/news/feed/rss/',
    'US - Time': 'http://time.com/newsfeed/feed/',
    'US - Fox News': 'http://feeds.foxnews.com/foxnews/latest?format=xml',
  },
  'Blogs': {
    'Riccardo Carlesso - Blog':   'https://ricc.rocks/en/index.xml',
    'Riccardo Carlesso - Medium': 'https://medium.com/feed/@palladiusbonton', # both this..
    'Romin Irani - Medium':       'https://iromin.medium.com/feed',           # .. and this work
    'Guillaume Laforge - Medium':       'https://glaforge.medium.com/feed',           # .. and this work
    'Marc Cohen - Medium':        'https://marcacohen.medium.com/feed',
# 🕷️ 6  Crawling RSS Feed from: Laurent Picard - Medium # https://PicardParis.medium.com/feed❌ Some issues with parsing https://PicardParis.medium.com/feed:
# 🕷️ 7  Crawling RSS Feed from: Aja Hammerly - Medium # https://thagomizer.medium.com/feed❌ Some issues with parsing https://thagomizer.medium.com/feed:
    #'Laurent Picard - Medium':        'https://PicardParis.medium.com/feed',
    #'Aja Hammerly - Medium':        'https://thagomizer.medium.com/feed',
    'Richard Seroter Blog':       'https://seroter.com/feed/',
    'Google Cloud - Medium':      'https://medium.com/feed/google-cloud',
  },
  'Technology': {
    'GCP latest releases':        'https://cloud.google.com/feeds/gcp-release-notes.xml',
    'Google Cloud Blog': 'https://cloudblog.withgoogle.com/rss/',
    'Ruby (EN RSS)':  'https://www.ruby-lang.org/en/feeds/news.rss',
    'Ruby (English)':  'https://www.ruby-lang.org/en/',
    'Ruby (Italian)':  'https://www.ruby-lang.org/it/',

    # Ruby RSS from https://rss.feedspot.com/ruby_on_rails_rss_feeds/
    'Ruby on Rails': 'https://rubyonrails.org/feed.xml',
    'Ruby Flow': 'https://rubyflow.com/rss',
    'Everyday Rails': 'http://feeds.feedburner.com/EverydayRails',
    'Drifitng ruby': 'https://www.driftingruby.com/episodes/feed.atom',
    'Kevin Randles on Medium': 'https://medium.com/feed/@krandles',
    #/Ruby
  }
}

NewsFeedback = {
  technology: [
    # These works
    'https://it.wikipedia.org/wiki/',
    'http://www.latimes.com/',
    # from feedbag
    'https://daringfireball.net',
    #'https://kottke.org', SLOW
    #"http://planet.debian.org/", # oh wow so many
    #"http://ve.planetalinux.org",
    "cnn.com",

    # These Do NOT work
    'https://www.repubblica.it',
    'http://time.com/',
    'http://www.bbc.com/',
    'http://www.cnn.com/',
    'https://www.bbc.com/',
    'https://www.cnn.com/',
    # personal
    'http://ricc.rocks',
    'https://ricc.rocks',
    'ricc.rocks',
    #'www.palladius.it',
    #'https://www.linkedin.com/in/riccardocarlesso/',
    'http://opentomeraviglia.app/',
  ]
}
