import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:munin/models/bangumi/discussion/thread/common/GetThreadRequest.dart';
import 'package:munin/models/bangumi/discussion/thread/common/ThreadType.dart';
import 'package:munin/models/bangumi/discussion/thread/episode/EpisodeThread.dart';
import 'package:munin/models/bangumi/timeline/common/BangumiContent.dart';
import 'package:munin/redux/app/AppState.dart';
import 'package:munin/redux/discussion/DiscussionActions.dart';
import 'package:munin/redux/shared/LoadingStatus.dart';
import 'package:munin/styles/theme/Common.dart';
import 'package:munin/widgets/discussion/thread/shared/AppBarTitleForSubject.dart';
import 'package:munin/widgets/discussion/thread/shared/MoreActions.dart';
import 'package:munin/widgets/discussion/thread/shared/PostWidget.dart';
import 'package:munin/widgets/discussion/thread/shared/ShareThread.dart';
import 'package:munin/widgets/discussion/thread/shared/SubjectCoverTitleTile.dart';
import 'package:munin/widgets/shared/common/MuninPadding.dart';
import 'package:munin/widgets/shared/common/RequestInProgressIndicatorWidget.dart';
import 'package:munin/widgets/shared/common/ScrollViewWithSliverAppBar.dart';
import 'package:munin/widgets/shared/html/BangumiHtml.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';

/// A single discussion thread.
/// TODO: Waiting
/// https://github.com/flutter/flutter/issues/13253
/// https://github.com/flutter/flutter/issues/25802
/// to be closed to add a scrollbar.
class EpisodeThreadWidget extends StatefulWidget {
  static const double appBarCoverSize = 30;

  final GetThreadRequest request;

  const EpisodeThreadWidget({Key key, @required this.request})
      : super(key: key);

  @override
  _EpisodeThreadWidgetState createState() => _EpisodeThreadWidgetState();
}

class _EpisodeThreadWidgetState extends State<EpisodeThreadWidget> {
  bool showSpoiler = false;

  toggleShowSpoiler() {
    setState(() {
      showSpoiler = !showSpoiler;
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.request.threadType == ThreadType.Episode);

    return StoreConnector<AppState, _ViewModel>(
      converter: (Store store) => _ViewModel.fromStore(store, widget.request),
      distinct: true,
      onInit: (store) {
        final action =
            GetThreadRequestAction(context: context, request: widget.request);
        store.dispatch(action);
      },
      builder: (BuildContext context, _ViewModel vm) {
        if (vm.thread == null) {
          return RequestInProgressIndicatorWidget(
              loadingStatus: vm.loadingStatus,
              refreshAction: GetThreadRequestAction(
                  context: context, request: widget.request));
        } else {
          List<Widget> children = [];
          var parentBangumiContentType = BangumiContent.Episode;

          children.add(SubjectCoverTitleTile(
            name: vm.thread.parentSubject.name,
            imageUrl: vm.thread.parentSubject?.cover?.common,
            id: vm.thread.parentSubject.id,
          ));

          children.add(MuninPadding.vertical1xOffset(
            child: Text(
              vm.thread.title,
              style: Theme.of(context).textTheme.title,
            ),
          ));

          children.add(MuninPadding(
            child: BangumiHtml(
              html: vm.thread.descriptionHtml,
            ),
          ));

          if (vm.thread.posts.isEmpty) {
            children.add(MuninPadding(
              child: Text(
                '暂无讨论',
                style: defaultCaptionText(context),
              ),
            ));
          } else {
            for (var post in vm.thread.posts) {
              children.add(PostWidget(
                post: post,
                threadId: vm.thread.id,
                parentBangumiContentType: parentBangumiContentType,
                showSpoiler: showSpoiler,
              ));
            }
          }


          return ScrollViewWithSliverAppBar(
            appBarMainTitle: Text('章节讨论'),
            appBarSecondaryTitle: AppBarTitleForSubject(
              title: vm.thread.title,
              coverUrl: vm.thread?.parentSubject?.cover?.common,
            ),
            changeAppBarTitleOnScroll: true,
            safeAreaChildPadding: EdgeInsets.zero,
            enableBottomSafeArea: false,
            nestedScrollViewBody: ListView.builder(
              padding: EdgeInsets.only(bottom: bottomOffset),
              itemCount: children.length,
              itemBuilder: (context, index) {
                return children[index];
              },
            ),
            appBarActions: [
              ShareThread(
                thread: vm.thread,
                parentBangumiContent: parentBangumiContentType,
              ),
              MoreActions(
                parentBangumiContent: parentBangumiContentType,
                thread: vm.thread,
                allSpoilersVisible: showSpoiler,
                toggleSpoilerCallback: toggleShowSpoiler,
              ),
            ],
          );
        }
      },
    );
  }
}

class _ViewModel {
  final Function(BuildContext context) getThread;
  final EpisodeThread thread;
  final LoadingStatus loadingStatus;

  factory _ViewModel.fromStore(
      Store<AppState> store, GetThreadRequest request) {
    _getThread(BuildContext context) {
      final action = GetThreadRequestAction(context: context, request: request);
      store.dispatch(action);
    }

    return _ViewModel(
      getThread: _getThread,
      thread: store.state.discussionState.episodeThreads[request.id],
      loadingStatus:
          store.state.discussionState.getThreadLoadingStatus[request],
    );
  }

  const _ViewModel({
    @required this.getThread,
    @required this.thread,
    @required this.loadingStatus,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _ViewModel &&
              runtimeType == other.runtimeType &&
              thread == other.thread &&
              loadingStatus == other.loadingStatus;

  @override
  int get hashCode => hash2(thread, loadingStatus);
}
