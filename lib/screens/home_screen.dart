import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/city_provider.dart';
import '../models/city.dart';
import '../widgets/discover_city_card.dart';
import '../widgets/search_field.dart';
import '../widgets/settings_button.dart';
import '../widgets/loading_panel.dart';
import 'narration_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _searchLayerLink = LayerLink();

  bool _showLoadingPanel = false;
  String _loadingCityName = '';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onCityTap(City city) async {
    setState(() {
      _showLoadingPanel = true;
      _loadingCityName = city.name;
    });
    final provider = context.read<CityProvider>();
    await provider.selectCity(city);

    if (mounted) {
      setState(() {
        _showLoadingPanel = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NarrationScreen()),
      );
    }
  }

  void _closeLoadingPanel() {
    setState(() {
      _showLoadingPanel = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CityProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          context.read<CityProvider>().clearSearch();
        },
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          bottom: false,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discover',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF111827),
                              letterSpacing: -0.5,
                            ),
                          ),
                          SettingsButton(isConnected: provider.isConnected),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: CompositedTransformTarget(
                        link: _searchLayerLink,
                        child: SearchField(
                          controller: _searchController,
                          onChanged: (value) {
                            context.read<CityProvider>().searchCity(value);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Cities',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.0,
                            ),
                        itemCount: cities.length,
                        itemBuilder: (context, index) {
                          final city = cities[index];
                          return TweenAnimationBuilder<Offset>(
                            tween: Tween<Offset>(
                              begin: const Offset(0, 0.2),
                              end: Offset.zero,
                            ),
                            duration: Duration(
                              milliseconds: 400 + (index * 100),
                            ),
                            curve: Curves.easeOutCubic,
                            builder: (context, offset, child) {
                              return FractionalTranslation(
                                translation: offset,
                                child: child,
                              );
                            },
                            child: DiscoverCityCard(
                              city: city,
                              onTap: () => _onCityTap(city),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                if (provider.searchResults.isNotEmpty)
                  CompositedTransformFollower(
                    link: _searchLayerLink,
                    showWhenUnlinked: false,
                    offset: const Offset(0, 56),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 48,
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 1,
                            ),
                          ),
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: provider.searchResults.length,
                            separatorBuilder: (context, index) => const Divider(
                              height: 1,
                              color: Color(0xFFE5E7EB),
                            ),
                            itemBuilder: (context, index) {
                              final city = provider.searchResults[index];
                              return ListTile(
                                title: Text(
                                  city.name,
                                  style: TextStyle(
                                    color: const Color(0xFF111827),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                leading: const Icon(
                                  Icons.location_city,
                                  color: Color(0xFF9CA3AF),
                                ),
                                onTap: () {
                                  _onCityTap(city);
                                  provider.clearSearch();
                                  _searchController.clear();
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                if (_showLoadingPanel)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: MediaQuery.of(context).padding.bottom,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: LoadingPanel(
                        cityName: _loadingCityName,
                        onClose: _closeLoadingPanel,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
