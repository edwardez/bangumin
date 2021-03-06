import {ModuleWithProviders, NgModule, Optional, SkipSelf} from '@angular/core';
import {OauthInterceptor} from './oauth.interceptor';
import {HTTP_INTERCEPTORS} from '@angular/common/http';
import {CacheInterceptor} from './cache/cache.interceptor';
import {CustomXsrfInterceptor} from './xsrf/custom-xsrf.interceptor';
import {ErrorNotificationInterceptor} from './error-handler/error-notification.interceptor';

// TODO: remove this interceptor once https://github.com/auth0/angular2-jwt/issues/427 is solved
// currently it's needed to added different header here since angular-jwt doesn't support change token according to domain routes
@NgModule()
export class InterceptorsModule {
  constructor(@Optional() @SkipSelf() parentModule: InterceptorsModule) {
    if (parentModule) {
      throw new Error('InterceptorsModule is already loaded. It should only be imported in your application\'s main module.');
    }
  }

  static forRoot(): ModuleWithProviders {
    return {
      ngModule: InterceptorsModule,
      providers: [
        {
          provide: HTTP_INTERCEPTORS,
          useClass: CacheInterceptor,
          multi: true
        },
        {
          provide: HTTP_INTERCEPTORS,
          useClass: OauthInterceptor,
          multi: true
        },
        {
          provide: HTTP_INTERCEPTORS,
          useClass: CustomXsrfInterceptor,
          multi: true
        },
        {
          provide: HTTP_INTERCEPTORS,
          useClass: ErrorNotificationInterceptor,
          multi: true
        }
      ]
    };
  }
}
