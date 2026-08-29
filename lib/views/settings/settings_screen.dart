import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _projAlerts = true;
  bool _attAlerts = true;
  bool _matAlerts = true;
  bool _expAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text('Manage company preferences, admin credentials, and automated notifications.', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),

            // Company Profile Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Company Details', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: 'ZoomerCode Constructions Pvt. Ltd.',
                          decoration: const InputDecoration(labelText: 'Company Name'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: '+91 98765 43210',
                          decoration: const InputDecoration(labelText: 'Phone'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: 'info@zooomercode.com',
                          decoration: const InputDecoration(labelText: 'Company Email'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: '1st Floor, ZoomerCode Building, Kakkanad, Kochi',
                          decoration: const InputDecoration(labelText: 'Address'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Notifications & Preferences Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notification Alerts', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                  SwitchListTile(
                    title: const Text('Project Delay & Milestone Alerts'),
                    value: _projAlerts,
                    onChanged: (val) => setState(() => _projAlerts = val),
                  ),
                  SwitchListTile(
                    title: const Text('Attendance Check-In & Verification Alerts'),
                    value: _attAlerts,
                    onChanged: (val) => setState(() => _attAlerts = val),
                  ),
                  SwitchListTile(
                    title: const Text('Low Material Stock Reorder Alerts'),
                    value: _matAlerts,
                    onChanged: (val) => setState(() => _matAlerts = val),
                  ),
                  SwitchListTile(
                    title: const Text('Expense Overbudget & Approval Requests'),
                    value: _expAlerts,
                    onChanged: (val) => setState(() => _expAlerts = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved successfully!')));
                  },
                  child: const Text('Save Settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
