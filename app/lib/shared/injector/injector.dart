import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:munin/config/application.dart';
import 'package:munin/models/bangumi/BangumiCookieCredentials.dart';
import 'package:munin/providers/bangumi/BangumiCookieService.dart';
import 'package:munin/providers/bangumi/BangumiOauthService.dart';
import 'package:munin/providers/bangumi/discussion/BangumiDiscussionService.dart';
import 'package:munin/providers/bangumi/progress/BangumiProgressService.dart';
import 'package:munin/providers/bangumi/search/BangumiSearchService.dart';
import 'package:munin/providers/bangumi/subject/BangumiSubjectService.dart';
import 'package:munin/providers/bangumi/timeline/BangumiTimelineService.dart';
import 'package:munin/providers/bangumi/user/BangumiUserService.dart';
import 'package:munin/providers/bangumi/util/DioInterceptors.dart';
import 'package:munin/providers/storage/SecureStorageService.dart';
import 'package:munin/providers/storage/SharedPreferenceService.dart';
import 'package:munin/providers/util/RetryableHttpClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> injector(GetIt getIt) async {
  final FlutterSecureStorage secureStorage = new FlutterSecureStorage();
  Map<String, String> credentials = await secureStorage.readAll();

  String serializedBangumiCookieCredentials =
      credentials[bangumiCookieCredentialsKey];
  BangumiCookieCredentials bangumiCookieCredential;

  if (serializedBangumiCookieCredentials != null) {
    bangumiCookieCredential =
        BangumiCookieCredentials.fromJson(serializedBangumiCookieCredentials);
  }

  CookieJar bangumiCookieJar = CookieJar();
  getIt.registerSingleton<CookieJar>(bangumiCookieJar);

  SecureStorageService secureStorageService =
      SecureStorageService(secureStorage: secureStorage);
  SharedPreferenceService sharedPreferenceService = SharedPreferenceService(
      sharedPreferences: await SharedPreferences.getInstance());

  final BangumiCookieService _bangumiCookieService = BangumiCookieService(
      bangumiCookieCredential: bangumiCookieCredential,
      secureStorageService: secureStorageService,
      dio: createDioForBangumiCookieService(
          bangumiCookieCredential, bangumiCookieJar));

  final String serializedBangumiOauthCredentials =
  credentials[bangumiOauthCredentialsKey];

  RetryableHttpClient oauthHttpClient = RetryableHttpClient(http.Client());
  final BangumiOauthService _bangumiOauthService = BangumiOauthService(
    cookieClient: _bangumiCookieService,
    serializedBangumiOauthCredentials: serializedBangumiOauthCredentials,
    secureStorageService: secureStorageService,
    oauthHttpClient: oauthHttpClient,
  );

  getIt.registerSingleton<SharedPreferenceService>(sharedPreferenceService);
  getIt.registerSingleton<SecureStorageService>(secureStorageService);
  getIt.registerSingleton<BangumiCookieService>(_bangumiCookieService);
  getIt.registerSingleton<BangumiOauthService>(_bangumiOauthService);

  final bangumiUserService = BangumiUserService(
      cookieClient: _bangumiCookieService,
      oauthClient: _bangumiOauthService,
      sharedPreferenceService: sharedPreferenceService);
  getIt.registerSingleton<BangumiUserService>(bangumiUserService);

  final bangumiTimelineService =
      BangumiTimelineService(cookieClient: _bangumiCookieService);
  getIt.registerSingleton<BangumiTimelineService>(bangumiTimelineService);

  final bangumiSubjectService = BangumiSubjectService(
      cookieClient: _bangumiCookieService, oauthClient: _bangumiOauthService);
  getIt.registerSingleton<BangumiSubjectService>(bangumiSubjectService);

  final bangumiSearchService = BangumiSearchService(
      cookieClient: _bangumiCookieService, oauthClient: _bangumiOauthService);
  getIt.registerSingleton<BangumiSearchService>(bangumiSearchService);

  final bangumiDiscussionService =
      BangumiDiscussionService(cookieClient: _bangumiCookieService);
  getIt.registerSingleton<BangumiDiscussionService>(bangumiDiscussionService);

  final bangumiProgressService = BangumiProgressService(
    cookieClient: _bangumiCookieService,
    oauthClient: _bangumiOauthService,
  );
  getIt.registerSingleton<BangumiProgressService>(bangumiProgressService);

  return;
}

void saveBangumiCookieToCookieJar(CookieJar bangumiCookieJar,
    List<Cookie> cookies, String bangumiHostForDio) {
  bangumiCookieJar.saveFromResponse(
      Uri.parse("https://$bangumiMainHost"), cookies);

  bangumiCookieJar.saveFromResponse(
      Uri.parse("https://$bangumiHostForDio"), cookies);
}

/// Creates a new dio client with present settings
Dio createDioForBangumiCookieService(
  BangumiCookieCredentials bangumiCookieCredential,
  CookieJar bangumiCookieJar, {
  String bangumiHostForDio,
}) {
  final bangumiHost =
      bangumiHostForDio ?? Application.environmentValue.bangumiHostForDio;
  Map<String, dynamic> headers = {
    HttpHeaders.hostHeader: bangumiHost,
    HttpHeaders.refererHeader: 'https://$bangumiHost/',
  };

  // Attaches user agent and cookie to dio  if these are not null
  // user agent is handled by us, we manually attach it to headers
  // cookie is handled by dio with [CookieJar]
  if (bangumiCookieCredential != null) {
    List<Cookie> cookies = [];
    if (bangumiCookieCredential.authCookie != null) {
      cookies.add(Cookie('chii_auth', bangumiCookieCredential.authCookie));
    }

    if (bangumiCookieCredential.sessionCookie != null) {
      cookies.add(Cookie('chii_sid', bangumiCookieCredential.sessionCookie));
    }

    // https://github.com/bangumi/api/issues/43#issuecomment-414563212 requires
    // [chii_searchDateLine] to be present
    cookies.add(Cookie('chii_searchDateLine', '0'));

    if (bangumiCookieCredential.userAgent != null) {
      headers[HttpHeaders.userAgentHeader] = bangumiCookieCredential.userAgent;
    }

    saveBangumiCookieToCookieJar(bangumiCookieJar, cookies, bangumiHost);
  }

  var dio = Dio(BaseOptions(
    baseUrl: "https://$bangumiHost",
    connectTimeout: Duration(seconds: 10).inMilliseconds,
    receiveTimeout: Duration(seconds: 10).inMilliseconds,
    headers: headers,
    contentType: ContentType.html.mimeType,
    // Transform the response data to a String encoded with UTF8.
    // The default value is [ResponseType.JSON].
    responseType: ResponseType.plain,
  ));

  dio.interceptors.add(CookieManager(bangumiCookieJar));

  BangumiCookieExpirationCheckInterceptor expirationChecker =
  BangumiCookieExpirationCheckInterceptor(
      expiresOn: bangumiCookieCredential?.expiresOn);

  getIt.registerSingleton<BangumiCookieExpirationCheckInterceptor>(
      expirationChecker);
  dio.interceptors.add(expirationChecker);

  // Enables logging in development environment
  if (Application.environmentValue?.environmentType ==
      EnvironmentType.Development) {
//    dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  return dio;
}
