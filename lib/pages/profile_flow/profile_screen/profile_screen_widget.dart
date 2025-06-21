import '';
import '/componants/app_bar/app_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'profile_screen_model.dart';
export 'profile_screen_model.dart';

class ProfileScreenWidget extends StatefulWidget {
  const ProfileScreenWidget({super.key});

  static String routeName = 'profile_screen';
  static String routePath = '/profileScreen';

  @override
  State<ProfileScreenWidget> createState() => _ProfileScreenWidgetState();
}

class _ProfileScreenWidgetState extends State<ProfileScreenWidget> {
  late ProfileScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileScreenModel());
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
                title: 'Profile',
                backIcon: true,
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (FFAppState().connected == true) {
                    return ListView(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        24.0,
                        0,
                        24.0,
                      ),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(),
                            child: Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Builder(
                                builder: (context) {
                                  if (FFAppState().isLogin == false) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: Image.asset(
                                        'assets/images/place_holderProfile.png',
                                        width: 100.0,
                                        height: 100.0,
                                        fit: BoxFit.contain,
                                      ),
                                    );
                                  } else {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: CachedNetworkImage(
                                        fadeInDuration:
                                            Duration(milliseconds: 500),
                                        fadeOutDuration:
                                            Duration(milliseconds: 500),
                                        imageUrl:
                                            '${FFAppConstants.imageBaseURL}${getJsonField(
                                          FFAppState().userDetils,
                                          r'''$.image''',
                                        ).toString()}',
                                        width: 100.0,
                                        height: 100.0,
                                        fit: BoxFit.cover,
                                        errorWidget:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          'assets/images/error_image.png',
                                          width: 100.0,
                                          height: 100.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        if (FFAppState().isLogin == true)
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 14.0, 16.0, 16.0),
                              child: RichText(
                                textScaler: MediaQuery.of(context).textScaler,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: getJsonField(
                                        FFAppState().userDetils,
                                        r'''$.firstname''',
                                      ).toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Roboto',
                                            fontSize: 20.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            useGoogleFonts: false,
                                            lineHeight: 1.5,
                                          ),
                                    ),
                                    TextSpan(
                                      text: ' ',
                                      style: TextStyle(),
                                    ),
                                    TextSpan(
                                      text: getJsonField(
                                        FFAppState().userDetils,
                                        r'''$.lastname''',
                                      ).toString(),
                                      style: TextStyle(),
                                    )
                                  ],
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Roboto',
                                        fontSize: 20.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        useGoogleFonts: false,
                                        lineHeight: 1.5,
                                      ),
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        Container(
                          height: 24.0,
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                          ),
                        ),
                        if (FFAppState().isLogin == true)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 16.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(
                                  MyProfileWidget.routeName,
                                  queryParameters: {
                                    'fname': serializeParam(
                                      FFAppState().userFirstName,
                                      ParamType.String,
                                    ),
                                    'lname': serializeParam(
                                      FFAppState().userLastName,
                                      ParamType.String,
                                    ),
                                    'profilePicture': serializeParam(
                                      '${FFAppConstants.imageBaseURL}${getJsonField(
                                        FFAppState().userDetils,
                                        r'''$.image''',
                                      ).toString()}',
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                              child: Container(
                                width: 100.0,
                                height: 64.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 8.0, 0.0, 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 48.0,
                                        height: 48.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .lightGrey,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: SvgPicture.asset(
                                              'assets/images/profile.svg',
                                              width: 24.0,
                                              height: 24.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'My profile',
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
                                      ),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: SvgPicture.asset(
                                          'assets/images/arrow_right.svg',
                                          width: 20.0,
                                          height: 20.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ]
                                        .divide(SizedBox(width: 16.0))
                                        .addToStart(SizedBox(width: 8.0))
                                        .addToEnd(SizedBox(width: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (FFAppState().isLogin == true)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 16.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(
                                    NotificationScreenWidget.routeName);
                              },
                              child: Container(
                                width: 100.0,
                                height: 64.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 8.0, 0.0, 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 48.0,
                                        height: 48.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .lightGrey,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: SvgPicture.asset(
                                              'assets/images/notifications_FILL0_wght400_GRAD0_opsz24.svg',
                                              width: 24.0,
                                              height: 24.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Notifications',
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
                                      ),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: SvgPicture.asset(
                                          'assets/images/arrow_right.svg',
                                          width: 20.0,
                                          height: 20.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ]
                                        .divide(SizedBox(width: 16.0))
                                        .addToStart(SizedBox(width: 8.0))
                                        .addToEnd(SizedBox(width: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(SettingPageWidget.routeName);
                            },
                            child: Container(
                              width: 100.0,
                              height: 64.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: 48.0,
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .lightGrey,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: SvgPicture.asset(
                                            'assets/images/setting.svg',
                                            width: 24.0,
                                            height: 24.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Settings',
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
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: SvgPicture.asset(
                                        'assets/images/arrow_right.svg',
                                        width: 20.0,
                                        height: 20.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ]
                                      .divide(SizedBox(width: 16.0))
                                      .addToStart(SizedBox(width: 8.0))
                                      .addToEnd(SizedBox(width: 8.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (FFAppState().isLogin == false)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                context.goNamed(LoginScreenWidget.routeName);
                              },
                              text: 'Login/Register',
                              options: FFButtonOptions(
                                width: 189.0,
                                height: 56.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primary,
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
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
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
          ],
        ),
      ),
    );
  }
}
