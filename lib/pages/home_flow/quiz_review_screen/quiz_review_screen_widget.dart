import '/componants/app_bar/app_bar_widget.dart';
import '/flutter_flow/flutter_flow_audio_player.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'quiz_review_screen_model.dart';
export 'quiz_review_screen_model.dart';

class QuizReviewScreenWidget extends StatefulWidget {
  const QuizReviewScreenWidget({
    super.key,
    this.catID,
  });

  final String? catID;

  static String routeName = 'quiz_review_screen';
  static String routePath = '/quizReviewScreen';

  @override
  State<QuizReviewScreenWidget> createState() => _QuizReviewScreenWidgetState();
}

class _QuizReviewScreenWidgetState extends State<QuizReviewScreenWidget>
    with TickerProviderStateMixin {
  late QuizReviewScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QuizReviewScreenModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Builder(
          builder: (context) {
            if (FFAppState().connected == true) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  wrapWithModel(
                    model: _model.appBarModel,
                    updateCallback: () => safeSetState(() {}),
                    child: AppBarWidget(
                      title: 'Test overview',
                      backIcon: false,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment(0.0, 0),
                          child: TabBar(
                            labelColor:
                                FlutterFlowTheme.of(context).primaryText,
                            unselectedLabelColor:
                                FlutterFlowTheme.of(context).secondaryText,
                            labelStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                            unselectedLabelStyle: TextStyle(),
                            indicatorColor:
                                FlutterFlowTheme.of(context).primary,
                            padding: EdgeInsets.all(4.0),
                            tabs: [
                              Tab(
                                text: 'Answered',
                              ),
                              Tab(
                                text: 'Skipped',
                              ),
                            ],
                            controller: _model.tabBarController,
                            onTap: (i) async {
                              [() async {}, () async {}][i]();
                            },
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _model.tabBarController,
                            children: [
                              Builder(
                                builder: (context) {
                                  final ques =
                                      FFAppState().quesReviewList.where((q) => q['user_answer'] != null && q['user_answer'] != 'skipped').toList();

                                  return ListView.separated(
                                    padding: EdgeInsets.fromLTRB(
                                      0,
                                      16.0,
                                      0,
                                      16.0,
                                    ),
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: ques.length,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(height: 16.0),
                                    itemBuilder: (context, quesIndex) {
                                      final quesItem = ques[quesIndex];
                                      print('REVIEW DEBUG: user_answer=' + (quesItem['user_answer']?.toString() ?? 'null') + ', answer=' + (quesItem['answer']?.toString() ?? 'null') + ', options=' + (quesItem['option']?.toString() ?? 'null'));
                                      return Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .white,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 15.0,
                                                color: Color(0x1A000000),
                                                offset: Offset(
                                                  0.0,
                                                  4.0,
                                                ),
                                                spreadRadius: 0.0,
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 0.0, 16.0, 0.0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1.0, 0.0),
                                                        child: RichText(
                                                          textScaler:
                                                              MediaQuery.of(
                                                                      context)
                                                                  .textScaler,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: 'Q',
                                                                style:
                                                                    TextStyle(),
                                                              ),
                                                              TextSpan(
                                                                text: (quesIndex +
                                                                        1)
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(),
                                                              ),
                                                              TextSpan(
                                                                text: '.',
                                                                style:
                                                                    TextStyle(),
                                                              )
                                                            ],
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize:
                                                                      15.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  useGoogleFonts:
                                                                      false,
                                                                  lineHeight:
                                                                      1.5,
                                                                ),
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1.0, 0.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        8.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: RichText(
                                                              textScaler:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        getJsonField(
                                                                      quesItem,
                                                                      r'''$.question_title''',
                                                                    ).toString(),
                                                                    style:
                                                                        TextStyle(),
                                                                  )
                                                                ],
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize:
                                                                          15.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      useGoogleFonts:
                                                                          false,
                                                                      lineHeight:
                                                                          1.5,
                                                                    ),
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if ('audio' ==
                                                      getJsonField(
                                                        quesItem,
                                                        r'''$.question_type''',
                                                      ).toString())
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  0.0),
                                                      child:
                                                          FlutterFlowAudioPlayer(
                                                        audio: Audio.network(
                                                          getJsonField(
                                                                    quesItem,
                                                                    r'''$.audio''',
                                                                  ) !=
                                                                  null
                                                              ? '${FFAppConstants.imageBaseURL}${getJsonField(
                                                                  quesItem,
                                                                  r'''$.audio''',
                                                                ).toString()}'
                                                              : 'https://filesamples.com/samples/audio/mp3/sample3.mp3',
                                                          metas: Metas(
                                                            title: 'Audio',
                                                          ),
                                                        ),
                                                        titleTextStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      false,
                                                                ),
                                                        playbackDurationTextStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      false,
                                                                ),
                                                        fillColor: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        playbackButtonColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        activeTrackColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        inactiveTrackColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        elevation: 0.0,
                                                        playInBackground:
                                                            PlayInBackground
                                                                .disabledRestoreOnForeground,
                                                      ),
                                                    ),
                                                  if ('images' ==
                                                      getJsonField(
                                                        quesItem,
                                                        r'''$.question_type''',
                                                      ).toString())
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          fadeInDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      500),
                                                          fadeOutDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      500),
                                                          imageUrl: getJsonField(
                                                                    quesItem,
                                                                    r'''$.image''',
                                                                  ) !=
                                                                  null
                                                              ? '${FFAppConstants.imageBaseURL}${getJsonField(
                                                                  quesItem,
                                                                  r'''$.image''',
                                                                ).toString()}'
                                                              : 'https://images.unsplash.com/photo-1472457974886-0ebcd59440cc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyfHxsZWdvfGVufDB8fHx8MTcyNTUyNTYwMnww&ixlib=rb-4.0.3&q=80&w=1080',
                                                          width:
                                                              double.infinity,
                                                          height: 200.0,
                                                          fit: BoxFit.contain,
                                                          alignment: Alignment(
                                                              0.0, 0.0),
                                                        ),
                                                      ),
                                                    ),
                                                  Builder(
                                                    builder: (context) {
                                                      if ('${getJsonField(
                                                            quesItem,
                                                            r'''$.question_type''',
                                                          ).toString()}' !=
                                                          'true_false') {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      16.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Builder(
                                                                builder:
                                                                    (context) {
                                                                  if (getJsonField(
                                                                        quesItem,
                                                                        r'''$.option.a''',
                                                                      ) ==
                                                                      getJsonField(
                                                                        quesItem,
                                                                        r'''$.answer''',
                                                                      )) {
                                                                    return ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/images/Vector_(1).svg',
                                                                        width:
                                                                            24.0,
                                                                        height:
                                                                            24.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    );
                                                                  } else if (getJsonField(
                                                                        quesItem,
                                                                        r'''$.option.a''',
                                                                      ) ==
                                                                      getJsonField(
                                                                        quesItem,
                                                                        r'''$.user_answer''',
                                                                      )) {
                                                                    return Container(
                                                                      width:
                                                                          26.0,
                                                                      height:
                                                                          26.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .info,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .cancel_sharp,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/images/Ellipse_19.svg',
                                                                        width:
                                                                            24.0,
                                                                        height:
                                                                            24.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                              Expanded(
                                                                child: RichText(
                                                                  textScaler: MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            getJsonField(
                                                                          quesItem,
                                                                          r'''$.option.a''',
                                                                        ).toString(),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 17.0,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: false,
                                                                              lineHeight: 1.5,
                                                                            ),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            ' ',
                                                                        style:
                                                                            TextStyle(),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            () {
                                                                          if (getJsonField(
                                                                                quesItem,
                                                                                r'''$.option.a''',
                                                                              ) ==
                                                                              getJsonField(
                                                                                quesItem,
                                                                                r'''$.user_answer''',
                                                                              )) {
                                                                            return '(Your Answer)';
                                                                          } else if (getJsonField(
                                                                                quesItem,
                                                                                r'''$.option.a''',
                                                                              ) ==
                                                                              getJsonField(
                                                                                quesItem,
                                                                                r'''$.answer''',
                                                                              )) {
                                                                            return '(Corrrect Answer)';
                                                                          } else {
                                                                            return ' ';
                                                                          }
                                                                        }(),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).black40,
                                                                        ),
                                                                      )
                                                                    ],
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              false,
                                                                          lineHeight:
                                                                              1.5,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 6.0)),
                                                          ),
                                                        );
                                                      } else {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      16.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Builder(
                                                                builder:
                                                                    (context) {
                                                                  if ('True' ==
                                                                      getJsonField(
                                                                        quesItem,
                                                                        r'''$.answer''',
                                                                      ).toString()) {
                                                                    return ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/images/Vector_(1).svg',
                                                                        width:
                                                                            24.0,
                                                                        height:
                                                                            24.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    );
                                                                  } else if ('True' ==
                                                                      getJsonField(
                                                                        quesItem,
                                                                        r'''$.user_answer''',
                                                                      ).toString()) {
                                                                    return Container(
                                                                      width:
                                                                          26.0,
                                                                      height:
                                                                          26.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .info,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .cancel_sharp,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/images/Ellipse_19.svg',
                                                                        width:
                                                                            24.0,
                                                                        height:
                                                                            24.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                              Expanded(
                                                                child: RichText(
                                                                  textScaler: MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'True',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 17.0,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: false,
                                                                              lineHeight: 1.5,
                                                                            ),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            ' ',
                                                                        style:
                                                                            TextStyle(),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            () {
                                                                          if ('True' ==
                                                                              getJsonField(
                                                                                quesItem,
                                                                                r'''$.user_answer''',
                                                                              ).toString()) {
                                                                            return '(Your Answer)';
                                                                          } else if ('True' ==
                                                                              getJsonField(
                                                                                quesItem,
                                                                                r'''$.answer''',
                                                                              ).toString()) {
                                                                            return '(Correct Answer)';
                                                                          } else {
                                                                            return ' ';
                                                                          }
                                                                        }(),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).black40,
                                                                        ),
                                                                      )
                                                                    ],
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              false,
                                                                          lineHeight:
                                                                              1.5,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 6.0)),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  Builder(
                                                    builder: (context) {
                                                      if ('${getJsonField(
                                                            quesItem,
                                                            r'''$.question_type''',
                                                          ).toString()}' !=
                                                          'true_false') {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      16.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Builder(
                                                                builder:
                                                                    (context) {
                                                                  if (getJsonField(
                                                                        quesItem,
                                                                        r'''$.option.b''',
                                                                      ) ==
                                                                      getJsonField(
                                                                        quesItem,
                                                                        r'''$.answer''',
                                                                      )) {
                                                                    return ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/images/Vector_(1).svg',
                                                                        width:
                                                                            24.0,
                                                                        height:
                                                                            24.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    );
                                                                  } else if (getJsonField(
                                                                        quesItem,
                                                                        r'''$.option.b''',
                                                                      ) ==
                                                                      getJsonField(
                                                                        quesItem,
                                                                        r'''$.user_answer''',
                                                                      )) {
                                                                    return Container(
                                                                      width:
                                                                          26.0,
                                                                      height:
                                                                          26.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .info,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .cancel_sharp,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/images/Ellipse_19.svg',
                                                                        width:
                                                                            24.0,
                                                                        height:
                                                                            24.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                              Expanded(
                                                                child: RichText(
                                                                  textScaler: MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            getJsonField(
                                                                          quesItem,
                                                                          r'''$.option.b''',
                                                                        ).toString(),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 17.0,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: false,
                                                                              lineHeight: 1.5,
                                                                            ),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            ' ',
                                                                        style:
                                                                            TextStyle(),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            () {
                                                                          if (getJsonField(
                                                                                quesItem,
                                                                                r'''$.option.b''',
                                                                              ) ==
                                                                              getJsonField(
                                                                                quesItem,
                                                                                r'''$.user_answer''',
                                                                              )) {
                                                                            return '(Your Answer)';
                                                                          } else if (getJsonField(
                                                                                quesItem,
                                                                                r'''$.option.b''',
                                                                              ) ==
                                                                              getJsonField(
                                                                                quesItem,
                                                                                r'''$.answer''',
                                                                              )) {
                                                                            return '(Correct Answer)';
                                                                          } else {
                                                                            return ' ';
                                                                          }
                                                                        }(),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).black40,
                                                                        ),
                                                                      )
                                                                    ],
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              false,
                                                                          lineHeight:
                                                                              1.5,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 6.0)),
                                                          ),
                                                        );
                                                      } else {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      16.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Builder(
                                                                builder:
                                                                    (context) {
                                                                  if ('False' ==
                                                                      getJsonField(
                                                                        quesItem,
                                                                        r'''$.answer''',
                                                                      ).toString()) {
                                                                    return ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/images/Vector_(1).svg',
                                                                        width:
                                                                            24.0,
                                                                        height:
                                                                            24.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    );
                                                                  } else if ('False' ==
                                                                      getJsonField(
                                                                        quesItem,
                                                                        r'''$.user_answer''',
                                                                      ).toString()) {
                                                                    return Container(
                                                                      width:
                                                                          26.0,
                                                                      height:
                                                                          26.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .info,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .cancel_sharp,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/images/Ellipse_19.svg',
                                                                        width:
                                                                            24.0,
                                                                        height:
                                                                            24.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                              Expanded(
                                                                child: RichText(
                                                                  textScaler: MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'False',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 17.0,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: false,
                                                                              lineHeight: 1.5,
                                                                            ),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            ' ',
                                                                        style:
                                                                            TextStyle(),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            () {
                                                                          if ('False' ==
                                                                              getJsonField(
                                                                                quesItem,
                                                                                r'''$.user_answer''',
                                                                              ).toString()) {
                                                                            return '(Your Answer)';
                                                                          } else if ('False' ==
                                                                              getJsonField(
                                                                                quesItem,
                                                                                r'''$.answer''',
                                                                              ).toString()) {
                                                                            return '(Correct Answer)';
                                                                          } else {
                                                                            return ' ';
                                                                          }
                                                                        }(),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).black40,
                                                                        ),
                                                                      )
                                                                    ],
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              false,
                                                                          lineHeight:
                                                                              1.5,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 6.0)),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  if ('${getJsonField(
                                                        quesItem,
                                                        r'''$.question_type''',
                                                      ).toString()}' !=
                                                      'true_false')
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Builder(
                                                            builder: (context) {
                                                              if (getJsonField(
                                                                    quesItem,
                                                                    r'''$.option.c''',
                                                                  ) ==
                                                                  getJsonField(
                                                                    quesItem,
                                                                    r'''$.answer''',
                                                                  )) {
                                                                return ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/images/Vector_(1).svg',
                                                                    width: 24.0,
                                                                    height:
                                                                        24.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                );
                                                              } else if (getJsonField(
                                                                    quesItem,
                                                                    r'''$.option.c''',
                                                                  ) ==
                                                                  getJsonField(
                                                                    quesItem,
                                                                    r'''$.user_answer''',
                                                                  )) {
                                                                return Container(
                                                                  width: 26.0,
                                                                  height: 26.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .info,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child: Icon(
                                                                    Icons
                                                                        .cancel_sharp,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .error,
                                                                    size: 24.0,
                                                                  ),
                                                                );
                                                              } else {
                                                                return ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/images/Ellipse_19.svg',
                                                                    width: 24.0,
                                                                    height:
                                                                        24.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                          Expanded(
                                                            child: RichText(
                                                              textScaler:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        getJsonField(
                                                                      quesItem,
                                                                      r'''$.option.c''',
                                                                    ).toString(),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              false,
                                                                          lineHeight:
                                                                              1.5,
                                                                        ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: ' ',
                                                                    style:
                                                                        TextStyle(),
                                                                  ),
                                                                  TextSpan(
                                                                    text: () {
                                                                      if (getJsonField(
                                                                            quesItem,
                                                                            r'''$.option.c''',
                                                                          ) ==
                                                                          getJsonField(
                                                                            quesItem,
                                                                            r'''$.user_answer''',
                                                                          )) {
                                                                        return '(Your Answer)';
                                                                      } else if (getJsonField(
                                                                            quesItem,
                                                                            r'''$.option.c''',
                                                                          ) ==
                                                                          getJsonField(
                                                                            quesItem,
                                                                            r'''$.answer''',
                                                                          )) {
                                                                        return '(Correct Answer)';
                                                                      } else {
                                                                        return ' ';
                                                                      }
                                                                    }(),
                                                                    style:
                                                                        TextStyle(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .black40,
                                                                    ),
                                                                  )
                                                                ],
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize:
                                                                          17.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          false,
                                                                      lineHeight:
                                                                          1.5,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            width: 6.0)),
                                                      ),
                                                    ),
                                                  if ('${getJsonField(
                                                        quesItem,
                                                        r'''$.question_type''',
                                                      ).toString()}' !=
                                                      'true_false')
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Builder(
                                                            builder: (context) {
                                                              if (getJsonField(
                                                                    quesItem,
                                                                    r'''$.option.d''',
                                                                  ) ==
                                                                  getJsonField(
                                                                    quesItem,
                                                                    r'''$.answer''',
                                                                  )) {
                                                                return ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/images/Vector_(1).svg',
                                                                    width: 24.0,
                                                                    height:
                                                                        24.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                );
                                                              } else if (getJsonField(
                                                                    quesItem,
                                                                    r'''$.option.d''',
                                                                  ) ==
                                                                  getJsonField(
                                                                    quesItem,
                                                                    r'''$.user_answer''',
                                                                  )) {
                                                                return Container(
                                                                  width: 26.0,
                                                                  height: 26.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .info,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child: Icon(
                                                                    Icons
                                                                        .cancel_sharp,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                        .error,
                                                                    size: 24.0,
                                                                  ),
                                                                );
                                                              } else {
                                                                return ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/images/Ellipse_19.svg',
                                                                    width: 24.0,
                                                                    height:
                                                                        24.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                          Expanded(
                                                            child: RichText(
                                                              textScaler:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        getJsonField(
                                                                      quesItem,
                                                                      r'''$.option.d''',
                                                                    ).toString(),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              false,
                                                                          lineHeight:
                                                                              1.5,
                                                                        ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: ' ',
                                                                    style:
                                                                        TextStyle(),
                                                                  ),
                                                                  TextSpan(
                                                                    text: () {
                                                                      if (getJsonField(
                                                                            quesItem,
                                                                            r'''$.option.d''',
                                                                          ) ==
                                                                          getJsonField(
                                                                            quesItem,
                                                                            r'''$.user_answer''',
                                                                          )) {
                                                                        return '(Your Answer)';
                                                                      } else if (getJsonField(
                                                                            quesItem,
                                                                            r'''$.option.d''',
                                                                          ) ==
                                                                          getJsonField(
                                                                            quesItem,
                                                                            r'''$.answer''',
                                                                          )) {
                                                                        return '(Correct Answer)';
                                                                      } else {
                                                                        return ' ';
                                                                      }
                                                                    }(),
                                                                    style:
                                                                        TextStyle(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .black40,
                                                                    ),
                                                                  )
                                                                ],
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize:
                                                                          17.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          false,
                                                                      lineHeight:
                                                                          1.5,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            width: 6.0)),
                                                      ),
                                                    ),
                                                  if ('' !=
                                                      getJsonField(
                                                        quesItem,
                                                        r'''$.description''',
                                                      ).toString())
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: FFButtonWidget(
                                                        onPressed: () async {
                                                          context.pushNamed(
                                                            ExplanationPageWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'explanation':
                                                                  serializeParam(
                                                                getJsonField(
                                                                  quesItem,
                                                                  r'''$.description''',
                                                                ).toString(),
                                                                ParamType
                                                                    .String,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        },
                                                        text:
                                                            'View Explanation',
                                                        options:
                                                            FFButtonOptions(
                                                          width:
                                                              double.infinity,
                                                          height: 56.0,
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      24.0,
                                                                      0.0,
                                                                      24.0,
                                                                      0.0),
                                                          iconPadding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          textStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .override(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .white,
                                                                    fontSize:
                                                                        18.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    useGoogleFonts:
                                                                        false,
                                                                    lineHeight:
                                                                        1.2,
                                                                  ),
                                                          elevation: 0.0,
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 1.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                      ),
                                                    ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                  ),
                                                ]
                                                    .addToStart(
                                                        SizedBox(height: 16.0))
                                                    .addToEnd(
                                                        SizedBox(height: 16.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              Builder(
                                builder: (context) {
                                  final question =
                                      FFAppState().quesReviewList.where((q) => q['user_answer'] == 'skipped').toList();

                                  return ListView.separated(
                                    padding: EdgeInsets.fromLTRB(
                                      0,
                                      16.0,
                                      0,
                                      16.0,
                                    ),
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: question.length,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(height: 16.0),
                                    itemBuilder: (context, questionIndex) {
                                      final questionItem =
                                          question[questionIndex];
                                      print('REVIEW DEBUG: user_answer=' + (questionItem['user_answer']?.toString() ?? 'null') + ', answer=' + (questionItem['answer']?.toString() ?? 'null') + ', options=' + (questionItem['option']?.toString() ?? 'null'));
                                      return Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .white,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 15.0,
                                                color: Color(0x1A000000),
                                                offset: Offset(
                                                  0.0,
                                                  2.0,
                                                ),
                                                spreadRadius: 0.0,
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 0.0, 16.0, 0.0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1.0, 0.0),
                                                        child: RichText(
                                                          textScaler:
                                                              MediaQuery.of(
                                                                      context)
                                                                  .textScaler,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: 'Q',
                                                                style:
                                                                    TextStyle(),
                                                              ),
                                                              TextSpan(
                                                                text: (questionIndex +
                                                                        1)
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(),
                                                              ),
                                                              TextSpan(
                                                                text: '.',
                                                                style:
                                                                    TextStyle(),
                                                              )
                                                            ],
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize:
                                                                      15.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  useGoogleFonts:
                                                                      false,
                                                                  lineHeight:
                                                                      1.5,
                                                                ),
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1.0, 0.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        8.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: RichText(
                                                              textScaler:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        getJsonField(
                                                                      questionItem,
                                                                      r'''$.question_title''',
                                                                    ).toString(),
                                                                    style:
                                                                        TextStyle(),
                                                                  )
                                                                ],
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize:
                                                                          15.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      useGoogleFonts:
                                                                          false,
                                                                      lineHeight:
                                                                          1.5,
                                                                    ),
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if ('images' ==
                                                      getJsonField(
                                                        questionItem,
                                                        r'''$.question_type''',
                                                      ).toString())
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.network(
                                                          getJsonField(
                                                                    questionItem,
                                                                    r'''$.image''',
                                                                  ) !=
                                                                  null
                                                              ? '${FFAppConstants.imageBaseURL}${getJsonField(
                                                                  questionItem,
                                                                  r'''$.image''',
                                                                ).toString()}'
                                                              : 'https://images.unsplash.com/photo-1472457974886-0ebcd59440cc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyfHxsZWdvfGVufDB8fHx8MTcyNTUyNTYwMnww&ixlib=rb-4.0.3&q=80&w=1080',
                                                          width:
                                                              double.infinity,
                                                          height: 200.0,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  if ('audio' ==
                                                      getJsonField(
                                                        questionItem,
                                                        r'''$.question_type''',
                                                      ).toString())
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  0.0),
                                                      child:
                                                          FlutterFlowAudioPlayer(
                                                        audio: Audio.network(
                                                          getJsonField(
                                                                    questionItem,
                                                                    r'''$.audio''',
                                                                  ) !=
                                                                  null
                                                              ? '${FFAppConstants.imageBaseURL}${getJsonField(
                                                                  questionItem,
                                                                  r'''$.audio''',
                                                                ).toString()}'
                                                              : 'https://filesamples.com/samples/audio/mp3/sample3.mp3',
                                                          metas: Metas(
                                                            title: 'Title',
                                                          ),
                                                        ),
                                                        titleTextStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      false,
                                                                ),
                                                        playbackDurationTextStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      false,
                                                                ),
                                                        fillColor: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        playbackButtonColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        activeTrackColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        inactiveTrackColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        elevation: 0.0,
                                                        playInBackground:
                                                            PlayInBackground
                                                                .disabledRestoreOnForeground,
                                                      ),
                                                    ),
                                                  Builder(
                                                    builder: (context) {
                                                      if ('${getJsonField(
                                                            questionItem,
                                                            r'''$.question_type''',
                                                          ).toString()}' !=
                                                          'true_false') {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      16.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Builder(
                                                                builder:
                                                                    (context) {
                                                                  if (getJsonField(
                                                                        questionItem,
                                                                        r'''$.option.a''',
                                                                      ) ==
                                                                      getJsonField(
                                                                        questionItem,
                                                                        r'''$.answer''',
                                                                      )) {
                                                                    return ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/images/Vector_(1).svg',
                                                                        width:
                                                                            24.0,
                                                                        height:
                                                                            24.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return Container(
                                                                      width:
                                                                          26.0,
                                                                      height:
                                                                          26.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .info,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .cancel_sharp,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                              Expanded(
                                                                child: RichText(
                                                                  textScaler: MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            getJsonField(
                                                                          questionItem,
                                                                          r'''$.option.a''',
                                                                        ).toString(),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 17.0,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: false,
                                                                              lineHeight: 1.5,
                                                                            ),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            ' ',
                                                                        style:
                                                                            TextStyle(),
                                                                      ),
                                                                      TextSpan(
                                                                        text: getJsonField(
                                                                                  questionItem,
                                                                                  r'''$.option.a''',
                                                                                ) ==
                                                                                getJsonField(
                                                                                  questionItem,
                                                                                  r'''$.answer''',
                                                                                )
                                                                            ? '(Correct Answer)'
                                                                            : ' ',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).black40,
                                                                        ),
                                                                      )
                                                                    ],
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              false,
                                                                          lineHeight:
                                                                              1.5,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 6.0)),
                                                          ),
                                                        );
                                                      } else {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      16.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Builder(
                                                                builder:
                                                                    (context) {
                                                                  if ('True' ==
                                                                      getJsonField(
                                                                        questionItem,
                                                                        r'''$.answer''',
                                                                      ).toString()) {
                                                                    return ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/images/Vector_(1).svg',
                                                                        width:
                                                                            24.0,
                                                                        height:
                                                                            24.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return Container(
                                                                      width:
                                                                          26.0,
                                                                      height:
                                                                          26.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .info,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .cancel_sharp,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                              Expanded(
                                                                child: RichText(
                                                                  textScaler: MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'True',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 17.0,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: false,
                                                                              lineHeight: 1.5,
                                                                            ),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            ' ',
                                                                        style:
                                                                            TextStyle(),
                                                                      ),
                                                                      TextSpan(
                                                                        text: 'True' ==
                                                                                getJsonField(
                                                                                  questionItem,
                                                                                  r'''$.user_answer''',
                                                                                ).toString()
                                                                            ? '(Your Answer)'
                                                                            : ' ',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).black40,
                                                                        ),
                                                                      )
                                                                    ],
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              false,
                                                                          lineHeight:
                                                                              1.5,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 6.0)),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  Builder(
                                                    builder: (context) {
                                                      if ('${getJsonField(
                                                            questionItem,
                                                            r'''$.question_type''',
                                                          ).toString()}' !=
                                                          'true_false') {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      16.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Builder(
                                                                builder:
                                                                    (context) {
                                                                  if (getJsonField(
                                                                        questionItem,
                                                                        r'''$.option.b''',
                                                                      ) ==
                                                                      getJsonField(
                                                                        questionItem,
                                                                        r'''$.answer''',
                                                                      )) {
                                                                    return ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/images/Vector_(1).svg',
                                                                        width:
                                                                            24.0,
                                                                        height:
                                                                            24.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return Container(
                                                                      width:
                                                                          26.0,
                                                                      height:
                                                                          26.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .info,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .cancel_sharp,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                              Expanded(
                                                                child: RichText(
                                                                  textScaler: MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            getJsonField(
                                                                          questionItem,
                                                                          r'''$.option.b''',
                                                                        ).toString(),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 17.0,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: false,
                                                                              lineHeight: 1.5,
                                                                            ),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            ' ',
                                                                        style:
                                                                            TextStyle(),
                                                                      ),
                                                                      TextSpan(
                                                                        text: getJsonField(
                                                                                  questionItem,
                                                                                  r'''$.option.b''',
                                                                                ) ==
                                                                                getJsonField(
                                                                                  questionItem,
                                                                                  r'''$.answer''',
                                                                                )
                                                                            ? '(Correct Answer)'
                                                                            : ' ',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).black40,
                                                                        ),
                                                                      )
                                                                    ],
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              false,
                                                                          lineHeight:
                                                                              1.5,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 6.0)),
                                                          ),
                                                        );
                                                      } else {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      16.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Builder(
                                                                builder:
                                                                    (context) {
                                                                  if ('False' ==
                                                                      getJsonField(
                                                                        questionItem,
                                                                        r'''$.answer''',
                                                                      ).toString()) {
                                                                    return ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/images/Vector_(1).svg',
                                                                        width:
                                                                            24.0,
                                                                        height:
                                                                            24.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return Container(
                                                                      width:
                                                                          26.0,
                                                                      height:
                                                                          26.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .info,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .cancel_sharp,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                              Expanded(
                                                                child: RichText(
                                                                  textScaler: MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'False',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 17.0,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: false,
                                                                              lineHeight: 1.5,
                                                                            ),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            ' ',
                                                                        style:
                                                                            TextStyle(),
                                                                      ),
                                                                      TextSpan(
                                                                        text: 'False' ==
                                                                                getJsonField(
                                                                                  questionItem,
                                                                                  r'''$.user_answer''',
                                                                                ).toString()
                                                                            ? '(Your Answer)'
                                                                            : ' ',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).black40,
                                                                        ),
                                                                      )
                                                                    ],
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              false,
                                                                          lineHeight:
                                                                              1.5,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 6.0)),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  if ('${getJsonField(
                                                        questionItem,
                                                        r'''$.question_type''',
                                                      ).toString()}' !=
                                                      'true_false')
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Builder(
                                                            builder: (context) {
                                                              if (getJsonField(
                                                                    questionItem,
                                                                    r'''$.option.c''',
                                                                  ) ==
                                                                  getJsonField(
                                                                    questionItem,
                                                                    r'''$.answer''',
                                                                  )) {
                                                                return ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/images/Vector_(1).svg',
                                                                    width: 24.0,
                                                                    height:
                                                                        24.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                );
                                                              } else {
                                                                return Container(
                                                                  width: 26.0,
                                                                  height: 26.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .info,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child: Icon(
                                                                    Icons
                                                                        .cancel_sharp,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                        .error,
                                                                    size: 24.0,
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                          Expanded(
                                                            child: RichText(
                                                              textScaler:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        getJsonField(
                                                                      questionItem,
                                                                      r'''$.option.c''',
                                                                    ).toString(),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              false,
                                                                          lineHeight:
                                                                              1.5,
                                                                        ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: ' ',
                                                                    style:
                                                                        TextStyle(),
                                                                  ),
                                                                  TextSpan(
                                                                    text: getJsonField(
                                                                              questionItem,
                                                                              r'''$.option.c''',
                                                                            ) ==
                                                                            getJsonField(
                                                                              questionItem,
                                                                              r'''$.answer''',
                                                                            )
                                                                        ? '(Correct Answer)'
                                                                        : ' ',
                                                                    style:
                                                                        TextStyle(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .black40,
                                                                    ),
                                                                  )
                                                                ],
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize:
                                                                          17.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          false,
                                                                      lineHeight:
                                                                          1.5,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            width: 6.0)),
                                                      ),
                                                    ),
                                                  if ('${getJsonField(
                                                        questionItem,
                                                        r'''$.question_type''',
                                                      ).toString()}' !=
                                                      'true_false')
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Builder(
                                                            builder: (context) {
                                                              if (getJsonField(
                                                                    questionItem,
                                                                    r'''$.option.d''',
                                                                  ) ==
                                                                  getJsonField(
                                                                    questionItem,
                                                                    r'''$.answer''',
                                                                  )) {
                                                                return ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/images/Vector_(1).svg',
                                                                    width: 24.0,
                                                                    height:
                                                                        24.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                );
                                                              } else {
                                                                return Container(
                                                                  width: 26.0,
                                                                  height: 26.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .info,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child: Icon(
                                                                    Icons
                                                                        .cancel_sharp,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                        .error,
                                                                    size: 24.0,
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                          Expanded(
                                                            child: RichText(
                                                              textScaler:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        getJsonField(
                                                                      questionItem,
                                                                      r'''$.option.d''',
                                                                    ).toString(),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize:
                                                                              17.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              false,
                                                                          lineHeight:
                                                                              1.5,
                                                                        ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: ' ',
                                                                    style:
                                                                        TextStyle(),
                                                                  ),
                                                                  TextSpan(
                                                                    text: getJsonField(
                                                                              questionItem,
                                                                              r'''$.option.d''',
                                                                            ) ==
                                                                            getJsonField(
                                                                              questionItem,
                                                                              r'''$.answer''',
                                                                            )
                                                                        ? '(Correct Answer)'
                                                                        : ' ',
                                                                    style:
                                                                        TextStyle(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .black40,
                                                                    ),
                                                                  )
                                                                ],
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize:
                                                                          17.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          false,
                                                                      lineHeight:
                                                                          1.5,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            width: 6.0)),
                                                      ),
                                                    ),
                                                  if (getJsonField(
                                                        questionItem,
                                                        r'''$.description''',
                                                      ) !=
                                                      null)
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: FFButtonWidget(
                                                        onPressed: () async {
                                                          context.pushNamed(
                                                            ExplanationPageWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'explanation':
                                                                  serializeParam(
                                                                getJsonField(
                                                                  questionItem,
                                                                  r'''$.description''',
                                                                ).toString(),
                                                                ParamType
                                                                    .String,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        },
                                                        text:
                                                            'View explanation',
                                                        options:
                                                            FFButtonOptions(
                                                          width:
                                                              double.infinity,
                                                          height: 56.0,
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      24.0,
                                                                      0.0,
                                                                      24.0,
                                                                      0.0),
                                                          iconPadding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          textStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .override(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .white,
                                                                    fontSize:
                                                                        18.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    useGoogleFonts:
                                                                        false,
                                                                    lineHeight:
                                                                        1.2,
                                                                  ),
                                                          elevation: 0.0,
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 1.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                      ),
                                                    ),
                                                ]
                                                    .addToStart(
                                                        SizedBox(height: 16.0))
                                                    .addToEnd(
                                                        SizedBox(height: 16.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Lottie.asset(
                  'assets/jsons/No_Wifi.json',
                  width: 150.0,
                  height: 150.0,
                  fit: BoxFit.contain,
                  animate: true,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
