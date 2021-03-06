import * as express from 'express';
import * as dynamooseUserModel from '../models/nosql/user';
import {BanguminErrorCode, CustomError} from '../services/errorHandler';
import {celebrate, Joi} from 'celebrate';
import {SettingService} from '../services/bangumin/settingService';

const router = express.Router();

/**
 * post updated user settings to database
 */
router.post('/', celebrate({
  body: {
    id: Joi.string().regex(/^\d+$/).required(),
    appLanguage: Joi.string(),
    bangumiLanguage: Joi.string(),
    appTheme: Joi.string(),
    showA11YViolationTheme: Joi.boolean(),
    stopCrawling: Joi.boolean(),
  },
}), (req: any, res: any, next: any) => {
  const id = req.user.id;
  const newUserSettings: dynamooseUserModel.UserSchema = req.body;
  // users are only allowed to update their own settings
  newUserSettings.id = req.user.id;
  dynamooseUserModel.User
    .updateUser(newUserSettings)
    .then((response) => {
      return SettingService.updateUserExcludeSettings(newUserSettings.stopCrawling, Number(newUserSettings.id))
        .then((r) => {
          return res.json(response);
        });
    })
    .catch((error) => {
      if (error instanceof CustomError || error.name === 'ValidationError') {
        return next(error);
      }
      return next(new CustomError(BanguminErrorCode.NoSQLResponseError, error, 'Error occurred during querying dynamoDB'));
    });

});

/**
 * get updated user settings from database
 */
router.get('/', (req: any, res: any, next: any) => {
  // users are only allowed to view their own settings, use id from session
  dynamooseUserModel.User
    .findUser(req.user.id)
    .then((response) => {
      res.json(response);
    })
    .catch((error) => {
      if (error instanceof CustomError || error.name === 'ValidationError') {
        return next(error);
      }

      return next(new CustomError(BanguminErrorCode.NoSQLResponseError, error, 'Error occurred during querying dynamoDB'));
    });

});

export const settings = router;
