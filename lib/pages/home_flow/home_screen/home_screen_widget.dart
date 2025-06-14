import '';
import '/backend/api_requests/api_calls.dart';
import '/componants/email_verification_dialog/email_verification_dialog_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/shimmer/blank_component/blank_component_widget.dart';
import '/shimmer/shimmer_banner/shimmer_banner_widget.dart';
import '/shimmer/shimmer_container/shimmer_container_widget.dart';
import '/shimmer/shimmer_home_list/shimmer_home_list_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'home_screen_model.dart';
import 'dart:ui';
export 'home_screen_model.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  static String routeName = 'home_screen';
  static String routePath = '/homeScreen';

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget>
    with TickerProviderStateMixin {
  late HomeScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  // Store quizzes for each category for search
  final Map<String, List<dynamic>> homePageQuizzes = {};

  // Banner carousel current index
  int _bannerCurrentIndex = 0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeScreenModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (FFAppState().isLogin) {
        _model.apiResultaov = await QuizGroup.isVerifyAccountCall.call(
          email: getJsonField(
            FFAppState().userDetils,
            r'''$.email''',
          ).toString().toString(),
        );

        if (QuizGroup.isVerifyAccountCall.success(
              (_model.apiResultaov?.jsonBody ?? ''),
            ) !=
            1) {
          await showDialog(
            context: context,
            builder: (dialogContext) {
              return Dialog(
                elevation: 0,
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                alignment: AlignmentDirectional(0.0, 0.0)
                    .resolve(Directionality.of(context)),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(dialogContext).unfocus();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: EmailVerificationDialogWidget(),
                ),
              );
            },
          );
        }
      }
      _model.getUserRankRes = await QuizGroup.getuserrankApiCall.call(
        userId: getJsonField(
          FFAppState().userDetils,
          r'''$.id''',
        ).toString().toString(),
        token: FFAppState().loginToken,
      );

      if (QuizGroup.getuserrankApiCall.success(
            (_model.getUserRankRes?.jsonBody ?? ''),
          ) ==
          1) {
        final points = QuizGroup.getuserrankApiCall
            .points(
              (_model.getUserRankRes?.jsonBody ?? ''),
            );
        FFAppState().userPoints = points != null ? points.toInt() : 0;
        FFAppState().update(() {});
        /*if (FFAppState().userPoints < 10) {
          await actions.rewardedVideoAdInitAction();
        }*/
      }
    });

    animationsMap.addAll({
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.linear,
            delay: 50.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, -20.0),
            end: Offset(0.0, 0.0),
          ),
        ],
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

    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            elevation: 0,
            title: SizedBox(
              height: 50,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 5,),
                  Image.asset('assets/images/mock_test_horizontal_logo.png',width: 150,),
                ],
              ),
            ),
            actions: [
              // Store quizzes for search
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController searchController = TextEditingController();
                          List<dynamic> searchResults = [];
                          bool isLoading = false;
                          String lastQuery = '';
                          return StatefulBuilder(
                            builder: (context, setState) {
                              Future<void> performSearch(String query) async {
                                setState(() {
                                  isLoading = true;
                                });
                                // Combine all quizzes from homePageQuizzes
                                final allHomeQuizzes = homePageQuizzes.values.expand((x) => x).toList();
                                final results = allHomeQuizzes.where((quiz) {
                                  final name = getJsonField(quiz, r'''$.name''').toString().toLowerCase();
                                  return name.contains(query.toLowerCase());
                                }).toList();
                                setState(() {
                                  searchResults = results;
                                  isLoading = false;
                                  lastQuery = query;
                                });
                              }
                              return Dialog(
                                insetPadding: EdgeInsets.all(16),
                                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Container(
                                  width: 400,
                                  constraints: BoxConstraints(maxHeight: 500),
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: searchController,
                                              autofocus: true,
                                              decoration: InputDecoration(
                                                hintText: 'Search quiz by name',
                                                prefixIcon: Icon(Icons.search, size: 20),
                                                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(24.0),
                                                  borderSide: BorderSide.none,
                                                ),
                                                filled: true,
                                                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                isDense: true,
                                              ),
                                              style: FlutterFlowTheme.of(context).bodyMedium,
                                              onChanged: (value) {
                                                if (value.trim().isNotEmpty) {
                                                  performSearch(value.trim());
                                                } else {
                                                  setState(() {
                                                    searchResults = [];
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () => Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      if (isLoading)
                                        Center(child: CircularProgressIndicator()),
                                      if (!isLoading && searchResults.isEmpty && searchController.text.isNotEmpty)
                                        Center(child: Text('No quizzes found', style: FlutterFlowTheme.of(context).bodyMedium)),
                                      if (!isLoading && searchResults.isNotEmpty)
                                        Expanded(
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            itemCount: searchResults.length,
                                            separatorBuilder: (_, __) => SizedBox(height: 8),
                                            itemBuilder: (context, index) {
                                              final quiz = searchResults[index];
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  context.pushNamed(
                                                    DetailScreenWidget.routeName,
                                                    queryParameters: {
                                                      'catId': serializeParam(
                                                        getJsonField(quiz, r'''$.categoryId''').toString(),
                                                        ParamType.String,
                                                      ),
                                                      'name': serializeParam(
                                                        getJsonField(quiz, r'''$.name''').toString(),
                                                        ParamType.String,
                                                      ),
                                                      'image': serializeParam(
                                                        '${FFAppConstants.imageBaseURL}${getJsonField(quiz, r'''$.image''').toString()}',
                                                        ParamType.String,
                                                      ),
                                                      'quizTime': serializeParam(
                                                        getJsonField(quiz, r'''$.minutes_per_quiz''').toString(),
                                                        ParamType.String,
                                                      ),
                                                      'description': serializeParam(
                                                        getJsonField(quiz, r'''$.description''').toString(),
                                                        ParamType.String,
                                                      ),
                                                      'quizID': serializeParam(
                                                        getJsonField(quiz, r'''$._id''').toString(),
                                                        ParamType.String,
                                                      ),
                                                      'ques': serializeParam(
                                                        getJsonField(quiz, r'''$.total_questions'''),
                                                        ParamType.int,
                                                      ),
                                                      'title': serializeParam(
                                                        getJsonField(quiz, r'''$.name''').toString(),
                                                        ParamType.String,
                                                      ),
                                                      'timerStatus': serializeParam(
                                                        getJsonField(quiz, r'''$.timer_status'''),
                                                        ParamType.int,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: CachedNetworkImage(
                                                          imageUrl: '${FFAppConstants.imageBaseURL}${getJsonField(quiz, r'''$.image''').toString()}',
                                                          width: 40,
                                                          height: 40,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Expanded(
                                                        child: Text(
                                                          getJsonField(quiz, r'''$.name''').toString(),
                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Roboto',
                                                            fontSize: 16.0,
                                                            fontWeight: FontWeight.w500,
                                                            useGoogleFonts: false,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (FFAppState().connected == true) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Carousel
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200.0,
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          child: FutureBuilder<ApiCallResponse>(
                            future: QuizGroup.getCarouselBannersCall.call(),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).primary,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final bannersResponse = snapshot.data!;
                              final banners = GetCarouselBannersCall()
                                  .bannersList(bannersResponse.jsonBody)
                                  ?.toList() ?? [];

                              if (banners.isEmpty) {
                                return Container(); // Hide if no banners
                              }

                              return CarouselSlider(
                                options: CarouselOptions(
                                  height: 200.0,
                                  viewportFraction: 1.0, // edge-to-edge
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 3),
                                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: false,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _bannerCurrentIndex = index;
                                    });
                                  },
                                ),
                                items: banners.map((banner) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.zero,
                                        padding: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: '${FFAppConstants.imageBaseURL}${getJsonField(
                                            banner,
                                            r'''$.image''',
                                          ).toString()}',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                FlutterFlowTheme.of(context).primary,
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                        // Banner pointer dots
                        FutureBuilder<ApiCallResponse>(
                          future: QuizGroup.getCarouselBannersCall.call(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return SizedBox.shrink();
                            final bannersResponse = snapshot.data!;
                            final banners = GetCarouselBannersCall()
                                .bannersList(bannersResponse.jsonBody)
                                ?.toList() ?? [];
                            if (banners.isEmpty) return SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(banners.length, (index) {
                                  return AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                                    width: 8.0,
                                    height: 8.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _bannerCurrentIndex == index
                                          ? Colors.black
                                          : Colors.black.withOpacity(0.2),
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 1.0), // Add spacing after carousel
                      ],
                    ),
                    
                    Expanded(
                      child: FutureBuilder<ApiCallResponse>(
                        future: FFAppState()
                            .selfChalange(
                          requestFn: () =>
                              QuizGroup.getpointssettingApiCall.call(
                            token: FFAppState().loginToken,
                          ),
                        )
                            .then((result) {
                          _model.apiRequestCompleted1 = true;
                          return result;
                        }),
                        builder: (context, snapshot) {
                          // Customize what your widget looks like when it's loading.
                          if (!snapshot.hasData) {
                            return Container(
                              width: double.infinity,
                              child: ShimmerHomeListWidget(),
                            );
                          }
                          final selfContainerGetpointssettingApiResponse =
                              snapshot.data!;

                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(),
                            child: FutureBuilder<ApiCallResponse>(
                              future: FFAppState()
                                  .featured(
                                requestFn: () => GetFeatureCategoryCall.call(
                                  baseURL: FFAppConstants.baseURL,
                                ),
                              )
                                  .then((result) {
                                _model.apiRequestCompleted4 = true;
                                return result;
                              }),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return Container(
                                    width: double.infinity,
                                    child: ShimmerHomeListWidget(),
                                  );
                                }
                                final feautureContainerGetFeatureCategoryResponse =
                                    snapshot.data!;

                                return Container(
                                  decoration: BoxDecoration(),
                                  child: FutureBuilder<ApiCallResponse>(
                                    future: FFAppState()
                                        .categoryViewall(
                                      requestFn: () =>
                                          QuizGroup.getAllCategoriesCall.call(),
                                    )
                                        .then((result) {
                                      _model.apiRequestCompleted2 = true;
                                      return result;
                                    }),
                                    builder: (context, snapshot) {
                                      // Customize what your widget looks like when it's loading.
                                      if (!snapshot.hasData) {
                                        return BlankComponentWidget();
                                      }
                                      final categoriesContainerGetAllCategoriesResponse =
                                          snapshot.data!;

                                      return Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(),
                                        child: Builder(
                                          builder: (context) {
                                            if ((QuizGroup.getAllCategoriesCall
                                                        .success(
                                                      categoriesContainerGetAllCategoriesResponse
                                                          .jsonBody,
                                                    ) ==
                                                    2) ||
                                                (GetFeatureCategoryCall.success(
                                                      feautureContainerGetFeatureCategoryResponse
                                                          .jsonBody,
                                                    ) ==
                                                    2) ||
                                                (QuizGroup
                                                        .getpointssettingApiCall
                                                        .success(
                                                      selfContainerGetpointssettingApiResponse
                                                          .jsonBody,
                                                    ) ==
                                                    2)) {
                                              return Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 16.0, 0.0),
                                                  child: Text(
                                                    valueOrDefault<String>(
                                                      GetFeatureCategoryCall
                                                          .message(
                                                        feautureContainerGetFeatureCategoryResponse
                                                            .jsonBody,
                                                      ),
                                                      'Message',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Roboto',
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts: false,
                                                          lineHeight: 1.5,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return RefreshIndicator(
                                                key: Key(
                                                    'RefreshIndicator_hrdannp9'),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                onRefresh: () async {
                                                  await Future.wait([
                                                    Future(() async {
                                                      safeSetState(() {
                                                        FFAppState()
                                                            .clearBannerCache();
                                                        _model.apiRequestCompleted5 =
                                                            false;
                                                      });
                                                      await _model
                                                          .waitForApiRequestCompleted5(
                                                              maxWait: 3000);
                                                    }),
                                                    Future(() async {
                                                      safeSetState(() {
                                                        FFAppState()
                                                            .clearCategoryViewallCache();
                                                        _model.apiRequestCompleted2 =
                                                            false;
                                                      });
                                                      await _model
                                                          .waitForApiRequestCompleted2(
                                                              maxWait: 3000);
                                                    }),
                                                    Future(() async {
                                                      safeSetState(() {
                                                        FFAppState()
                                                            .clearFeaturedCache();
                                                        _model.apiRequestCompleted4 =
                                                            false;
                                                      });
                                                      await _model
                                                          .waitForApiRequestCompleted4(
                                                              maxWait: 3000);
                                                    }),
                                                    Future(() async {
                                                      safeSetState(() {
                                                        FFAppState()
                                                            .clearSelfChalangeCache();
                                                        _model.apiRequestCompleted1 =
                                                            false;
                                                      });
                                                      await _model
                                                          .waitForApiRequestCompleted1(
                                                              maxWait: 3000);
                                                    }),
                                                    Future(() async {
                                                      safeSetState(() {
                                                        FFAppState()
                                                            .clearCoinsCache();
                                                        _model.apiRequestCompleted3 =
                                                            false;
                                                      });
                                                      await _model
                                                          .waitForApiRequestCompleted3(
                                                              maxWait: 3000);
                                                    }),
                                                  ]);
                                                },
                                                child: SingleChildScrollView(
                                                  primary: false,
                                                  physics:
                                                      const AlwaysScrollableScrollPhysics(),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      if (QuizGroup
                                                                  .getAllCategoriesCall
                                                                  .category(
                                                                categoriesContainerGetAllCategoriesResponse
                                                                    .jsonBody,
                                                              ) !=
                                                              null &&
                                                          (QuizGroup
                                                                  .getAllCategoriesCall
                                                                  .category(
                                                            categoriesContainerGetAllCategoriesResponse
                                                                .jsonBody,
                                                          ))!
                                                              .isNotEmpty)
                                                        // Category with Quizzes Section
                                                        Builder(
                                                          builder: (context) {
                                                            final allCategories = (QuizGroup.getAllCategoriesCall
                                                                      .category(
                                                                        categoriesContainerGetAllCategoriesResponse.jsonBody,
                                                                      )
                                                                      ?.toList() ??
                                                                  []);
                                                            return Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: allCategories.asMap().entries.map((entry) {
                                                                final idx = entry.key;
                                                                final category = entry.value;
                                                                final categoryName = getJsonField(category, r'''$.name''').toString();
                                                                final categoryId = getJsonField(category, r'''$._id''').toString();
                                                                return Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    if (idx != 0)
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: ClipRect(
                                                                              child: BackdropFilter(
                                                                                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                                                                child: Container(
                                                                                  height: 1.0,
                                                                                  color: Colors.black.withOpacity(0.15),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0, bottom: 8.0),
                                                                      child: Text(
                                                                        categoryName,
                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 18.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: false,
                                                                              lineHeight: 1.5,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    // Full-width divider below category name
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: ClipRect(
                                                                            child: BackdropFilter(
                                                                              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                                                              child: Container(
                                                                                height: 1.0,
                                                                                color: Colors.black.withOpacity(0.15),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Container(
                                                                      width: double.infinity,
                                                                      height: 105.0,
                                                                      child: FutureBuilder<ApiCallResponse>(
                                                                        future: GetquizbycategoryCall.call(categoryId: categoryId),
                                                                        builder: (context, snapshot) {
                                                                          if (!snapshot.hasData) {
                                                                            return Center(
                                                                              child: SizedBox(
                                                                                width: 30.0,
                                                                                height: 30.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    FlutterFlowTheme.of(context).primary,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final quizResponse = snapshot.data!;
                                                                          final quizzes = GetquizbycategoryCall.quizDetailsList(quizResponse.jsonBody)?.toList() ?? [];
                                                                          // Store quizzes for this category in the map
                                                                          homePageQuizzes[categoryId] = quizzes;
                                                                          if (quizzes.isEmpty) {
                                                                            return Center(
                                                                              child: Text(
                                                                                'No content available',
                                                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                                                              ),
                                                                            );
                                                                          }
                                                                          return ListView.separated(
                                                                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                                                                            scrollDirection: Axis.horizontal,
                                                                            itemCount: quizzes.length,
                                                                            separatorBuilder: (_, __) => SizedBox(width: 16.0),
                                                                            itemBuilder: (context, index) {
                                                                              final quiz = quizzes[index];
                                                                              return InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  context.pushNamed(
                                                                                    DetailScreenWidget.routeName,
                                                                                    queryParameters: {
                                                                                      'catId': serializeParam(
                                                                                        categoryId,
                                                                                        ParamType.String,
                                                                                      ),
                                                                                      'name': serializeParam(
                                                                                        getJsonField(quiz, r'''$.name''').toString(),
                                                                                        ParamType.String,
                                                                                      ),
                                                                                      'image': serializeParam(
                                                                                        '${FFAppConstants.imageBaseURL}${getJsonField(quiz, r'''$.image''').toString()}',
                                                                                        ParamType.String,
                                                                                      ),
                                                                                      'quizTime': serializeParam(
                                                                                        getJsonField(quiz, r'''$.minutes_per_quiz''').toString(),
                                                                                        ParamType.String,
                                                                                      ),
                                                                                      'description': serializeParam(
                                                                                        getJsonField(quiz, r'''$.description''').toString(),
                                                                                        ParamType.String,
                                                                                      ),
                                                                                      'quizID': serializeParam(
                                                                                        getJsonField(quiz, r'''$._id''').toString(),
                                                                                        ParamType.String,
                                                                                      ),
                                                                                      'ques': serializeParam(
                                                                                        getJsonField(quiz, r'''$.total_questions'''),
                                                                                        ParamType.int,
                                                                                      ),
                                                                                      'title': serializeParam(
                                                                                        getJsonField(quiz, r'''$.name''').toString(),
                                                                                        ParamType.String,
                                                                                      ),
                                                                                      'timerStatus': serializeParam(
                                                                                        getJsonField(quiz, r'''$.timer_status'''),
                                                                                        ParamType.int,
                                                                                      ),
                                                                                    }.withoutNulls,
                                                                                  );
                                                                                },
                                                                                child: Container(
                                                                                  width: 87.0,
                                                                                  height: 87.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Container(
                                                                                        width: 48.0,
                                                                                        height: 48.0,
                                                                                        decoration: BoxDecoration(
                                                                                          color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                                        ),
                                                                                        child: ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(0.0),
                                                                                          child: CachedNetworkImage(
                                                                                            fadeInDuration: Duration(milliseconds: 200),
                                                                                            fadeOutDuration: Duration(milliseconds: 200),
                                                                                            imageUrl: '${FFAppConstants.imageBaseURL}${getJsonField(quiz, r'''$.image''').toString()}',
                                                                                            width: 48.0,
                                                                                            height: 48.0,
                                                                                            fit: BoxFit.cover,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                                                                        child: Text(
                                                                                          getJsonField(quiz, r'''$.name''').toString(),
                                                                                          textAlign: TextAlign.center,
                                                                                          maxLines: 2,
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Roboto',
                                                                                                fontSize: 14.0,
                                                                                                letterSpacing: 0.0,
                                                                                                useGoogleFonts: false,
                                                                                              ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              }).toList(),
                                                            );
                                                          },
                                                        ),

                                                      // E-books Section
                                                      /*Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    16.0,
                                                                    24.0,
                                                                    16.0,
                                                                    0.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize.max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  'E-books',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Roboto',
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
                                                                            1.5,
                                                                      ),
                                                                ),
                                                                InkWell(
                                                                  splashColor: Colors
                                                                      .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap: () async {
                                                                    // TODO: Add view all e-books navigation
                                                                  },
                                                                  child: Text(
                                                                    'View All',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          color: FlutterFlowTheme.of(
                                                                                  context)
                                                                              .primary,
                                                                          fontSize:
                                                                              14.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          useGoogleFonts:
                                                                              false,
                                                                          lineHeight:
                                                                              1.5,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 200.0,
                                                              decoration:
                                                                  BoxDecoration(),
                                                              child:
                                                                  FutureBuilder<
                                                                      ApiCallResponse>(
                                                                future: GetAllEbooksCall()
                                                                    .call(
                                                                        token: FFAppState()
                                                                            .loginToken),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  // Customize what your widget looks like when it's loading.
                                                                  if (!snapshot
                                                                      .hasData) {
                                                                    return Center(
                                                                      child:
                                                                          SizedBox(
                                                                        width: 50.0,
                                                                        height:
                                                                            50.0,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation<Color>(
                                                                            FlutterFlowTheme.of(context)
                                                                                .primary,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                  final ebooksResponse =
                                                                      snapshot
                                                                          .data!;
                                                                  final ebooks =
                                                                      GetAllEbooksCall()
                                                                              .ebooksList(
                                                                                  ebooksResponse.jsonBody)
                                                                              ?.toList() ??
                                                                          [];

                                                                  if (ebooks
                                                                      .isEmpty) {
                                                                    return Center(
                                                                      child: Text(
                                                                        'No e-books available',
                                                                        style: FlutterFlowTheme.of(
                                                                                context)
                                                                            .bodyMedium,
                                                                      ),
                                                                    );
                                                                  }

                                                                  return ListView
                                                                      .separated(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16.0,
                                                                            0,
                                                                            16.0,
                                                                            0),
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    itemCount: ebooks
                                                                        .length,
                                                                    separatorBuilder: (_,
                                                                            __) =>
                                                                        SizedBox(
                                                                            width:
                                                                                16.0),
                                                                    itemBuilder:
                                                                        (context,
                                                                            ebookIndex) {
                                                                      final ebook =
                                                                          ebooks[
                                                                              ebookIndex];
                                                                      return InkWell(
                                                                        splashColor:
                                                                            Colors.transparent,
                                                                        focusColor:
                                                                            Colors.transparent,
                                                                        hoverColor:
                                                                            Colors.transparent,
                                                                        highlightColor:
                                                                            Colors.transparent,
                                                                        onTap:
                                                                            () async {
                                                                          // TODO: Add e-book detail navigation
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                               140.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: FlutterFlowTheme.of(context)
                                                                                .secondaryBackground,
                                                                            borderRadius:
                                                                                BorderRadius.circular(12.0),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              ClipRRect(
                                                                                borderRadius:
                                                                                    BorderRadius.circular(12.0),
                                                                                child:
                                                                                    CachedNetworkImage(
                                                                                  fadeInDuration: Duration(milliseconds: 200),
                                                                                  fadeOutDuration: Duration(milliseconds: 200),
                                                                                  imageUrl: '${FFAppConstants.imageBaseURL}${getJsonField(
                                                                                    ebook,
                                                                                    r'''$.image''',
                                                                                  ).toString()}',
                                                                                  width: 140.0,
                                                                                  height: 140.0,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(
                                                                                    8.0,
                                                                                    8.0,
                                                                                    8.0,
                                                                                    0.0),
                                                                                child:
                                                                                    Text(
                                                                                  getJsonField(
                                                                                    ebook,
                                                                                    r'''$.title''',
                                                                                  ).toString(),
                                                                                  maxLines:
                                                                                      2,
                                                                                  style: FlutterFlowTheme.of(context)
                                                                                      .bodyMedium
                                                                                      .override(
                                                                                        fontFamily: 'Roboto',
                                                                                        fontSize: 14.0,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        useGoogleFonts: false,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),*/

                                                      if (FFAppState()
                                                              .isLogin ==
                                                          true)
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: Visibility(
                                                            visible: QuizGroup
                                                                    .getpointssettingApiCall
                                                                    .selfMode(
                                                                  selfContainerGetpointssettingApiResponse
                                                                      .jsonBody,
                                                                ) ==
                                                                1,
                                                            child: Padding(
                                                              padding: EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      16.0,
                                                                      0.0,
                                                                      16.0,
                                                                      valueOrDefault<
                                                                          double>(
                                                                        FFAppState().countAd !=
                                                                                2
                                                                            ? 0.0
                                                                            : 16.0,
                                                                        0.0,
                                                                      )),
                                                              child: InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  FFAppState()
                                                                      .selectedQuizType = '';
                                                                  FFAppState()
                                                                      .selectedQuizAmount = '';
                                                                  FFAppState()
                                                                      .selectedQuizDuration = '';
                                                                  safeSetState(
                                                                      () {});

                                                                  context.pushNamed(
                                                                      SelfChellengeWidget
                                                                          .routeName);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 396.0,
                                                                  height: 148.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                    image:
                                                                        DecorationImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image: Image
                                                                          .asset(
                                                                        'assets/images/Rectangle_3463277.png',
                                                                      ).image,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            16.0),
                                                                        child:
                                                                            Text(
                                                                          'Challenge yourself',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Roboto',
                                                                                color: FlutterFlowTheme.of(context).white,
                                                                                fontSize: 20.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.bold,
                                                                                useGoogleFonts: false,
                                                                                lineHeight: 1.5,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                      FFButtonWidget(
                                                                        onPressed:
                                                                            () async {
                                                                          FFAppState().selectedQuizType =
                                                                              '';
                                                                          FFAppState().selectedQuizAmount =
                                                                              '';
                                                                          FFAppState().selectedQuizDuration =
                                                                              '';
                                                                          safeSetState(
                                                                              () {});

                                                                          context
                                                                              .pushNamed(SelfChellengeWidget.routeName);
                                                                        },
                                                                        text:
                                                                            'Play now',
                                                                        options:
                                                                            FFButtonOptions(
                                                                          height:
                                                                              40.0,
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              24.0,
                                                                              0.0,
                                                                              24.0,
                                                                              0.0),
                                                                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          color:
                                                                              Color(0x00FFFFFF),
                                                                          textStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .override(
                                                                                fontFamily: 'Roboto',
                                                                                color: FlutterFlowTheme.of(context).white,
                                                                                fontSize: 18.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                useGoogleFonts: false,
                                                                              ),
                                                                          elevation:
                                                                              0.0,
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).white,
                                                                            width:
                                                                                1.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(12.0),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      Builder(
                                                        builder: (context) {
                                                          if (FFAppState()
                                                                  .isRewardedVideoAd ==
                                                              1) {
                                                            return Visibility(
                                                              visible: FFAppState()
                                                                      .userPoints <
                                                                  10,
                                                              child: Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        20.0,
                                                                        16.0,
                                                                        20.0,
                                                                        24.0),
                                                                child: InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap:
                                                                      () async {
                                                                    await actions
                                                                        .showRewardedVideoAd(
                                                                      FFAppState()
                                                                          .rewardedPoints,
                                                                      () async {
                                                                        FFAppState().isReward =
                                                                            false;
                                                                        FFAppState()
                                                                            .update(() {});
                                                                        _model.apiResultvte = await QuizGroup
                                                                            .addPointsApiCall
                                                                            .call(
                                                                          userId:
                                                                              getJsonField(
                                                                            FFAppState().userDetils,
                                                                            r'''$.id''',
                                                                          ).toString(),
                                                                          points: FFAppState()
                                                                              .rewardedPoints
                                                                              .toDouble(),
                                                                          description:
                                                                              'ad rewarded points',
                                                                          token:
                                                                              FFAppState().loginToken,
                                                                        );

                                                                        if (QuizGroup.addPointsApiCall.success(
                                                                              (_model.apiResultvte?.jsonBody ?? ''),
                                                                            ) ==
                                                                            1) {
                                                                          FFAppState()
                                                                              .clearCoinsCache();
                                                                          FFAppState()
                                                                              .clearCoinsHistoryCache();
                                                                        }
                                                                      },
                                                                      () async {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content:
                                                                                Text(
                                                                              'Ad not Available',
                                                                              style: TextStyle(
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                              ),
                                                                            ),
                                                                            duration:
                                                                                Duration(milliseconds: 4000),
                                                                            backgroundColor:
                                                                                FlutterFlowTheme.of(context).secondary,
                                                                          ),
                                                                        );
                                                                      },
                                                                    );

                                                                    safeSetState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        64.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12.0),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          8.0,
                                                                          0.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children:
                                                                            [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Vector.png',
                                                                              width: 20.0,
                                                                              height: 20.0,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                          RichText(
                                                                            textScaler:
                                                                                MediaQuery.of(context).textScaler,
                                                                            text:
                                                                                TextSpan(
                                                                              children: [
                                                                                TextSpan(
                                                                                  text: 'Watch a video to earn ',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Roboto',
                                                                                        color: FlutterFlowTheme.of(context).info,
                                                                                        fontSize: 18.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        useGoogleFonts: false,
                                                                                        lineHeight: 1.5,
                                                                                      ),
                                                                                ),
                                                                                TextSpan(
                                                                                  text: FFAppState().rewardedPoints.toString(),
                                                                                  style: TextStyle(),
                                                                                ),
                                                                                TextSpan(
                                                                                  text: ' points',
                                                                                  style: TextStyle(),
                                                                                )
                                                                              ],
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Roboto',
                                                                                    color: FlutterFlowTheme.of(context).info,
                                                                                    fontSize: 18.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    useGoogleFonts: false,
                                                                                    lineHeight: 1.5,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ].divide(SizedBox(width: 8.0)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            return Container(
                                                              decoration:
                                                                  BoxDecoration(),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ].addToStart(
                                                        SizedBox(height: 16.0)),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        },
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
      ),
    );
  }
}
