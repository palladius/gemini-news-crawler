
ProgVersion = '0.1'

CHANGELOG = {
  '0.1': 'initial stesure.'
}
NEWS ={
  'italy': {
    ########################################################################################################
    # Best italian RSSs: https://www.internetto.it/lista-aggiornata-dei-migliori-feed-rss-italiani/
    ########################################################################################################
    # Example from https://github.com/feedjira/feedjira
    #'Earthquakes': 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_week.atom',
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
    'Riccardo - Blog': 'https://ricc.rocks/en/index.xml',
#######################
#  'Europe': {

    'BCC Europe': 'https://feeds.bbci.co.uk/news/world/europe/rss.xml',
    'BBC Science': 'https://feeds.bbci.co.uk/news/science_and_environment/rss.xml',
    'BBC Politics': 'https://feeds.bbci.co.uk/news/politics/rss.xml',
    'BBC Science and Environment': 'https://feeds.bbci.co.uk/news/science_and_environment/rss.xml',
    # seems fishy but: https://www.ajplus.net/stories?format=rss
    'Al Jazeera - News': 'https://www.aljazeera.com/xml/rss/all.xml',
    'CNN money': 'http://rss.cnn.com/rss/money_latest.rss',
    #'CNN Worls HTML': 'https://edition.cnn.com/world',

#  },
#  'US Genera l': {  # WOWOWOW    # https://about.fb.com/wp-content/uploads/2016/05/rss-urls-1.pdf
# BROKEN 'riccardo CNN': 'https://rss.app/feed/0Up7DBlFK2DIbtl1',
    'US general1': 'http://feeds.abcnews.com/abcnews/usheadlines',
    'US general2': 'http://rss.cnn.com/rss/cnn_topstories.rss',
    'US general3': 'http://www.cbsnews.com/latest/rss/main',
#    'US general4': 'http://www.nytimes.com/services/xml/rss/nyt/National.xml',
#    'US general5': 'http://online.wsj.com/xml/rss/3_7085.xml',
#    'US general6': 'http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=news2',
    'US general7': 'http://rss.csmonitor.com/feeds/usa',
    'US general8': 'http://feeds.nbcnews.com/feeds/topstories',
    'US general9': 'http://feeds.nbcnews.com/feeds/worldnews',
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
#    'US general22': 'http://www.politico.com/rss/politicopicks.xml',
    'US general23': 'http://www.newyorker.com/feed/news',
    'US general24': 'http://feeds.feedburner.com/NationPBSNewsHour',
    'US general25': 'http://feeds.feedburner.com/NewshourWorld',
#    'US general26': 'http://www.usnews.com/rss/news',
    'US general29': 'http://feeds.feedburner.com/AtlanticNational',
    'US general30': 'http://feeds.feedburner.com/TheAtlanticWire',
    'US general31': 'http://www.latimes.com/nation/rss2.0.xml',
    'US general32': 'http://www.latimes.com/world/rss2.0.xml',
    'US general34': 'https://news.vice.com/rss',
    'US general36': 'http://www.salon.com/category/news/feed/rss/',
    'US general37': 'http://time.com/newsfeed/feed/',
    'US general38': 'http://feeds.foxnews.com/foxnews/latest?format=xml',

  },

}

NewsFeedback = {
  technology: [
    # These works
    'https://www.ruby-lang.org/en/',
    'https://www.ruby-lang.org/it/',
    'https://it.wikipedia.org/wiki/',
    'http://www.latimes.com/',
    # from feedbag
    'https://daringfireball.net',
    #'https://kottke.org', SLOW
    #"http://planet.debian.org/", # oh wow so many
    "http://ve.planetalinux.org",
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
