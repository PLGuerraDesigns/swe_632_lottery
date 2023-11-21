import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartViewer extends StatefulWidget {
  const BarChartViewer({
    super.key,
    required this.maxValue,
    required this.data,
    required this.labels,
  });

  final int maxValue;

  final List<int> data;

  final List<String> labels;

  @override
  State<StatefulWidget> createState() => BarChartViewerState();
}

class BarChartViewerState extends State<BarChartViewer> {
  int touchedIndex = -1;

  bool isPlaying = false;

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 12,
    List<int> showTooltips = const <int>[],
  }) {
    barColor ??= Theme.of(context).colorScheme.surface;
    return BarChartGroupData(
      x: x,
      barsSpace: 10,
      barRods: <BarChartRodData>[
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: widget.maxValue.toDouble(),
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  Widget title(double value, TitleMeta meta) {
    return RotatedBox(
      quarterTurns: 3,
      child: Text(
        widget.labels[value.toInt()],
        style: Theme.of(context).textTheme.titleSmall,
        textAlign: TextAlign.left,
      ),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Theme.of(context).colorScheme.primaryContainer,
          tooltipRoundedRadius: 8,
          fitInsideVertically: true,
          tooltipMargin: -50,
          rotateAngle: -90,
          getTooltipItem: (BarChartGroupData group, int groupIndex,
              BarChartRodData rod, int rodIndex) {
            return BarTooltipItem(
              '${widget.data[group.x]}/${widget.maxValue}',
              Theme.of(context).textTheme.titleSmall!,
              children: <TextSpan>[
                TextSpan(
                  text: '\n${widget.data[group.x] * 100 ~/ widget.maxValue}%',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            );
          },
        ),
        touchCallback:
            (FlTouchEvent event, BarTouchResponse? barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: title,
            reservedSize: 150,
          ),
        ),
        leftTitles: const AxisTitles(),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: <BarChartGroupData>[
        for (int i = 0; i < widget.data.length; i++)
          makeGroupData(
            i,
            widget.data[i].toDouble(),
            isTouched: i == touchedIndex,
            // showTooltips: ,
          ),
      ],
      gridData: const FlGridData(
        drawVerticalLine: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RotatedBox(
              quarterTurns: 1,
              child: BarChart(
                mainBarData(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
