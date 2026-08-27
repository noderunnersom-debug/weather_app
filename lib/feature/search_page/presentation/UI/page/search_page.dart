import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather/core/di/si.dart';
import 'package:weather/core/storage/selected_city_storage.dart';
import 'package:weather/domain/entity/city_entity.dart';
import 'package:weather/feature/search_page/presentation/UI/widgets/search_bar_widget.dart';
import 'package:weather/feature/search_page/presentation/UI/widgets/city_card.dart';
import 'package:weather/core/utils/popular_cities.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../bloc/search_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SearchBloc>(),
      child: SearchPageContent(),
    );
  }
}

class SearchPageContent extends StatefulWidget {
  const SearchPageContent({super.key});

  @override
  State<SearchPageContent> createState() => _SearchPageContentState();
}

class _SearchPageContentState extends State<SearchPageContent> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      context.read<SearchBloc>().add(ClearSearchEvent());
    } else {
      context.read<SearchBloc>().add(SearchCitiesEvent(query));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _onCitySelected(CityEntity city) async {
    final storage = getIt<SelectedCityStorage>();

    await storage.saveCity(lat: city.lat, lon: city.lon, name: city.name);
    if (!mounted) return;

    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryGradientTop,
              AppColors.primaryGradientBottom,
            ],
          ),
        ),
        child: Column(
          children: [
            SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              focusNode: _focusNode,
            ),

            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.textPrimary,
                      ),
                    );
                  }

                  if (state is SearchError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    );
                  }

                  final List<CityEntity> cities = state is SearchLoaded
                      ? state.cities
                      : popularCities;

                  if (cities.isEmpty) {
                    return Center(
                      child: Text(
                        'Города не найдены',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      final city = cities[index];

                      return CityCard(
                        city: city,
                        onTap: () => _onCitySelected(city),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
