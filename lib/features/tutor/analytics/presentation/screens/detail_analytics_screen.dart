import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/quiz_results_export_service.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:class_app/features/tutor/analytics/presentation/widgets/score_frequency_chart.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_bloc.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_events.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailAnalyticsScreen extends StatefulWidget {
  const DetailAnalyticsScreen({
    super.key,
    required this.id,
    required this.title,
  });
  final String id;
  final String title;

  @override
  State<DetailAnalyticsScreen> createState() => _DetailAnalyticsScreenState();
}

class _DetailAnalyticsScreenState extends State<DetailAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    // You can fetch detailed analytics data here if needed
    context.read<QuestionBloc>().add(
      GetQuizAnalyticsEvent(widget.id),
    ); // Assuming this event fetches detailed analytics
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(
          onTap: () {
            if (FocusScope.of(context).hasFocus) {
              FocusScope.of(context).unfocus();
            }
            Navigator.pop(context);
            context.read<QuestionBloc>().add(GetAnalyticsEvent());
          },
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: SizeConfig.blockSizeHorizontal! * 6,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
        ),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<QuestionBloc, QuestionState>(
        buildWhen:
            (previous, current) =>
                current is GetQuizAnalyticsLoadedState ||
                current is GetQuizAnalyticsErrorState ||
                current is GetQuizAnalyticsLoadingState,
        builder: (context, state) {
          if (state is GetQuizAnalyticsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetQuizAnalyticsErrorState) {
            return Center(child: Text(state.message));
          } else if (state is GetQuizAnalyticsLoadedState) {
            final analytics = state.analytics;

            if (analytics.isEmpty) {
              return const Center(
                child: Text(
                  "No responses received yet.",
                  style: TextStyle(color: Color(blackColor)),
                  textAlign: TextAlign.center,
                ),
              );
            }

            /// Build score frequency map from totalSubmissions per score (optional)
            final scoreFrequency = <int, int>{};
            for (var item in analytics) {
              int score = item['correctAnswers'] ?? 0;
              scoreFrequency[score] = (scoreFrequency[score] ?? 0) + 1;
            }

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.horizontalPadding(context),
                    ),
                    children: [
                      SizedBox(height: SizeConfig.blockSizeVertical! * 1),

                      AccuracyBarChart(analytics: analytics),
                      SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                      BlocConsumer<QuestionBloc, QuestionState>(
                        listener: (context, state) async {
                          if (state is FetchQuizResultsErrorState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }

                          if (state is FetchQuizResultsSuccessState) {
                            final filePath =
                                await QuizResultExportService.exportToPdf(
                                  quizTitle: widget.title,
                                  responses: state.results,
                                  fileName: '${widget.title}_quiz_results',
                                );
                            if (filePath != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Check your downloads folder for file.',
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Permission denied or error occurred.',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        builder: (context, state) {
                          return CustomElevatedButton(
                            buttonText:
                                state is FetchingQuizResultsState
                                    ? exportingResultsText
                                    : exportResultsText,
                            onPressed: () {
                              context.read<QuestionBloc>().add(
                                FetchQuizResultsEvent(widget.id),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                      GridView.builder(
                        itemCount: analytics.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio:
                              SizeConfig.orientation(context) ==
                                      Orientation.portrait
                                  ? 1.2
                                  : 2.2,
                        ),
                        itemBuilder: (context, index) {
                          final item = analytics[index];
                          final correct = item['correctAnswers'] ?? 0;
                          final total = item['totalSubmissions'] ?? 0;
                          return InkWell(
                            borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeVertical! * 2,
                            ),
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(greyColor)),
                                borderRadius: BorderRadius.circular(
                                  SizeConfig.blockSizeVertical! * 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Q${index + 1}"),
                                  Text(
                                    "$correct/$total",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical! * 1),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Handle unexpected states
            return const Center(child: Text("Unexpected state encountered."));
          }
        },
      ),
    );
  }
}

class QuestionAnalyticsBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> analytics;
  final int totalQuestions;

  const QuestionAnalyticsBarChart({
    super.key,
    required this.analytics,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    // Fill missing questions with zero data
    final filledAnalytics = List.generate(totalQuestions, (index) {
      return analytics.length > index
          ? analytics[index]
          : {'correctAnswers': 0, 'wrongAnswers': 0};
    });

    final chartWidth = totalQuestions * 28.0; // Adjust spacing per question

    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: chartWidth,
          child: BarChart(
            BarChartData(
              maxY: _getMaxY(filledAnalytics).toDouble(),
              barGroups: _buildBarGroups(filledAnalytics),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < totalQuestions) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            "Q${index + 1}",
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    reservedSize: 32,
                  ),
                ),
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(enabled: true),
            ),
          ),
        ),
      ),
    );
  }

  int _getMaxY(List<Map<String, dynamic>> data) {
    int max = 0;
    for (var item in data) {
      int correct = item['correctAnswers'] ?? 0;
      if (correct > max) max = correct;
    }
    return max + 2;
  }

  List<BarChartGroupData> _buildBarGroups(List<Map<String, dynamic>> data) {
    return List.generate(data.length, (index) {
      final item = data[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (item['correctAnswers'] as int).toDouble(),
            color: Colors.green,
            width: 12,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
        barsSpace: 2,
      );
    });
  }
}
