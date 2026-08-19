import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/services/location_service.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_app_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  LatLng? _currentLocation;

  bool _loading = true;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _loadLocation();
  }

  Future<void> _loadLocation() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final position =
          await LocationService.instance
              .getCurrentLocation();

      if (!mounted) {
        return;
      }

      setState(() {
        _currentLocation = LatLng(
          position.latitude,
          position.longitude,
        );

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

  void _moveToCurrentLocation() {
    if (_currentLocation == null) {
      return;
    }

    _mapController.move(
      _currentLocation!,
      16,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppTheme.background,

      appBar: const AppAppBar(
        title: 'Safety Map',
        showBackButton: true,
      ),

      body: Stack(
        children: [
          _buildMap(),

          if (_loading)
            _buildLoading(),

          if (_errorMessage != null &&
              !_loading)
            _buildError(),

          if (_currentLocation != null &&
              !_loading)
            _buildLocationCard(),

          if (_currentLocation != null &&
              !_loading)
            _buildMyLocationButton(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    final location =
        _currentLocation ??
        const LatLng(
          11.0168,
          76.9558,
        );

    return FlutterMap(
      mapController:
          _mapController,

      options:
          MapOptions(
        initialCenter:
            location,

        initialZoom:
            16,

        minZoom:
            3,

        maxZoom:
            19,
      ),

      children: [
        TileLayer(
          urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

          userAgentPackageName:
              'com.example.mobile_app',
        ),

        if (_currentLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point:
                    _currentLocation!,

                width: 60,

                height: 60,

                child:
                    _buildLocationMarker(),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildLocationMarker() {
    return Container(
      decoration:
          BoxDecoration(
        shape:
            BoxShape.circle,

        color:
            AppTheme.secondary,

        border:
            Border.all(
          color:
              Colors.white,

          width: 4,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.25,
            ),

            blurRadius:
                8,
          ),
        ],
      ),

      child:
          const Icon(
        Icons.person_rounded,
        color:
            Colors.white,
        size: 28,
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child:
          Card(
        child:
            Padding(
          padding:
              EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 18,
          ),

          child:
              Row(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              SizedBox(
                width: 22,
                height: 22,

                child:
                    CircularProgressIndicator(
                  strokeWidth: 2.5,
                ),
              ),

              SizedBox(
                width: 14,
              ),

              Text(
                'Getting location...',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child:
          Container(
        margin:
            const EdgeInsets.all(24),

        padding:
            const EdgeInsets.all(20),

        decoration:
            BoxDecoration(
          color:
              AppTheme.surface,

          borderRadius:
              BorderRadius.circular(
            18,
          ),
        ),

        child:
            Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            const Icon(
              Icons.location_off_rounded,

              color:
                  AppTheme.sos,

              size:
                  45,
            ),

            const SizedBox(
              height: 12,
            ),

            const Text(
              'Unable to get location',

              style:
                  TextStyle(
                color:
                    AppTheme.textPrimary,

                fontSize:
                    17,

                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              _errorMessage ??
                  'Please check GPS permission.',

              textAlign:
                  TextAlign.center,

              style:
                  const TextStyle(
                color:
                    AppTheme.textMuted,

                fontSize:
                    12,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            ElevatedButton.icon(
              onPressed:
                  _loadLocation,

              icon:
                  const Icon(
                Icons.refresh_rounded,
              ),

              label:
                  const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    final location =
        _currentLocation!;

    return Positioned(
      top:
          16,

      left:
          16,

      right:
          16,

      child:
          Container(
        padding:
            const EdgeInsets.all(14),

        decoration:
            BoxDecoration(
          color:
              AppTheme.surface,

          borderRadius:
              BorderRadius.circular(
            16,
          ),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(
                alpha: 0.18,
              ),

              blurRadius:
                  10,

              offset:
                  const Offset(
                0,
                4,
              ),
            ),
          ],
        ),

        child:
            Row(
          children: [
            Container(
              width:
                  44,

              height:
                  44,

              decoration:
                  BoxDecoration(
                color:
                    AppTheme.secondary
                        .withValues(
                  alpha: 0.12,
                ),

                shape:
                    BoxShape.circle,
              ),

              child:
                  const Icon(
                Icons
                    .my_location_rounded,

                color:
                    AppTheme.secondary,
              ),
            ),

            const SizedBox(
              width:
                  12,
            ),

            Expanded(
              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Your Current Location',

                    style:
                        TextStyle(
                      color:
                          AppTheme.textPrimary,

                      fontSize:
                          14,

                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  const SizedBox(
                    height:
                        4,
                  ),

                  Text(
                    '${location.latitude.toStringAsFixed(6)}, '
                    '${location.longitude.toStringAsFixed(6)}',

                    style:
                        const TextStyle(
                      color:
                          AppTheme.textMuted,

                      fontSize:
                          11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyLocationButton() {
    return Positioned(
      right:
          16,

      bottom:
          25,

      child:
          FloatingActionButton(
        heroTag:
            'my_location_button',

        onPressed:
            _moveToCurrentLocation,

        backgroundColor:
            AppTheme.secondary,

        child:
            const Icon(
          Icons.my_location_rounded,

          color:
              Colors.white,
        ),
      ),
    );
  }
}