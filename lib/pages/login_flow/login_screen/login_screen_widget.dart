import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'login_screen_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
export 'login_screen_model.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({super.key});

  static String routeName = 'login_screen';
  static String routePath = '/loginScreen';

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget>
    with TickerProviderStateMixin {
  late LoginScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginScreenModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    animationsMap.addAll({
      'textOnPageLoadAnimation': AnimationInfo(
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

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    print('DEBUG: Starting Google Sign-In');
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print('DEBUG: Google user: $googleUser');
      if (googleUser == null) {
        print('DEBUG: User cancelled Google Sign-In');
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print('DEBUG: Google Auth: $googleAuth');
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('DEBUG: Firebase credential created, signing in...');
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      print('DEBUG: Firebase sign-in successful: \\${userCredential.user}');
      // Send token to backend
      final idToken = await userCredential.user?.getIdToken();
      final response = await http.post(
        Uri.parse('https://quiz.deltospark.com/api/google-signin'), // <-- Change to your backend URL if needed
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': idToken,
          'deviceId': 'flutter-app', // Replace with real deviceId if available
        }),
      );
      print('Backend response: \\${response.body}');
      // Extract and save token for authenticated API calls
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == 1 && responseData['data'] != null && responseData['data']['token'] != null) {
        FFAppState().loginToken = responseData['data']['token'];
        FFAppState().isLogin = true;
        // Save user details for later use (including userId)
        if (responseData['data']['userDetails'] != null) {
          FFAppState().userDetils = responseData['data']['userDetails'];
          print('DEBUG: Saved userDetils: \\${FFAppState().userDetils}');
        }
        print('DEBUG: Saved loginToken: \\${FFAppState().loginToken}');
      }
    
      // Navigate to home screen after successful Google sign-in
      context.goNamed(HomeScreenWidget.routeName);
      return userCredential;
    } catch (e, stack) {
      print('ERROR during Google Sign-In: $e');
      print('STACKTRACE: $stack');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $e')),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFB3C6FF),
                  Color(0xFFEDEAFF), // soft purple
                   // soft blue
                  Color(0xFFF8F8FF), // near white
                ],
              ),
            ),
            child: SafeArea(
              top: true,
              child: Builder(
                builder: (context) {
                  if (FFAppState().connected == true) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(height: 50),
                        Expanded(
                          child: Form(
                            key: _model.formKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 16.0, 16.0, 16.0),
                              child: ListView(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: [
                                  SizedBox(height: 32),
                                  Text(
                                    'Sign In',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Roboto',
                                          fontSize: 28.0,
                                          fontWeight: FontWeight.bold,
                                          useGoogleFonts: false,
                                        ),
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Welcome back you\'ve been missed',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Roboto',
                                          fontSize: 16.0,
                                          color: Colors.black54,
                                          useGoogleFonts: false,
                                        ),
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(height: 24),
                                  TextFormField(
                                    controller: _model.textController1,
                                    focusNode: _model.textFieldFocusNode1,
                                    decoration: InputDecoration(
                                      labelText: 'Email ID',
                                      hintText: 'Enter Email ID',
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: _model.textController1Validator
                                        .asValidator(context),
                                  ),
                                  SizedBox(height: 16),
                                  TextFormField(
                                    controller: _model.textController2,
                                    focusNode: _model.textFieldFocusNode2,
                                    obscureText: !_model.passwordVisibility,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      hintText: 'Enter Password',
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                      suffixIcon: IconButton(
                                        icon: Icon(_model.passwordVisibility
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () => setState(
                                            () => _model.passwordVisibility =
                                                !_model.passwordVisibility),
                                      ),
                                    ),
                                    validator: _model.textController2Validator
                                        .asValidator(context),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _rememberMe,
                                        onChanged: (val) => setState(
                                            () => _rememberMe = val ?? false),
                                        activeColor: Colors.deepPurple,
                                      ),
                                      Text('Remember Me'),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          context.pushNamed(
                                              FogotpasswordScreenWidget
                                                  .routeName);
                                          safeSetState(() {
                                            _model.textController1?.clear();
                                            _model.textController2?.clear();
                                          });
                                        },
                                        child: Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  FFButtonWidget(
                                    onPressed: () async {
                                      if (_model.formKey.currentState == null ||
                                          !_model.formKey.currentState!
                                              .validate()) {
                                        return;
                                      }
                                      _model.loginRes =
                                          await QuizGroup.usersigninApiCall.call(
                                        email: _model.textController1.text,
                                        password: _model.textController2.text,
                                        deviceId: FFAppState().deviceId,
                                        registrationToken: FFAppState().tokenFcm,
                                      );

                                      if (QuizGroup.usersigninApiCall.success(
                                            (_model.loginRes?.jsonBody ?? ''),
                                          ) ==
                                          2) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              QuizGroup.usersigninApiCall
                                                  .message(
                                                (_model.loginRes?.jsonBody ??
                                                    ''),
                                              )!,
                                              style: TextStyle(
                                                color: FlutterFlowTheme.of(
                                                        context)
                                                    .primaryText,
                                              ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 2000),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondary,
                                          ),
                                        );
                                      } else {
                                        if (QuizGroup.usersigninApiCall.success(
                                              (_model.loginRes?.jsonBody ?? ''),
                                            ) ==
                                            1) {
                                          _model.userRes =
                                              await QuizGroup.getuserApiCall.call(
                                            userId: getJsonField(
                                              QuizGroup.usersigninApiCall
                                                  .userDetails(
                                                (_model.loginRes?.jsonBody ?? ''),
                                              ),
                                              r'''$.id''',
                                            ).toString(),
                                            token:
                                                QuizGroup.usersigninApiCall.token(
                                              (_model.loginRes?.jsonBody ?? ''),
                                            ),
                                          );

                                          if (QuizGroup.getuserApiCall.success(
                                                (_model.userRes?.jsonBody ??
                                                    ''),
                                              ) ==
                                              2) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  QuizGroup.getuserApiCall
                                                      .message(
                                                    (_model.userRes?.jsonBody ??
                                                        ''),
                                                  )!,
                                                  style: TextStyle(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                  ),
                                                ),
                                                duration:
                                                    Duration(milliseconds: 2000),
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                              ),
                                            );
                                          } else {
                                            if (QuizGroup.getuserApiCall.success(
                                                  (_model.userRes?.jsonBody ??
                                                      ''),
                                                ) ==
                                                1) {
                                              FFAppState().isLogin = true;
                                              FFAppState().userId =
                                                  QuizGroup.getuserApiCall.userId(
                                                (_model.userRes?.jsonBody ?? ''),
                                              )!;
                                              FFAppState().userDetils = QuizGroup
                                                  .getuserApiCall
                                                  .userCred(
                                                (_model.userRes?.jsonBody ?? ''),
                                              );
                                              FFAppState().loginToken = QuizGroup
                                                  .usersigninApiCall
                                                  .token(
                                                (_model.loginRes?.jsonBody ?? ''),
                                              )!;
                                              FFAppState().currentPassword =
                                                  _model.textController2.text;
                                              FFAppState().profilePicture =
                                                  getJsonField(
                                                QuizGroup.getuserApiCall.userCred(
                                                  (_model.userRes?.jsonBody ??
                                                      ''),
                                                ),
                                                r'''$.image''',
                                              ).toString();
                                              FFAppState().update(() {});

                                              context.goNamed(
                                                  HomeScreenWidget.routeName);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    QuizGroup.getuserApiCall
                                                        .message(
                                                      (_model.userRes?.jsonBody ??
                                                          ''),
                                                    )!,
                                                    style: TextStyle(
                                                      color: FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText,
                                                    ),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 2000),
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(context)
                                                          .secondary,
                                                ),
                                              );
                                            }
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                QuizGroup.usersigninApiCall
                                                    .message(
                                                  (_model.loginRes?.jsonBody ??
                                                      ''),
                                                )!,
                                                style: TextStyle(
                                                  color:
                                                      FlutterFlowTheme.of(context)
                                                          .primaryText,
                                                ),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 2000),
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                            ),
                                          );
                                        }
                                      }

                                      safeSetState(() {});
                                    },
                                    text: 'Sign In',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 56.0,
                                      color: Colors.black,
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),

                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(child: Divider()),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text('Or with'),
                                      ),
                                      Expanded(child: Divider()),
                                    ],
                                  ),
                                  SizedBox(height: 1),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      OutlinedButton(
                                      onPressed: () async {
     print('Google Sign-In button pressed');
     await signInWithGoogle(context);
   },
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          side: BorderSide.none,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          backgroundColor: Colors.transparent,
                                        ),
                                        child: Image.asset(
                                          'assets/images/googlesign.png',
                                          width: 150,
                                          height: 150,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Don't have an account? "),
                                      GestureDetector(
                                        onTap: () async {
                                          context.pushNamed(
                                              SignupScreenWidget.routeName);
                                          safeSetState(() {
                                            _model.textController1?.clear();
                                            _model.textController2?.clear();
                                          });
                                        },
                                        child: Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                ],
                              ),
                            ),
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
        ),
      ),
    );
  }
}
