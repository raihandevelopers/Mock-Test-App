import '';
import '/backend/api_requests/api_calls.dart';
import '/componants/app_bar/app_bar_widget.dart';
import '/componants/payment_success_componant/payment_success_componant_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'payment_screen_model.dart';
export 'payment_screen_model.dart';

class PaymentScreenWidget extends StatefulWidget {
  const PaymentScreenWidget({
    super.key,
    this.paymentPrice,
    this.points,
    this.planId,
  });

  final int? paymentPrice;
  final int? points;
  final String? planId;

  static String routeName = 'payment_screen';
  static String routePath = '/paymentScreen';

  @override
  State<PaymentScreenWidget> createState() => _PaymentScreenWidgetState();
}

class _PaymentScreenWidgetState extends State<PaymentScreenWidget> {
  late PaymentScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentScreenModel());
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
                      title: 'Payment method',
                      backIcon: false,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(
                          0,
                          16.0,
                          0,
                          16.0,
                        ),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 20.0),
                            child: Text(
                              'Select payment method',
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
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 16.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                _model.selectPayment = 0;
                                safeSetState(() {});
                              },
                              child: Container(
                                width: double.infinity,
                                height: 66.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 16.0, 16.0, 16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/stripe_ic.png',
                                          width: 34.0,
                                          height: 34.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Stripe',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 17.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  useGoogleFonts: false,
                                                  lineHeight: 1.0,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Builder(
                                        builder: (context) {
                                          if (_model.selectPayment == 0) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                              child: SvgPicture.asset(
                                                'assets/images/Component_25.svg',
                                                width: 24.0,
                                                height: 24.0,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          } else {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                              child: SvgPicture.asset(
                                                'assets/images/Component_25-1.svg',
                                                width: 24.0,
                                                height: 24.0,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 16.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                _model.selectPayment = 1;
                                safeSetState(() {});
                              },
                              child: Container(
                                width: double.infinity,
                                height: 66.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 16.0, 16.0, 16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: SvgPicture.asset(
                                          'assets/images/razorpay_logo_(1).svg',
                                          width: 34.0,
                                          height: 34.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'RazorPay',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 17.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  useGoogleFonts: false,
                                                  lineHeight: 1.0,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Builder(
                                        builder: (context) {
                                          if (_model.selectPayment == 1) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                              child: SvgPicture.asset(
                                                'assets/images/Component_25.svg',
                                                width: 24.0,
                                                height: 24.0,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          } else {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                              child: SvgPicture.asset(
                                                'assets/images/Component_25-1.svg',
                                                width: 24.0,
                                                height: 24.0,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 24.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${widget.paymentPrice?.toString()}.00',
                          maxLines: 1,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Roboto',
                                    fontSize: 24.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts: false,
                                    lineHeight: 1.5,
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 10.0),
                          child: Builder(
                            builder: (context) {
                              if (_model.selectPayment != 2) {
                                return Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Builder(
                                    builder: (context) => FFButtonWidget(
                                      onPressed: () async {
                                        if (_model.selectPayment == 1) {
                                          await actions.razorpayCustom(
                                            context,
                                            FFAppConstants.razorpayKeyID,
                                            (widget.paymentPrice!).toString(),
                                            '${getJsonField(
                                              FFAppState().userDetils,
                                              r'''$.firstname''',
                                            ).toString()} ${getJsonField(
                                              FFAppState().userDetils,
                                              r'''$.lastname''',
                                            ).toString()}',
                                            'demo',
                                            getJsonField(
                                              FFAppState().userDetils,
                                              r'''$.phone''',
                                            ).toString(),
                                            getJsonField(
                                              FFAppState().userDetils,
                                              r'''$.email''',
                                            ).toString(),
                                            () async {
                                              _model.planResCopy =
                                                  await QuizGroup.buyPlanCall
                                                      .call(
                                                userId: getJsonField(
                                                  FFAppState().userDetils,
                                                  r'''$.id''',
                                                ).toString(),
                                                planId: widget.planId,
                                                points: widget.points,
                                                price: widget.paymentPrice,
                                                token: FFAppState().loginToken,
                                              );

                                              if (QuizGroup.buyPlanCall.success(
                                                    (_model.planResCopy
                                                            ?.jsonBody ??
                                                        ''),
                                                  ) ==
                                                  1) {
                                                _model.apiResultxs =
                                                    await QuizGroup
                                                        .addPointsApiCall
                                                        .call(
                                                  userId: getJsonField(
                                                    FFAppState().userDetils,
                                                    r'''$.id''',
                                                  ).toString(),
                                                  points: widget.points
                                                      ?.toDouble(),
                                                  description:
                                                      'Purchase ${widget.points?.toString()} points',
                                                  token:
                                                      FFAppState().loginToken,
                                                );

                                                if (QuizGroup.addPointsApiCall
                                                        .success(
                                                      (_model.apiResultxs
                                                              ?.jsonBody ??
                                                          ''),
                                                    ) ==
                                                    1) {
                                                  await showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (dialogContext) {
                                                      return Dialog(
                                                        elevation: 0,
                                                        insetPadding:
                                                            EdgeInsets.zero,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        alignment:
                                                            AlignmentDirectional(
                                                                    0.0, 0.0)
                                                                .resolve(
                                                                    Directionality.of(
                                                                        context)),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    dialogContext)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Container(
                                                            height: 450.0,
                                                            child:
                                                                PaymentSuccessComponantWidget(
                                                              price: widget
                                                                  .points,
                                                              onTapHome:
                                                                  () async {
                                                                _model.planHis =
                                                                    await QuizGroup
                                                                        .planHistoryAPICall
                                                                        .call(
                                                                  userId:
                                                                      getJsonField(
                                                                    FFAppState()
                                                                        .userDetils,
                                                                    r'''$.id''',
                                                                  ).toString(),
                                                                  token: FFAppState()
                                                                      .loginToken,
                                                                );

                                                                if (QuizGroup
                                                                        .planHistoryAPICall
                                                                        .success(
                                                                      (_model.planHis
                                                                              ?.jsonBody ??
                                                                          ''),
                                                                    ) ==
                                                                    1) {
                                                                  FFAppState()
                                                                          .isPremium =
                                                                      true;
                                                                  safeSetState(
                                                                      () {});
                                                                  FFAppState()
                                                                      .clearCoinsCache();
                                                                  FFAppState()
                                                                      .clearCoinsHistoryCache();
                                                                  Navigator.pop(
                                                                      context);

                                                                  context.goNamed(
                                                                      HomeScreenWidget
                                                                          .routeName);
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      QuizGroup.buyPlanCall
                                                          .message(
                                                        (_model.planResCopy
                                                                ?.jsonBody ??
                                                            ''),
                                                      )!,
                                                      style: TextStyle(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                    backgroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondary,
                                                  ),
                                                );
                                              }
                                            },
                                            () async {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Payment failed',
                                                    style: TextStyle(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .info,
                                                      fontSize: 15.0,
                                                    ),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .error,
                                                ),
                                              );
                                            },
                                            'USD',
                                          );
                                        } else {
                                          /*if (_model.selectPayment == 0) {
                                            await actions.initStripeAction(
                                              FFAppConstants
                                                  .stripePublishableKey,
                                            );
                                            *//*await actions.customStripe(
                                              context,
                                              (widget.paymentPrice!)
                                                  .toString(),
                                              'USD',
                                              'US',
                                              () async {
                                                _model.planResCopy2 =
                                                    await QuizGroup.buyPlanCall
                                                        .call(
                                                  userId: getJsonField(
                                                    FFAppState().userDetils,
                                                    r'''$.id''',
                                                  ).toString(),
                                                  planId: widget.planId,
                                                  points: widget.points,
                                                  price: widget.paymentPrice,
                                                  token:
                                                      FFAppState().loginToken,
                                                );

                                                if (QuizGroup.buyPlanCall
                                                        .success(
                                                      (_model.planResCopy2
                                                              ?.jsonBody ??
                                                          ''),
                                                    ) ==
                                                    1) {
                                                  _model.apiResultx =
                                                      await QuizGroup
                                                          .addPointsApiCall
                                                          .call(
                                                    userId: getJsonField(
                                                      FFAppState().userDetils,
                                                      r'''$.id''',
                                                    ).toString(),
                                                    points: widget.points
                                                        ?.toDouble(),
                                                    description:
                                                        'Purchase ${widget.points?.toString()} points',
                                                    token:
                                                        FFAppState().loginToken,
                                                  );

                                                  if (QuizGroup.addPointsApiCall
                                                          .success(
                                                        (_model.apiResultx
                                                                ?.jsonBody ??
                                                            ''),
                                                      ) ==
                                                      1) {
                                                    await showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (dialogContext) {
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
                                                            child: Container(
                                                              height: 450.0,
                                                              child:
                                                                  PaymentSuccessComponantWidget(
                                                                price: widget
                                                                    .paymentPrice,
                                                                onTapHome:
                                                                    () async {
                                                                  _model.his =
                                                                      await QuizGroup
                                                                          .planHistoryAPICall
                                                                          .call(
                                                                    userId:
                                                                        getJsonField(
                                                                      FFAppState()
                                                                          .userDetils,
                                                                      r'''$.id''',
                                                                    ).toString(),
                                                                    token: FFAppState()
                                                                        .loginToken,
                                                                  );

                                                                  if (QuizGroup
                                                                          .planHistoryAPICall
                                                                          .success(
                                                                        (_model.his?.jsonBody ??
                                                                            ''),
                                                                      ) ==
                                                                      1) {
                                                                    FFAppState()
                                                                            .isPremium =
                                                                        true;
                                                                    safeSetState(
                                                                        () {});
                                                                    Navigator.pop(
                                                                        context);
                                                                    FFAppState()
                                                                        .clearCoinsCache();
                                                                    FFAppState()
                                                                        .clearCoinsHistoryCache();

                                                                    context.goNamed(
                                                                        HomeScreenWidget
                                                                            .routeName);
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            Text(
                                                                          QuizGroup
                                                                              .planHistoryAPICall
                                                                              .message(
                                                                            (_model.his?.jsonBody ??
                                                                                ''),
                                                                          )!,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).info,
                                                                            fontSize:
                                                                                15.0,
                                                                          ),
                                                                        ),
                                                                        duration:
                                                                            Duration(milliseconds: 4000),
                                                                        backgroundColor:
                                                                            FlutterFlowTheme.of(context).error,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        QuizGroup.buyPlanCall
                                                            .message(
                                                          (_model.planResCopy2
                                                                  ?.jsonBody ??
                                                              ''),
                                                        )!,
                                                        style: TextStyle(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                  );
                                                }
                                              },
                                              () async {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Payment failed',
                                                      style: TextStyle(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                    backgroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .error,
                                                  ),
                                                );
                                              },
                                              FFAppConstants.stripeSecretKey,
                                            );*//*
                                          }*/
                                        }

                                        safeSetState(() {});
                                      },
                                      text: 'Pay now',
                                      options: FFButtonOptions(
                                        width: 190.0,
                                        height: 56.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Roboto',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .black,
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts: false,
                                              lineHeight: 1.2,
                                            ),
                                        elevation: 0.0,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  width: 200.0,
                                  height: 60.0,
                                  child: custom_widgets.GooglePayWidget(
                                    width: 200.0,
                                    height: 60.0,
                                    priceAmount:
                                        (widget.paymentPrice!).toString(),
                                  ),
                                );
                              }
                            },
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
