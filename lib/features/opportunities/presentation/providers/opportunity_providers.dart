import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/network/network_providers.dart';
import '../../data/repositories/mock_opportunity_repository.dart';
import '../../domain/models/opportunity.dart';
import '../../domain/repositories/opportunity_repository.dart';

/// Active OpportunityRepository provider
final opportunityRepositoryProvider = Provider<OpportunityRepository>((ref) {
  final useMock = ref.watch(useMockRepositoriesProvider);
  final database = ref.watch(appDatabaseProvider);
  if (useMock) {
    return MockOpportunityRepository(database: database);
  }
  return MockOpportunityRepository(database: database);
});

/// Category filter state provider
final selectedOpportunityCategoryProvider = StateProvider<OpportunityCategory?>((ref) => null);

/// State holder for opportunity list + offline cache fallback
class OpportunitiesState {
  final List<Opportunity> opportunities;
  final bool isFromOfflineCache;

  const OpportunitiesState({
    required this.opportunities,
    this.isFromOfflineCache = false,
  });
}

class OpportunitiesNotifier extends StateNotifier<AsyncValue<OpportunitiesState>> {
  final OpportunityRepository _repository;
  final Ref _ref;

  OpportunitiesNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    loadOpportunities();
  }

  Future<void> loadOpportunities() async {
    state = const AsyncValue.loading();
    final category = _ref.read(selectedOpportunityCategoryProvider);
    final database = _ref.read(appDatabaseProvider);

    try {
      final list = await _repository.getOpportunities(category: category);
      state = AsyncValue.data(OpportunitiesState(opportunities: list, isFromOfflineCache: false));
    } catch (e) {
      // Intermittent connectivity handling: Fall back directly to Drift SQLite offline cache!
      try {
        final cached = category == null
            ? await database.getAllOpportunities()
            : await database.getOpportunitiesByCategory(category.toDbString());

        if (cached.isNotEmpty) {
          final mapped = cached
              .map(
                (c) => Opportunity(
                  id: c.id,
                  title: c.title,
                  category: OpportunityCategory.fromDbString(c.category),
                  provider: c.provider,
                  description: c.description,
                  eligibility: c.eligibility,
                  deadline: c.deadline,
                  url: c.url,
                ),
              )
              .toList();
          state =
              AsyncValue.data(OpportunitiesState(opportunities: mapped, isFromOfflineCache: true));
          return;
        }
      } catch (_) {}

      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final opportunitiesProvider =
    StateNotifierProvider<OpportunitiesNotifier, AsyncValue<OpportunitiesState>>((ref) {
  final repo = ref.watch(opportunityRepositoryProvider);
  return OpportunitiesNotifier(repo, ref);
});
