import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/services/location_service.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_app_bar.dart';
import '../../shared/widgets/app_card.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({
    super.key,
  });

  @override
  State<LocationScreen> createState() =>
      _LocationScreenState();
}

class _LocationScreenState
    extends State<LocationScreen> {
  Position? _position;

  bool _loading = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    if (_loading) {
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final Position position =
          await LocationService.instance
              .getCurrentLocation();

      if (!mounted) {
        return;
      }

      setState(() {
        _position = position;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
        _errorMessage =
            e.toString().replaceFirst(
          'Exception: ',
          '',
        );
      });
    }
  }

  Future<void> _openLocationSettings() async {
    await LocationService.instance
        .openLocationSettings();
  }

  Future<void> _openAppSettings() async {
    await LocationService.instance
        .openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: const AppAppBar(
        title: 'Current Location',
        showBackButton: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),

          padding:
              const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),

              const SizedBox(height: 20),

              if (_loading)
                _buildLoading(),

              if (!_loading &&
                  _errorMessage != null)
                _buildError(),

              if (!_loading &&
                  _errorMessage == null &&
                  _position != null)
                _buildLocationDetails(),

              const SizedBox(height: 20),

              _buildRefreshButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(
                alpha: 0.12,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.my_location_rounded,
              color: AppTheme.secondary,
              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'GPS Location',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Get your current location for tourist safety monitoring.',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return AppCard(
      child: Column(
        children: [
          const SizedBox(height: 10),

          const CircularProgressIndicator(
            color: AppTheme.secondary,
          ),

          const SizedBox(height: 18),

          const Text(
            'Getting your current location...',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Please make sure GPS is enabled.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildError() {
    final bool permissionError =
        _errorMessage != null &&
        _errorMessage!.contains(
          'permanently denied',
        );

    return AppCard(
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppTheme.sos.withValues(
                alpha: 0.12,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_off_rounded,
              color: AppTheme.sos,
              size: 32,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Location unavailable',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            _errorMessage ??
                'Unable to get your location.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 18),

          if (permissionError)
            OutlinedButton.icon(
              onPressed: _openAppSettings,
              icon: const Icon(
                Icons.settings_rounded,
              ),
              label: const Text(
                'Open App Settings',
              ),
            )
          else
            OutlinedButton.icon(
              onPressed:
                  _openLocationSettings,
              icon: const Icon(
                Icons.gps_fixed_rounded,
              ),
              label: const Text(
                'Turn On GPS',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationDetails() {
    final Position position = _position!;

    return AppCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: AppTheme.secondary,
                size: 22,
              ),

              SizedBox(width: 8),

              Text(
                'Location detected',
                style: TextStyle(
                  color: AppTheme.secondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _coordinateRow(
            icon: Icons.north_rounded,
            title: 'Latitude',
            value:
                position.latitude
                    .toStringAsFixed(6),
          ),

          const SizedBox(height: 15),

          _coordinateRow(
            icon: Icons.east_rounded,
            title: 'Longitude',
            value:
                position.longitude
                    .toStringAsFixed(6),
          ),

          const SizedBox(height: 15),

          _coordinateRow(
            icon: Icons.gps_fixed_rounded,
            title: 'Accuracy',
            value:
                '${position.accuracy.toStringAsFixed(1)} metres',
          ),
        ],
      ),
    );
  }

  Widget _coordinateRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(
              alpha: 0.12,
            ),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.secondary,
            size: 20,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 10,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRefreshButton() {
    return SizedBox(
      height: 50,

      child: ElevatedButton.icon(
        onPressed:
            _loading ? null : _getLocation,

        icon: const Icon(
          Icons.refresh_rounded,
        ),

        label: Text(
          _loading
              ? 'Getting Location...'
              : 'Refresh Location',
        ),
      ),
    );
  }
}