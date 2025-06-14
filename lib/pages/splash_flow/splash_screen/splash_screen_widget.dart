import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'splash_screen_model.dart';
export 'splash_screen_model.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({super.key});

  static String routeName = 'splash_screen';
  static String routePath = '/splashScreen';

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget>
    with TickerProviderStateMixin {
  late SplashScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SplashScreenModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 3000));
      await actions.getDeviceId();
      await actions.getFCM();
      await actions.counterAdAction();
      if (FFAppState().isInite == true) {
        if (FFAppState().isLogin == true) {
          // Skip ad validation and set default values
          FFAppState().isBannerAd = 0;
          FFAppState().isInterstialAd = 0;
          FFAppState().isRewardedVideoAd = 0;
          FFAppState().rewardedPoints = 0;
          FFAppState().update(() {});
          context.goNamed(HomeScreenWidget.routeName);
        } else {
          context.goNamed(LoginScreenWidget.routeName);
        }
      } else {
        try {
          _model.introRes = await QuizGroup.getIntroAPICall.call();
          
          print('Intro API Response: ${_model.introRes?.jsonBody}');
          
          if (_model.introRes == null) {
            print('Intro API Response is null');
            // Handle null response by going to login
            FFAppState().isInite = true;
            FFAppState().update(() {});
            context.goNamed(LoginScreenWidget.routeName);
            return;
          }

          if (QuizGroup.getIntroAPICall.success(
                (_model.introRes?.jsonBody ?? ''),
              ) ==
              1) {
            context.goNamed(
              OnBordingScreenWidget.routeName,
              queryParameters: {
                'introsList': serializeParam(
                  QuizGroup.getIntroAPICall.introDetailsList(
                    (_model.introRes?.jsonBody ?? ''),
                  ),
                  ParamType.JSON,
                  isList: true,
                ),
              }.withoutNulls,
            );
          } else {
            print('Intro API success is not 1');
            if (FFAppState().isLogin == true) {
              _model.getAds = await QuizGroup.getadssettingsApiCall.call(
                token: FFAppState().loginToken,
              );

              print('Ad Settings Response: ${_model.getAds?.jsonBody}');

              if (QuizGroup.getadssettingsApiCall.success(
                    (_model.getAds?.jsonBody ?? ''),
                  ) ==
                  1) {
                FFAppState().isBannerAd = (QuizGroup.getadssettingsApiCall.banner(
                  (_model.getAds?.jsonBody ?? ''),
                ) as int?) ?? 0;
                FFAppState().isInterstialAd = (QuizGroup.getadssettingsApiCall.interstial(
                  (_model.getAds?.jsonBody ?? ''),
                ) as int?) ?? 0;
                FFAppState().isRewardedVideoAd = (QuizGroup.getadssettingsApiCall.rewarded(
                  (_model.getAds?.jsonBody ?? ''),
                ) as int?) ?? 0;
                FFAppState().rewardedPoints = (QuizGroup.getadssettingsApiCall.points(
                  (_model.getAds?.jsonBody ?? ''),
                ) as int?) ?? 0;
                FFAppState().update(() {});
              }

              context.goNamed(HomeScreenWidget.routeName);
            } else {
              FFAppState().isInite = true;
              FFAppState().update(() {});

              context.goNamed(LoginScreenWidget.routeName);
            }
          }
        } catch (e) {
          print('Error in intro API call: $e');
          FFAppState().isInite = true;
          FFAppState().update(() {});
          context.goNamed(LoginScreenWidget.routeName);
        }
      }
    });

    animationsMap.addAll({
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeIn,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondary,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    'assets/images/mocktest_logo.png',
                    width: 98.0,
                    height: 98.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 13.0, 0.0, 0.0),
                  child: Text(
                    'Mock Test',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Roboto',
                          color: Color(0xFF201F1F),
                          fontSize: 28.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: false,
                          lineHeight: 1.5,
                        ),
                  ),
                ),
              ],
            ).animateOnPageLoad(animationsMap['columnOnPageLoadAnimation']!),
          ),
        ),
      ),
    );
  }
}
