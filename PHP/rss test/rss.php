<?php
#include('config.php');

/*  Free php RSS to Content v1.0
    By johnedwardsproperties.com
	Free to use, please acknowledge me 
    
    Place the URL of an RSS feed in the $URL_1 variable.
	If you have additional RSS feeds place them into $URL_2 - $URL_5
	The script will combines all the feeds together and shuffles the listings
	
	Change item_limit to limit number of listings displayed
	
	Add <?php include("rss.php"); ?> where you want the feeds to display
*/
#$keywords1 = str_replace(" ", "%20", $keywords);

$URL_1 = "http://productionadvice.co.uk/feed/";
#$URL_2 = "http://www.articlesnatch.com/rss2/$keywords1";
#$URL_3 = "http://news.google.co.uk/news?hl=en&tab=wn&ned=uk&q=$keywords1&ie=UTF-8&output=rss";
$URL_4 = "";
$URL_5 = "";

/*
Change this to limit number of listings displayed
*/
$item_limit = 10;

?>

<?php $_F=__FILE__;$_X='Pz48P3BocA0KNXJyMnJfcjVwMnJ0NG5nKDApOw0KDQpmM25jdDQybiBzdDFydEVsNW01bnQoJHAxcnM1ciwgJG4xbTUsICQxdHRycykgew0KICAgCWdsMmIxbCAkcnNzX2NoMW5uNWwsICRjM3JyNW50bHlfd3I0dDRuZywgJG0xNG47DQogICAJc3c0dGNoKCRuMW01KSB7DQogICAJCWMxczUgIlJTUyI6DQogICAJCWMxczUgIlJERjpSREYiOg0KICAgCQljMXM1ICJJVEVNUyI6DQogICAJCQkkYzNycjVudGx5X3dyNHQ0bmcgPSAiIjsNCiAgIAkJCWJyNTFrOw0KICAgCQljMXM1ICJDSEFOTkVMIjoNCiAgIAkJCSRtMTRuID0gIkNIQU5ORUwiOw0KICAgCQkJYnI1MWs7DQogICAJCWMxczUgIklNQUdFIjoNCiAgIAkJCSRtMTRuID0gIklNQUdFIjsNCiAgIAkJCSRyc3NfY2gxbm41bFsiSU1BR0UiXSA9IDFycjF5KCk7DQogICAJCQlicjUxazsNCiAgIAkJYzFzNSAiSVRFTSI6DQogICAJCQkkbTE0biA9ICJJVEVNUyI7DQogICAJCQlicjUxazsNCiAgIAkJZDVmMTNsdDoNCiAgIAkJCSRjM3JyNW50bHlfd3I0dDRuZyA9ICRuMW01Ow0KICAgCQkJYnI1MWs7DQogICAJfQ0KfQ0KDQpmM25jdDQybiA1bmRFbDVtNW50KCRwMXJzNXIsICRuMW01KSB7DQogICAJZ2wyYjFsICRyc3NfY2gxbm41bCwgJGMzcnI1bnRseV93cjR0NG5nLCAkNHQ1bV9jMjNudDVyOw0KICAgCSRjM3JyNW50bHlfd3I0dDRuZyA9ICIiOw0KICAgCTRmICgkbjFtNSA9PSAiSVRFTSIpIHsNCiAgIAkJJDR0NW1fYzIzbnQ1cisrOw0KICAgCX0NCn0NCg0KZjNuY3Q0Mm4gY2gxcjFjdDVyRDF0MSgkcDFyczVyLCAkZDF0MSkgew0KCWdsMmIxbCAkcnNzX2NoMW5uNWwsICRjM3JyNW50bHlfd3I0dDRuZywgJG0xNG4sICQ0dDVtX2MyM250NXI7DQoJNGYgKCRjM3JyNW50bHlfd3I0dDRuZyAhPSAiIikgew0KCQlzdzR0Y2goJG0xNG4pIHsNCgkJCWMxczUgIkNIQU5ORUwiOg0KCQkJCTRmICg0c3M1dCgkcnNzX2NoMW5uNWxbJGMzcnI1bnRseV93cjR0NG5nXSkpIHsNCgkJCQkJJHJzc19jaDFubjVsWyRjM3JyNW50bHlfd3I0dDRuZ10gLj0gJGQxdDE7DQoJCQkJfSA1bHM1IHsNCgkJCQkJJHJzc19jaDFubjVsWyRjM3JyNW50bHlfd3I0dDRuZ10gPSAkZDF0MTsNCgkJCQl9DQoJCQkJYnI1MWs7DQoJCQljMXM1ICJJTUFHRSI6DQoJCQkJNGYgKDRzczV0KCRyc3NfY2gxbm41bFskbTE0bl1bJGMzcnI1bnRseV93cjR0NG5nXSkpIHsNCgkJCQkJJHJzc19jaDFubjVsWyRtMTRuXVskYzNycjVudGx5X3dyNHQ0bmddIC49ICRkMXQxOw0KCQkJCX0gNWxzNSB7DQoJCQkJCSRyc3NfY2gxbm41bFskbTE0bl1bJGMzcnI1bnRseV93cjR0NG5nXSA9ICRkMXQxOw0KCQkJCX0NCgkJCQlicjUxazsNCgkJCWMxczUgIklURU1TIjoNCgkJCQk0ZiAoNHNzNXQoJHJzc19jaDFubjVsWyRtMTRuXVskNHQ1bV9jMjNudDVyXVskYzNycjVudGx5X3dyNHQ0bmddKSkgew0KCQkJCQkkcnNzX2NoMW5uNWxbJG0xNG5dWyQ0dDVtX2MyM250NXJdWyRjM3JyNW50bHlfd3I0dDRuZ10gLj0gJGQxdDE7DQoJCQkJfSA1bHM1IHsNCgkJCQkJLy9wcjRudCAoInJzc19jaDFubjVsWyRtMTRuXVskNHQ1bV9jMjNudDVyXVskYzNycjVudGx5X3dyNHQ0bmddID0gJGQxdDE8YnI+Iik7DQoJCQkJCSRyc3NfY2gxbm41bFskbTE0bl1bJDR0NW1fYzIzbnQ1cl1bJGMzcnI1bnRseV93cjR0NG5nXSA9ICRkMXQxOw0KCQkJCX0NCgkJCQlicjUxazsNCgkJfQ0KCX0NCn0NCg0KDQpmM25jdDQybiAgZzV0X3JzcygkZjRsNSwgJGQxdDEpDQp7DQoNCgkkeG1sX3AxcnM1ciA9IHhtbF9wMXJzNXJfY3I1MXQ1KCcnKTsNCgl4bWxfczV0XzVsNW01bnRfaDFuZGw1cigkeG1sX3AxcnM1ciwgInN0MXJ0RWw1bTVudCIsICI1bmRFbDVtNW50Iik7DQoJeG1sX3M1dF9jaDFyMWN0NXJfZDF0MV9oMW5kbDVyKCR4bWxfcDFyczVyLCAiY2gxcjFjdDVyRDF0MSIpOw0KCTRmICghKCRmcCA9IGYycDVuKCRmNGw1LCAiciIpKSkgew0KCQlkNDUoImMyM2xkIG4ydCAycDVuIFhNTCA0bnAzdCIpOw0KCX0NCgkNCgl3aDRsNSAoJGQxdDEgPSBmcjUxZCgkZnAsIHUwOWUpKSB7DQoJCTRmICgheG1sX3AxcnM1KCR4bWxfcDFyczVyLCAkZDF0MSwgZjUyZigkZnApKSkgew0KCQkJZDQ1KHNwcjRudGYoIlhNTCA1cnIycjogJXMgMXQgbDRuNSAlZCIsDQoJCQkJCQl4bWxfNXJyMnJfc3RyNG5nKHhtbF9nNXRfNXJyMnJfYzJkNSgkeG1sX3AxcnM1cikpLA0KCQkJCQkJeG1sX2c1dF9jM3JyNW50X2w0bjVfbjNtYjVyKCR4bWxfcDFyczVyKSkpOw0KCQl9DQoJfQ0KCXhtbF9wMXJzNXJfZnI1NSgkeG1sX3AxcnM1cik7DQoNCn0NCg0KZjNuY3Q0Mm4gZzV0X3Q1c3QoJGY0bDUsICRkMXQxKQ0Kew0KCSR4bWxfcDFyczVyID0geG1sX3AxcnM1cl9jcjUxdDUoJycpOw0KCXhtbF9zNXRfNWw1bTVudF9oMW5kbDVyKCR4bWxfcDFyczVyLCAic3QxcnRFbDVtNW50IiwgIjVuZEVsNW01bnQiKTsNCgl4bWxfczV0X2NoMXIxY3Q1cl9kMXQxX2gxbmRsNXIoJHhtbF9wMXJzNXIsICJjaDFyMWN0NXJEMXQxIik7DQoJDQoJNGYgKCEoJGZwID0gZjJwNW4oJGY0bDUsICJyIikpKSB7DQoJCQlkNDUoImMyM2xkIG4ydCAycDVuIFhNTCA0bnAzdCIpOw0KCQl9IDVsczUgew0KCQkJLy81Y2gyKCIyayIpOw0KCX0NCgkNCgkJd2g0bDUgKCRkMXQxID0gZnI1MWQoJGZwLCB1MDllKSkgew0KCQk0ZiAoIXhtbF9wMXJzNSgkeG1sX3AxcnM1ciwgJGQxdDEsIGY1MmYoJGZwKSkpIHsNCgkJCWQ0NShzcHI0bnRmKCJYTUwgNXJyMnI6ICVzIDF0IGw0bjUgJWQiLA0KCQkJCQkJeG1sXzVycjJyX3N0cjRuZyh4bWxfZzV0XzVycjJyX2MyZDUoJHhtbF9wMXJzNXIpKSwNCgkJCQkJCXhtbF9nNXRfYzNycjVudF9sNG41X24zbWI1cigkeG1sX3AxcnM1cikpKTsNCgkJfQ0KCX0NCgl4bWxfcDFyczVyX2ZyNTUoJHhtbF9wMXJzNXIpOw0KfQ0KDQpzNXRfdDRtNV9sNG00dCgwKTsNCiRyc3NfY2gxbm41bCA9IDFycjF5KCk7DQokYzNycjVudGx5X3dyNHQ0bmcgPSAiIjsNCiRtMTRuID0gIiI7DQokNHQ1bV9jMjNudDVyID0gMDsNCg0KNGYoITVtcHR5ICgkVVJMXzYpKQ0KCWc1dF90NXN0KCRVUkxfNiwgJGQxdDEpOw0KCQ0KNGYoITVtcHR5ICgkVVJMX2EpKQ0KCWc1dF90NXN0KCRVUkxfYSwgJGQxdDEpOw0KCQ0KNGYoITVtcHR5ICgkVVJMX28pKQ0KCWc1dF90NXN0KCRVUkxfbywgJGQxdDEpOw0KCQ0KNGYoITVtcHR5ICgkVVJMX3UpKQ0KCWc1dF90NXN0KCRVUkxfdSwgJGQxdDEpOw0KCQ0KNGYoITVtcHR5ICgkVVJMX2kpKQ0KCWc1dF90NXN0KCRVUkxfaSwgJGQxdDEpOw0KDQoNCg0KDQoNCg0KZjJyKCQ0ID0gMDskNCA8IGMyM250KCRyc3NfY2gxbm41bFsiSVRFTVMiXSk7JDQrKykgew0KCSRyc3NfNHQ1bVskNF0gPSAkNDsNCn0NCg0Kc2gzZmZsNSgkcnNzXzR0NW0pOw0KDQoJCQ0KDQoNCjRmICg0c3M1dCgkcnNzX2NoMW5uNWxbIklURU1TIl0pKSB7DQoJNGYgKGMyM250KCRyc3NfY2gxbm41bFsiSVRFTVMiXSkgPiAwKSB7DQoJCWYycigkNCA9IDA7JDQgPCBjMjNudCgkcnNzX2NoMW5uNWxbIklURU1TIl0pOyQ0KyspIHsNCgkJCTVjaDIoIjxwPiIgKTsNCgkJCTVjaDIoIjwxIGhyNWY9XCIiKTsNCgkJCTVjaDIoJHJzc19jaDFubjVsWyJJVEVNUyJdWyRyc3NfNHQ1bVskNF1dWyJMSU5LIl0pOw0KCQkJNWNoMigiXCIgdDFyZzV0PSdfYmwxbmsnIHI1bD1cIm4yZjJsbDJ3XCI+Iik7DQoJCQk1Y2gyKCRyc3NfY2gxbm41bFsiSVRFTVMiXVskcnNzXzR0NW1bJDRdXVsiVElUTEUiXSk7DQoJCQk1Y2gyKCI8LzE+Iik7DQoJCQk1Y2gyKCI8YnIgLz4iKTsNCgkJCTVjaDIoJHJzc19jaDFubjVsWyJJVEVNUyJdWyRyc3NfNHQ1bVskNF1dWyJERVNDUklQVElPTiJdKTsNCgkJCTVjaDIoIjwvcD4iKTsNCgkJCTRmKCQ0ID49ICQ0dDVtX2w0bTR0KSAkNCA9IGMyM250KCRyc3NfY2gxbm41bFsiSVRFTVMiXSk7DQoJCX0NCgl9DQp9DQoNCg0KJEw0bmtbXSA9ICJBbm4xcDJsNHMgUjUxbCBFc3QxdDUiOw0KJEw0bmtbXSA9ICJBbm4xcDJsNHMgTUQgUjUxbCBFc3QxdDUiOw0KJEw0bmtbXSA9ICJSNTFsIEVzdDF0NSA0biBBbm4xcDJsNHMgTUQiOw0KJEw0bmtbXSA9ICJBbm4xcDJsNHMgTTFyeWwxbmQgUjUxbCBFc3QxdDUiOw0KJEw0bmtbXSA9ICJSNTFsIEVzdDF0NSA0biBBbm4xcDJsNHMiOw0KJEw0bmtbXSA9ICJBbm4xcDJsNHMgUjUxbCBFc3QxdDUgZjJyIFMxbDUiOw0KJEw0bmtbXSA9ICJSNTFsIEVzdDF0NSA0biBBbm4xcDJsNHMgTTFyeWwxbmQiOw0KJEw0bmtbXSA9ICJBbm4xcDJsNHMgUjUxbCBFc3QxdDUgTDRzdDRuZ3MiOw0KJEw0bmtbXSA9ICJBbm4xcDJsNHMgTUQgUjUxbCBFc3QxdDUgZjJyIFMxbDUiOw0KJEw0bmtbXSA9ICJBbm4xcDJsNHMgSDJtNXMgZjJyIFMxbDUiOw0KJEw0bmtbXSA9ICJBbm4xcDJsNHMgSDJtNXMiOw0KJEw0bmtbXSA9ICJIMm01cyBmMnIgUzFsNSA0biBBbm4xcDJsNHMiOw0KJEw0bmtbXSA9ICJIMm01cyA0biBBbm4xcDJsNHMiOw0KJEw0bmtbXSA9ICJBbm4xcDJsNHMgSDIzczVzIGYyciBTMWw1IjsNCiRMNG5rW10gPSAiQW5uMXAybDRzIEgyM3M1cyI7DQokTDRua1tdID0gIkFubjFwMmw0cyBQcjJwNXJ0NDVzIjsNCiRMNG5rW10gPSAiQW5uMXAybDRzIE1EIEgybTVzIjsNCiRMNG5rW10gPSAiQW5uMXAybDRzIE1EIEgybTVzIGYyciBTMWw1IjsNCiRMNG5rW10gPSAiQW5uMXAybDRzIE0xcnlsMW5kIEgybTVzIjsNCiRMNG5rW10gPSAiQW5uMXAybDRzIFI1MWwgRXN0MXQ1IDFuZCBIMm01cyBmMnIgUzFsNSI7DQoNCnNoM2ZmbDUoJEw0bmspOw0KDQpzcjFuZCh0NG01KCkpOw0KJHIxbmQybSA9IChyMW5kKCklNjAwKTsNCg0KJFRoNVQ1eHQgPSAkTDRua1swXTsNCg0KNGYoJHIxbmQybSA+PSBhaSkNCnsNCiRUaDVUNXh0ID0gIkFubjFwMmw0cyBSNTFsIEVzdDF0NSI7DQp9DQoNCiRUaDVUNXh0ID0gIkFubjFwMmw0cyBSNTFsIEVzdDF0NSI7DQoNCi8vNWNoMigiPHA+PDEgaHI1Zj0naHR0cDovL3d3dy5qMmhuNWR3MXJkc3ByMnA1cnQ0NXMuYzJtJz5Bbm4xcDJsNHMgUjUxbCBFc3QxdDU8LzE+PGJyIC8+SjJobkVkdzFyZHNQcjJwNXJ0NDVzLmMybSA0cyBiMXM1ZCA0biBBbm4xcDJsNHMuIEl0IGgxcyA1djVyeXRoNG5nIGYyciBiMnRoIGIzeTVycyAxbmQgczVsbDVycyBzdDFydDRuZyB0aDU0ciBoMm01IHM1MXJjaCA0bmNsM2Q0bmcgMSBmcjU1IE1MUyBzNTFyY2guIEl0IGMybnQxNG5zIDV4dDVuczR2NSA0bmYycm0xdDQybiAybiA8MSBocjVmPSdodHRwOi8vd3d3LmoyaG41ZHcxcmRzcHIycDVydDQ1cy5jMm0vQW5uNUFyM25kNWxDMjNudHkucGhwJz5BQTwvMT4sIDwxIGhyNWY9J2h0dHA6Ly93d3cuajJobjVkdzFyZHNwcjJwNXJ0NDVzLmMybS9QcjRuYzVHNTJyZzVzQzIzbnR5LnBocCc+UEc8LzE+IDFuZCA8MSBocd3d3LmoyaG41ZHcxcmRzcHIycDVydDQ1cy5jMm0vTTJudGcybTVyeUMyM250eS5waHAnPk1HPC8xPiBjMjNudHkgcjUxbCA1c3QxdDUgMW5kIDJ0aDVyIHByMnA1cnQ0NXMgNG4gdGg1IHI1ZzQybi48L3A+Iik7DQoNCg0KNWNoMigiPHAgMWw0Z249J2M1bnQ1cic+RzVuNXIxdDVkIGJ5IDwxIGhyNWY9J2h0dHA6Ly93d3cuajJobjVkdzFyZHNwcjJwNXJ0NDVzLmMybS9GcjU1UEhQUlNTdDJDMm50NW50LnBocCc+RnI1NSBQSFAgUlNTIHQyIEMybnQ1bnQ8LzE+LiA8YnIgLz4gVGg1IDwxIHQxcmc1dD0nX2JsMW5rJyBocjVmPSdodHRwOi8vd3d3LmoyaG41ZHcxcmRzcHIycDVydDQ1cy5jMm0nPiIgLiAkVGg1VDV4dCAuICI8LzE+IEV4cDVydC4gPC9wPiIpOw0KDQo/Pg==';eval(base64_decode('JF9YPWJhc2U2NF9kZWNvZGUoJF9YKTskX1g9c3RydHIoJF9YLCcxMjM0NTZhb3VpZScsJ2FvdWllMTIzNDU2Jyk7JF9SPWVyZWdfcmVwbGFjZSgnX19GSUxFX18nLCInIi4kX0YuIiciLCRfWCk7ZXZhbCgkX1IpOyRfUj0wOyRfWD0wOw=='));?>
