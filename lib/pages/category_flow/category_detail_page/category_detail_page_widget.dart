import '/backend/api_requests/api_calls.dart';
import '/componants/app_bar/app_bar_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'category_detail_page_model.dart';
export 'category_detail_page_model.dart';

class CategoryDetailPageWidget extends StatefulWidget {
  const CategoryDetailPageWidget({
    super.key,
    this.title,
    this.catId,
  });

  final String? title;
  final String? catId;

  static String routeName = 'category_detail_page';
  static String routePath = '/categoryDetailPage';

  @override
  State<CategoryDetailPageWidget> createState() =>
      _CategoryDetailPageWidgetState();
}

class _CategoryDetailPageWidgetState extends State<CategoryDetailPageWidget>
    with TickerProviderStateMixin {
  late CategoryDetailPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CategoryDetailPageModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: null,
      ),
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            wrapWithModel(
              model: _model.appBarModel,
              updateCallback: () => safeSetState(() {}),
              child: AppBarWidget(
                title: widget.title!,
                backIcon: false,
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (FFAppState().connected == true) {
                    return FutureBuilder<ApiCallResponse>(
                      future: FFAppState()
                          .details(
                        uniqueQueryKey: valueOrDefault<String>(
                          widget.catId,
                          '65498',
                        ),
                        requestFn: () {
                          print('Making API call for category ID: ${widget.catId}');
                          return GetquizbycategoryCall.call(
                            categoryId: widget.catId,
                          );
                        },
                      )
                          .then((result) {
                        try {
                          print('API Response Status: ${result.statusCode}');
                          print('API Response Body: ${result.jsonBody}');
                          _model.apiRequestCompleted = true;
                          _model.apiRequestLastUniqueKey =
                              valueOrDefault<String>(
                            widget.catId,
                            '65498',
                          );
                        } catch (e) {
                          print('Error processing API response: $e');
                        }
                        return result;
                      }),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          print('FutureBuilder Error: ${snapshot.error}');
                          return Center(
                            child: Text('Error loading quizzes: ${snapshot.error}'),
                          );
                        }
                        
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final response = snapshot.data!;
                        if (response.jsonBody == null) {
                          return Center(
                            child: Text('No quizzes found for this category'),
                          );
                        }

                        return Container(
                          decoration: BoxDecoration(),
                          child: Builder(
                            builder: (context) {
                              if (GetquizbycategoryCall.success(
                                    response.jsonBody,
                                  ) ==
                                  2) {
                                return Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    child: Text(
                                      valueOrDefault<String>(
                                        GetquizbycategoryCall.message(
                                          response.jsonBody,
                                        ),
                                        'Message',
                                      ),
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
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
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  child: Builder(
                                    builder: (context) {
                                      final quizList =
                                          GetquizbycategoryCall.quizDetailsList(
                                                response.jsonBody,
                                              )?.toList() ??
                                              [];

                                      return RefreshIndicator(
                                        key: Key('RefreshIndicator_qbk37jzx'),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                        onRefresh: () async {
                                          safeSetState(() {
                                            FFAppState().clearDetailsCacheKey(
                                                _model.apiRequestLastUniqueKey);
                                            _model.apiRequestCompleted = false;
                                          });
                                          await _model
                                              .waitForApiRequestCompleted();
                                        },
                                        child: ListView.separated(
                                          padding: EdgeInsets.fromLTRB(
                                            0,
                                            16.0,
                                            0,
                                            16.0,
                                          ),
                                          scrollDirection: Axis.vertical,
                                          itemCount: quizList.length,
                                          separatorBuilder: (_, __) =>
                                              SizedBox(height: 16.0),
                                          itemBuilder:
                                              (context, quizListIndex) {
                                            final quizListItem =
                                                quizList[quizListIndex];
                                            return InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                if (FFAppState().isLogin ==
                                                    true) {
                                                  context.pushNamed(
                                                    DetailScreenWidget
                                                        .routeName,
                                                    queryParameters: {
                                                      'catId': serializeParam(
                                                        widget.catId,
                                                        ParamType.String,
                                                      ),
                                                      'name': serializeParam(
                                                        getJsonField(
                                                          quizListItem,
                                                          r'''$.name''',
                                                        ).toString(),
                                                        ParamType.String,
                                                      ),
                                                      'image': serializeParam(
                                                        '${FFAppConstants.imageBaseURL}${getJsonField(
                                                          quizListItem,
                                                          r'''$.image''',
                                                        ).toString()}',
                                                        ParamType.String,
                                                      ),
                                                      'quizTime':
                                                          serializeParam(
                                                        getJsonField(
                                                          quizListItem,
                                                          r'''$.minutes_per_quiz''',
                                                        ).toString(),
                                                        ParamType.String,
                                                      ),
                                                      'description':
                                                          serializeParam(
                                                        getJsonField(
                                                          quizListItem,
                                                          r'''$.description''',
                                                        ).toString(),
                                                        ParamType.String,
                                                      ),
                                                      'ques': serializeParam(
                                                        getJsonField(
                                                          quizListItem,
                                                          r'''$.total_questions''',
                                                        ),
                                                        ParamType.int,
                                                      ),
                                                      'quizID': serializeParam(
                                                        getJsonField(
                                                          quizListItem,
                                                          r'''$._id''',
                                                        ).toString(),
                                                        ParamType.String,
                                                      ),
                                                      'title': serializeParam(
                                                        widget.title,
                                                        ParamType.String,
                                                      ),
                                                      'timerStatus':
                                                          serializeParam(
                                                        getJsonField(
                                                          quizListItem,
                                                          r'''$.timer_status''',
                                                        ),
                                                        ParamType.int,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Please login first for View Content',
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 2000),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      action: SnackBarAction(
                                                        label: 'Login',
                                                        textColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        onPressed: () async {
                                                          context.goNamed(
                                                              LoginScreenWidget
                                                                  .routeName);
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height: 118.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 12.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          fadeInDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      200),
                                                          fadeOutDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      200),
                                                          imageUrl:
                                                              valueOrDefault<
                                                                  String>(
                                                            '${FFAppConstants.imageBaseURL}${getJsonField(
                                                              quizListItem,
                                                              r'''$.image''',
                                                            ).toString()}',
                                                            'https://picsum.photos/seed/223/600',
                                                          ),
                                                          width: 70.0,
                                                          height: 70.0,
                                                          fit: BoxFit.cover,
                                                          alignment: Alignment(
                                                              0.0, -1.0),
                                                          errorWidget: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              Image.asset(
                                                            'assets/images/error_image.png',
                                                            width: 70.0,
                                                            height: 70.0,
                                                            fit: BoxFit.cover,
                                                            alignment:
                                                                Alignment(
                                                                    0.0, -1.0),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      12.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                getJsonField(
                                                                  quizListItem,
                                                                  r'''$.name''',
                                                                ).toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                maxLines: 2,
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
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      useGoogleFonts:
                                                                          false,
                                                                      lineHeight:
                                                                          1.2,
                                                                    ),
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    '${getJsonField(
                                                                      quizListItem,
                                                                      r'''$.total_questions''',
                                                                    ).toString()} questions',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    maxLines: 1,
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
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          useGoogleFonts:
                                                                              false,
                                                                          lineHeight:
                                                                              1.2,
                                                                        ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          5.0,
                                                                      height:
                                                                          5.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .black,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${getJsonField(
                                                                      quizListItem,
                                                                      r'''$.minutes_per_quiz''',
                                                                    ).toString()} min',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    maxLines: 1,
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
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          useGoogleFonts:
                                                                              false,
                                                                          lineHeight:
                                                                              1.2,
                                                                        ),
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    width:
                                                                        4.0)),
                                                              ),
                                                            ].divide(SizedBox(
                                                                height: 12.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ).animateOnPageLoad(
                                              animationsMap[
                                                  'containerOnPageLoadAnimation']!,
                                              effects: [
                                                MoveEffect(
                                                  curve: Curves.easeInOut,
                                                  delay: valueOrDefault<double>(
                                                    quizListIndex * 111,
                                                    0.0,
                                                  ).ms,
                                                  duration: 400.0.ms,
                                                  begin: Offset(100.0, 0.0),
                                                  end: Offset(0.0, 0.0),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
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
          /*  if (FFAppState().isBannerAd == 1)
              custom_widgets.Bannerwidget(
                width: double.infinity,
                height: 50.0,
              ),*/
          ],
        ),
      ),
    );
  }
}
