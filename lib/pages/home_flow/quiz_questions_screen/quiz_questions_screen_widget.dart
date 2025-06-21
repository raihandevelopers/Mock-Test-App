import '';
import '/backend/api_requests/api_calls.dart';
import '/componants/complete_quiz/complete_quiz_widget.dart';
import '/componants/option_dialog/option_dialog_widget.dart';
import '/componants/quit_quiz/quit_quiz_widget.dart';
import '/componants/timeout_dialog/timeout_dialog_widget.dart';
import '/flutter_flow/flutter_flow_audio_player.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'quiz_questions_screen_model.dart';
import 'package:google_cloud_translation/google_cloud_translation.dart';
export 'quiz_questions_screen_model.dart';

class QuizQuestionsScreenWidget extends StatefulWidget {
  const QuizQuestionsScreenWidget({
    super.key,
    this.title,
    this.catId,
    this.image,
    this.time,
    this.quizID,
    this.timerStatus,
  });

  final String? title;
  final String? catId;
  final String? image;
  final int? time;
  final String? quizID;
  final int? timerStatus;

  static String routeName = 'quiz_questions_screen';
  static String routePath = '/quizQuestionsScreen';

  @override
  State<QuizQuestionsScreenWidget> createState() =>
      _QuizQuestionsScreenWidgetState();
}

