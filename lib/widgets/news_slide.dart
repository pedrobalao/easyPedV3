import 'package:easypedv3/models/news.dart';
import 'package:easypedv3/utils/app_styles.dart';
import 'package:easypedv3/widgets/page_indicator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsSlide extends StatefulWidget {
  const NewsSlide({required this.news, super.key});

  final List<News> news;

  @override
  State<NewsSlide> createState() => _NewsSlideState();
}

class _NewsSlideState extends State<NewsSlide> {
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
    if (widget.news.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.news.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) =>
                _NewsCard(news: widget.news[index]),
          ),
        ),
        const Gap(8),
        PageIndicator(
          count: widget.news.length,
          currentIndex: _currentPage,
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.news});

  final News news;

  Future<void> _openNewsUrl() async {
    FirebaseAnalytics.instance.logSelectItem(items: [
      AnalyticsEventItem(
        itemCategory: 'news_open',
        itemId: news.id.toString(),
        itemName: news.title,
      ),
    ]);
    if (!await launchUrl(Uri.parse(news.url!))) {
      throw Exception('Could not launch ${news.url}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: _openNewsUrl,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.coverUrl != null)
              SizedBox(
                height: 150,
                width: double.infinity,
                child: Image.network(news.coverUrl!, fit: BoxFit.cover),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title ?? '',
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
                        news.description ?? '',
                        maxLines: 2,
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
