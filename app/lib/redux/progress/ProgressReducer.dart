import 'dart:collection';

import 'package:built_collection/built_collection.dart';
import 'package:munin/models/bangumi/progress/api/EpisodeProgress.dart';
import 'package:munin/models/bangumi/progress/api/InProgressAnimeOrRealCollection.dart';
import 'package:munin/models/bangumi/progress/api/InProgressBookCollection.dart';
import 'package:munin/models/bangumi/progress/common/EpisodeStatus.dart';
import 'package:munin/models/bangumi/progress/common/EpisodeUpdateType.dart';
import 'package:munin/models/bangumi/progress/common/InProgressCollection.dart';
import 'package:munin/models/bangumi/subject/common/SubjectType.dart';
import 'package:munin/redux/progress/ProgressActions.dart';
import 'package:munin/redux/progress/ProgressState.dart';
import 'package:munin/redux/progress/common.dart';
import 'package:redux/redux.dart';

final progressReducers = combineReducers<ProgressState>([
  TypedReducer<ProgressState, GetSubjectEpisodesSuccessAction>(
      getSubjectEpisodesSuccessReducer),
  TypedReducer<ProgressState, GetProgressSuccessAction>(
      getProgressSuccessReducer),
  TypedReducer<ProgressState, UpdateInProgressEpisodeSuccessAction>(
      updateInProgressEpisodeSuccessReducer),
  TypedReducer<ProgressState, DeleteInProgressSubjectAction>(
      deleteInProgressSubjectReducer),
  TypedReducer<ProgressState, UpdateInProgressBatchEpisodesSuccessAction>(
      updateInProgressBatchEpisodesSuccessReducer),
  TypedReducer<ProgressState, UpdateBookProgressSuccessAction>(
      updateBookProgressSuccessReducer),
]);

ProgressState getSubjectEpisodesSuccessReducer(
    ProgressState progressState, GetSubjectEpisodesSuccessAction action) {
  return progressState.rebuild((b) => b
    ..watchableSubjects.addAll(
      {action.subjectId: action.subjectEpisodes},
    ));
}

ProgressState getProgressSuccessReducer(ProgressState progressState,
    GetProgressSuccessAction getProgressSuccessAction) {
  for (SubjectType type in getProgressSuccessAction.subjectTypes) {
    LinkedHashMap<int, InProgressCollection> subjects =
        getProgressSuccessAction.progresses[type];

    assert(subjects != null);
    if (subjects == null) {
      continue;
    }

    progressState = progressState.rebuild((b) => b
      ..progresses
          .addAll({type: BuiltList<InProgressCollection>(subjects.values)}));
  }

  return progressState;
}

ProgressState updateInProgressEpisodeSuccessReducer(
    ProgressState progressState, UpdateInProgressEpisodeSuccessAction action) {
  Iterable<InProgressCollection> progresses = progressState
      .progresses[action.subject.type]
      .map<InProgressCollection>((InProgressCollection progress) {
    if (progress.subject.id == action.subject.id &&
        progress is InProgressAnimeOrRealCollection) {
      EpisodeStatus prevEpisodeStatus;
      EpisodeProgress newEpisodeProgress =
          progress.episodes[action.episodeId].rebuild((b) {
        prevEpisodeStatus = b.userEpisodeStatus;
        return b
          ..userEpisodeStatus =
              action.episodeUpdateType.destinationEpisodeStatus;
      });

      InProgressCollection newInProgressSubject = progress.rebuild((b) => b
        ..episodes.addAll({action.episodeId: newEpisodeProgress})
        ..completedEpisodesCount += EpisodeUpdateType.watchedEpisodeCountChange(
            prevEpisodeStatus, action.episodeUpdateType));
      return newInProgressSubject;
    }

    return progress;
  });

  return progressState.rebuild((b) => b
    ..progresses.addAll(
        {action.subject.type: BuiltList<InProgressCollection>(progresses)}));
}

ProgressState deleteInProgressSubjectReducer(
    ProgressState progressState, DeleteInProgressSubjectAction action) {
  var progressesToUpdate = progressState.progresses[action.subjectType];
  if (progressesToUpdate != null) {
    progressesToUpdate = progressesToUpdate.rebuild((b) =>
        b.removeWhere((progress) => progress.subject.id == action.subjectId));

    progressState = progressState.rebuild(
        (b) => b.progresses.addAll({action.subjectType: progressesToUpdate}));
  }

  return progressState;
}

ProgressState updateInProgressBatchEpisodesSuccessReducer(
    ProgressState progressState,
    UpdateInProgressBatchEpisodesSuccessAction action) {
  Iterable<InProgressCollection> progresses = progressState
      .progresses[action.subject.type]
      .map<InProgressCollection>((InProgressCollection progress) {
    if (progress.subject.id == action.subject.id &&
        progress is InProgressAnimeOrRealCollection) {
      LinkedHashMap<int, EpisodeProgress> updatedEpisodes = LinkedHashMap();

      /// total number of changed episodes to add to completedEpisodesCount
      int totalChangedEpisodesCountToAdd = 0;
      for (var episode in progress.episodes.values) {
        if (isEpisodeProgressAffectedByCollectUntilOperation(
            episode, action.newEpisodeNumber)) {
          totalChangedEpisodesCountToAdd +=
              EpisodeUpdateType.watchedEpisodeCountChange(
                  episode.userEpisodeStatus, EpisodeUpdateType.Collect);
          episode = episode
              .rebuild((b) => b..userEpisodeStatus = EpisodeStatus.Completed);
          updatedEpisodes[episode.id] = episode;
        } else {
          updatedEpisodes[episode.id] = episode;
        }
      }

      return progress.rebuild((b) => b
        ..episodes.replace(updatedEpisodes)
        ..completedEpisodesCount += totalChangedEpisodesCountToAdd);
    }

    return progress;
  });

  return progressState.rebuild((b) => b
    ..progresses.addAll(
        {action.subject.type: BuiltList<InProgressCollection>(progresses)}));
}

ProgressState updateBookProgressSuccessReducer(
    ProgressState progressState, UpdateBookProgressSuccessAction action) {
  BuiltList<InProgressCollection> bookProgresses =
      progressState.progresses[SubjectType.Book];

  if (bookProgresses == null) {
    return progressState;
  }

  Iterable<InProgressCollection> progresses =
      bookProgresses.map<InProgressCollection>((InProgressCollection progress) {
    if (progress.subject.id == action.subjectId &&
        progress is InProgressBookCollection) {
      InProgressBookCollection newEpisodeProgress = progress.rebuild((b) => b
        ..completedEpisodesCount = action.newEpisodeNumber
        ..completedVolumesCount = action.newVolumeNumber);
      return newEpisodeProgress;
    }

    return progress;
  });

  return progressState.rebuild((b) => b
    ..progresses.addAll(
        {SubjectType.Book: BuiltList<InProgressCollection>(progresses)}));
}
