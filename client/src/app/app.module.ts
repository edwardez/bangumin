import {BrowserModule} from '@angular/platform-browser';
import {NgModule} from '@angular/core';

import {AppRoutingModule} from './app-routing.module';

import {ServiceWorkerModule} from '@angular/service-worker';
import {AppComponent} from './app.component';

import {environment} from '../environments/environment';
import {HttpClient, HttpClientModule} from '@angular/common/http';
import {TranslateLoader, TranslateModule} from '@ngx-translate/core';
import {TranslateHttpLoader} from '@ngx-translate/http-loader';
import {DashboardComponent} from './home/dashboard/dashboard.component';

import {InterceptorsModule} from './shared/interceptors/interceptors.module';
import {BanguminSharedModule} from './bangumin-shared.module';
import {BanguminHomeModule} from './home/home.module';
import {BanguminCommonComponentModule} from './common/common.module';
import {CookieModule} from 'ngx-cookie';
import {BanguminAuthModule} from './auth/bangumin-auth.module';
import {BanguminSearchModule} from './search/bangumin-search.module';
import {BanguminSettingsModule} from './settings/bangumin-settings.module';
import {BanguminSubjectModule} from './subject/bangumin-subject.module';
import {JwtModule} from '@auth0/angular-jwt';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {LoadingBarHttpClientModule} from '@ngx-loading-bar/http-client';
import {DocumentsModule} from './documents/documents.module';
import {QuillModule} from 'ngx-quill';

@NgModule({
  declarations: [
    AppComponent,
    DashboardComponent,
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    HttpClientModule,
    BanguminSharedModule,
    BanguminHomeModule,
    BanguminCommonComponentModule,
    BanguminAuthModule,
    BanguminSettingsModule,
    BanguminSubjectModule,
    BanguminSearchModule,
    DocumentsModule,
    CookieModule.forRoot(),
    JwtModule.forRoot({
      config: {
        tokenGetter: tokenGetter,
        whitelistedDomains: environment.whitelistedDomains,
        blacklistedRoutes: environment.blacklistedRoutes
      }
    }),
    InterceptorsModule.forRoot(
    ),
    LoadingBarHttpClientModule,
    TranslateModule.forRoot({
        loader: {
          provide: TranslateLoader,
          useFactory: HttpLoaderFactory,
          deps: [HttpClient]
        }
      }
    ),
    QuillModule.forRoot(),
    ServiceWorkerModule.register('ngsw-worker.js', {enabled: environment.production}),
  ],
  entryComponents: [],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule {

  constructor() {
  }
}

// required for AOT compilation
export function HttpLoaderFactory(http: HttpClient) {
  return new TranslateHttpLoader(http);
}

export function tokenGetter() {
  return localStorage.getItem('accessToken');
}