class _QuizQuestionsScreenWidgetState extends State<QuizQuestionsScreenWidget> {
  late QuizQuestionsScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Translation related state
  late Translation _translation;
  String _selectedLang = 'en';
  String _translatedQuestion = '';
  List<String> _translatedOptions = [];
  bool _isTranslating = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QuizQuestionsScreenModel());
    _translation = Translation(apiKey: 'AIzaSyCsrdktiTiJHrsd9n3EZ323XksrqVBIUzw'); // <-- Replace with your API key

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().quesIndex = _model.pageViewCurrentIndex + 1;
      safeSetState(() {});
      _model.quizRes = await QuizGroup.getquestionsbyquizidApiCall.call(
        quizId: widget.quizID,
        token: FFAppState().loginToken,
      );

      FFAppState().questionType = getJsonField(
        (_model.quizRes?.jsonBody ?? ''),
        r'''$.question_type''',
      ).toString().toString();
      safeSetState(() {});
      _model.isLoading = false;
      safeSetState(() {});
      await Future.delayed(const Duration(milliseconds: 1000));
      _model.timerController.onResetTimer();

      _model.timerController.onStartTimer();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> _translateQuestionAndOptions(String question, List<String> options) async {
    setState(() { _isTranslating = true; });
    final translatedQ = await _translation.translate(text: question, to: _selectedLang);
    final translatedOpts = <String>[];
    for (final opt in options) {
      final t = await _translation.translate(text: opt, to: _selectedLang);
      translatedOpts.add(t.translatedText);
    }
    setState(() {
      _translatedQuestion = translatedQ.translatedText;
      _translatedOptions = translatedOpts;
      _isTranslating = false;
    });
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Builder(
          builder: (context) {
            if (QuizGroup.getquestionsbyquizidApiCall.success(
                  (_model.quizRes?.jsonBody ?? ''),
                ) ==
                2) {
              return Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Text(
                    valueOrDefault<String>(
                      QuizGroup.getquestionsbyquizidApiCall.message(
                        (_model.quizRes?.jsonBody ?? ''),
                      ),
                      'Message',
                    ),
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Roboto',
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: false,
                          lineHeight: 1.5,
                        ),
                  ),
                ),
              );
            } else {
              return Builder(
                builder: (context) {
                  if (_model.isLoading == false) {
                    return Builder(
                      builder: (context) {
                        if (QuizGroup.getquestionsbyquizidApiCall.success(
                              (_model.quizRes?.jsonBody ?? ''),
                            ) ==
                            1) {
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 126.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 18.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Builder(
                                            builder: (context) => InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              onTap: () async {
                                                if (_model.pageViewCurrentIndex == 0) {
                                                  // Show quit dialog and reset state as before
                                                await showDialog(
                                                  context: context,
                                                  builder: (dialogContext) {
                                                    return Dialog(
                                                      elevation: 0,
                                                        insetPadding: EdgeInsets.zero,
                                                        backgroundColor: Colors.transparent,
                                                        alignment: AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                            FocusScope.of(dialogContext).unfocus();
                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                        },
                                                        child: QuitQuizWidget(),
                                                      ),
                                                    );
                                                  },
                                                );

                                                FFAppState().quesIndex = 1;
                                                safeSetState(() {});
                                                FFAppState().correctQues = 0;
                                                safeSetState(() {});
                                                FFAppState().wrongQues = 0;
                                                safeSetState(() {});
                                                } else {
                                                  // Go to previous question
                                                  await _model.pageViewController?.previousPage(
                                                    duration: Duration(milliseconds: 300),
                                                    curve: Curves.ease,
                                                  );
                                                  FFAppState().quesIndex = _model.pageViewCurrentIndex;
                                                  safeSetState(() {});
                                                }
                                              },
                                              child: Container(
                                                width: 40.0,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(context).lightGrey,
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                child: Icon(
                                                  _model.pageViewCurrentIndex == 0
                                                    ? Icons.close_sharp
                                                    : Icons.arrow_back_ios_new_rounded,
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                  size: 24.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: RichText(
                                                textScaler:
                                                    MediaQuery.of(context)
                                                        .textScaler,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: valueOrDefault<
                                                          String>(
                                                        widget.title,
                                                        'title',
                                                      ),
                                                      style: TextStyle(),
                                                    )
                                                  ],
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 22.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        useGoogleFonts: false,
                                                        lineHeight: 1.5,
                                                      ),
                                                ),
                                                maxLines: 2,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Builder(
                                              builder: (context) => InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  if (_model.userAnswer ==
                                                          null ||
                                                      _model.userAnswer == '') {
                                                    FFAppState().notAnswerQues =
                                                        FFAppState()
                                                                .notAnswerQues +
                                                            1;
                                                    FFAppState()
                                                        .addToNotAnswerQuestion(<String,
                                                            dynamic>{
                                                      'question_title':
                                                          getJsonField(
                                                        QuizGroup
                                                            .getquestionsbyquizidApiCall
                                                            .questionDetailsList(
                                                              (_model.quizRes
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            )
                                                            ?.elementAtOrNull(_model
                                                                .pageViewCurrentIndex),
                                                        r'''$.question_title''',
                                                      ),
                                                      'question_type':
                                                          getJsonField(
                                                        QuizGroup
                                                            .getquestionsbyquizidApiCall
                                                            .questionDetailsList(
                                                              (_model.quizRes
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            )
                                                            ?.elementAtOrNull(_model
                                                                .pageViewCurrentIndex),
                                                        r'''$.question_type''',
                                                      ),
                                                      'answer': getJsonField(
                                                        QuizGroup
                                                            .getquestionsbyquizidApiCall
                                                            .questionDetailsList(
                                                              (_model.quizRes
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            )
                                                            ?.elementAtOrNull(_model
                                                                .pageViewCurrentIndex),
                                                        r'''$.answer''',
                                                      ),
                                                      'option': getJsonField(
                                                        QuizGroup
                                                            .getquestionsbyquizidApiCall
                                                            .questionDetailsList(
                                                              (_model.quizRes
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            )
                                                            ?.elementAtOrNull(_model
                                                                .pageViewCurrentIndex),
                                                        r'''$.option''',
                                                      ),
                                                      'user_answer':
                                                          FFAppState().userAns,
                                                    });
                                                    FFAppState()
                                                        .quesIndex = _model
                                                            .pageViewCurrentIndex +
                                                        1;
                                                    safeSetState(() {});
                                                    if (QuizGroup
                                                            .getquestionsbyquizidApiCall
                                                            .questionDetailsList(
                                                              (_model.quizRes
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            )
                                                            ?.length ==
                                                        (_model.pageViewCurrentIndex +
                                                            1)) {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (dialogContext) {
                                                          return Dialog(
                                                            elevation: 0,
                                                            insetPadding:
                                                                EdgeInsets.zero,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            alignment: AlignmentDirectional(
                                                                    0.0, 0.0)
                                                                .resolve(
                                                                    Directionality.of(
                                                                        context)),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                FocusScope.of(
                                                                        dialogContext)
                                                                    .unfocus();
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                              },
                                                              child:
                                                                  CompleteQuizWidget(
                                                                completed:
                                                                    () async {
                                                                  FFAppState()
                                                                      .quesIndex = 0;
                                                                  safeSetState(
                                                                      () {});

                                                                  context
                                                                      .goNamed(
                                                                    QuizResultWidget
                                                                        .routeName,
                                                                    queryParameters:
                                                                        {
                                                                      'correctAnswer':
                                                                          serializeParam(
                                                                        FFAppState()
                                                                            .correctQues,
                                                                        ParamType
                                                                            .int,
                                                                      ),
                                                                      'wrongAnswer':
                                                                          serializeParam(
                                                                        FFAppState()
                                                                            .wrongQues,
                                                                        ParamType
                                                                            .int,
                                                                      ),
                                                                      'totalQuestion':
                                                                          serializeParam(
                                                                        QuizGroup
                                                                            .getquestionsbyquizidApiCall
                                                                            .questionDetailsList(
                                                                              (_model.quizRes?.jsonBody ?? ''),
                                                                            )
                                                                            ?.length,
                                                                        ParamType
                                                                            .int,
                                                                      ),
                                                                      'notAnswer':
                                                                          serializeParam(
                                                                        FFAppState()
                                                                            .notAnswerQues,
                                                                        ParamType
                                                                            .int,
                                                                      ),
                                                                      'quizID':
                                                                          serializeParam(
                                                                        widget
                                                                            .quizID,
                                                                        ParamType
                                                                            .String,
                                                                      ),
                                                                      'quizTime':
                                                                          serializeParam(
                                                                        widget
                                                                            .time
                                                                            ?.toString(),
                                                                        ParamType
                                                                            .String,
                                                                      ),
                                                                      'catID':
                                                                          serializeParam(
                                                                        widget
                                                                            .catId,
                                                                        ParamType
                                                                            .String,
                                                                      ),
                                                                      'title':
                                                                          serializeParam(
                                                                        widget
                                                                            .title,
                                                                        ParamType
                                                                            .String,
                                                                      ),
                                                                      'image':
                                                                          serializeParam(
                                                                        widget
                                                                            .image,
                                                                        ParamType
                                                                            .String,
                                                                      ),
                                                                    }.withoutNulls,
                                                                  );

                                                                  _model
                                                                      .timerController
                                                                      .onResetTimer();
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );

                                                      await _model
                                                          .pageViewController
                                                          ?.animateToPage(
                                                        0,
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        curve: Curves.ease,
                                                      );
                                                    } else {
                                                      FFAppState()
                                                          .quesIndex = _model
                                                              .pageViewCurrentIndex +
                                                          1;
                                                      safeSetState(() {});
                                                      if (QuizGroup
                                                              .getquestionsbyquizidApiCall
                                                              .questionDetailsList(
                                                                (_model.quizRes
                                                                        ?.jsonBody ??
                                                                    ''),
                                                              )
                                                              ?.length !=
                                                          FFAppState()
                                                              .quesIndex) {
                                                        await _model
                                                            .pageViewController
                                                            ?.nextPage(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  300),
                                                          curve: Curves.ease,
                                                        );
                                                      }
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  width: 70.0,
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Text(
                                                    'Skip',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Roboto',
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          useGoogleFonts: false,
                                                          lineHeight: 1.5,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 1.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .black10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Stack(
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1.0, 0.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 0.0, 12.0),
                                            child: RichText(
                                              textScaler: MediaQuery.of(context)
                                                  .textScaler,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'Question ',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Roboto',
                                                          fontSize: 20.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          useGoogleFonts: false,
                                                          lineHeight: 1.5,
                                                        ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        (_model.pageViewCurrentIndex +
                                                                1)
                                                            .toString(),
                                                    style: TextStyle(),
                                                  ),
                                                  TextSpan(
                                                    text: ' of ',
                                                    style: TextStyle(),
                                                  ),
                                                  TextSpan(
                                                    text: QuizGroup
                                                        .getquestionsbyquizidApiCall
                                                        .questionDetailsList(
                                                          (_model.quizRes
                                                                  ?.jsonBody ??
                                                              ''),
                                                        )!
                                                        .length
                                                        .toString(),
                                                    style: TextStyle(),
                                                  )
                                                ],
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Roboto',
                                                          fontSize: 20.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          useGoogleFonts: false,
                                                          lineHeight: 1.5,
                                                        ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (widget.timerStatus == 1)
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 0.0, 16.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 15.0,
                                                                0.0, 0.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                      child: custom_widgets
                                                          .LinearBarTimer(
                                                        width: 309.0,
                                                        height: 10.0,
                                                        time: (widget.time!) *
                                                            60 *
                                                            1000,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 100.0,
                                                  height: 34.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Builder(
                                                    builder: (context) =>
                                                        FlutterFlowTimer(
                                                      initialTime:
                                                          (widget.time!) *
                                                              60 *
                                                              1000,
                                                      getDisplayTime: (value) =>
                                                          StopWatchTimer
                                                              .getDisplayTime(
                                                        value,
                                                        hours: false,
                                                        milliSecond: false,
                                                      ),
                                                      controller: _model
                                                          .timerController,
                                                      updateStateInterval:
                                                          Duration(
                                                              milliseconds:
                                                                  1000),
                                                      onChanged: (value,
                                                          displayTime,
                                                          shouldUpdate) {
                                                        _model.timerMilliseconds =
                                                            value;
                                                        _model.timerValue =
                                                            displayTime;
                                                        if (shouldUpdate)
                                                          safeSetState(() {});
                                                      },
                                                      textAlign: TextAlign.center,
                                                      style: FlutterFlowTheme.of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Roboto',
                                                            color: Colors.white,
                                                            fontSize: 16.0,
                                                            useGoogleFonts: false,
                                                          ),
                                                      onEnded: () async {
                                                        await showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder:
                                                              (dialogContext) {
                                                            return Dialog(
                                                              elevation: 0,
                                                              insetPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              alignment: AlignmentDirectional(
                                                                      0.0, 0.0)
                                                                  .resolve(
                                                                      Directionality.of(
                                                                          context)),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  FocusScope.of(
                                                                          dialogContext)
                                                                      .unfocus();
                                                                  FocusManager
                                                                      .instance
                                                                      .primaryFocus
                                                                      ?.unfocus();
                                                                },
                                                                child:
                                                                    TimeoutDialogWidget(
                                                                  istimeout:
                                                                      () async {
                                                                    FFAppState()
                                                                        .clearCoinsCache();

                                                                    context
                                                                        .pushNamed(
                                                                      QuizResultWidget
                                                                          .routeName,
                                                                      queryParameters:
                                                                          {
                                                                        'correctAnswer':
                                                                            serializeParam(
                                                                        FFAppState()
                                                                            .correctQues,
                                                                        ParamType
                                                                            .int,
                                                                        ),
                                                                        'wrongAnswer':
                                                                            serializeParam(
                                                                        FFAppState()
                                                                            .wrongQues,
                                                                        ParamType
                                                                            .int,
                                                                        ),
                                                                        'totalQuestion':
                                                                            serializeParam(
                                                                        QuizGroup
                                                                            .getquestionsbyquizidApiCall
                                                                            .questionDetailsList(
                                                                              (_model.quizRes?.jsonBody ?? ''),
                                                                            )
                                                                            ?.length,
                                                                        ParamType
                                                                            .int,
                                                                        ),
                                                                        'notAnswer':
                                                                            serializeParam(
                                                                        FFAppState()
                                                                            .notAnswerQues,
                                                                        ParamType
                                                                            .int,
                                                                        ),
                                                                        'quizID':
                                                                            serializeParam(
                                                                        FFAppState()
                                                                            .quizID,
                                                                        ParamType
                                                                            .String,
                                                                        ),
                                                                        'title':
                                                                            serializeParam(
                                                                        widget
                                                                            .title,
                                                                        ParamType
                                                                            .String,
                                                                        ),
                                                                      }.withoutNulls,
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 16.0)),
                                            ),
                                          ),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            primary: false,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 625.0,
                                                  decoration: BoxDecoration(),
                                                  child: Builder(
                                                    builder: (context) {
                                                      final categorywisequiz = QuizGroup
                                                              .getquestionsbyquizidApiCall
                                                              .questionDetailsList(
                                                                (_model.quizRes
                                                                        ?.jsonBody ??
                                                                    ''),
                                                              )
                                                              ?.toList() ??
                                                          [];

                                                      return Container(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      40.0),
                                                          child:
                                                              PageView.builder(
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            controller: _model
                                                                    .pageViewController ??=
                                                                PageController(
                                                                    initialPage: max(
                                                                        0,
                                                                        min(
                                                                            0,
                                                                            categorywisequiz.length -
                                                                                1))),
                                                            onPageChanged:
                                                                (_) async {
                                                              FFAppState()
                                                                      .questionType =
                                                                  getJsonField(
                                                                categorywisequiz
                                                                    .elementAtOrNull(
                                                                        _model
                                                                            .pageViewCurrentIndex),
                                                                r'''$.question_type''',
                                                              ).toString();
                                                              safeSetState(
                                                                  () {});
                                                            },
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount:
                                                                categorywisequiz
                                                                    .length,
                                                            itemBuilder: (context,
                                                                categorywisequizIndex) {
                                                              final categorywisequizItem =
                                                                  categorywisequiz[
                                                                      categorywisequizIndex];
                                                              return Builder(
                                                                builder:
                                                                    (context) {
                                                                  if ('${getJsonField(
                                                                        categorywisequizItem,
                                                                        r'''$.question_type''',
                                                                      ).toString()}' ==
                                                                      'text_only') {
                                                                    return Container(
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            16.0,
                                                                            0.0,
                                                                            16.0,
                                                                            0.0),
                                                                        child:
                                                                            ListView(
                                                                          padding:
                                                                              EdgeInsets.fromLTRB(
                                                                            0,
                                                                            24.0,
                                                                            0,
                                                                            24.0,
                                                                          ),
                                                                          primary:
                                                                              false,
                                                                          scrollDirection:
                                                                              Axis.vertical,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Text('Language: '),
                                                                                  DropdownButton<String>(
                                                                                    value: _selectedLang,
                                                                                    items: [
                                                                                      DropdownMenuItem(value: 'en', child: Text('English')),
                                                                                      DropdownMenuItem(value: 'hi', child: Text('Hindi')),
                                                                                    ],
                                                                                    onChanged: (val) async {
                                                                                      if (val == null) return;
                                                                                      setState(() { _selectedLang = val; });
                                                                                      // Get current question and options
                                                                                      final categorywisequiz = QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''),)?.toList() ?? [];
                                                                                      final idx = _model.pageViewCurrentIndex;
                                                                                      if (categorywisequiz.isNotEmpty && idx < categorywisequiz.length) {
                                                                                        final q = getJsonField(categorywisequiz[idx], r'''$.question_title''').toString();
                                                                                        final opts = [
                                                                                          getJsonField(categorywisequiz[idx], r'''$.option.a''').toString(),
                                                                                          getJsonField(categorywisequiz[idx], r'''$.option.b''').toString(),
                                                                                          getJsonField(categorywisequiz[idx], r'''$.option.c''').toString(),
                                                                                          getJsonField(categorywisequiz[idx], r'''$.option.d''').toString(),
                                                                                        ];
                                                                                        if (val == 'en') {
                                                                                          setState(() {
                                                                                            _translatedQuestion = q;
                                                                                            _translatedOptions = opts;
                                                                                          });
                                                                                        } else {
                                                                                          await _translateQuestionAndOptions(q, opts);
                                                                                        }
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Align(
                                                                              alignment: AlignmentDirectional(-1.0, 0.0),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                                                                                child: Text(
                                                                                  _selectedLang == 'en'
                                                                                    ? getJsonField(categorywisequizItem, r'''$.question_title''').toString()
                                                                                    : _translatedQuestion.isNotEmpty ? _translatedQuestion : getJsonField(categorywisequizItem, r'''$.question_title''').toString(),
                                                                                  textAlign: TextAlign.start,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Roboto',
                                                                                        fontSize: 18.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        useGoogleFonts: false,
                                                                                        lineHeight: 1.2,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                                                              child: InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  _model.userAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.option.a''',
                                                                                  ).toString();
                                                                                  _model.actualAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.answer''',
                                                                                  ).toString();
                                                                                  safeSetState(() {});
                                                                                  FFAppState().selectedColorIndex = 0;
                                                                                  FFAppState().update(() {});
                                                                                },
                                                                                child: Container(
                                                                                  width: 369.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FFAppState().selectedColorIndex == 0 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).grey,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  alignment: AlignmentDirectional(0.0, 0.0),
                                                                                  child: Align(
                                                                                    alignment: AlignmentDirectional(0.0, 0.0),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.all(16.0),
                                                                                      child: Text(
                                                                                        _selectedLang == 'en'
                                                                                          ? getJsonField(categorywisequizItem, r'''$.option.a''').toString()
                                                                                          : (_translatedOptions.isNotEmpty ? _translatedOptions[0] : getJsonField(categorywisequizItem, r'''$.option.a''').toString()),
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Roboto',
                                                                                              fontSize: 18.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              useGoogleFonts: false,
                                                                                              lineHeight: 1.5,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                                                              child: InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  _model.userAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.option.b''',
                                                                                  ).toString();
                                                                                  _model.actualAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.answer''',
                                                                                  ).toString();
                                                                                  safeSetState(() {});
                                                                                  FFAppState().selectedColorIndex = 1;
                                                                                  FFAppState().update(() {});
                                                                                },
                                                                                child: Container(
                                                                                  width: 369.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FFAppState().selectedColorIndex == 1 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).grey,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  child: Align(
                                                                                    alignment: AlignmentDirectional(0.0, 0.0),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.all(16.0),
                                                                                      child: Text(
                                                                                        _selectedLang == 'en'
                                                                                          ? getJsonField(categorywisequizItem, r'''$.option.b''').toString()
                                                                                          : (_translatedOptions.isNotEmpty ? _translatedOptions[1] : getJsonField(categorywisequizItem, r'''$.option.b''').toString()),
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Roboto',
                                                                                              fontSize: 18.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              useGoogleFonts: false,
                                                                                              lineHeight: 1.5,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                                                              child: InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  _model.userAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.option.c''',
                                                                                  ).toString();
                                                                                  _model.actualAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.answer''',
                                                                                  ).toString();
                                                                                  safeSetState(() {});
                                                                                  FFAppState().selectedColorIndex = 2;
                                                                                  FFAppState().update(() {});
                                                                                },
                                                                                child: Container(
                                                                                  width: 369.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FFAppState().selectedColorIndex == 2 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).grey,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  child: Align(
                                                                                    alignment: AlignmentDirectional(0.0, 0.0),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.all(16.0),
                                                                                      child: Text(
                                                                                        _selectedLang == 'en'
                                                                                          ? getJsonField(categorywisequizItem, r'''$.option.c''').toString()
                                                                                          : (_translatedOptions.isNotEmpty ? _translatedOptions[2] : getJsonField(categorywisequizItem, r'''$.option.c''').toString()),
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Roboto',
                                                                                              fontSize: 18.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              useGoogleFonts: false,
                                                                                              lineHeight: 1.5,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            InkWell(
                                                                              splashColor: Colors.transparent,
                                                                              focusColor: Colors.transparent,
                                                                              hoverColor: Colors.transparent,
                                                                              highlightColor: Colors.transparent,
                                                                              onTap: () async {
                                                                                _model.userAnswer = getJsonField(
                                                                                  categorywisequizItem,
                                                                                  r'''$.option.d''',
                                                                                ).toString();
                                                                                _model.actualAnswer = getJsonField(
                                                                                  categorywisequizItem,
                                                                                  r'''$.answer''',
                                                                                ).toString();
                                                                                safeSetState(() {});
                                                                                FFAppState().selectedColorIndex = 3;
                                                                                FFAppState().update(() {});
                                                                              },
                                                                              child: Container(
                                                                                width: 369.0,
                                                                                decoration: BoxDecoration(
                                                                                  color: FFAppState().selectedColorIndex == 3 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).grey,
                                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                                ),
                                                                                child: Align(
                                                                                  alignment: AlignmentDirectional(0.0, 0.0),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.all(16.0),
                                                                                    child: Text(
                                                                                      _selectedLang == 'en'
                                                                                        ? getJsonField(categorywisequizItem, r'''$.option.d''').toString()
                                                                                        : (_translatedOptions.isNotEmpty ? _translatedOptions[3] : getJsonField(categorywisequizItem, r'''$.option.d''').toString()),
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Roboto',
                                                                                            fontSize: 18.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            useGoogleFonts: false,
                                                                                            lineHeight: 1.5,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  } else if ('${getJsonField(
                                                                        categorywisequizItem,
                                                                        r'''$.question_type''',
                                                                      ).toString()}' ==
                                                                      'true_false') {
                                                                    return Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          16.0,
                                                                          50.0,
                                                                          16.0,
                                                                          20.0),
                                                                      child:
                                                                          Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            50.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          borderRadius:
                                                                              BorderRadius.circular(16.0),
                                                                        ),
                                                                        alignment: AlignmentDirectional(
                                                                            0.0,
                                                                            -1.0),
                                                                        child:
                                                                            ListView(
                                                                          padding:
                                                                              EdgeInsets.fromLTRB(
                                                                            0,
                                                                            24.0,
                                                                            0,
                                                                            24.0,
                                                                          ),
                                                                          primary:
                                                                              false,
                                                                          scrollDirection:
                                                                              Axis.vertical,
                                                                          children: [
                                                                            Align(
                                                                              alignment: AlignmentDirectional(-1.0, 0.0),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                                                                                child: Text(
                                                                                  _selectedLang == 'en'
                                                                                    ? getJsonField(categorywisequizItem, r'''$.question_title''').toString()
                                                                                    : _translatedQuestion.isNotEmpty ? _translatedQuestion : getJsonField(categorywisequizItem, r'''$.question_title''').toString(),
                                                                                  textAlign: TextAlign.start,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Roboto',
                                                                                        fontSize: 18.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        useGoogleFonts: false,
                                                                                        lineHeight: 1.2,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                                                              child: InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  _model.userAnswer = 'True';
                                                                                  _model.actualAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.answer''',
                                                                                  ).toString();
                                                                                  safeSetState(() {});
                                                                                  FFAppState().selectedColorIndex = 0;
                                                                                  FFAppState().update(() {});
                                                                                },
                                                                                child: Container(
                                                                                  width: 369.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FFAppState().selectedColorIndex == 0 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).grey,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  alignment: AlignmentDirectional(0.0, 0.0),
                                                                                  child: Align(
                                                                                    alignment: AlignmentDirectional(0.0, 0.0),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.all(16.0),
                                                                                      child: Text(
                                                                                        'True',
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Roboto',
                                                                                              fontSize: 18.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              useGoogleFonts: false,
                                                                                              lineHeight: 1.5,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                                                              child: InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  _model.userAnswer = 'False';
                                                                                  _model.actualAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.answer''',
                                                                                  ).toString();
                                                                                  safeSetState(() {});
                                                                                  FFAppState().selectedColorIndex = 1;
                                                                                  FFAppState().update(() {});
                                                                                },
                                                                                child: Container(
                                                                                  width: 369.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FFAppState().selectedColorIndex == 1 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).grey,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  child: Align(
                                                                                    alignment: AlignmentDirectional(0.0, 0.0),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.all(16.0),
                                                                                      child: Text(
                                                                                        'False',
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Roboto',
                                                                                              fontSize: 18.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              useGoogleFonts: false,
                                                                                              lineHeight: 1.5,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  } else if ('${getJsonField(
                                                                        categorywisequizItem,
                                                                        r'''$.question_type''',
                                                                      ).toString()}' ==
                                                                      'images') {
                                                                    return Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          16.0,
                                                                          50.0,
                                                                          16.0,
                                                                          20.0),
                                                                      child:
                                                                          Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            50.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          borderRadius:
                                                                              BorderRadius.circular(16.0),
                                                                        ),
                                                                        alignment: AlignmentDirectional(
                                                                            0.0,
                                                                            -1.0),
                                                                        child:
                                                                            ListView(
                                                                          padding:
                                                                              EdgeInsets.fromLTRB(
                                                                            0,
                                                                            24.0,
                                                                            0,
                                                                            24.0,
                                                                          ),
                                                                          primary:
                                                                              false,
                                                                          scrollDirection:
                                                                              Axis.vertical,
                                                                          children: [
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(12.0),
                                                                              child: CachedNetworkImage(
                                                                                fadeInDuration: Duration(milliseconds: 500),
                                                                                fadeOutDuration: Duration(milliseconds: 500),
                                                                                imageUrl: getJsonField(
                                                                                          categorywisequizItem,
                                                                                          r'''$.image''',
                                                                                        ) !=
                                                                                        null
                                                                                    ? '${FFAppConstants.imageBaseURL}${getJsonField(
                                                                                        categorywisequizItem,
                                                                                        r'''$.image''',
                                                                                      ).toString()}'
                                                                                    : 'https://images.unsplash.com/photo-1472457974886-0ebcd59440cc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyfHxsZWdvfGVufDB8fHx8MTcyNTUyNTYwMnww&ixlib=rb-4.0.3&q=80&w=1080',
                                                                                width: 200.0,
                                                                                height: 200.0,
                                                                                fit: BoxFit.contain,
                                                                                alignment: Alignment(0.0, 0.0),
                                                                              ),
                                                                            ),
                                                                            Align(
                                                                              alignment: AlignmentDirectional(-1.0, 0.0),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 24.0),
                                                                                child: Text(
                                                                                  _selectedLang == 'en'
                                                                                    ? getJsonField(categorywisequizItem, r'''$.question_title''').toString()
                                                                                    : _translatedQuestion.isNotEmpty ? _translatedQuestion : getJsonField(categorywisequizItem, r'''$.question_title''').toString(),
                                                                                  textAlign: TextAlign.start,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Roboto',
                                                                                        fontSize: 18.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        useGoogleFonts: false,
                                                                                        lineHeight: 1.2,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Expanded(
                                                                                  child: InkWell(
                                                                                    splashColor: Colors.transparent,
                                                                                    focusColor: Colors.transparent,
                                                                                    hoverColor: Colors.transparent,
                                                                                    highlightColor: Colors.transparent,
                                                                                    onTap: () async {
                                                                                      _model.userAnswer = getJsonField(
                                                                                        categorywisequizItem,
                                                                                        r'''$.option.a''',
                                                                                      ).toString();
                                                                                      _model.actualAnswer = getJsonField(
                                                                                        categorywisequizItem,
                                                                                        r'''$.answer''',
                                                                                      ).toString();
                                                                                      safeSetState(() {});
                                                                                      FFAppState().selectedColorIndex = 0;
                                                                                      FFAppState().update(() {});
                                                                                    },
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: FFAppState().selectedColorIndex == 0 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).grey,
                                                                                        borderRadius: BorderRadius.circular(12.0),
                                                                                      ),
                                                                                      alignment: AlignmentDirectional(0.0, 0.0),
                                                                                      child: Align(
                                                                                        alignment: AlignmentDirectional(0.0, 0.0),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.all(16.0),
                                                                                          child: Text(
                                                                                            _selectedLang == 'en'
                                                                                              ? getJsonField(categorywisequizItem, r'''$.option.a''').toString()
                                                                                              : (_translatedOptions.isNotEmpty ? _translatedOptions[0] : getJsonField(categorywisequizItem, r'''$.option.a''').toString()),
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: 'Roboto',
                                                                                                  fontSize: 18.0,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.normal,
                                                                                                  useGoogleFonts: false,
                                                                                                  lineHeight: 1.5,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: InkWell(
                                                                                    splashColor: Colors.transparent,
                                                                                    focusColor: Colors.transparent,
                                                                                    hoverColor: Colors.transparent,
                                                                                    highlightColor: Colors.transparent,
                                                                                    onTap: () async {
                                                                                      _model.userAnswer = getJsonField(
                                                                                        categorywisequizItem,
                                                                                        r'''$.option.b''',
                                                                                      ).toString();
                                                                                      _model.actualAnswer = getJsonField(
                                                                                        categorywisequizItem,
                                                                                        r'''$.answer''',
                                                                                      ).toString();
                                                                                      safeSetState(() {});
                                                                                      FFAppState().selectedColorIndex = 1;
                                                                                      FFAppState().update(() {});
                                                                                    },
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: FFAppState().selectedColorIndex == 1 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).grey,
                                                                                        borderRadius: BorderRadius.circular(12.0),
                                                                                      ),
                                                                                      child: Align(
                                                                                        alignment: AlignmentDirectional(0.0, 0.0),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.all(16.0),
                                                                                          child: Text(
                                                                                            _selectedLang == 'en'
                                                                                              ? getJsonField(categorywisequizItem, r'''$.option.b''').toString()
                                                                                              : (_translatedOptions.isNotEmpty ? _translatedOptions[1] : getJsonField(categorywisequizItem, r'''$.option.b''').toString()),
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  fontFamily: 'Roboto',
                                                                                                  fontSize: 18.0,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.normal,
                                                                                                  useGoogleFonts: false,
                                                                                                  lineHeight: 1.5,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ].divide(SizedBox(width: 16.0)),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      focusColor: Colors.transparent,
                                                                                      hoverColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () async {
                                                                                        _model.userAnswer = getJsonField(
                                                                                          categorywisequizItem,
                                                                                          r'''$.option.c''',
                                                                                        ).toString();
                                                                                        _model.actualAnswer = getJsonField(
                                                                                          categorywisequizItem,
                                                                                          r'''$.answer''',
                                                                                        ).toString();
                                                                                        safeSetState(() {});
                                                                                        FFAppState().selectedColorIndex = 2;
                                                                                        FFAppState().update(() {});
                                                                                      },
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          color: FFAppState().selectedColorIndex == 2 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).grey,
                                                                                          borderRadius: BorderRadius.circular(12.0),
                                                                                        ),
                                                                                        alignment: AlignmentDirectional(0.0, 0.0),
                                                                                        child: Align(
                                                                                          alignment: AlignmentDirectional(0.0, 0.0),
                                                                                          child: Padding(
                                                                                            padding: EdgeInsets.all(16.0),
                                                                                            child: Text(
                                                                                              _selectedLang == 'en'
                                                                                                ? getJsonField(categorywisequizItem, r'''$.option.c''').toString()
                                                                                                : (_translatedOptions.isNotEmpty ? _translatedOptions[2] : getJsonField(categorywisequizItem, r'''$.option.c''').toString()),
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    fontFamily: 'Roboto',
                                                                                                    fontSize: 18.0,
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.normal,
                                                                                                    useGoogleFonts: false,
                                                                                                    lineHeight: 1.5,
                                                                                                  ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      focusColor: Colors.transparent,
                                                                                      hoverColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () async {
                                                                                        _model.userAnswer = getJsonField(
                                                                                          categorywisequizItem,
                                                                                          r'''$.option.d''',
                                                                                        ).toString();
                                                                                        _model.actualAnswer = getJsonField(
                                                                                          categorywisequizItem,
                                                                                          r'''$.answer''',
                                                                                        ).toString();
                                                                                        safeSetState(() {});
                                                                                        FFAppState().selectedColorIndex = 3;
                                                                                        FFAppState().update(() {});
                                                                                      },
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          color: FFAppState().selectedColorIndex == 3 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).grey,
                                                                                          borderRadius: BorderRadius.circular(12.0),
                                                                                        ),
                                                                                        child: Align(
                                                                                          alignment: AlignmentDirectional(0.0, 0.0),
                                                                                          child: Padding(
                                                                                            padding: EdgeInsets.all(16.0),
                                                                                            child: Text(
                                                                                              _selectedLang == 'en'
                                                                                                ? getJsonField(categorywisequizItem, r'''$.option.d''').toString()
                                                                                                : (_translatedOptions.isNotEmpty ? _translatedOptions[3] : getJsonField(categorywisequizItem, r'''$.option.d''').toString()),
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    fontFamily: 'Roboto',
                                                                                                    fontSize: 18.0,
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.normal,
                                                                                                    useGoogleFonts: false,
                                                                                                    lineHeight: 1.5,
                                                                                                  ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ].divide(SizedBox(width: 16.0)),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  } else if ('${getJsonField(
                                                                        categorywisequizItem,
                                                                        r'''$.question_type''',
                                                                      ).toString()}' ==
                                                                      'audio') {
                                                                    return Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          16.0,
                                                                          50.0,
                                                                          16.0,
                                                                          20.0),
                                                                      child:
                                                                          Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            50.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          borderRadius:
                                                                              BorderRadius.circular(16.0),
                                                                        ),
                                                                        alignment: AlignmentDirectional(
                                                                            0.0,
                                                                            -1.0),
                                                                        child:
                                                                            ListView(
                                                                          padding:
                                                                              EdgeInsets.fromLTRB(
                                                                            0,
                                                                            24.0,
                                                                            0,
                                                                            24.0,
                                                                          ),
                                                                          primary:
                                                                              false,
                                                                          scrollDirection:
                                                                              Axis.vertical,
                                                                          children: [
                                                                            Align(
                                                                              alignment: AlignmentDirectional(-1.0, 0.0),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                                                                                child: Text(
                                                                                  _selectedLang == 'en'
                                                                                    ? getJsonField(categorywisequizItem, r'''$.question_title''').toString()
                                                                                    : _translatedQuestion.isNotEmpty ? _translatedQuestion : getJsonField(categorywisequizItem, r'''$.question_title''').toString(),
                                                                                  textAlign: TextAlign.start,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Roboto',
                                                                                        fontSize: 18.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        useGoogleFonts: false,
                                                                                        lineHeight: 1.2,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                                                                              child: FlutterFlowAudioPlayer(
                                                                                audio: Audio.network(
                                                                                  getJsonField(
                                                                                            categorywisequizItem,
                                                                                            r'''$.audio''',
                                                                                          ) !=
                                                                                          null
                                                                                      ? '${FFAppConstants.imageBaseURL}${getJsonField(
                                                                                          categorywisequizItem,
                                                                                          r'''$.audio''',
                                                                                        ).toString()}'
                                                                                      : 'https://filesamples.com/samples/audio/mp3/sample3.mp3',
                                                                                  metas: Metas(
                                                                                    title: 'Audio',
                                                                                  ),
                                                                                ),
                                                                                titleTextStyle: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                      fontFamily: 'Roboto',
                                                                                      letterSpacing: 0.0,
                                                                                      useGoogleFonts: false,
                                                                                    ),
                                                                                playbackDurationTextStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                      fontFamily: 'Roboto',
                                                                                      letterSpacing: 0.0,
                                                                                      useGoogleFonts: false,
                                                                                    ),
                                                                                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                playbackButtonColor: FlutterFlowTheme.of(context).primary,
                                                                                activeTrackColor: FlutterFlowTheme.of(context).primary,
                                                                                inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
                                                                                elevation: 0.0,
                                                                                playInBackground: PlayInBackground.disabledRestoreOnForeground,
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                                                              child: InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  _model.userAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.option.a''',
                                                                                  ).toString();
                                                                                  _model.actualAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.answer''',
                                                                                  ).toString();
                                                                                  safeSetState(() {});
                                                                                  FFAppState().selectedColorIndex = 0;
                                                                                  FFAppState().update(() {});
                                                                                },
                                                                                child: Container(
                                                                                  width: 369.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FFAppState().selectedColorIndex == 0 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).grey,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  alignment: AlignmentDirectional(0.0, 0.0),
                                                                                  child: Align(
                                                                                    alignment: AlignmentDirectional(0.0, 0.0),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.all(16.0),
                                                                                      child: Text(
                                                                                        _selectedLang == 'en'
                                                                                          ? getJsonField(categorywisequizItem, r'''$.option.a''').toString()
                                                                                          : (_translatedOptions.isNotEmpty ? _translatedOptions[0] : getJsonField(categorywisequizItem, r'''$.option.a''').toString()),
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Roboto',
                                                                                              fontSize: 18.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              useGoogleFonts: false,
                                                                                              lineHeight: 1.5,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                                                              child: InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  _model.userAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.option.b''',
                                                                                  ).toString();
                                                                                  _model.actualAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.answer''',
                                                                                  ).toString();
                                                                                  safeSetState(() {});
                                                                                  FFAppState().selectedColorIndex = 1;
                                                                                  FFAppState().update(() {});
                                                                                },
                                                                                child: Container(
                                                                                  width: 369.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FFAppState().selectedColorIndex == 1 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).grey,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  child: Align(
                                                                                    alignment: AlignmentDirectional(0.0, 0.0),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.all(16.0),
                                                                                      child: Text(
                                                                                        _selectedLang == 'en'
                                                                                          ? getJsonField(categorywisequizItem, r'''$.option.b''').toString()
                                                                                          : (_translatedOptions.isNotEmpty ? _translatedOptions[1] : getJsonField(categorywisequizItem, r'''$.option.b''').toString()),
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Roboto',
                                                                                              fontSize: 18.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              useGoogleFonts: false,
                                                                                              lineHeight: 1.5,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                                                              child: InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  _model.userAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.option.c''',
                                                                                  ).toString();
                                                                                  _model.actualAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.answer''',
                                                                                  ).toString();
                                                                                  safeSetState(() {});
                                                                                  FFAppState().selectedColorIndex = 2;
                                                                                  FFAppState().update(() {});
                                                                                },
                                                                                child: Container(
                                                                                  width: 369.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FFAppState().selectedColorIndex == 2 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).grey,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  child: Align(
                                                                                    alignment: AlignmentDirectional(0.0, 0.0),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.all(16.0),
                                                                                      child: Text(
                                                                                        _selectedLang == 'en'
                                                                                          ? getJsonField(categorywisequizItem, r'''$.option.c''').toString()
                                                                                          : (_translatedOptions.isNotEmpty ? _translatedOptions[2] : getJsonField(categorywisequizItem, r'''$.option.c''').toString()),
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Roboto',
                                                                                              fontSize: 18.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              useGoogleFonts: false,
                                                                                              lineHeight: 1.5,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            InkWell(
                                                                              splashColor: Colors.transparent,
                                                                              focusColor: Colors.transparent,
                                                                              hoverColor: Colors.transparent,
                                                                              highlightColor: Colors.transparent,
                                                                              onTap: () async {
                                                                                _model.userAnswer = getJsonField(
                                                                                  categorywisequizItem,
                                                                                  r'''$.option.d''',
                                                                                ).toString();
                                                                                _model.actualAnswer = getJsonField(
                                                                                  categorywisequizItem,
                                                                                  r'''$.answer''',
                                                                                ).toString();
                                                                                safeSetState(() {});
                                                                                FFAppState().selectedColorIndex = 3;
                                                                                FFAppState().update(() {});
                                                                              },
                                                                              child: Container(
                                                                                width: 369.0,
                                                                                decoration: BoxDecoration(
                                                                                  color: FFAppState().selectedColorIndex == 3 ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).grey,
                                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                                ),
                                                                                child: Align(
                                                                                  alignment: AlignmentDirectional(0.0, 0.0),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.all(16.0),
                                                                                    child: Text(
                                                                                      _selectedLang == 'en'
                                                                                        ? getJsonField(categorywisequizItem, r'''$.option.d''').toString()
                                                                                        : (_translatedOptions.isNotEmpty ? _translatedOptions[3] : getJsonField(categorywisequizItem, r'''$.option.d''').toString()),
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Roboto',
                                                                                            fontSize: 18.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            useGoogleFonts: false,
                                                                                            lineHeight: 1.5,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return Container(
                                                                      width:
                                                                          100.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 24.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Builder(
                                                      builder: (context) =>
                                                          Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    16.0,
                                                                    0.0,
                                                                    16.0,
                                                                    0.0),
                                                        child: FFButtonWidget(
                                                          onPressed: () async {
                                                            if (_model.userAnswer ==
                                                                    null ||
                                                                _model.userAnswer ==
                                                                    '') {
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (dialogContext) {
                                                                  return Dialog(
                                                                    elevation:
                                                                        0,
                                                                    insetPadding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    alignment: AlignmentDirectional(
                                                                            0.0,
                                                                            0.0)
                                                                        .resolve(
                                                                            Directionality.of(context)),
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        FocusScope.of(dialogContext)
                                                                            .unfocus();
                                                                        FocusManager
                                                                            .instance
                                                                            .primaryFocus
                                                                            ?.unfocus();
                                                                      },
                                                                      child:
                                                                          OptionDialogWidget(
                                                                        istimeout:
                                                                            () async {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            } else {
                                                              FFAppState()
                                                                      .userAns =
                                                                  _model
                                                                      .userAnswer!;
                                                              FFAppState()
                                                                  .update(
                                                                      () {});
                                                              if ('${getJsonField(
                                                                    QuizGroup
                                                                        .getquestionsbyquizidApiCall
                                                                        .questionDetailsList(
                                                                          (_model.quizRes?.jsonBody ??
                                                                              ''),
                                                                        )
                                                                        ?.elementAtOrNull(
                                                                            _model.pageViewCurrentIndex),
                                                                    r'''$.question_type''',
                                                                  ).toString()}' ==
                                                                  'text_only') {
                                                                FFAppState()
                                                                    .addToQuesList(<String,
                                                                        dynamic>{
                                                                  'question_title':
                                                                      getJsonField(
                                                                    QuizGroup
                                                                        .getquestionsbyquizidApiCall
                                                                        .questionDetailsList(
                                                                          (_model.quizRes?.jsonBody ??
                                                                              ''),
                                                                        )
                                                                        ?.elementAtOrNull(
                                                                            _model.pageViewCurrentIndex),
                                                                    r'''$.question_title''',
                                                                  ),
                                                                  'question_type':
                                                                      getJsonField(
                                                                    QuizGroup
                                                                        .getquestionsbyquizidApiCall
                                                                        .questionDetailsList(
                                                                          (_model.quizRes?.jsonBody ??
                                                                              ''),
                                                                        )
                                                                        ?.elementAtOrNull(
                                                                            _model.pageViewCurrentIndex),
                                                                    r'''$.question_type''',
                                                                  ),
                                                                  'answer':
                                                                      getJsonField(
                                                                    QuizGroup
                                                                        .getquestionsbyquizidApiCall
                                                                        .questionDetailsList(
                                                                          (_model.quizRes?.jsonBody ??
                                                                              ''),
                                                                        )
                                                                        ?.elementAtOrNull(
                                                                            _model.pageViewCurrentIndex),
                                                                    r'''$.answer''',
                                                                  ),
                                                                  'option':
                                                                      getJsonField(
                                                                    QuizGroup
                                                                        .getquestionsbyquizidApiCall
                                                                        .questionDetailsList(
                                                                          (_model.quizRes?.jsonBody ??
                                                                              ''),
                                                                        )
                                                                        ?.elementAtOrNull(
                                                                            _model.pageViewCurrentIndex),
                                                                    r'''$.option''',
                                                                  ),
                                                                  'user_answer':
                                                                      FFAppState()
                                                                          .userAns,
                                                                  'description': '' !=
                                                                          getJsonField(
                                                                            QuizGroup.getquestionsbyquizidApiCall
                                                                                .questionDetailsList(
                                                                                  (_model.quizRes?.jsonBody ?? ''),
                                                                                )
                                                                                ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                            r'''$.description''',
                                                                          ).toString()
                                                                      ? getJsonField(
                                                                          QuizGroup
                                                                              .getquestionsbyquizidApiCall
                                                                              .questionDetailsList(
                                                                                (_model.quizRes?.jsonBody ?? ''),
                                                                              )
                                                                              ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.description''',
                                                                        )
                                                                      : '',
                                                                });
                                                                safeSetState(
                                                                    () {});
                                                                if (_model
                                                                        .userAnswer ==
                                                                    _model
                                                                        .actualAnswer) {
                                                                  FFAppState()
                                                                          .correctQues =
                                                                      FFAppState()
                                                                              .correctQues +
                                                                          1;
                                                                  FFAppState()
                                                                      .update(
                                                                          () {});
                                                                } else {
                                                                  FFAppState()
                                                                          .wrongQues =
                                                                      FFAppState()
                                                                              .wrongQues +
                                                                          1;
                                                                  FFAppState()
                                                                      .update(
                                                                          () {});
                                                                }

                                                                FFAppState()
                                                                        .noOfQues =
                                                                    QuizGroup
                                                                        .getquestionsbyquizidApiCall
                                                                        .questionDetailsList(
                                                                          (_model.quizRes?.jsonBody ??
                                                                              ''),
                                                                        )!
                                                                        .length;
                                                                safeSetState(
                                                                    () {});
                                                                if (FFAppState()
                                                                        .noOfQues ==
                                                                    (_model.pageViewCurrentIndex +
                                                                        1)) {
                                                                  FFAppState()
                                                                      .selectedColorIndex = -1;
                                                                  safeSetState(
                                                                      () {});
                                                                  _model
                                                                      .timerController
                                                                      .onStopTimer();
                                                                  await showDialog(
                                                                    barrierDismissible:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (dialogContext) {
                                                                      return Dialog(
                                                                        elevation:
                                                                            0,
                                                                        insetPadding:
                                                                            EdgeInsets.zero,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        alignment:
                                                                            AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            FocusScope.of(dialogContext).unfocus();
                                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                                          },
                                                                          child:
                                                                              CompleteQuizWidget(
                                                                            completed:
                                                                                () async {
                                                                              FFAppState().quesIndex = 0;
                                                                              safeSetState(() {});
                                                                              _model.pointsSetting = await QuizGroup.getpointssettingApiCall.call(
                                                                                token: FFAppState().loginToken,
                                                                              );

                                                                              if (QuizGroup.getpointssettingApiCall.success(
                                                                                    (_model.pointsSetting?.jsonBody ?? ''),
                                                                                  ) ==
                                                                                  1) {
                                                                                // Get points with null safety
                                                                                final correctPoints = QuizGroup.getpointssettingApiCall.correctPoints(
                                                                                  (_model.pointsSetting?.jsonBody ?? ''),
                                                                                );
                                                                                final penaltyPoints = QuizGroup.getpointssettingApiCall.penaltyPoints(
                                                                                  (_model.pointsSetting?.jsonBody ?? ''),
                                                                                );

                                                                                // Set points with default values if null
                                                                                FFAppState().correctQuesPoints = correctPoints ?? 0;
                                                                                FFAppState().wrongQuesPoints = penaltyPoints ?? 0;
                                                                                FFAppState().update(() {});
                                                                                FFAppState().clearCoinsCache();

                                                                                context.goNamed(
                                                                                  QuizResultWidget.routeName,
                                                                                  queryParameters: {
                                                                                    'correctAnswer': serializeParam(
                                                                                      FFAppState().correctQues,
                                                                                      ParamType.int,
                                                                                    ),
                                                                                    'wrongAnswer': serializeParam(
                                                                                      FFAppState().wrongQues,
                                                                                      ParamType.int,
                                                                                    ),
                                                                                    'totalQuestion': serializeParam(
                                                                                      QuizGroup.getquestionsbyquizidApiCall
                                                                                          .questionDetailsList(
                                                                                            (_model.quizRes?.jsonBody ?? ''),
                                                                                          )
                                                                                          ?.length,
                                                                                      ParamType.int,
                                                                                    ),
                                                                                    'notAnswer': serializeParam(
                                                                                      FFAppState().notAnswerQues,
                                                                                      ParamType.int,
                                                                                    ),
                                                                                    'quizID': serializeParam(
                                                                                      widget.quizID,
                                                                                      ParamType.String,
                                                                                    ),
                                                                                    'title': serializeParam(
                                                                                      '${widget.title} Quiz',
                                                                                      ParamType.String,
                                                                                    ),
                                                                                    'image': serializeParam(
                                                                                      widget.image,
                                                                                      ParamType.String,
                                                                                    ),
                                                                                    'quizTime': serializeParam(
                                                                                      widget.time?.toString(),
                                                                                      ParamType.String,
                                                                                    ),
                                                                                    'catID': serializeParam(
                                                                                      widget.catId,
                                                                                      ParamType.String,
                                                                                    ),
                                                                                  }.withoutNulls,
                                                                                );

                                                                                _model.timerController.onResetTimer();
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );

                                                                  await _model
                                                                      .pageViewController
                                                                      ?.animateToPage(
                                                                    0,
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            500),
                                                                    curve: Curves
                                                                        .ease,
                                                                  );
                                                                } else {
                                                                  FFAppState()
                                                                          .quesIndex =
                                                                      _model.pageViewCurrentIndex +
                                                                          1;
                                                                  safeSetState(
                                                                      () {});
                                                                  FFAppState()
                                                                      .selectedColorIndex = -1;
                                                                  safeSetState(
                                                                      () {});
                                                                  _model.userAnswer =
                                                                      null;
                                                                  _model.actualAnswer =
                                                                      null;
                                                                  safeSetState(
                                                                      () {});
                                                                  await _model
                                                                      .pageViewController
                                                                      ?.nextPage(
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            300),
                                                                    curve: Curves
                                                                        .ease,
                                                                  );
                                                                }

                                                                FFAppState().addToQuesType(() {
                                                                  final questionList = QuizGroup.getquestionsbyquizidApiCall.questionTypeList(
                                                                    (_model.quizRes?.jsonBody ?? ''),
                                                                  );
                                                                  if (questionList == null || _model.pageViewCurrentIndex + 1 >= questionList.length) {
                                                                    return '';  // Return empty string if no question type available
                                                                  }
                                                                  return questionList[_model.pageViewCurrentIndex + 1] ?? '';
                                                                }());
                                                                safeSetState(() {});
                                                              } else {
                                                                if ('${getJsonField(
                                                                      QuizGroup
                                                                          .getquestionsbyquizidApiCall
                                                                          .questionDetailsList(
                                                                            (_model.quizRes?.jsonBody ??
                                                                                ''),
                                                                          )
                                                                          ?.elementAtOrNull(
                                                                              _model.pageViewCurrentIndex),
                                                                      r'''$.question_type''',
                                                                    ).toString()}' ==
                                                                    'true_false') {
                                                                  FFAppState()
                                                                      .addToQuesList(<String,
                                                                          dynamic>{
                                                                    'question_title':
                                                                        getJsonField(
                                                                      QuizGroup
                                                                          .getquestionsbyquizidApiCall
                                                                          .questionDetailsList(
                                                                            (_model.quizRes?.jsonBody ??
                                                                                ''),
                                                                          )
                                                                          ?.elementAtOrNull(
                                                                              _model.pageViewCurrentIndex),
                                                                      r'''$.question_title''',
                                                                    ),
                                                                    'question_type':
                                                                        getJsonField(
                                                                      QuizGroup
                                                                          .getquestionsbyquizidApiCall
                                                                          .questionDetailsList(
                                                                            (_model.quizRes?.jsonBody ??
                                                                                ''),
                                                                          )
                                                                          ?.elementAtOrNull(
                                                                              _model.pageViewCurrentIndex),
                                                                      r'''$.question_type''',
                                                                    ),
                                                                    'answer':
                                                                        getJsonField(
                                                                      QuizGroup
                                                                          .getquestionsbyquizidApiCall
                                                                          .questionDetailsList(
                                                                            (_model.quizRes?.jsonBody ??
                                                                                ''),
                                                                          )
                                                                          ?.elementAtOrNull(
                                                                              _model.pageViewCurrentIndex),
                                                                      r'''$.answer''',
                                                                    ),
                                                                    'user_answer':
                                                                        FFAppState()
                                                                            .userAns,
                                                                    'description': '' !=
                                                                            getJsonField(
                                                                              QuizGroup.getquestionsbyquizidApiCall
                                                                                  .questionDetailsList(
                                                                                    (_model.quizRes?.jsonBody ?? ''),
                                                                                  )
                                                                                  ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                              r'''$.description''',
                                                                            ).toString()
                                                                        ? getJsonField(
                                                                            QuizGroup.getquestionsbyquizidApiCall
                                                                                .questionDetailsList(
                                                                                  (_model.quizRes?.jsonBody ?? ''),
                                                                                )
                                                                                ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                            r'''$.description''',
                                                                          )
                                                                        : '',
                                                                  });
                                                                  safeSetState(
                                                                      () {});
                                                                  if (_model
                                                                          .userAnswer ==
                                                                      _model
                                                                          .actualAnswer) {
                                                                    FFAppState()
                                                                            .correctQues =
                                                                        FFAppState().correctQues +
                                                                            1;
                                                                    FFAppState()
                                                                        .update(
                                                                            () {});
                                                                  } else {
                                                                    FFAppState()
                                                                            .wrongQues =
                                                                        FFAppState().wrongQues +
                                                                            1;
                                                                    FFAppState()
                                                                        .update(
                                                                            () {});
                                                                  }

                                                                  FFAppState()
                                                                          .noOfQues =
                                                                      QuizGroup
                                                                          .getquestionsbyquizidApiCall
                                                                          .questionDetailsList(
                                                                            (_model.quizRes?.jsonBody ??
                                                                                ''),
                                                                          )!
                                                                          .length;
                                                                  safeSetState(
                                                                      () {});
                                                                  if (FFAppState()
                                                                          .noOfQues ==
                                                                      (_model.pageViewCurrentIndex +
                                                                          1)) {
                                                                    FFAppState()
                                                                        .selectedColorIndex = -1;
                                                                    safeSetState(
                                                                        () {});
                                                                    _model
                                                                        .timerController
                                                                        .onStopTimer();
                                                                    await showDialog(
                                                                      barrierDismissible:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (dialogContext) {
                                                                        return Dialog(
                                                                          elevation:
                                                                              0,
                                                                          insetPadding:
                                                                              EdgeInsets.zero,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          alignment:
                                                                              AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              FocusScope.of(dialogContext).unfocus();
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                            },
                                                                            child:
                                                                                CompleteQuizWidget(
                                                                              completed: () async {
                                                                                FFAppState().quesIndex = 0;
                                                                                safeSetState(() {});
                                                                                _model.pointsSetting1 = await QuizGroup.getpointssettingApiCall.call(
                                                                                  token: FFAppState().loginToken,
                                                                                );

                                                                                if (QuizGroup.getpointssettingApiCall.success(
                                                                                      (_model.pointsSetting1?.jsonBody ?? ''),
                                                                                    ) ==
                                                                                    1) {
                                                                                  FFAppState().correctQuesPoints = QuizGroup.getpointssettingApiCall.correctPoints(
                                                                                    (_model.pointsSetting1?.jsonBody ?? ''),
                                                                                  )!;
                                                                                  FFAppState().wrongQuesPoints = QuizGroup.getpointssettingApiCall.penaltyPoints(
                                                                                    (_model.pointsSetting1?.jsonBody ?? ''),
                                                                                  )!;
                                                                                  FFAppState().update(() {});
                                                                                  FFAppState().clearCoinsCache();

                                                                                  context.goNamed(
                                                                                    QuizResultWidget.routeName,
                                                                                    queryParameters: {
                                                                                      'correctAnswer': serializeParam(
                                                                                        FFAppState().correctQues,
                                                                                        ParamType.int,
                                                                                      ),
                                                                                      'wrongAnswer': serializeParam(
                                                                                        FFAppState().wrongQues,
                                                                                        ParamType.int,
                                                                                      ),
                                                                                      'totalQuestion': serializeParam(
                                                                                        QuizGroup.getquestionsbyquizidApiCall
                                                                                            .questionDetailsList(
                                                                                              (_model.quizRes?.jsonBody ?? ''),
                                                                                            )
                                                                                            ?.length,
                                                                                        ParamType.int,
                                                                                      ),
                                                                                      'notAnswer': serializeParam(
                                                                                        FFAppState().notAnswerQues,
                                                                                        ParamType.int,
                                                                                      ),
                                                                                      'quizID': serializeParam(
                                                                                        widget.quizID,
                                                                                        ParamType.String,
                                                                                      ),
                                                                                      'title': serializeParam(
                                                                                        '${widget.title} Quiz',
                                                                                        ParamType.String,
                                                                                      ),
                                                                                      'image': serializeParam(
                                                                                        widget.image,
                                                                                        ParamType.String,
                                                                                      ),
                                                                                      'quizTime': serializeParam(
                                                                                        widget.time?.toString(),
                                                                                        ParamType.String,
                                                                                      ),
                                                                                      'catID': serializeParam(
                                                                                        widget.catId,
                                                                                        ParamType.String,
                                                                                      ),
                                                                                    }.withoutNulls,
                                                                                  );

                                                                                  _model.timerController.onResetTimer();
                                                                                }
                                                                              },
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );

                                                                    await _model
                                                                        .pageViewController
                                                                        ?.animateToPage(
                                                                      0,
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              500),
                                                                      curve: Curves
                                                                          .ease,
                                                                    );
                                                                  } else {
                                                                    FFAppState()
                                                                            .quesIndex =
                                                                        _model.pageViewCurrentIndex +
                                                                            1;
                                                                    safeSetState(
                                                                        () {});
                                                                    FFAppState()
                                                                        .selectedColorIndex = -1;
                                                                    safeSetState(
                                                                        () {});
                                                                    _model.userAnswer =
                                                                        null;
                                                                    _model.actualAnswer =
                                                                        null;
                                                                    safeSetState(
                                                                        () {});
                                                                    await _model
                                                                        .pageViewController
                                                                        ?.nextPage(
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              300),
                                                                      curve: Curves
                                                                          .ease,
                                                                    );
                                                                  }

                                                                  FFAppState().addToQuesType(() {
                                                                    final questionList = QuizGroup.getquestionsbyquizidApiCall.questionTypeList(
                                                                      (_model.quizRes?.jsonBody ?? ''),
                                                                    );
                                                                    if (questionList == null || _model.pageViewCurrentIndex + 1 >= questionList.length) {
                                                                      return '';  // Return empty string if no question type available
                                                                    }
                                                                    return questionList[_model.pageViewCurrentIndex + 1] ?? '';
                                                                  }());
                                                                  safeSetState(() {});
                                                                } else {
                                                                  if ('${getJsonField(
                                                                        QuizGroup
                                                                            .getquestionsbyquizidApiCall
                                                                            .questionDetailsList(
                                                                              (_model.quizRes?.jsonBody ?? ''),
                                                                            )
                                                                            ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                        r'''$.question_type''',
                                                                      ).toString()}' ==
                                                                      'images') {
                                                                    FFAppState()
                                                                        .addToQuesList(<String,
                                                                            dynamic>{
                                                                      'question_title':
                                                                          getJsonField(
                                                                        QuizGroup
                                                                            .getquestionsbyquizidApiCall
                                                                            .questionDetailsList(
                                                                              (_model.quizRes?.jsonBody ?? ''),
                                                                            )
                                                                            ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                        r'''$.question_title''',
                                                                      ),
                                                                      'question_type':
                                                                          getJsonField(
                                                                        QuizGroup
                                                                            .getquestionsbyquizidApiCall
                                                                            .questionDetailsList(
                                                                              (_model.quizRes?.jsonBody ?? ''),
                                                                            )
                                                                            ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                        r'''$.question_type''',
                                                                      ),
                                                                      'answer':
                                                                          getJsonField(
                                                                        QuizGroup
                                                                            .getquestionsbyquizidApiCall
                                                                            .questionDetailsList(
                                                                              (_model.quizRes?.jsonBody ?? ''),
                                                                            )
                                                                            ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                        r'''$.answer''',
                                                                      ),
                                                                      'option':
                                                                          getJsonField(
                                                                        QuizGroup
                                                                            .getquestionsbyquizidApiCall
                                                                            .questionDetailsList(
                                                                              (_model.quizRes?.jsonBody ?? ''),
                                                                            )
                                                                            ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                        r'''$.option''',
                                                                      ),
                                                                      'user_answer':
                                                                          FFAppState()
                                                                              .userAns,
                                                                      'description': '' !=
                                                                              getJsonField(
                                                                                QuizGroup.getquestionsbyquizidApiCall
                                                                                    .questionDetailsList(
                                                                                      (_model.quizRes?.jsonBody ?? ''),
                                                                                    )
                                                                                    ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                                r'''$.description''',
                                                                              ).toString()
                                                                          ? getJsonField(
                                                                              QuizGroup.getquestionsbyquizidApiCall
                                                                                  .questionDetailsList(
                                                                                    (_model.quizRes?.jsonBody ?? ''),
                                                                                  )
                                                                                  ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                              r'''$.description''',
                                                                            )
                                                                          : '',
                                                                      'image':
                                                                          getJsonField(
                                                                        QuizGroup
                                                                            .getquestionsbyquizidApiCall
                                                                            .questionDetailsList(
                                                                              (_model.quizRes?.jsonBody ?? ''),
                                                                            )
                                                                            ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                        r'''$.image''',
                                                                      ),
                                                                    });
                                                                    safeSetState(
                                                                        () {});
                                                                    if (_model
                                                                            .userAnswer ==
                                                                        _model
                                                                            .actualAnswer) {
                                                                      FFAppState()
                                                                              .correctQues =
                                                                          FFAppState().correctQues +
                                                                              1;
                                                                      FFAppState()
                                                                          .update(
                                                                              () {});
                                                                    } else {
                                                                      FFAppState()
                                                                              .wrongQues =
                                                                          FFAppState().wrongQues +
                                                                              1;
                                                                      FFAppState()
                                                                          .update(
                                                                              () {});
                                                                    }

                                                                    FFAppState()
                                                                            .noOfQues =
                                                                        QuizGroup
                                                                            .getquestionsbyquizidApiCall
                                                                            .questionDetailsList(
                                                                              (_model.quizRes?.jsonBody ?? ''),
                                                                            )!
                                                                            .length;
                                                                    safeSetState(
                                                                        () {});
                                                                    if (FFAppState()
                                                                            .noOfQues ==
                                                                        (_model.pageViewCurrentIndex +
                                                                            1)) {
                                                                      FFAppState()
                                                                          .selectedColorIndex = -1;
                                                                      safeSetState(
                                                                          () {});
                                                                      _model
                                                                          .timerController
                                                                          .onStopTimer();
                                                                      await showDialog(
                                                                        barrierDismissible:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (dialogContext) {
                                                                          return Dialog(
                                                                            elevation:
                                                                                0,
                                                                            insetPadding:
                                                                                EdgeInsets.zero,
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            alignment:
                                                                                AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                FocusScope.of(dialogContext).unfocus();
                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                              },
                                                                              child: CompleteQuizWidget(
                                                                                completed: () async {
                                                                                  FFAppState().quesIndex = 0;
                                                                                  safeSetState(() {});
                                                                                  _model.pointsSetting2 = await QuizGroup.getpointssettingApiCall.call(
                                                                                    token: FFAppState().loginToken,
                                                                                  );

                                                                                  if (QuizGroup.getpointssettingApiCall.success(
                                                                                        (_model.pointsSetting2?.jsonBody ?? ''),
                                                                                      ) ==
                                                                                      1) {
                                                                                    FFAppState().correctQuesPoints = QuizGroup.getpointssettingApiCall.correctPoints(
                                                                                      (_model.pointsSetting2?.jsonBody ?? ''),
                                                                                    )!;
                                                                                    FFAppState().wrongQuesPoints = QuizGroup.getpointssettingApiCall.penaltyPoints(
                                                                                      (_model.pointsSetting2?.jsonBody ?? ''),
                                                                                    )!;
                                                                                    FFAppState().update(() {});
                                                                                    FFAppState().clearCoinsCache();

                                                                                    context.goNamed(
                                                                                      QuizResultWidget.routeName,
                                                                                      queryParameters: {
                                                                                        'correctAnswer': serializeParam(
                                                                                          FFAppState().correctQues,
                                                                                          ParamType.int,
                                                                                        ),
                                                                                        'wrongAnswer': serializeParam(
                                                                                          FFAppState().wrongQues,
                                                                                          ParamType.int,
                                                                                        ),
                                                                                        'totalQuestion': serializeParam(
                                                                                          QuizGroup.getquestionsbyquizidApiCall
                                                                                              .questionDetailsList(
                                                                                                (_model.quizRes?.jsonBody ?? ''),
                                                                                              )
                                                                                              ?.length,
                                                                                          ParamType.int,
                                                                                        ),
                                                                                        'notAnswer': serializeParam(
                                                                                          FFAppState().notAnswerQues,
                                                                                          ParamType.int,
                                                                                        ),
                                                                                        'quizID': serializeParam(
                                                                                          widget.quizID,
                                                                                          ParamType.String,
                                                                                        ),
                                                                                        'title': serializeParam(
                                                                                          '${widget.title} Quiz',
                                                                                          ParamType.String,
                                                                                        ),
                                                                                        'image': serializeParam(
                                                                                          widget.image,
                                                                                          ParamType.String,
                                                                                        ),
                                                                                        'quizTime': serializeParam(
                                                                                          widget.time?.toString(),
                                                                                          ParamType.String,
                                                                                        ),
                                                                                        'catID': serializeParam(
                                                                                          widget.catId,
                                                                                          ParamType.String,
                                                                                        ),
                                                                                      }.withoutNulls,
                                                                                    );

                                                                                    _model.timerController.onResetTimer();
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );

                                                                      await _model
                                                                          .pageViewController
                                                                          ?.animateToPage(
                                                                        0,
                                                                        duration:
                                                                            Duration(milliseconds: 500),
                                                                        curve: Curves
                                                                            .ease,
                                                                      );
                                                                    } else {
                                                                      FFAppState()
                                                                              .quesIndex =
                                                                          _model.pageViewCurrentIndex +
                                                                              1;
                                                                      safeSetState(
                                                                          () {});
                                                                      FFAppState()
                                                                          .selectedColorIndex = -1;
                                                                      safeSetState(
                                                                          () {});
                                                                      _model.userAnswer =
                                                                          null;
                                                                      _model.actualAnswer =
                                                                          null;
                                                                      safeSetState(
                                                                          () {});
                                                                      await _model
                                                                          .pageViewController
                                                                          ?.nextPage(
                                                                        duration:
                                                                            Duration(milliseconds: 300),
                                                                        curve: Curves
                                                                            .ease,
                                                                      );
                                                                    }

                                                                    FFAppState().addToQuesType(() {
                                                                      final questionList = QuizGroup.getquestionsbyquizidApiCall.questionTypeList(
                                                                        (_model.quizRes?.jsonBody ?? ''),
                                                                      );
                                                                      if (questionList == null || _model.pageViewCurrentIndex + 1 >= questionList.length) {
                                                                        return '';  // Return empty string if no question type available
                                                                      }
                                                                      return questionList[_model.pageViewCurrentIndex + 1] ?? '';
                                                                    }());
                                                                    safeSetState(() {});
                                                                  } else {
                                                                    if ('${getJsonField(
                                                                          QuizGroup
                                                                              .getquestionsbyquizidApiCall
                                                                              .questionDetailsList(
                                                                                (_model.quizRes?.jsonBody ?? ''),
                                                                              )
                                                                              ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.question_type''',
                                                                        ).toString()}' ==
                                                                        'audio') {
                                                                      FFAppState()
                                                                          .addToQuesList(<String,
                                                                              dynamic>{
                                                                        'question_title':
                                                                            getJsonField(
                                                                          QuizGroup
                                                                              .getquestionsbyquizidApiCall
                                                                              .questionDetailsList(
                                                                                (_model.quizRes?.jsonBody ?? ''),
                                                                              )
                                                                              ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.question_title''',
                                                                        ),
                                                                        'question_type':
                                                                            getJsonField(
                                                                          QuizGroup
                                                                              .getquestionsbyquizidApiCall
                                                                              .questionDetailsList(
                                                                                (_model.quizRes?.jsonBody ?? ''),
                                                                              )
                                                                              ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.question_type''',
                                                                        ),
                                                                        'answer':
                                                                            getJsonField(
                                                                          QuizGroup
                                                                              .getquestionsbyquizidApiCall
                                                                              .questionDetailsList(
                                                                                (_model.quizRes?.jsonBody ?? ''),
                                                                              )
                                                                              ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.answer''',
                                                                        ),
                                                                        'option':
                                                                            getJsonField(
                                                                          QuizGroup
                                                                              .getquestionsbyquizidApiCall
                                                                              .questionDetailsList(
                                                                                (_model.quizRes?.jsonBody ?? ''),
                                                                              )
                                                                              ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.option''',
                                                                        ),
                                                                        'user_answer':
                                                                            FFAppState().userAns,
                                                                        'description': '' !=
                                                                                getJsonField(
                                                                                  QuizGroup.getquestionsbyquizidApiCall
                                                                                      .questionDetailsList(
                                                                                        (_model.quizRes?.jsonBody ?? ''),
                                                                                      )
                                                                                      ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                                  r'''$.description''',
                                                                                ).toString()
                                                                            ? getJsonField(
                                                                                QuizGroup.getquestionsbyquizidApiCall
                                                                                    .questionDetailsList(
                                                                                      (_model.quizRes?.jsonBody ?? ''),
                                                                                    )
                                                                                    ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                                r'''$.description''',
                                                                              )
                                                                            : '',
                                                                        'audio':
                                                                            getJsonField(
                                                                          QuizGroup
                                                                              .getquestionsbyquizidApiCall
                                                                              .questionDetailsList(
                                                                                (_model.quizRes?.jsonBody ?? ''),
                                                                              )
                                                                              ?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.audio''',
                                                                        ),
                                                                      });
                                                                      safeSetState(
                                                                          () {});
                                                                      if (_model
                                                                              .userAnswer ==
                                                                          _model
                                                                              .actualAnswer) {
                                                                        FFAppState()
                                                                            .correctQues = FFAppState()
                                                                                .correctQues +
                                                                            1;
                                                                        FFAppState()
                                                                            .update(() {});
                                                                      } else {
                                                                        FFAppState()
                                                                            .wrongQues = FFAppState()
                                                                                .wrongQues +
                                                                            1;
                                                                        FFAppState()
                                                                            .update(() {});
                                                                      }

                                                                      FFAppState().noOfQues = QuizGroup
                                                                          .getquestionsbyquizidApiCall
                                                                          .questionDetailsList(
                                                                            (_model.quizRes?.jsonBody ??
                                                                                ''),
                                                                          )!
                                                                          .length;
                                                                      safeSetState(
                                                                          () {});
                                                                      if (FFAppState()
                                                                              .noOfQues ==
                                                                          (_model.pageViewCurrentIndex +
                                                                              1)) {
                                                                        FFAppState().selectedColorIndex =
                                                                            -1;
                                                                        safeSetState(
                                                                            () {});
                                                                        _model
                                                                            .timerController
                                                                            .onStopTimer();
                                                                        await showDialog(
                                                                          barrierDismissible:
                                                                              false,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (dialogContext) {
                                                                            return Dialog(
                                                                              elevation: 0,
                                                                              insetPadding: EdgeInsets.zero,
                                                                              backgroundColor: Colors.transparent,
                                                                              alignment: AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  FocusScope.of(dialogContext).unfocus();
                                                                                  FocusManager.instance.primaryFocus?.unfocus();
                                                                                },
                                                                                child: CompleteQuizWidget(
                                                                                  completed: () async {
                                                                                    FFAppState().quesIndex = 0;
                                                                                    safeSetState(() {});
                                                                                    _model.pointsSetting3 = await QuizGroup.getpointssettingApiCall.call(
                                                                                      token: FFAppState().loginToken,
                                                                                    );

                                                                                    if (QuizGroup.getpointssettingApiCall.success(
                                                                                          (_model.pointsSetting3?.jsonBody ?? ''),
                                                                                        ) ==
                                                                                        1) {
                                                                                      FFAppState().correctQuesPoints = QuizGroup.getpointssettingApiCall.correctPoints(
                                                                                        (_model.pointsSetting3?.jsonBody ?? ''),
                                                                                      )!;
                                                                                      FFAppState().wrongQuesPoints = QuizGroup.getpointssettingApiCall.penaltyPoints(
                                                                                        (_model.pointsSetting3?.jsonBody ?? ''),
                                                                                      )!;
                                                                                      FFAppState().update(() {});
                                                                                      FFAppState().clearCoinsCache();

                                                                                      context.goNamed(
                                                                                        QuizResultWidget.routeName,
                                                                                        queryParameters: {
                                                                                          'correctAnswer': serializeParam(
                                                                                            FFAppState().correctQues,
                                                                                            ParamType.int,
                                                                                          ),
                                                                                          'wrongAnswer': serializeParam(
                                                                                            FFAppState().wrongQues,
                                                                                            ParamType.int,
                                                                                          ),
                                                                                          'totalQuestion': serializeParam(
                                                                                            QuizGroup.getquestionsbyquizidApiCall
                                                                                                .questionDetailsList(
                                                                                                  (_model.quizRes?.jsonBody ?? ''),
                                                                                                )
                                                                                                ?.length,
                                                                                            ParamType.int,
                                                                                          ),
                                                                                          'notAnswer': serializeParam(
                                                                                            FFAppState().notAnswerQues,
                                                                                            ParamType.int,
                                                                                          ),
                                                                                          'quizID': serializeParam(
                                                                                            widget.quizID,
                                                                                            ParamType.String,
                                                                                          ),
                                                                                          'title': serializeParam(
                                                                                            '${widget.title} Quiz',
                                                                                            ParamType.String,
                                                                                          ),
                                                                                          'image': serializeParam(
                                                                                            widget.image,
                                                                                            ParamType.String,
                                                                                          ),
                                                                                          'quizTime': serializeParam(
                                                                                            widget.time?.toString(),
                                                                                            ParamType.String,
                                                                                          ),
                                                                                          'catID': serializeParam(
                                                                                            widget.catId,
                                                                                            ParamType.String,
                                                                                          ),
                                                                                        }.withoutNulls,
                                                                                      );

                                                                                      _model.timerController.onResetTimer();
                                                                                    }
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        );

                                                                        await _model
                                                                            .pageViewController
                                                                            ?.animateToPage(
                                                                          0,
                                                                          duration:
                                                                              Duration(milliseconds: 500),
                                                                          curve:
                                                                              Curves.ease,
                                                                        );
                                                                      } else {
                                                                        FFAppState()
                                                                            .quesIndex = _model
                                                                                .pageViewCurrentIndex +
                                                                            1;
                                                                        safeSetState(
                                                                            () {});
                                                                        FFAppState().selectedColorIndex =
                                                                            -1;
                                                                        safeSetState(
                                                                            () {});
                                                                        _model.userAnswer =
                                                                            null;
                                                                        _model.actualAnswer =
                                                                            null;
                                                                        safeSetState(
                                                                            () {});
                                                                        await _model
                                                                            .pageViewController
                                                                            ?.nextPage(
                                                                          duration:
                                                                              Duration(milliseconds: 300),
                                                                          curve:
                                                                              Curves.ease,
                                                                        );
                                                                      }

                                                                      FFAppState().addToQuesType(() {
                                                                        final questionList = QuizGroup.getquestionsbyquizidApiCall.questionTypeList(
                                                                          (_model.quizRes?.jsonBody ?? ''),
                                                                        );
                                                                        if (questionList == null || _model.pageViewCurrentIndex + 1 >= questionList.length) {
                                                                          return '';  // Return empty string if no question type available
                                                                        }
                                                                        return questionList[_model.pageViewCurrentIndex + 1] ?? '';
                                                                      }());
                                                                      safeSetState(() {});
                                                                    }
                                                                  }
                                                                }
                                                              }
                                                            }

                                                            safeSetState(() {});
                                                          },
                                                          text: '${(FFAppState().quesIndex + 1).toString()}' ==
                                                                  '${QuizGroup.getquestionsbyquizidApiCall.questionDetailsList(
                                                                        (_model.quizRes?.jsonBody ??
                                                                            ''),
                                                                      )?.length.toString()}'
                                                              ? 'Submit'
                                                              : 'Next',
                                                          options:
                                                              FFButtonOptions(
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
                                                          showLoadingIndicator:
                                                              false,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              'No Quizzes are found',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Roboto',
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    return Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150.0,
                            height: 70.0,
                            child: custom_widgets.ProgressIndicator(
                              width: 150.0,
                              height: 70.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
