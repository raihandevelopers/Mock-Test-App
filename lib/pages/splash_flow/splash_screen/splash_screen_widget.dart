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
      try {
        print('Starting splash screen initialization...');
        
        // Add a timeout for the entire initialization process
        await Future.delayed(const Duration(milliseconds: 3000));
        
        print('Getting device ID...');
        try {
          await actions.getDeviceId();
          print('Device ID obtained successfully');
        } catch (e) {
          print('Error getting device ID: $e');
        }
        
        print('Getting FCM token...');
        try {
          await actions.getFCM();
          print('FCM token obtained successfully');
        } catch (e) {
          print('Error getting FCM token: $e');
        }
        
        print('Getting ad counter...');
        try {
          await actions.counterAdAction();
          print('Ad counter obtained successfully');
        } catch (e) {
          print('Error getting ad counter: $e');
        }

        print('Checking app initialization status...');
        print('isInite: ${FFAppState().isInite}');
        print('isLogin: ${FFAppState().isLogin}');
        
        if (FFAppState().isInite == true) {
          print('App already initialized, checking login status...');
          if (FFAppState().isLogin == true) {
            print('User is logged in, proceeding to home screen...');
            // Skip ad validation and set default values
            FFAppState().isBannerAd = 0;
            FFAppState().isInterstialAd = 0;
            FFAppState().isRewardedVideoAd = 0;
            FFAppState().rewardedPoints = 0;
            FFAppState().update(() {});
            print('Navigating to home screen...');
            context.goNamed(HomeScreenWidget.routeName);
          } else {
            print('User is not logged in, proceeding to login screen...');
            context.goNamed(LoginScreenWidget.routeName);
          }
        } else {
          print('App not initialized, getting intro data...');
          try {
            print('Calling intro API...');
            print('API URL: ${QuizGroup.getBaseUrl()}getintro');
            
            _model.introRes = await QuizGroup.getIntroAPICall.call().timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                print('Intro API call timed out after 10 seconds');
                return ApiCallResponse(
                  '{"success":0,"message":"Timeout getting intro data"}',
                  {'content-type': 'application/json'},
                  -1,
                );
              },
            );
            
            print('Intro API Response Status: ${_model.introRes?.statusCode}');
            print('Intro API Response Headers: ${_model.introRes?.headers}');
            print('Intro API Response Body: ${_model.introRes?.jsonBody}');
            
            if (_model.introRes == null) {
              print('Intro API Response is null, proceeding to login...');
              FFAppState().isInite = true;
              FFAppState().update(() {});
              context.goNamed(LoginScreenWidget.routeName);
              return;
            }

            if (_model.introRes?.statusCode == -1) {
              print('Intro API call failed with status code -1, proceeding to login...');
              FFAppState().isInite = true;
              FFAppState().update(() {});
              context.goNamed(LoginScreenWidget.routeName);
              return;
            }

            final success = QuizGroup.getIntroAPICall.success(
              (_model.introRes?.jsonBody ?? ''),
            );
            print('Intro API success value: $success');

            if (success == 1) {
              print('Intro API successful, proceeding to onboarding...');
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
              print('Intro API success is not 1, checking login status...');
              if (FFAppState().isLogin == true) {
                print('User is logged in, getting ad settings...');
                _model.getAds = await QuizGroup.getadssettingsApiCall.call(
                  token: FFAppState().loginToken,
                ).timeout(
                  const Duration(seconds: 10),
                  onTimeout: () {
                    print('Ad settings API call timed out after 10 seconds');
                    return ApiCallResponse(
                      '{"success":0,"message":"Timeout getting ad settings"}',
                      {'content-type': 'application/json'},
                      -1,
                    );
                  },
                );

                print('Ad Settings Response: ${_model.getAds?.jsonBody}');

                if (QuizGroup.getadssettingsApiCall.success(
                      (_model.getAds?.jsonBody ?? ''),
                    ) == 1) {
                  print('Ad settings successful, updating app state...');
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

                print('Proceeding to home screen...');
                context.goNamed(HomeScreenWidget.routeName);
              } else {
                print('User is not logged in, proceeding to login screen...');
                FFAppState().isInite = true;
                FFAppState().update(() {});

                context.goNamed(LoginScreenWidget.routeName);
              }
            }
          } catch (e, stackTrace) {
            print('Error in intro API call: $e');
            print('Stack trace: $stackTrace');
            FFAppState().isInite = true;
            FFAppState().update(() {});
            context.goNamed(LoginScreenWidget.routeName);
          }
        }
      } catch (e) {
        print('Error in splash screen initialization: $e');
        // If anything fails, proceed to login screen
        FFAppState().isInite = true;
        FFAppState().update(() {});
        context.goNamed(LoginScreenWidget.routeName);
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
