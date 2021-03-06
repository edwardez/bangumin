import * as express from 'express';
import _ from 'lodash';
import {Record} from '../models/relational/bangumi/record';
import {getSubjectStatsById, getUserStatsByIdOrUsername} from '../services/bangumi/statsService';
import {celebrate, Joi} from 'celebrate';
import {BanguminErrorCode, CustomError} from '../services/errorHandler';

const router = express.Router();

/**
 * get user stats info
 */
router.get('/user/:userIdOrUsername', celebrate({
  params: {
    userIdOrUsername: Joi.string().token(),
  },
}), (req: any, res: any, next: any) => {
  const userIdOrUsername: string | number = isNaN(Number(req.params.userIdOrUsername)) ? req.params.userIdOrUsername : Number(
    req.params.userIdOrUsername);

  getUserStatsByIdOrUsername(userIdOrUsername).then(
    (userStats: Record[]) => {
      if (userStats) {
        const lastModified = userStats.length === 0 ? null : _.maxBy(userStats, record => record.rowLastModified).rowLastModified;

        return res.json(
          {
            ...(typeof userIdOrUsername === 'number' ? {userId: userIdOrUsername} : {userName: userIdOrUsername}),
            lastModified,
            stats: userStats.map((userRecordInstance) => {
              const userRecord = userRecordInstance.toJSON();
              delete userRecord.rowLastModified;
              return userRecord;
            }),
          },
        );
      }

      next(new CustomError(BanguminErrorCode.RequestResourceNotFoundError,
        new Error(BanguminErrorCode[BanguminErrorCode.RequestResourceNotFoundError]), 'Requested user id stats doesn\'t exist'));
    },
  ).catch((error) => {
    if (error instanceof CustomError || error.name === 'ValidationError') {
      return next(error);
    }
    return next(new CustomError(BanguminErrorCode.RDSResponseError, error));
  });

});

/**
 * get subject stats info
 */
router.get('/subject/:subjectId', celebrate({
  params: {
    subjectId: Joi.number().min(0).max(Number.MAX_SAFE_INTEGER),
  },
}), (req: any, res: any, next: any) => {
  const subjectId = req.params.subjectId;
  getSubjectStatsById(subjectId).then(
    (subjectStats: Record[]) => {
      if (subjectStats) {
        const lastModified = subjectStats.length === 0 ? null : _.maxBy(subjectStats, record => record.rowLastModified).rowLastModified;

        return res.json({
          subjectId,
          lastModified,
          stats: subjectStats.map((subjectRecordInstance) => {
            const userRecord = subjectRecordInstance.toJSON();
            delete userRecord.rowLastModified;
            return userRecord;
          }),
        });
      }

      return next(new CustomError(BanguminErrorCode.RequestResourceNotFoundError,
        new Error(BanguminErrorCode[BanguminErrorCode.RequestResourceNotFoundError]), 'Requested subject id stats doesn\'t exist'));
    },
  ).catch((error) => {
    if (error instanceof CustomError || error.name === 'ValidationError') {
      return next(error);
    }

    return next(new CustomError(BanguminErrorCode.RDSResponseError, error));
  });

});

export const stats = router;
