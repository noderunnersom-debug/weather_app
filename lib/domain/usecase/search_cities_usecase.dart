import 'package:injectable/injectable.dart';
import 'package:weather/domain/entity/city_entity.dart';
import '../repository/repository.dart';

@injectable
class SearchCitiesUsecase {
  final Repository repo;

  SearchCitiesUsecase(this.repo);

  Future<List<CityEntity>> execute(String query) async {
    if (query.isEmpty) return [];

    final results = await repo.searchCities(query);
    final normalizedQuery = query.trim().toLowerCase();

    return results
        .where((city) => city.name.toLowerCase().contains(normalizedQuery))
        .toList();
  }
}
