import 'package:easypedv3/models/congress.dart';
import 'package:easypedv3/utils/app_styles.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CongressesSlide extends StatefulWidget {
  const CongressesSlide({required this.congresses, super.key});

  final List<Congress> congresses;

  @override
  State<CongressesSlide> createState() => _CongressesSlideState();
}

class _CongressesSlideState extends State<CongressesSlide> {
  int _currentPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.congresses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.congresses.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) =>
                _CongressCard(congress: widget.congresses[index]),
          ),
        ),
        const Gap(8),
        _PageIndicator(
          count: widget.congresses.length,
          currentIndex: _currentPage,
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}

class _CongressCard extends StatelessWidget {
  const _CongressCard({required this.congress});

  final Congress congress;

  Future<void> _openCongressUrl() async {
    FirebaseAnalytics.instance.logSelectItem(items: [
      AnalyticsEventItem(
        itemCategory: 'congress_open',
        itemId: congress.id.toString(),
        itemName: congress.title,
      ),
    ]);
    if (!await launchUrl(Uri.parse(congress.url!))) {
      throw Exception('Could not launch ${congress.url}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formatter = DateFormat('yMMMMd');

    final dateText = congress.beginDate == congress.endDate
        ? formatter.format(congress.beginDate!)
        : '${formatter.format(congress.beginDate!)} - ${formatter.format(congress.endDate!)}';

    return GestureDetector(
      onTap: _openCongressUrl,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (congress.coverUrl != null)
              SizedBox(
                height: 150,
                width: double.infinity,
                child: Image.network(congress.coverUrl!, fit: BoxFit.cover),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateText,
                      style: Styles.headLineStyle5.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      congress.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.headLineStyle3.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                    const Gap(4),
                    Flexible(
                      child: Text(
                        '${congress.city ?? ''} - ${congress.country ?? ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Styles.headLineStyle4.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.count,
    required this.currentIndex,
    required this.activeColor,
  });

  final int count;
  final int currentIndex;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? activeColor : activeColor.withAlpha(77),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
