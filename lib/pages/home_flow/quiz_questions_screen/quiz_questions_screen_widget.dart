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
import 'package:json_annotation/json_annotation.dart';
export 'quiz_questions_screen_model.dart';

class QuizQuestionsScreenWidget extends StatefulWidget {
  const QuizQuestionsScreenWidget({
    super.key,
    this.title,
    this.catId,
    this.image,
    this.quizTime,
    this.description,
    this.ques,
    this.quizID,
    this.timerStatus,
  });

  final String? title;
  final String? catId;
  final String? image;
  final String? quizTime;
  final String? description;
  final int? ques;
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
  bool _didParseParams = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Translation related state
  late Translation _translation;
  String _selectedLang = 'en';
  String _translatedQuestion = '';
  List<String> _translatedOptions = [];
  bool _isTranslating = false;

  // Track selected option index for each question
  Map<int, int> selectedOptionPerQuestion = {};

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

      print('QUIZ DEBUG: Received quiz object: ' + (_model.quizRes?.jsonBody ?? '').toString());
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

    // Extract correctAnsReward and penaltyPerQuestion from API response if available
    double correctAnsReward = 0.0;
    double penaltyPerQuestion = 0.0;
    final quizJson = _model.quizRes?.jsonBody;
    dynamic quizMap = quizJson;
    if (quizJson is String) {
      try {
        quizMap = jsonDecode(quizJson);
      } catch (e) {
        quizMap = {};
      }
    }
    // Extract from top-level data fields as per backend
    final apiCorrect = getJsonField(quizMap, r'$.data.correctAnsReward');
    final apiPenalty = getJsonField(quizMap, r'$.data.penaltyPerQuestion');
    if (apiCorrect != null) {
      if (apiCorrect is num) {
        correctAnsReward = apiCorrect.toDouble();
      } else if (apiCorrect is String) {
        correctAnsReward = double.tryParse(apiCorrect) ?? 0.0;
      }
    }
    if (apiPenalty != null) {
      if (apiPenalty is num) {
        penaltyPerQuestion = apiPenalty.toDouble();
      } else if (apiPenalty is String) {
        penaltyPerQuestion = double.tryParse(apiPenalty) ?? 0.0;
      }
    }
    // Questions and totalMark logic
    final questions = getJsonField(quizMap, r'$.data.questionsDetails');
    int totalQuestions = 0;
    if (questions is List) {
      totalQuestions = questions.length;
    }
    double totalMark = correctAnsReward * totalQuestions.toDouble();
    print('QUIZ DEBUG: correctAnsReward: ' + correctAnsReward.toString());
    print('QUIZ DEBUG: penaltyPerQuestion: ' + penaltyPerQuestion.toString());
    print('QUIZ DEBUG: totalMark: ' + totalMark.toString());

