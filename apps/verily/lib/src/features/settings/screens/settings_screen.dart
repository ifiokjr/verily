import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iOS-style settings screen following Apple Human Interface Guidelines.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _locationEnabled = true;
  double _textSize = 1.0;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Appearance Section
            SliverToBoxAdapter(child: _buildSectionHeader('Appearance')),
            SliverToBoxAdapter(
              child: _buildListSection([
                _buildSwitchTile(
                  icon: CupertinoIcons.moon_fill,
                  title: 'Dark Mode',
                  value: _darkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      _darkModeEnabled = value;
                    });
                  },
                ),
                _buildSliderTile(
                  icon: CupertinoIcons.textformat_size,
                  title: 'Text Size',
                  value: _textSize,
                  min: 0.8,
                  max: 1.5,
                  onChanged: (value) {
                    setState(() {
                      _textSize = value;
                    });
                  },
                ),
                _buildPickerTile(
                  icon: CupertinoIcons.globe,
                  title: 'Language',
                  value: _selectedLanguage,
                  onTap: () {
                    _showLanguagePicker();
                  },
                ),
              ]),
            ),

            // Privacy Section
            SliverToBoxAdapter(child: _buildSectionHeader('Privacy')),
            SliverToBoxAdapter(
              child: _buildListSection([
                _buildSwitchTile(
                  icon: CupertinoIcons.location_fill,
                  title: 'Location Services',
                  value: _locationEnabled,
                  onChanged: (value) {
                    setState(() {
                      _locationEnabled = value;
                    });
                  },
                ),
                _buildListTile(
                  icon: CupertinoIcons.hand_raised_fill,
                  title: 'Privacy Policy',
                  onTap: () {
                    // Navigate to privacy policy
                  },
                ),
                _buildListTile(
                  icon: CupertinoIcons.doc_text_fill,
                  title: 'Terms of Service',
                  onTap: () {
                    // Navigate to terms of service
                  },
                ),
              ]),
            ),

            // Notifications Section
            SliverToBoxAdapter(child: _buildSectionHeader('Notifications')),
            SliverToBoxAdapter(
              child: _buildListSection([
                _buildSwitchTile(
                  icon: CupertinoIcons.bell_fill,
                  title: 'Push Notifications',
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
              ]),
            ),

            // About Section
            SliverToBoxAdapter(child: _buildSectionHeader('About')),
            SliverToBoxAdapter(
              child: _buildListSection([
                _buildListTile(
                  icon: CupertinoIcons.info_circle_fill,
                  title: 'App Version',
                  trailing: const Text(
                    '1.0.0',
                    style: TextStyle(
                      color: CupertinoColors.secondaryLabel,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {},
                ),
                _buildListTile(
                  icon: CupertinoIcons.star_fill,
                  title: 'Rate the App',
                  onTap: () {
                    // Open app store rating
                  },
                ),
                _buildListTile(
                  icon: CupertinoIcons.question_circle_fill,
                  title: 'Help & Support',
                  onTap: () {
                    // Navigate to help page
                  },
                ),
              ]),
            ),

            // Reset Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: CupertinoColors.systemRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  child: const Text(
                    'Reset All Settings',
                    style: TextStyle(
                      color: CupertinoColors.systemRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    _showResetConfirmation();
                  },
                ),
              ),
            ),

            // Bottom spacing
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.secondaryLabel,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildListSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 22, color: CupertinoColors.systemBlue),
              const SizedBox(width: 16),
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 16)),
              ),
              trailing ??
                  const Icon(
                    CupertinoIcons.chevron_right,
                    size: 18,
                    color: CupertinoColors.systemGrey,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 22, color: CupertinoColors.systemBlue),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: CupertinoColors.systemBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile({
    required IconData icon,
    required String title,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: CupertinoColors.systemBlue),
              const SizedBox(width: 16),
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 38, right: 8, top: 8),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.textformat_size,
                  size: 16,
                  color: CupertinoColors.systemGrey,
                ),
                Expanded(
                  child: CupertinoSlider(
                    value: value,
                    min: min,
                    max: max,
                    onChanged: onChanged,
                  ),
                ),
                const Icon(
                  CupertinoIcons.textformat_size,
                  size: 24,
                  color: CupertinoColors.systemGrey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 22, color: CupertinoColors.systemBlue),
              const SizedBox(width: 16),
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 16)),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: CupertinoColors.secondaryLabel,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                CupertinoIcons.chevron_right,
                size: 18,
                color: CupertinoColors.systemGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguagePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.only(top: 6.0),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const Divider(height: 0),
              Expanded(
                child: CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(
                    initialItem: [
                      'English',
                      'Spanish',
                      'French',
                      'German',
                      'Japanese',
                      'Chinese',
                    ].indexOf(_selectedLanguage),
                  ),
                  onSelectedItemChanged: (int selectedItem) {
                    setState(() {
                      _selectedLanguage =
                          [
                            'English',
                            'Spanish',
                            'French',
                            'German',
                            'Japanese',
                            'Chinese',
                          ][selectedItem];
                    });
                  },
                  children: [
                    for (var language in [
                      'English',
                      'Spanish',
                      'French',
                      'German',
                      'Japanese',
                      'Chinese',
                    ])
                      Center(
                        child: Text(
                          language,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showResetConfirmation() {
    showCupertinoDialog(
      context: context,
      builder:
          (BuildContext context) => CupertinoAlertDialog(
            title: const Text('Reset All Settings'),
            content: const Text(
              'Are you sure you want to reset all settings to default values? This action cannot be undone.',
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  setState(() {
                    _notificationsEnabled = true;
                    _darkModeEnabled = false;
                    _locationEnabled = true;
                    _textSize = 1.0;
                    _selectedLanguage = 'English';
                  });
                  Navigator.pop(context);
                },
                child: const Text('Reset'),
              ),
            ],
          ),
    );
  }
}
