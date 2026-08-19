import 'package:flutter/material.dart';

import '../../core/services/trip_service.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/models/trip_model.dart';
import '../../shared/widgets/app_app_bar.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';

class CreateTripScreen extends StatefulWidget {
  final bool isEditing;

  const CreateTripScreen({
    super.key,
    this.isEditing = false,
  });

  @override
  State<CreateTripScreen> createState() =>
      _CreateTripScreenState();
}

class _CreateTripScreenState
    extends State<CreateTripScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController _startController =
      TextEditingController();

  final TextEditingController _destinationController =
      TextEditingController();

  final TextEditingController _notesController =
      TextEditingController();

  DateTime? _selectedDate;

  TimeOfDay? _selectedTime;

  int _travellers = 1;

  bool _shareLocation = true;

  bool _safeRoute = true;

  bool _riskAlerts = true;

  String _emergencyContact =
      'Emergency Contact';

  @override
  void initState() {
    super.initState();

    if (widget.isEditing) {
      _loadExistingTrip();
    }
  }

  @override
  void dispose() {
    _startController.dispose();
    _destinationController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  // ============================================================
  // LOAD EXISTING TRIP
  // ============================================================

  void _loadExistingTrip() {
    final TripModel? trip =
        TripService.instance.currentTrip;

    if (trip == null) {
      return;
    }

    _startController.text =
        trip.startLocation;

    _destinationController.text =
        trip.destination;

    _notesController.text =
        trip.notes;

    _selectedDate =
        trip.date;

    _selectedTime =
        _parseTime(trip.startTime);

    _travellers =
        trip.travellers;

    _emergencyContact =
        trip.emergencyContact;

    _shareLocation =
        trip.shareLocation;

    _safeRoute =
        trip.safeRoute;

    _riskAlerts =
        trip.riskAlerts;
  }

  // ============================================================
  // PARSE TIME
  // ============================================================

  TimeOfDay? _parseTime(
    String value,
  ) {
    try {
      final List<String> parts =
          value.trim().split(' ');

      if (parts.isEmpty) {
        return null;
      }

      final List<String> timeParts =
          parts[0].split(':');

      if (timeParts.length != 2) {
        return null;
      }

      int hour =
          int.parse(timeParts[0]);

      final int minute =
          int.parse(timeParts[1]);

      if (parts.length > 1) {
        final String period =
            parts[1].toUpperCase();

        if (period == 'PM' &&
            hour != 12) {
          hour += 12;
        }

        if (period == 'AM' &&
            hour == 12) {
          hour = 0;
        }
      }

      return TimeOfDay(
        hour: hour,
        minute: minute,
      );
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // SELECT DATE
  // ============================================================

  Future<void> _selectDate() async {
    final DateTime now =
        DateTime.now();

    DateTime initialDate =
        _selectedDate ?? now;

    if (initialDate.isBefore(now)) {
      initialDate = now;
    }

    final DateTime? picked =
        await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(
        now.year + 2,
        now.month,
        now.day,
      ),
    );

    if (picked == null || !mounted) {
      return;
    }

    setState(() {
      _selectedDate = picked;
    });
  }

  // ============================================================
  // SELECT TIME
  // ============================================================

  Future<void> _selectTime() async {
    final TimeOfDay? picked =
        await showTimePicker(
      context: context,
      initialTime:
          _selectedTime ??
              TimeOfDay.now(),
    );

    if (picked == null || !mounted) {
      return;
    }

    setState(() {
      _selectedTime = picked;
    });
  }

  // ============================================================
  // SAVE TRIP
  // ============================================================

  Future<void> _saveTrip() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      _showMessage(
        'Please select a date.',
      );
      return;
    }

    if (_selectedTime == null) {
      _showMessage(
        'Please select a time.',
      );
      return;
    }

    final TripModel trip =
        TripModel(
      startLocation:
          _startController.text.trim(),

      destination:
          _destinationController.text.trim(),

      date:
          _selectedDate!,

      startTime:
          _selectedTime!.format(context),

      travellers:
          _travellers,

      emergencyContact:
          _emergencyContact,

      shareLocation:
          _shareLocation,

      safeRoute:
          _safeRoute,

      riskAlerts:
          _riskAlerts,

      notes:
          _notesController.text.trim(),
    );

    if (widget.isEditing) {
      await TripService.instance.updateTrip(
        trip,
      );
    } else {
      await TripService.instance.saveTrip(
        trip,
      );
    }

    if (!mounted) {
      return;
    }

    _showSuccessDialog();
  }

  // ============================================================
  // SUCCESS DIALOG
  // ============================================================

  void _showSuccessDialog() {
    final String title =
        widget.isEditing
            ? 'Trip Updated'
            : 'Trip Created';

    final String message =
        widget.isEditing
            ? 'Your trip has been updated successfully.'
            : 'Your trip has been created successfully.';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              AppTheme.surface,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
          ),

          content:
              Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration:
                    BoxDecoration(
                  color: AppTheme
                      .secondary
                      .withValues(
                    alpha: 0.12,
                  ),
                  shape:
                      BoxShape.circle,
                ),
                child:
                    const Icon(
                  Icons.check_rounded,
                  color:
                      AppTheme.secondary,
                  size: 44,
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              Text(
                title,
                style:
                    const TextStyle(
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

              Text(
                message,
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  color:
                      AppTheme.textMuted,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );

                Navigator.pop(
                  context,
                  true,
                );
              },
              child:
                  const Text(
                'Done',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

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

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          AppTheme.background,

      appBar: AppAppBar(
        title:
            widget.isEditing
                ? 'Edit Trip'
                : 'Create Trip',
        showBackButton: true,
      ),

      body:
          SafeArea(
        child:
            Form(
          key: _formKey,

          child:
              SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(),

            padding:
                const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              30,
            ),

            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .stretch,

              children: [
                _buildHeader(),

                const SizedBox(
                  height: 24,
                ),

                const Text(
                  'Trip Location',
                  style:
                      TextStyle(
                    color:
                        AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                AppCard(
                  child:
                      Column(
                    children: [
                      TextFormField(
                        controller:
                            _startController,
                        style:
                            const TextStyle(
                          color:
                              AppTheme.textPrimary,
                        ),
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Starting Point',
                          hintText:
                              'Enter starting location',
                          prefixIcon:
                              Icon(
                            Icons
                                .my_location_rounded,
                            color:
                                AppTheme.secondary,
                          ),
                        ),
                        validator:
                            (value) {
                          if (value ==
                                  null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return 'Enter starting point';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      TextFormField(
                        controller:
                            _destinationController,
                        style:
                            const TextStyle(
                          color:
                              AppTheme.textPrimary,
                        ),
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Destination',
                          hintText:
                              'Where are you going?',
                          prefixIcon:
                              Icon(
                            Icons
                                .location_on_rounded,
                            color:
                                AppTheme.primary,
                          ),
                        ),
                        validator:
                            (value) {
                          if (value ==
                                  null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return 'Enter destination';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),

                const Text(
                  'Trip Schedule',
                  style:
                      TextStyle(
                    color:
                        AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Row(
                  children: [
                    Expanded(
                      child:
                          _dateTimeCard(
                        icon: Icons
                            .calendar_month_rounded,
                        title:
                            'Date',
                        value:
                            _dateText(),
                        onTap:
                            _selectDate,
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child:
                          _dateTimeCard(
                        icon: Icons
                            .access_time_rounded,
                        title:
                            'Start Time',
                        value:
                            _timeText(),
                        onTap:
                            _selectTime,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 24,
                ),

                const Text(
                  'Travellers',
                  style:
                      TextStyle(
                    color:
                        AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                _travellerCard(),

                const SizedBox(
                  height: 24,
                ),

                const Text(
                  'Emergency Contact',
                  style:
                      TextStyle(
                    color:
                        AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                AppCard(
                  child:
                      DropdownButtonFormField<
                          String>(
                    initialValue:
                        _emergencyContact,

                    dropdownColor:
                        AppTheme.surface,

                    style:
                        const TextStyle(
                      color:
                          AppTheme.textPrimary,
                    ),

                    decoration:
                        const InputDecoration(
                      prefixIcon:
                          Icon(
                        Icons
                            .contact_emergency_outlined,
                        color:
                            AppTheme.secondary,
                      ),
                    ),

                    items: const [
                      DropdownMenuItem(
                        value:
                            'Emergency Contact',
                        child: Text(
                          'Emergency Contact',
                        ),
                      ),
                      DropdownMenuItem(
                        value:
                            'Family Member',
                        child: Text(
                          'Family Member',
                        ),
                      ),
                      DropdownMenuItem(
                        value:
                            'Friend',
                        child: Text(
                          'Friend',
                        ),
                      ),
                    ],

                    onChanged:
                        (value) {
                      if (value ==
                          null) {
                        return;
                      }

                      setState(() {
                        _emergencyContact =
                            value;
                      });
                    },
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),

                const Text(
                  'Safety Preferences',
                  style:
                      TextStyle(
                    color:
                        AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                _safetyCard(),

                const SizedBox(
                  height: 24,
                ),

                const Text(
                  'Additional Notes',
                  style:
                      TextStyle(
                    color:
                        AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                TextFormField(
                  controller:
                      _notesController,
                  maxLines: 4,
                  style:
                      const TextStyle(
                    color:
                        AppTheme.textPrimary,
                    fontSize: 13,
                  ),
                  decoration:
                      const InputDecoration(
                    hintText:
                        'Add any additional information...',
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                AppButton(
                  text:
                      widget.isEditing
                          ? 'Save Changes'
                          : 'Create Trip',

                  icon:
                      widget.isEditing
                          ? Icons.save_rounded
                          : Icons
                              .add_location_alt_rounded,

                  onPressed:
                      _saveTrip,
                ),

                const SizedBox(
                  height: 14,
                ),

                Text(
                  widget.isEditing
                      ? 'Update your trip details and save the changes.'
                      : 'Your safety preferences will be used during your trip.',
                  textAlign:
                      TextAlign.center,
                  style:
                      const TextStyle(
                    color:
                        AppTheme.textMuted,
                    fontSize: 10.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      padding:
          const EdgeInsets.all(20),

      decoration:
          BoxDecoration(
        gradient:
            LinearGradient(
          colors: [
            AppTheme.primary
                .withValues(
              alpha: 0.18,
            ),
            AppTheme.secondary
                .withValues(
              alpha: 0.08,
            ),
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        border: Border.all(
          color:
              AppTheme.primary
                  .withValues(
            alpha: 0.18,
          ),
        ),
      ),

      child:
          Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration:
                BoxDecoration(
              color: AppTheme
                  .primary
                  .withValues(
                alpha: 0.15,
              ),
              shape:
                  BoxShape.circle,
            ),
            child:
                Icon(
              widget.isEditing
                  ? Icons.edit_rounded
                  : Icons
                      .travel_explore_rounded,
              color:
                  AppTheme.secondary,
              size: 31,
            ),
          ),

          const SizedBox(
            width: 15,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  widget.isEditing
                      ? 'Update Your Journey'
                      : 'Plan Your Journey',
                  style:
                      const TextStyle(
                    color:
                        AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  widget.isEditing
                      ? 'Update your trip details and save the changes.'
                      : 'Create a trip and let us help keep you safe.',
                  style:
                      const TextStyle(
                    color:
                        AppTheme.textMuted,
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

  // ============================================================
  // DATE TIME CARD
  // ============================================================

  Widget _dateTimeCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap:
          onTap,
      borderRadius:
          BorderRadius.circular(
        16,
      ),

      child:
          AppCard(
        padding:
            const EdgeInsets.all(
          14,
        ),

        child:
            Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color:
                      AppTheme.secondary,
                  size: 20,
                ),

                const SizedBox(
                  width: 7,
                ),

                Text(
                  title,
                  style:
                      const TextStyle(
                    color:
                        AppTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              value,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style:
                  const TextStyle(
                color:
                    AppTheme.textPrimary,
                fontSize: 12,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TRAVELLER CARD
  // ============================================================

  Widget _travellerCard() {
    return AppCard(
      child:
          Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration:
                BoxDecoration(
              color: AppTheme
                  .primary
                  .withValues(
                alpha: 0.12,
              ),
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            child:
                const Icon(
              Icons.groups_rounded,
              color:
                  AppTheme.secondary,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          const Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  'Number of Travellers',
                  style:
                      TextStyle(
                    color:
                        AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Text(
                  'People travelling with you',
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

          _counterButton(
            icon:
                Icons.remove,
            onPressed:
                _travellers > 1
                    ? () {
                        setState(() {
                          _travellers--;
                        });
                      }
                    : null,
          ),

          Padding(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 14,
            ),
            child:
                Text(
              '$_travellers',
              style:
                  const TextStyle(
                color:
                    AppTheme.textPrimary,
                fontSize: 16,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),

          _counterButton(
            icon:
                Icons.add,
            onPressed:
                _travellers < 20
                    ? () {
                        setState(() {
                          _travellers++;
                        });
                      }
                    : null,
          ),
        ],
      ),
    );
  }

  Widget _counterButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap:
          onPressed,
      borderRadius:
          BorderRadius.circular(
        10,
      ),

      child:
          Container(
        width: 34,
        height: 34,

        decoration:
            BoxDecoration(
          color: AppTheme
              .primary
              .withValues(
            alpha: 0.12,
          ),
          borderRadius:
              BorderRadius.circular(
            10,
          ),
        ),

        child:
            Icon(
          icon,
          color:
              onPressed == null
                  ? AppTheme.textMuted
                  : AppTheme.secondary,
          size: 18,
        ),
      ),
    );
  }

  // ============================================================
  // SAFETY CARD
  // ============================================================

  Widget _safetyCard() {
    return AppCard(
      padding:
          EdgeInsets.zero,

      child:
          Column(
        children: [
          _safetyOption(
            icon:
                Icons.location_on_outlined,
            title:
                'Share Live Location',
            subtitle:
                'Allow trusted contacts to track your trip',
            value:
                _shareLocation,
            onChanged:
                (value) {
              setState(() {
                _shareLocation =
                    value;
              });
            },
          ),

          const Divider(
            color:
                Colors.white12,
            height: 1,
          ),

          _safetyOption(
            icon:
                Icons.route_outlined,
            title:
                'Safe Route',
            subtitle:
                'Prefer routes with lower safety risks',
            value:
                _safeRoute,
            onChanged:
                (value) {
              setState(() {
                _safeRoute =
                    value;
              });
            },
          ),

          const Divider(
            color:
                Colors.white12,
            height: 1,
          ),

          _safetyOption(
            icon:
                Icons.warning_amber_outlined,
            title:
                'Risk Alerts',
            subtitle:
                'Receive alerts when entering danger zones',
            value:
                _riskAlerts,
            onChanged:
                (value) {
              setState(() {
                _riskAlerts =
                    value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _safetyOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding:
          const EdgeInsets
              .symmetric(
        horizontal: 16,
        vertical: 7,
      ),

      leading:
          Container(
        width: 42,
        height: 42,

        decoration:
            BoxDecoration(
          color: AppTheme
              .primary
              .withValues(
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
              AppTheme.secondary,
          size: 21,
        ),
      ),

      title:
          Text(
        title,
        style:
            const TextStyle(
          color:
              AppTheme.textPrimary,
          fontSize: 13,
          fontWeight:
              FontWeight.w700,
        ),
      ),

      subtitle:
          Text(
        subtitle,
        style:
            const TextStyle(
          color:
              AppTheme.textMuted,
          fontSize: 10.5,
        ),
      ),

      trailing:
          Switch(
        value:
            value,
        activeThumbColor:
            AppTheme.secondary,
        onChanged:
            onChanged,
      ),
    );
  }

  // ============================================================
  // DATE TEXT
  // ============================================================

  String _dateText() {
    if (_selectedDate == null) {
      return 'Select date';
    }

    return '${_selectedDate!.day.toString().padLeft(2, '0')}/'
        '${_selectedDate!.month.toString().padLeft(2, '0')}/'
        '${_selectedDate!.year}';
  }

  // ============================================================
  // TIME TEXT
  // ============================================================

  String _timeText() {
    if (_selectedTime == null) {
      return 'Select time';
    }

    return _selectedTime!.format(
      context,
    );
  }
}