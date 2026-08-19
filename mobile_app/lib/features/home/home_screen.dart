import 'package:flutter/material.dart';

import '../../core/services/trip_service.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/models/trip_model.dart';
import '../../shared/widgets/app_card.dart';
import '../location/location_screen.dart';
import '../profile/profile_screen.dart';
import '../trip/create_trip_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  int _selectedIndex = 0;

  Future<void> _openProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const ProfileScreen(),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _openCreateTrip() async {
    final bool? result =
        await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const CreateTripScreen(),
      ),
    );

    if (!mounted) {
      return;
    }

    if (result == true) {
      setState(() {});
    }
  }

  Future<void> _editTrip() async {
    if (!TripService.instance.hasTrip) {
      return;
    }

    final bool? result =
        await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const CreateTripScreen(
          isEditing: true,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    if (result == true) {
      setState(() {});
    }
  }

  void _startTrip() {
    if (!TripService.instance.hasTrip) {
      _showMessage(
        'Please create a trip first.',
      );
      return;
    }

    _showMessage(
      'Start Trip functionality will be implemented in the next stage.',
    );
  }

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content:
            Text(message),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          AppTheme.background,

      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeTab(),
            _buildMapTab(),
            _buildSafetyTab(),
          ],
        ),
      ),

      bottomNavigationBar:
          NavigationBar(
        selectedIndex:
            _selectedIndex,

        backgroundColor:
            AppTheme.surface,

        indicatorColor:
            AppTheme.primary
                .withValues(
          alpha: 0.25,
        ),

        onDestinationSelected:
            (index) {
          setState(() {
            _selectedIndex =
                index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home_rounded,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.map_outlined,
            ),
            selectedIcon: Icon(
              Icons.map_rounded,
            ),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.shield_outlined,
            ),
            selectedIcon: Icon(
              Icons.shield_rounded,
            ),
            label: 'Safety',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(),

      padding:
          const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        30,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          _buildWelcome(),

          const SizedBox(
            height: 22,
          ),

          _buildSafetyStatus(),

          const SizedBox(
            height: 22,
          ),

          const Text(
            'Quick Actions',
            style:
                TextStyle(
              color:
                  AppTheme.textPrimary,
              fontSize: 18,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          _buildQuickActions(),

          const SizedBox(
            height: 24,
          ),

          const Text(
            'Your Journey',
            style:
                TextStyle(
              color:
                  AppTheme.textPrimary,
              fontSize: 18,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          _buildCurrentTrip(),

          const SizedBox(
            height: 24,
          ),

          _buildEmergencyCard(),
        ],
      ),
    );
  }

  Widget _buildWelcome() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Good day, Tourist 👋',
                style:
                    TextStyle(
                  color:
                      AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),

              SizedBox(
                height: 5,
              ),

              Text(
                'Stay safe while exploring.',
                style:
                    TextStyle(
                  color:
                      AppTheme.textPrimary,
                  fontSize: 23,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(
          width: 12,
        ),

        GestureDetector(
          onTap:
              _openProfile,
          child:
              Container(
            width: 54,
            height: 54,
            decoration:
                const BoxDecoration(
              shape:
                  BoxShape.circle,
              gradient:
                  LinearGradient(
                colors: [
                  AppTheme.primary,
                  AppTheme.secondary,
                ],
              ),
            ),
            child:
                const Icon(
              Icons.person_rounded,
              color:
                  Colors.white,
              size: 29,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSafetyStatus() {
    return AppCard(
      padding:
          const EdgeInsets.all(18),

      child:
          Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration:
                BoxDecoration(
              color: AppTheme.secondary
                  .withValues(
                alpha: 0.12,
              ),
              shape:
                  BoxShape.circle,
            ),
            child:
                const Icon(
              Icons.shield_rounded,
              color:
                  AppTheme.secondary,
              size: 31,
            ),
          ),

          const SizedBox(
            width: 15,
          ),

          const Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Safety Status',
                  style:
                      TextStyle(
                    color:
                        AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Text(
                  'You are in a safe zone',
                  style:
                      TextStyle(
                    color:
                        AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration:
                BoxDecoration(
              color: AppTheme.secondary
                  .withValues(
                alpha: 0.12,
              ),
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),
            child:
                const Text(
              'SAFE',
              style:
                  TextStyle(
                color:
                    AppTheme.secondary,
                fontSize: 10,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.55,
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      children: [
        _quickAction(
          icon:
              Icons.my_location_rounded,
          title:
              'My Location',
          color:
              AppTheme.secondary,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const LocationScreen(),
              ),
            );
          },
        ),

        _quickAction(
          icon:
              Icons.map_outlined,
          title:
              'View Map',
          color:
              AppTheme.primary,
          onTap: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
        ),

        _quickAction(
          icon:
              Icons.route_outlined,
          title:
              'Safe Route',
          color:
              AppTheme.primary,
          onTap: () {
            _showMessage(
              'Safe Route will be implemented in the next stage.',
            );
          },
        ),

        _quickAction(
          icon:
              Icons.add_location_alt_outlined,
          title:
              'Create Trip',
          color:
              AppTheme.secondary,
          onTap:
              _openCreateTrip,
        ),
      ],
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap:
          onTap,
      child:
          AppCard(
        padding:
            const EdgeInsets.all(14),

        child:
            Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration:
                  BoxDecoration(
                color:
                    color.withValues(
                  alpha: 0.12,
                ),
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              child:
                  Icon(
                icon,
                color:
                    color,
                size: 22,
              ),
            ),

            const SizedBox(
              width: 10,
            ),

            Expanded(
              child:
                  Text(
                title,
                style:
                    const TextStyle(
                  color:
                      AppTheme.textPrimary,
                  fontSize: 12.5,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentTrip() {
    final TripModel? trip =
        TripService.instance.currentTrip;

    if (trip == null) {
      return AppCard(
        child:
            Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons
                      .location_on_rounded,
                  color:
                      AppTheme.secondary,
                  size: 22,
                ),

                const SizedBox(
                  width: 8,
                ),

                const Expanded(
                  child:
                      Text(
                    'Current Trip',
                    style:
                        TextStyle(
                      color:
                          AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),

                _statusBadge(
                  'NOT STARTED',
                  AppTheme.primary,
                ),
              ],
            ),

            const SizedBox(
              height: 18,
            ),

            const Text(
              'No trip created yet.',
              style:
                  TextStyle(
                color:
                    AppTheme.textMuted,
                fontSize: 13,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            SizedBox(
              width:
                  double.infinity,
              height: 48,
              child:
                  ElevatedButton.icon(
                onPressed:
                    _openCreateTrip,
                icon:
                    const Icon(
                  Icons
                      .add_location_alt_rounded,
                ),
                label:
                    const Text(
                  'Create Trip',
                ),
              ),
            ),
          ],
        ),
      );
    }

    return AppCard(
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons
                    .location_on_rounded,
                color:
                    AppTheme.secondary,
                size: 22,
              ),

              const SizedBox(
                width: 8,
              ),

              const Expanded(
                child:
                    Text(
                  'Current Trip',
                  style:
                      TextStyle(
                    color:
                        AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),

              _statusBadge(
                'PLANNED',
                AppTheme.secondary,
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          _tripInfoRow(
            icon:
                Icons.my_location_rounded,
            title:
                'Starting Point',
            value:
                trip.startLocation,
            color:
                AppTheme.secondary,
          ),

          const SizedBox(
            height: 15,
          ),

          _tripInfoRow(
            icon:
                Icons.location_on_rounded,
            title:
                'Destination',
            value:
                trip.destination,
            color:
                AppTheme.primary,
          ),

          const SizedBox(
            height: 18,
          ),

          Row(
            children: [
              Expanded(
                child:
                    _tripSmallInfo(
                  icon:
                      Icons.calendar_month_rounded,
                  title:
                      'Date',
                  value:
                      '${trip.date.day.toString().padLeft(2, '0')}/'
                      '${trip.date.month.toString().padLeft(2, '0')}/'
                      '${trip.date.year}',
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child:
                    _tripSmallInfo(
                  icon:
                      Icons.access_time_rounded,
                  title:
                      'Time',
                  value:
                      trip.startTime,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

          _tripSmallInfo(
            icon:
                Icons.groups_rounded,
            title:
                'Travellers',
            value:
                '${trip.travellers} '
                '${trip.travellers == 1 ? 'traveller' : 'travellers'}',
          ),

          const SizedBox(
            height: 22,
          ),

          Row(
            children: [
              Expanded(
                child:
                    OutlinedButton.icon(
                  onPressed:
                      _editTrip,
                  icon:
                      const Icon(
                    Icons.edit_rounded,
                    size: 19,
                  ),
                  label:
                      const Text(
                    'Edit Trip',
                    style:
                        TextStyle(
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child:
                    ElevatedButton.icon(
                  onPressed:
                      _startTrip,
                  icon:
                      const Icon(
                    Icons
                        .play_arrow_rounded,
                    size: 20,
                  ),
                  label:
                      const Text(
                    'Start Trip',
                    style:
                        TextStyle(
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(
    String text,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets
              .symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration:
          BoxDecoration(
        color:
            color.withValues(
          alpha: 0.12,
        ),
        borderRadius:
            BorderRadius.circular(
          15,
        ),
      ),
      child:
          Text(
        text,
        style:
            TextStyle(
          color:
              color,
          fontSize: 9,
          fontWeight:
              FontWeight.w800,
        ),
      ),
    );
  }

  Widget _tripInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration:
              BoxDecoration(
            color:
                color.withValues(
              alpha: 0.12,
            ),
            borderRadius:
                BorderRadius.circular(
              12,
            ),
          ),
          child:
              Icon(
            icon,
            color:
                color,
            size: 22,
          ),
        ),

        const SizedBox(
          width: 12,
        ),

        Expanded(
          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(
                  color:
                      AppTheme.textMuted,
                  fontSize: 10,
                ),
              ),

              const SizedBox(
                height: 4,
              ),

              Text(
                value,
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
                style:
                    const TextStyle(
                  color:
                      AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tripSmallInfo({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color:
              AppTheme.secondary,
          size: 19,
        ),

        const SizedBox(
          width: 8,
        ),

        Expanded(
          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(
                  color:
                      AppTheme.textMuted,
                  fontSize: 9,
                ),
              ),

              const SizedBox(
                height: 3,
              ),

              Text(
                value,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style:
                    const TextStyle(
                  color:
                      AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyCard() {
    return GestureDetector(
      onTap: () {
        _showMessage(
          'Emergency / SOS functionality will be implemented next.',
        );
      },

      child:
          Container(
        padding:
            const EdgeInsets.all(18),

        decoration:
            BoxDecoration(
          color:
              AppTheme.sos.withValues(
            alpha: 0.08,
          ),

          borderRadius:
              BorderRadius.circular(18),

          border:
              Border.all(
            color:
                AppTheme.sos.withValues(
              alpha: 0.3,
            ),
          ),
        ),

        child:
            Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration:
                  const BoxDecoration(
                color:
                    AppTheme.sos,
                shape:
                    BoxShape.circle,
              ),
              child:
                  const Icon(
                Icons.sos_rounded,
                color:
                    Colors.white,
                size: 28,
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            const Expanded(
              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emergency Assistance',
                    style:
                        TextStyle(
                      color:
                          AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  SizedBox(
                    height: 4,
                  ),

                  Text(
                    'Tap here if you need immediate help',
                    style:
                        TextStyle(
                      color:
                          AppTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons
                  .arrow_forward_ios_rounded,
              color:
                  AppTheme.sos,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapTab() {
    return Center(
      child:
          Padding(
        padding:
            const EdgeInsets.all(24),
        child:
            AppCard(
          child:
              Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              const Icon(
                Icons.map_rounded,
                color:
                    AppTheme.secondary,
                size: 60,
              ),

              const SizedBox(
                height: 16,
              ),

              const Text(
                'Safety Map',
                style:
                    TextStyle(
                  color:
                      AppTheme.textPrimary,
                  fontSize: 21,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              const Text(
                'Live GPS tracking and geofencing will be connected here.',
                textAlign:
                    TextAlign.center,
                style:
                    TextStyle(
                  color:
                      AppTheme.textMuted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyTab() {
    return SingleChildScrollView(
      padding:
          const EdgeInsets.all(20),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 10,
          ),

          const Text(
            'Safety Center',
            style:
                TextStyle(
              color:
                  AppTheme.textPrimary,
              fontSize: 24,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          const Text(
            'Monitor your current safety status and nearby risks.',
            style:
                TextStyle(
              color:
                  AppTheme.textMuted,
              fontSize: 13,
            ),
          ),

          const SizedBox(
            height: 22,
          ),

          _safetyTile(
            icon:
                Icons.shield_rounded,
            title:
                'Current Risk',
            value:
                'Low Risk',
            color:
                AppTheme.secondary,
          ),

          const SizedBox(
            height: 12,
          ),

          _safetyTile(
            icon:
                Icons.location_on_rounded,
            title:
                'Geofence Status',
            value:
                'Safe Zone',
            color:
                AppTheme.secondary,
          ),

          const SizedBox(
            height: 12,
          ),

          _safetyTile(
            icon:
                Icons.warning_amber_rounded,
            title:
                'Nearby Alerts',
            value:
                'No active alerts',
            color:
                AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _safetyTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return AppCard(
      child:
          Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration:
                BoxDecoration(
              color:
                  color.withValues(
                alpha: 0.12,
              ),
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            child:
                Icon(
              icon,
              color:
                  color,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(
                    color:
                        AppTheme.textMuted,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  value,
                  style:
                      const TextStyle(
                    color:
                        AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}