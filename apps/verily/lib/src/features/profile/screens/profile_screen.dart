import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// User profile screen following iOS design guidelines.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Profile avatar
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: CupertinoColors.systemGrey5,
                      child: Icon(
                        CupertinoIcons.person_fill,
                        size: 60,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // User name
                    const Text(
                      'John Appleseed',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Email
                    const Text(
                      'john.appleseed@example.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Edit profile button
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: CupertinoColors.systemBlue),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(color: CupertinoColors.systemBlue),
                        ),
                      ),
                      onPressed: () {
                        // Handle edit profile
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Profile options
            SliverToBoxAdapter(child: _buildSectionHeader('Account')),
            SliverToBoxAdapter(
              child: _buildListSection([
                _buildListTile(
                  icon: CupertinoIcons.person,
                  title: 'Personal Information',
                  onTap: () {},
                ),
                _buildListTile(
                  icon: CupertinoIcons.bell,
                  title: 'Notifications',
                  onTap: () {},
                ),
                _buildListTile(
                  icon: CupertinoIcons.lock,
                  title: 'Privacy',
                  onTap: () {},
                ),
              ]),
            ),

            SliverToBoxAdapter(child: _buildSectionHeader('App')),
            SliverToBoxAdapter(
              child: _buildListSection([
                _buildListTile(
                  icon: CupertinoIcons.gear,
                  title: 'Settings',
                  onTap: () {
                    context.go('/settings');
                  },
                ),
                _buildListTile(
                  icon: CupertinoIcons.question_circle,
                  title: 'Help & Support',
                  onTap: () {},
                ),
                _buildListTile(
                  icon: CupertinoIcons.info,
                  title: 'About',
                  onTap: () {},
                ),
              ]),
            ),

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
                    'Sign Out',
                    style: TextStyle(
                      color: CupertinoColors.systemRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    // Handle sign out
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
        title,
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
}
