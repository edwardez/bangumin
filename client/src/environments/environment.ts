// The file contents for the current environment will overwrite these during build.
// The build system defaults to the dev environment which uses `environment.ts`, but if you do
// `ng build --env=prod` then `environment.prod.ts` will be used instead.
// The list of which env maps to which file can be found in `.angular-cli.json`.

export const environment = {
  production: false,
  FRONTEND_URL: 'http://127.0.0.1:4200',
  BANGUMI_API_URL: 'http://127.0.0.1:4200/proxy/api/bangumi',
  BANGUMI_OAUTH_URL: 'http://127.0.0.1:4200/proxy/oauth/bangumi',
  BACKEND_API_URL: 'http://127.0.0.1:3000/api',
  BACKEND_AUTH_URL: 'http://127.0.0.1:3000/auth',
  BACKEND_OAUTH_REDIRECT_URL: 'http://127.0.0.1:3000/oauth',
  BANGUMI_APP_ID: 'bgm2535b10d2c3d3e8d',
  whitelistedDomains: ['127.0.0.1:3000'],
  blacklistedRoutes: [/http:\/\/127\.0\.0\.1:4200\/proxy\/api\/.+/],
  availableLanguage: {
    'en-US': 'English',
    'zh-Hans': '简体中文'
  },
  commentMaxLength: 200,
  tagsMaxNumber: 10,
  progressPageMaxEpisodeCount: 30,
  invalidEpisode: '-1',
  invalidVolume: '-1'
};
