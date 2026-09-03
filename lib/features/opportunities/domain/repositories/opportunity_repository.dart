import '../models/opportunity.dart';

/// Abstract repository interface for fetching and filtering opportunities.
abstract class OpportunityRepository {
  Future<List<Opportunity>> getOpportunities({OpportunityCategory? category});
  Future<Opportunity?> getOpportunityById(String id);
}
