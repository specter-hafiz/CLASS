import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
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
        builder: (context, state) {
          if (state is GetQuizAnalyticsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetQuizAnalyticsErrorState) {
            return Center(child: Text(state.message));
          }

          if (state is GetQuizAnalyticsLoadedState) {
            final analytics = state.analytics;

            if (analytics.isEmpty) {
              return const Center(
                child: Text(
                  "No analytics found.\nNo responses received yet.",
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
                      AccuracyBarChart(analytics: analytics),
                      SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                      CustomElevatedButton(
                        buttonText: exportResultsText,
                        onPressed: () {
                          // handle export
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
          }

          return const Center(child: Text("No analytics found."));
        },
      ),
    );
  }
}

class QuestionAnalyticsBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> analytics;

  const QuestionAnalyticsBarChart({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: _getMaxY().toDouble(),
        barGroups: _buildBarGroups(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: _getBottomTitles,
              reservedSize: 48,
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(enabled: true),
      ),
    );
  }

  int _getMaxY() {
    int max = 0;
    for (var item in analytics) {
      int sum = item['correctAnswers'] + item['wrongAnswers'];
      if (sum > max) max = sum;
    }
    return (max + 2); // for padding
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(analytics.length, (index) {
      final item = analytics[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (item['correctAnswers'] as int).toDouble(),
            color: Color(blueColor),
            width: SizeConfig.blockSizeHorizontal! * 6,
          ),
          BarChartRodData(
            toY: (item['wrongAnswers'] as int).toDouble(),
            color: Colors.red,
            width: 14,
          ),
        ],
        barsSpace: 4,
      );
    });
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index >= 0 && index < analytics.length) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          "Q${index + 1}",
          style: TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