    // Extract quiz duration and timer status from the first question's quizId
    int quizDurationMinutes = 0;
    int timerStatus = 0;
    if (questions is List && questions.isNotEmpty) {
      final quizIdObj = getJsonField(questions[0], r'$.quizId');
      final apiDuration = getJsonField(quizIdObj, r'$.minutes_per_quiz');
      final apiTimerStatus = getJsonField(quizIdObj, r'$.timer_status');
      if (apiDuration != null) {
        if (apiDuration is num) {
          quizDurationMinutes = apiDuration.toInt();
        } else if (apiDuration is String) {
          quizDurationMinutes = int.tryParse(apiDuration) ?? 0;
        }
      }
      if (apiTimerStatus != null) {
        if (apiTimerStatus is num) {
          timerStatus = apiTimerStatus.toInt();
        } else if (apiTimerStatus is String) {
          timerStatus = int.tryParse(apiTimerStatus) ?? 0;
        }
      }
    }
    print('QUIZ DEBUG: timerStatus: ' + timerStatus.toString() + ', quizDurationMinutes: ' + quizDurationMinutes.toString());

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
                                height: 170.0,
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
                                          16.0, 0.0, 16.0, 8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: AlignmentDirectional(-1.0, 0.0),
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
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 8.0),
                                      child: Align(
                                        alignment: AlignmentDirectional(-1.0, 0.0),
                                        child: RichText(
                                          textScaler: MediaQuery.of(context).textScaler,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Question ',
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 20.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.bold,
                                                      useGoogleFonts: false,
                                                      lineHeight: 1.5,
                                                    ),
                                              ),
                                              TextSpan(
                                                text: (_model.pageViewCurrentIndex + 1).toString(),
                                                style: TextStyle(),
                                              ),
                                              TextSpan(
                                                text: ' of ',
                                                style: TextStyle(),
                                              ),
                                              TextSpan(
                                                text: QuizGroup.getquestionsbyquizidApiCall.questionDetailsList(
                                                  (_model.quizRes?.jsonBody ?? ''),
                                                )!.length.toString(),
                                                style: TextStyle(),
                                              )
                                            ],
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 20.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  useGoogleFonts: false,
                                                  lineHeight: 1.5,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (timerStatus == 1)
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15.0),
                                                  ),
                                                  child: custom_widgets.LinearBarTimer(
                                                    width: 309.0,
                                                    height: 10.0,
                                                    time: quizDurationMinutes * 60 * 1000,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 100.0,
                                              height: 34.0,
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).primary,
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                              alignment: AlignmentDirectional(0.0, 0.0),
                                              child: FlutterFlowTimer(
                                                initialTime: quizDurationMinutes * 60 * 1000,
                                                getDisplayTime: (value) => StopWatchTimer.getDisplayTime(
                                                  value,
                                                  hours: false,
                                                  milliSecond: false,
                                                ),
                                                controller: _model.timerController,
                                                updateStateInterval: Duration(milliseconds: 1000),
                                                onChanged: (value, displayTime, shouldUpdate) {
                                                  _model.timerMilliseconds = value;
                                                  _model.timerValue = displayTime;
                                                  if (shouldUpdate) safeSetState(() {});
                                                },
                                                textAlign: TextAlign.center,
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Roboto',
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                  useGoogleFonts: false,
                                                ),
                                                onEnded: () async {
                                                  await showDialog(
                                                    barrierDismissible: false,
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
                                                          child: TimeoutDialogWidget(
                                                            istimeout: () async {
                                                              FFAppState().clearCoinsCache();
                                                              context.pushNamed(
                                                                QuizResultWidget.routeName,
                                                                queryParameters: {
                                                                  'correctAnswer': serializeParam(FFAppState().correctQues, ParamType.int),
                                                                  'wrongAnswer': serializeParam(FFAppState().wrongQues, ParamType.int),
                                                                  'totalQuestion': serializeParam(questions is List ? questions.length : 0, ParamType.int),
                                                                  'notAnswer': serializeParam(FFAppState().notAnswerQues, ParamType.int),
                                                                  'quizID': serializeParam(widget.quizID, ParamType.String),
                                                                  'title': serializeParam(widget.title, ParamType.String),
                                                                  'correctAnsReward': serializeParam(correctAnsReward, ParamType.double),
                                                                  'penaltyPerQuestion': serializeParam(penaltyPerQuestion, ParamType.double),
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
                                          ].divide(SizedBox(width: 16.0)),
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
                                                                (idx) async {
                                                              FFAppState().selectedColorIndex = selectedOptionPerQuestion[idx] ?? -1;
                                                              FFAppState().update(() {});
                                                              FFAppState().questionType = getJsonField(
                                                                categorywisequiz.elementAtOrNull(idx),
                                                                r'''$.question_type''',
                                                              ).toString();
                                                              safeSetState(() {});
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
                                                              final selectedIndex = selectedOptionPerQuestion[categorywisequizIndex];
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
                                                                                      final idx = categorywisequizIndex;
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
                                                                                  if (selectedIndex == 0) {
                                                                                    // Deselect if already selected
                                                                                    _model.userAnswer = null;
                                                                                    _model.actualAnswer = null;
                                                                                    selectedOptionPerQuestion[categorywisequizIndex] = -1;
                                                                                    FFAppState().selectedColorIndex = -1;
                                                                                  } else {
                                                                                    _model.userAnswer = getJsonField(
                                                                                      categorywisequizItem,
                                                                                      r'''$.option.a''',
                                                                                    ).toString();
                                                                                    _model.actualAnswer = getJsonField(
                                                                                      categorywisequizItem,
                                                                                      r'''$.answer''',
                                                                                    ).toString();
                                                                                    selectedOptionPerQuestion[categorywisequizIndex] = 0;
                                                                                    FFAppState().selectedColorIndex = 0;
                                                                                  }
                                                                                  safeSetState(() {});
                                                                                  FFAppState().update(() {});
                                                                                },
                                                                                child: Container(
                                                                                  width: 369.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FlutterFlowTheme.of(context).grey,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                    border: selectedIndex == 0 ? Border.all(color: FlutterFlowTheme.of(context).primary, width: 2.0) : null,
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
                                                                                  if (selectedIndex == 1) {
                                                                                    // Deselect if already selected
                                                                                    _model.userAnswer = null;
                                                                                    _model.actualAnswer = null;
                                                                                    selectedOptionPerQuestion[categorywisequizIndex] = -1;
                                                                                    FFAppState().selectedColorIndex = -1;
                                                                                  } else {
                                                                                    _model.userAnswer = getJsonField(
                                                                                      categorywisequizItem,
                                                                                      r'''$.option.b''',
                                                                                    ).toString();
                                                                                    _model.actualAnswer = getJsonField(
                                                                                      categorywisequizItem,
                                                                                      r'''$.answer''',
                                                                                    ).toString();
                                                                                    selectedOptionPerQuestion[categorywisequizIndex] = 1;
                                                                                    FFAppState().selectedColorIndex = 1;
                                                                                  }
                                                                                  safeSetState(() {});
                                                                                  FFAppState().update(() {});
                                                                                },
                                                                                child: Container(
                                                                                  width: 369.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FlutterFlowTheme.of(context).grey,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                    border: selectedIndex == 1 ? Border.all(color: FlutterFlowTheme.of(context).primary, width: 2.0) : null,
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
                                                                                  if (selectedIndex == 2) {
                                                                                    // Deselect if already selected
                                                                                    _model.userAnswer = null;
                                                                                    _model.actualAnswer = null;
                                                                                    selectedOptionPerQuestion[categorywisequizIndex] = -1;
                                                                                    FFAppState().selectedColorIndex = -1;
                                                                                  } else {
                                                                                    _model.userAnswer = getJsonField(
                                                                                      categorywisequizItem,
                                                                                      r'''$.option.c''',
                                                                                    ).toString();
                                                                                    _model.actualAnswer = getJsonField(
                                                                                      categorywisequizItem,
                                                                                      r'''$.answer''',
                                                                                    ).toString();
                                                                                    selectedOptionPerQuestion[categorywisequizIndex] = 2;
                                                                                    FFAppState().selectedColorIndex = 2;
                                                                                  }
                                                                                  safeSetState(() {});
                                                                                  FFAppState().update(() {});
                                                                                },
                                                                                child: Container(
                                                                                  width: 369.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FlutterFlowTheme.of(context).grey,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                    border: selectedIndex == 2 ? Border.all(color: FlutterFlowTheme.of(context).primary, width: 2.0) : null,
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
                                                                                if (selectedIndex == 3) {
                                                                                  // Deselect if already selected
                                                                                  _model.userAnswer = null;
                                                                                  _model.actualAnswer = null;
                                                                                  selectedOptionPerQuestion[categorywisequizIndex] = -1;
                                                                                  FFAppState().selectedColorIndex = -1;
                                                                                } else {
                                                                                  _model.userAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.option.d''',
                                                                                  ).toString();
                                                                                  _model.actualAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.answer''',
                                                                                  ).toString();
                                                                                  selectedOptionPerQuestion[categorywisequizIndex] = 3;
                                                                                  FFAppState().selectedColorIndex = 3;
                                                                                }
                                                                                safeSetState(() {});
                                                                                FFAppState().update(() {});
                                                                              },
                                                                              child: Container(
                                                                                width: 369.0,
                                                                                decoration: BoxDecoration(
                                                                                  color: FlutterFlowTheme.of(context).grey,
                                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                                  border: selectedIndex == 3 ? Border.all(color: FlutterFlowTheme.of(context).primary, width: 2.0) : null,
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
                                                                                  if (selectedIndex == 0) {
                                                                                    // Deselect if already selected
                                                                                    _model.userAnswer = null;
                                                                                    _model.actualAnswer = null;
                                                                                    selectedOptionPerQuestion[categorywisequizIndex] = -1;
                                                                                    FFAppState().selectedColorIndex = -1;
                                                                                  } else {
                                                                                    _model.userAnswer = 'True';
                                                                                    _model.actualAnswer = getJsonField(
                                                                                      categorywisequizItem,
                                                                                      r'''$.answer''',
                                                                                    ).toString();
                                                                                    selectedOptionPerQuestion[categorywisequizIndex] = 0;
                                                                                    FFAppState().selectedColorIndex = 0;
                                                                                  }
                                                                                  safeSetState(() {});
                                                                                  FFAppState().update(() {});
                                                                                },
                                                                                child: Container(
                                                                                  width: 369.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FlutterFlowTheme.of(context).grey,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                    border: selectedIndex == 0 ? Border.all(color: FlutterFlowTheme.of(context).primary, width: 2.0) : null,
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
                                                                                  if (selectedIndex == 1) {
                                                                                    // Deselect if already selected
                                                                                    _model.userAnswer = null;
                                                                                    _model.actualAnswer = null;
                                                                                    selectedOptionPerQuestion[categorywisequizIndex] = -1;
                                                                                    FFAppState().selectedColorIndex = -1;
                                                                                  } else {
                                                                                    _model.userAnswer = 'False';
                                                                                    _model.actualAnswer = getJsonField(
                                                                                      categorywisequizItem,
                                                                                      r'''$.answer''',
                                                                                    ).toString();
                                                                                    selectedOptionPerQuestion[categorywisequizIndex] = 1;
                                                                                    FFAppState().selectedColorIndex = 1;
                                                                                  }
                                                                                  safeSetState(() {});
                                                                                  FFAppState().update(() {});
                                                                                },
                                                                                child: Container(
                                                                                  width: 369.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FlutterFlowTheme.of(context).grey,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                    border: selectedIndex == 1 ? Border.all(color: FlutterFlowTheme.of(context).primary, width: 2.0) : null,
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
                                                                                      if (selectedIndex == 0) {
                                                                                        // Deselect if already selected
                                                                                        _model.userAnswer = null;
                                                                                        _model.actualAnswer = null;
                                                                                        selectedOptionPerQuestion[categorywisequizIndex] = -1;
                                                                                        FFAppState().selectedColorIndex = -1;
                                                                                      } else {
                                                                                        _model.userAnswer = getJsonField(
                                                                                          categorywisequizItem,
                                                                                          r'''$.option.a''',
                                                                                        ).toString();
                                                                                        _model.actualAnswer = getJsonField(
                                                                                          categorywisequizItem,
                                                                                          r'''$.answer''',
                                                                                        ).toString();
                                                                                        selectedOptionPerQuestion[categorywisequizIndex] = 0;
                                                                                        FFAppState().selectedColorIndex = 0;
                                                                                      }
                                                                                      safeSetState(() {});
                                                                                      FFAppState().update(() {});
                                                                                    },
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: FlutterFlowTheme.of(context).grey,
                                                                                        borderRadius: BorderRadius.circular(12.0),
                                                                                        border: selectedIndex == 0 ? Border.all(color: FlutterFlowTheme.of(context).primary, width: 2.0) : null,
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
                                                                                      if (selectedIndex == 1) {
                                                                                        // Deselect if already selected
                                                                                        _model.userAnswer = null;
                                                                                        _model.actualAnswer = null;
                                                                                        selectedOptionPerQuestion[categorywisequizIndex] = -1;
                                                                                        FFAppState().selectedColorIndex = -1;
                                                                                      } else {
                                                                                        _model.userAnswer = getJsonField(
                                                                                          categorywisequizItem,
                                                                                          r'''$.option.b''',
                                                                                        ).toString();
                                                                                        _model.actualAnswer = getJsonField(
                                                                                          categorywisequizItem,
                                                                                          r'''$.answer''',
                                                                                        ).toString();
                                                                                        selectedOptionPerQuestion[categorywisequizIndex] = 1;
                                                                                        FFAppState().selectedColorIndex = 1;
                                                                                      }
                                                                                      safeSetState(() {});
                                                                                      FFAppState().update(() {});
                                                                                    },
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: FlutterFlowTheme.of(context).grey,
                                                                                        borderRadius: BorderRadius.circular(12.0),
                                                                                        border: selectedIndex == 1 ? Border.all(color: FlutterFlowTheme.of(context).primary, width: 2.0) : null,
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
                                                                                        if (selectedIndex == 2) {
                                                                                          // Deselect if already selected
                                                                                          _model.userAnswer = null;
                                                                                          _model.actualAnswer = null;
                                                                                          selectedOptionPerQuestion[categorywisequizIndex] = -1;
                                                                                          FFAppState().selectedColorIndex = -1;
                                                                                        } else {
                                                                                          _model.userAnswer = getJsonField(
                                                                                            categorywisequizItem,
                                                                                            r'''$.option.c''',
                                                                                          ).toString();
                                                                                          _model.actualAnswer = getJsonField(
                                                                                            categorywisequizItem,
                                                                                            r'''$.answer''',
                                                                                          ).toString();
                                                                                          selectedOptionPerQuestion[categorywisequizIndex] = 2;
                                                                                          FFAppState().selectedColorIndex = 2;
                                                                                        }
                                                                                        safeSetState(() {});
                                                                                        FFAppState().update(() {});
                                                                                      },
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          color: FlutterFlowTheme.of(context).grey,
                                                                                          borderRadius: BorderRadius.circular(12.0),
                                                                                          border: selectedIndex == 2 ? Border.all(color: FlutterFlowTheme.of(context).primary, width: 2.0) : null,
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
                                                                                        if (selectedIndex == 3) {
                                                                                          // Deselect if already selected
                                                                                          _model.userAnswer = null;
                                                                                          _model.actualAnswer = null;
                                                                                          selectedOptionPerQuestion[categorywisequizIndex] = -1;
                                                                                          FFAppState().selectedColorIndex = -1;
                                                                                        } else {
                                                                                          _model.userAnswer = getJsonField(
                                                                                            categorywisequizItem,
                                                                                            r'''$.option.d''',
                                                                                          ).toString();
                                                                                          _model.actualAnswer = getJsonField(
                                                                                            categorywisequizItem,
                                                                                            r'''$.answer''',
                                                                                          ).toString();
                                                                                          selectedOptionPerQuestion[categorywisequizIndex] = 3;
                                                                                          FFAppState().selectedColorIndex = 3;
                                                                                        }
                                                                                        safeSetState(() {});
                                                                                        FFAppState().update(() {});
                                                                                      },
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          color: FlutterFlowTheme.of(context).grey,
                                                                                          borderRadius: BorderRadius.circular(12.0),
                                                                                          border: selectedIndex == 3 ? Border.all(color: FlutterFlowTheme.of(context).primary, width: 2.0) : null,
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
                                                                                  if (selectedIndex == 0) {
                                                                                    // Deselect if already selected
                                                                                    _model.userAnswer = null;
                                                                                    _model.actualAnswer = null;
                                                                                    selectedOptionPerQuestion[categorywisequizIndex] = -1;
                                                                                    FFAppState().selectedColorIndex = -1;
                                                                                  } else {
                                                                                    _model.userAnswer = getJsonField(
                                                                                      categorywisequizItem,
                                                                                      r'''$.option.a''',
                                                                                    ).toString();
                                                                                    _model.actualAnswer = getJsonField(
                                                                                      categorywisequizItem,
                                                                                      r'''$.answer''',
                                                                                    ).toString();
                                                                                    selectedOptionPerQuestion[categorywisequizIndex] = 0;
                                                                                    FFAppState().selectedColorIndex = 0;
                                                                                  }
                                                                                  safeSetState(() {});
                                                                                  FFAppState().update(() {});
                                                                                },
                                                                                child: Container(
                                                                                  width: 369.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FlutterFlowTheme.of(context).grey,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                    border: selectedIndex == 0 ? Border.all(color: FlutterFlowTheme.of(context).primary, width: 2.0) : null,
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
                                                                                  if (selectedIndex == 1) {
                                                                                    // Deselect if already selected
                                                                                    _model.userAnswer = null;
                                                                                    _model.actualAnswer = null;
                                                                                    selectedOptionPerQuestion[categorywisequizIndex] = -1;
                                                                                    FFAppState().selectedColorIndex = -1;
                                                                                  } else {
                                                                                    _model.userAnswer = getJsonField(
                                                                                      categorywisequizItem,
                                                                                      r'''$.option.b''',
                                                                                    ).toString();
                                                                                    _model.actualAnswer = getJsonField(
                                                                                      categorywisequizItem,
                                                                                      r'''$.answer''',
                                                                                    ).toString();
                                                                                    selectedOptionPerQuestion[categorywisequizIndex] = 1;
                                                                                    FFAppState().selectedColorIndex = 1;
                                                                                  }
                                                                                  safeSetState(() {});
                                                                                  FFAppState().update(() {});
                                                                                },
                                                                                child: Container(
                                                                                  width: 369.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FlutterFlowTheme.of(context).grey,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                    border: selectedIndex == 1 ? Border.all(color: FlutterFlowTheme.of(context).primary, width: 2.0) : null,
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
                                                                                  if (selectedIndex == 2) {
                                                                                    // Deselect if already selected
                                                                                    _model.userAnswer = null;
                                                                                    _model.actualAnswer = null;
                                                                                    selectedOptionPerQuestion[categorywisequizIndex] = -1;
                                                                                    FFAppState().selectedColorIndex = -1;
                                                                                  } else {
                                                                                    _model.userAnswer = getJsonField(
                                                                                      categorywisequizItem,
                                                                                      r'''$.option.c''',
                                                                                    ).toString();
                                                                                    _model.actualAnswer = getJsonField(
                                                                                      categorywisequizItem,
                                                                                      r'''$.answer''',
                                                                                    ).toString();
                                                                                    selectedOptionPerQuestion[categorywisequizIndex] = 2;
                                                                                    FFAppState().selectedColorIndex = 2;
                                                                                  }
                                                                                  safeSetState(() {});
                                                                                  FFAppState().update(() {});
                                                                                },
                                                                                child: Container(
                                                                                  width: 369.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FlutterFlowTheme.of(context).grey,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                    border: selectedIndex == 2 ? Border.all(color: FlutterFlowTheme.of(context).primary, width: 2.0) : null,
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
                                                                                if (selectedIndex == 3) {
                                                                                  // Deselect if already selected
                                                                                  _model.userAnswer = null;
                                                                                  _model.actualAnswer = null;
                                                                                  selectedOptionPerQuestion[categorywisequizIndex] = -1;
                                                                                  FFAppState().selectedColorIndex = -1;
                                                                                } else {
                                                                                  _model.userAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.option.d''',
                                                                                  ).toString();
                                                                                  _model.actualAnswer = getJsonField(
                                                                                    categorywisequizItem,
                                                                                    r'''$.answer''',
                                                                                  ).toString();
                                                                                  selectedOptionPerQuestion[categorywisequizIndex] = 3;
                                                                                  FFAppState().selectedColorIndex = 3;
                                                                                }
                                                                                safeSetState(() {});
                                                                                FFAppState().update(() {});
                                                                              },
                                                                              child: Container(
                                                                                width: 369.0,
                                                                                decoration: BoxDecoration(
                                                                                  color: FlutterFlowTheme.of(context).grey,
                                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                                  border: selectedIndex == 3 ? Border.all(color: FlutterFlowTheme.of(context).primary, width: 2.0) : null,
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
                                                  // Back Button
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 40.0,
                                                      child: FFButtonWidget(
                                                        onPressed: () async {
                                                          if (_model.pageViewCurrentIndex > 0) {
                                                            await _model.pageViewController?.previousPage(
                                                              duration: Duration(milliseconds: 300),
                                                              curve: Curves.ease,
                                                            );
                                                            FFAppState().quesIndex = _model.pageViewCurrentIndex;
                                                            safeSetState(() {});
                                                          }
                                                        },
                                                        text: 'Back',
                                                        options: FFButtonOptions(
                                                          height: 40.0,
                                                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                            fontFamily: 'Roboto',
                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.w600,
                                                            useGoogleFonts: false,
                                                          ),
                                                          borderRadius: BorderRadius.circular(8.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.0),
                                                  // Skip Button
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 40.0,
                                                      child: FFButtonWidget(
                                                        onPressed: () async {
                                                          // Skip logic: go to next question without saving answer
                                                          if ((_model.pageViewController != null) && ((QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.length ?? 0) != (_model.pageViewCurrentIndex + 1))) {
                                                            await _model.pageViewController?.nextPage(
                                                              duration: Duration(milliseconds: 300),
                                                              curve: Curves.ease,
                                                            );
                                                            FFAppState().quesIndex = _model.pageViewCurrentIndex + 1;
                                                            safeSetState(() {});
                                                            FFAppState().selectedColorIndex = -1;
                                                            safeSetState(() {});
                                                            _model.userAnswer = null;
                                                            _model.actualAnswer = null;
                                                            safeSetState(() {});
                                                          }
                                                        },
                                                        text: 'Skip',
                                                        options: FFButtonOptions(
                                                          height: 40.0,
                                                          color: FlutterFlowTheme.of(context).alternate,
                                                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                            fontFamily: 'Roboto',
                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.w600,
                                                            useGoogleFonts: false,
                                                          ),
                                                          borderRadius: BorderRadius.circular(8.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.0),
                                                  // Save & Next Button
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 40.0,
                                                      child: FFButtonWidget(
                                                        onPressed: () async {
                                                          // First, process the answer for the current question
                                                          if (_model.userAnswer != null && _model.userAnswer != '') {
                                                            if (_model.userAnswer == _model.actualAnswer) {
                                                              FFAppState().correctQues += 1;
                                                            } else {
                                                              FFAppState().wrongQues += 1;
                                                            }
                                                          } else {
                                                            FFAppState().notAnswerQues += 1;
                                                            FFAppState().addToNotAnswerQuestion({
                                                              'question_title': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.question_title''',
                                                                        ),
                                                              'question_type': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.question_type''',
                                                                        ),
                                                              'answer': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.answer''',
                                                                        ),
                                                              'option': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.option''',
                                                                        ),
                                                              'user_answer': FFAppState().userAns,
                                                            });
                                                          }
                                                          FFAppState().update(() {});

                                                          final totalQuestions = (QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.length ?? 0);
                                                          final isLast = (_model.pageViewCurrentIndex + 1) == totalQuestions;

                                                          if (isLast) {
                                                            // It's the last question, navigate to the results screen
                                                            context.goNamed(
                                                              QuizResultWidget.routeName,
                                                              queryParameters: {
                                                                'correctAnswer': serializeParam(FFAppState().correctQues, ParamType.int),
                                                                'wrongAnswer': serializeParam(FFAppState().wrongQues, ParamType.int),
                                                                'totalQuestion': serializeParam(totalQuestions, ParamType.int),
                                                                'notAnswer': serializeParam(FFAppState().notAnswerQues, ParamType.int),
                                                                'quizID': serializeParam(widget.quizID, ParamType.String),
                                                                'quizTime': serializeParam(quizDurationMinutes.toString(), ParamType.String),
                                                                'catID': serializeParam(widget.catId, ParamType.String),
                                                                'title': serializeParam(widget.title, ParamType.String),
                                                                'image': serializeParam(widget.image, ParamType.String),
                                                                'correctAnsReward': serializeParam(correctAnsReward, ParamType.double),
                                                                'penaltyPerQuestion': serializeParam(penaltyPerQuestion, ParamType.double),
                                                              }.withoutNulls,
                                                            );
                                                          } else {
                                                            // It's not the last question, move to the next one
                                                            await _model.pageViewController?.nextPage(
                                                              duration: Duration(milliseconds: 300),
                                                              curve: Curves.ease,
                                                            );
                                                            _model.userAnswer = null;
                                                            _model.actualAnswer = null;
                                                            FFAppState().quesIndex = _model.pageViewCurrentIndex + 1;
                                                            FFAppState().selectedColorIndex = -1;
                                                            safeSetState(() {});
                                                          }

                                                          // Inside the Save & Next button logic, after processing the answer:
                                                          if (_model.userAnswer != null && _model.userAnswer != '') {
                                                            final userAnswer = (_model.userAnswer != null && _model.userAnswer.toString().trim().isNotEmpty)
                                                                ? _model.userAnswer.toString()
                                                                : 'skipped';
                                                            FFAppState().addToQuesList({
                                                              'question_title': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.question_title''',
                                                                        ),
                                                              'image': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.image''',
                                                                        ),
                                                              'audio': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.audio''',
                                                                        ),
                                                              'question_type': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.question_type''',
                                                                        ),
                                                              'option': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.option''',
                                                                        ),
                                                              'answer': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.answer''',
                                                                        ),
                                                              'user_answer': userAnswer,
                                                              'description': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.description''',
                                                                        ),
                                                            });
                                                          } else {
                                                            // For skipped questions
                                                            final userAnswer = 'skipped';
                                                            FFAppState().addToQuesList({
                                                              'question_title': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.question_title''',
                                                                        ),
                                                              'image': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.image''',
                                                                        ),
                                                              'audio': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.audio''',
                                                                        ),
                                                              'question_type': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.question_type''',
                                                                        ),
                                                              'option': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.option''',
                                                                        ),
                                                              'answer': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.answer''',
                                                                        ),
                                                              'user_answer': userAnswer,
                                                              'description': getJsonField(
                                                                QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.elementAtOrNull(_model.pageViewCurrentIndex),
                                                                          r'''$.description''',
                                                                        ),
                                                            });
                                                          }
                                                        },
                                                        text: ((QuizGroup.getquestionsbyquizidApiCall.questionDetailsList((_model.quizRes?.jsonBody ?? ''))?.length ?? 0) == (_model.pageViewCurrentIndex + 1)) ? 'Submit' : 'Save & Next',
                                                        options: FFButtonOptions(
                                                          height: 40.0,
                                                          color: FlutterFlowTheme.of(context).primary,
                                                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                            fontFamily: 'Roboto',
                                                            color: FlutterFlowTheme.of(context).white,
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.w600,
                                                            useGoogleFonts: false,
                                                          ),
                                                          borderRadius: BorderRadius.circular(8.0),
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
                        }
                        // Add this default return to handle all other cases
                        return SizedBox.shrink();
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
