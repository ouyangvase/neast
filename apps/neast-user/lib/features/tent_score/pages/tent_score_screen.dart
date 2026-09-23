import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/tent_score/models/tent_score_model.dart';
import 'package:neast/features/tent_score/providers/tent_score_provider.dart';
import 'package:neast/features/tent_score/widgets/tent_score_gauge.dart';
import 'package:neast/features/tent_score/widgets/tent_score_stats_list.dart';
import 'package:neast/features/tent_score/widgets/tent_score_streak_banner.dart';

/// Tent Score（租客信用评分）页面。
class TentScoreScreen extends ConsumerStatefulWidget {
  const TentScoreScreen({super.key});

  @override
  ConsumerState<TentScoreScreen> createState() => _TentScoreScreenState();
}

class _TentScoreScreenState extends ConsumerState<TentScoreScreen> {
  int _gaugeFromScore = 0;
  int _gaugeToScore = 0;
  bool _gaugeAnimate = true;
  int? _lastRenderedScore;

  @override
  void initState() {
    super.initState();
    final cached = ref.read(tentScoreProvider).value;
    if (cached != null) {
      _gaugeFromScore = cached.score;
      _gaugeToScore = cached.score;
      _gaugeAnimate = false;
      _lastRenderedScore = cached.score;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (ref.read(tentScoreProvider).hasValue) {
        ref.invalidate(tentScoreProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<TentScoreModel>>(tentScoreProvider, (previous, next) {
      next.whenData((model) {
        if (!mounted) return;
        final previousScore = previous?.value?.score ?? _lastRenderedScore;
        setState(() {
          if (previousScore == null) {
            _gaugeFromScore = 0;
            _gaugeToScore = model.score;
            _gaugeAnimate = true;
          } else if (previousScore != model.score) {
            _gaugeFromScore = previousScore;
            _gaugeToScore = model.score;
            _gaugeAnimate = true;
          } else {
            _gaugeFromScore = model.score;
            _gaugeToScore = model.score;
            _gaugeAnimate = false;
          }
          _lastRenderedScore = model.score;
        });
      });
    });

    final asyncScore = ref.watch(tentScoreProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
          title: const Text(
            'Tent Score',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'FD',
              fontVariations: [FontVariation('wght', 500)],
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        body: asyncScore.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _ErrorState(
            onRetry: () => ref.invalidate(tentScoreProvider),
          ),
          data: (model) => _Content(
            model: model,
            gaugeFromScore: _gaugeFromScore,
            gaugeToScore: _gaugeToScore,
            gaugeAnimate: _gaugeAnimate,
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.model,
    required this.gaugeFromScore,
    required this.gaugeToScore,
    required this.gaugeAnimate,
  });

  final TentScoreModel model;
  final int gaugeFromScore;
  final int gaugeToScore;
  final bool gaugeAnimate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: TentScoreGauge(
                    key: ValueKey('$gaugeFromScore-$gaugeToScore-$gaugeAnimate'),
                    fromScore: gaugeFromScore,
                    toScore: gaugeToScore,
                    maxScore: model.maxScore,
                    ratingLabel: model.ratingLabel,
                    animate: gaugeAnimate,
                  ),
                ),
                const SizedBox(height: 24),
                TentScoreStreakBanner(
                  streakLabel: model.streakLabel,
                  streakStatus: model.streakStatus,
                ),
                const SizedBox(height: 8),
                TentScoreStatsList(model: model),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Failed to load Tent Score',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'HG',
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
