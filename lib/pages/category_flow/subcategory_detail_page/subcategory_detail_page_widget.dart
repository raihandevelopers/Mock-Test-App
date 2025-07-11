import '/backend/api_requests/api_calls.dart';
import '/componants/app_bar/app_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubcategoryDetailPageWidget extends StatefulWidget {
  const SubcategoryDetailPageWidget({
    Key? key,
    this.subcategoryId,
    this.subcategoryName,
  }) : super(key: key);

  final String? subcategoryId;
  final String? subcategoryName;

  static String routeName = 'subcategory_detail_page';
  static String routePath = '/subcategoryDetailPage';

  @override
  State<SubcategoryDetailPageWidget> createState() => _SubcategoryDetailPageWidgetState();
}

class _SubcategoryDetailPageWidgetState extends State<SubcategoryDetailPageWidget> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final subcategoryId = args != null ? args['subcategoryId'] : widget.subcategoryId;
    final subcategoryName = args != null ? args['subcategoryName'] : widget.subcategoryName;

    return Scaffold(
      appBar: AppBar(
        title: Text(subcategoryName ?? 'Subcategory'),
      ),
      body: FutureBuilder<ApiCallResponse>(
        future: QuizGroup.getQuizBySubcategoryCall.call(subcategoryId: subcategoryId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final quizzes = QuizGroup.getQuizBySubcategoryCall.quizList(snapshot.data!.jsonBody) ?? [];
          if (quizzes.isEmpty) {
            return Center(child: Text('No quizzes found for this subcategory.'));
          }
          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            itemCount: quizzes.length,
            separatorBuilder: (_, __) => SizedBox(height: 16),
            itemBuilder: (context, index) {
              final quiz = quizzes[index];
              // DEBUG: Print the quiz object and its keys
              print('Quiz object at index $index: $quiz');
              print('Quiz keys: ${quiz.keys.toList()}');
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz['name'] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        SizedBox(width: 8),
                        Text('.', style: TextStyle(color: Colors.grey[700])),
                        SizedBox(width: 8),
                        Text(
                          '${quiz['minutes_per_quiz'] ?? ''} mins',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(width: 8),
                        Text('.', style: TextStyle(color: Colors.grey[700])),
                        SizedBox(width: 8),
                        Text(
                          '${quiz['minimum_required_points'] ?? 'N/A'} Marks',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            context.pushNamed(
                              'quiz_questions_screen',
                              queryParameters: {
                                'quizID': quiz['_id'],
                                'title': quiz['name'],
                                'image': '${FFAppConstants.imageBaseURL}${quiz['image']}',
                                'quizTime': quiz['minutes_per_quiz'].toString(),
                                'description': quiz['description'],
                              },
                            );
                          },
                          child: Text(
                            'Resume Test',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'English, Hindi',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
} 