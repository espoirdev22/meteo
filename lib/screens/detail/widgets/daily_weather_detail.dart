import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../model/weather_data.dart';
import '../../../core/constants/weather_emojis.dart';
import 'dart:ui';

class DailyWeatherDetail extends StatefulWidget {
  final WeatherData weatherData;
  final DateTime selectedDate;
  final Map<String, dynamic> dayForecast;

  const DailyWeatherDetail({
    Key? key,
    required this.weatherData,
    required this.selectedDate,
    required this.dayForecast,
  }) : super(key: key);

  @override
  State<DailyWeatherDetail> createState() => _DailyWeatherDetailState();
}

class _DailyWeatherDetailState extends State<DailyWeatherDetail>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _getGradientForWeather(),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header avec navigation
              _buildHeader(),

              // Contenu principal avec scroll contrôlé
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          // Informations principales de la journée
                          _buildMainDayInfo(),

                          // Prévision de température pour le lendemain
                          _buildTomorrowPreview(),

                          // Onglets de navigation
                          _buildTabNavigation(),
                        ],
                      ),
                    ),

                    // Contenu de l'onglet sélectionné
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildTabContent(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final formattedDate = DateFormat('EEEE d MMMM', 'fr_FR').format(widget.selectedDate);
    final capitalizedDate = formattedDate[0].toUpperCase() + formattedDate.substring(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ).animate()
              .scale(delay: 100.ms, duration: 500.ms, curve: Curves.elasticOut),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  capitalizedDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.weatherData.displayName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainDayInfo() {
    final maxTemp = widget.dayForecast['maxTemp'] as int;
    final minTemp = widget.dayForecast['minTemp'] as int;
    final description = widget.dayForecast['description'] as String;
    final emoji = widget.dayForecast['emoji'] as String;
    final rainChance = widget.dayForecast['rainChance'] as int;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // Emoji et température principale
          Text(
            emoji,
            style: const TextStyle(fontSize: 80),
          ).animate()
              .scale(delay: 200.ms, duration: 800.ms, curve: Curves.elasticOut)
              .then()
              .shimmer(duration: 2000.ms),

          const SizedBox(height: 16),

          // Température et description
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${maxTemp}°',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 64,
                  fontWeight: FontWeight.w200,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  WeatherEmojis.getTemperatureEmoji(maxTemp.toDouble()),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ).animate()
              .fadeIn(delay: 400.ms, duration: 800.ms)
              .slideY(begin: 0.5, duration: 800.ms),

          const SizedBox(height: 8),

          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ).animate()
              .fadeIn(delay: 600.ms, duration: 800.ms),

          const SizedBox(height: 12),

          // Températures min/max et probabilité de pluie
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: [
              Text(
                'Max.: ${maxTemp}°C  Min.: ${minTemp}°C',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
              if (rainChance > 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('💧', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      '${rainChance}%',
                      style: const TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ).animate()
              .fadeIn(delay: 800.ms, duration: 800.ms),
        ],
      ),
    );
  }

  Widget _buildTomorrowPreview() {
    final tomorrow = widget.selectedDate.add(const Duration(days: 1));
    final tomorrowForecast = _generateForecastForDate(tomorrow);
    final tempDiff = (widget.dayForecast['maxTemp'] as int) - (tomorrowForecast['maxTemp'] as int);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            tempDiff > 0 ? Icons.trending_down : Icons.trending_up,
            color: Colors.white70,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tempDiff > 0
                  ? 'La température de demain sera moins élevée de ${tempDiff}°'
                  : 'La température de demain sera plus élevée de ${tempDiff.abs()}°',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(delay: 1000.ms, duration: 800.ms)
        .slideY(begin: 0.3, duration: 800.ms);
  }

  Widget _buildTabNavigation() {
    final tabs = ['Aperçu', 'Précipitations', 'Vent', 'Humidité'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = _selectedTab == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                _tabController.animateTo(index);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent() {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _getTabContent(),
      ),
    );
  }

  Widget _getTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildPrecipitationTab();
      case 2:
        return _buildWindTab();
      case 3:
        return _buildHumidityTab();
      default:
        return _buildOverviewTab();
    }
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Prévisions horaires détaillées
          _buildHourlyDetailedForecast(),

          const SizedBox(height: 20),

          // Prévisions des 5 prochains jours
          _buildUpcomingDays(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHourlyDetailedForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aujourd\'hui',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 24,
            itemBuilder: (context, index) {
              final hour = index;
              final hourlyData = _generateHourlyDataForDay(index);
              final isNow = DateTime.now().hour == hour &&
                  widget.selectedDate.day == DateTime.now().day;

              return Container(
                width: 70,
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: isNow ? Colors.white.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: isNow ? Border.all(color: Colors.white.withOpacity(0.3)) : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isNow ? 'Maintenant' : '${hour.toString().padLeft(2, '0')}:00',
                      style: TextStyle(
                        color: isNow ? Colors.white : Colors.white70,
                        fontSize: 10,
                        fontWeight: isNow ? FontWeight.w600 : FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      hourlyData['emoji'] as String,
                      style: const TextStyle(fontSize: 20),
                    ),
                    if (hourlyData['rainChance'] > 0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('💧', style: TextStyle(fontSize: 8)),
                          Text(
                            '${hourlyData['rainChance']}%',
                            style: const TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ] else
                      const SizedBox(height: 10),
                    Text(
                      '${hourlyData['temp']}°',
                      style: TextStyle(
                        color: isNow ? Colors.white : Colors.white70,
                        fontSize: 14,
                        fontWeight: isNow ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingDays() {
    final upcomingDays = _generateUpcomingDaysData();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: upcomingDays.asMap().entries.map((entry) {
          final index = entry.key;
          final dayData = entry.value;
          final date = DateTime.now().add(Duration(days: index + 1));
          final dayName = _getDayName(date);

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: index < upcomingDays.length - 1
                  ? Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 0.5,
                ),
              )
                  : null,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Text(
                    dayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  dayData['emoji'] as String,
                  style: const TextStyle(fontSize: 18),
                ),
                if (dayData['rainChance'] > 0) ...[
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      const Text('💧', style: TextStyle(fontSize: 10)),
                      Text(
                        '${dayData['rainChance']}%',
                        style: const TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
                const Spacer(),
                Text(
                  '${dayData['minTemp']}°',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 30,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.3),
                        Colors.orange.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${dayData['maxTemp']}°',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPrecipitationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Moyenne de ce soir 49 %',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          _buildHumidityChart(),
        ],
      ),
    );
  }

  Widget _buildWindTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Vent moyen: ${widget.weatherData.windSpeedString}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          _buildWindChart(),
        ],
      ),
    );
  }

  Widget _buildHumidityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Humidité moyenne: ${widget.weatherData.humidityString}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          _buildHumidityChart(),
        ],
      ),
    );
  }

  Widget _buildHumidityChart() {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(8, (index) {
                final hour = index * 3;
                final humidity = 56 + (index % 3) * 2;
                final height = (humidity / 100) * 100;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '$humidity%',
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 16,
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${hour.toString().padLeft(2, '0')}h',
                        style: const TextStyle(color: Colors.white70, fontSize: 9),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindChart() {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(8, (index) {
                final hour = index * 3;
                final windSpeed = 3 + (index % 4) * 2;
                final height = (windSpeed / 15) * 100;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${windSpeed}km/h',
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 16,
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${hour.toString().padLeft(2, '0')}h',
                        style: const TextStyle(color: Colors.white70, fontSize: 9),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Méthodes utilitaires

  LinearGradient _getGradientForWeather() {
    final category = WeatherEmojis.getWeatherCategory(widget.dayForecast['emoji'] as String);

    switch (category) {
      case 'sunny':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF87CEEB), Color(0xFF4682B4)],
        );
      case 'cloudy':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF708090), Color(0xFF2F4F4F)],
        );
      case 'rainy':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4682B4), Color(0xFF191970)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF87CEEB), Color(0xFF4682B4)],
        );
    }
  }

  String _getDayName(DateTime date) {
    final formatter = DateFormat('EEEE', 'fr_FR');
    String dayName = formatter.format(date);
    return dayName[0].toLowerCase() + dayName.substring(1, 3) + '.';
  }

  Map<String, dynamic> _generateForecastForDate(DateTime date) {
    final baseTemp = widget.weatherData.temperature;
    final tempVariation = (date.day % 5) - 2;

    return {
      'maxTemp': (baseTemp + tempVariation).round(),
      'minTemp': (baseTemp + tempVariation - 5).round(),
      'emoji': WeatherEmojis.getSmartEmoji(
        iconCode: widget.weatherData.icon,
        temperature: baseTemp + tempVariation,
      ),
      'rainChance': (date.day % 3) * 20,
    };
  }

  Map<String, dynamic> _generateHourlyDataForDay(int hour) {
    final baseTemp = widget.dayForecast['maxTemp'] as int;
    final tempVariation = (hour % 6) - 3;
    final isNight = hour < 6 || hour > 20;

    return {
      'temp': baseTemp + tempVariation,
      'emoji': WeatherEmojis.getSmartEmoji(
        iconCode: widget.weatherData.icon + (isNight ? 'n' : 'd'),
        temperature: (baseTemp + tempVariation).toDouble(),
      ),
      'rainChance': hour % 4 == 0 ? (hour % 3) * 30 : 0,
    };
  }

  List<Map<String, dynamic>> _generateUpcomingDaysData() {
    return List.generate(5, (index) {
      final date = DateTime.now().add(Duration(days: index + 1));
      return _generateForecastForDate(date);
    });
  }
}