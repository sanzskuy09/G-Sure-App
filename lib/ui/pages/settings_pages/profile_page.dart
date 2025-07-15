// import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/pages/not_found_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFILE'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // Section for Profile Picture, Name, and Job Title
          Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: whiteColor,
                  child: Icon(Icons.person, color: primaryColor, size: 50),
                ),
                const SizedBox(height: 10),
                Text(
                  'Salman AF',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                // --- Job Title ---
                const Text(
                  'CMO - Consumer Finance',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Divider(thickness: 1),
          const SizedBox(height: 20),

          // Section for Profile Details
          _buildInfoCard(
            title: 'Profile Information',
            children: [
              _buildInfoTile(Icons.person_outline, 'Username', 'salmanaf'),
              _buildInfoTile(
                  Icons.email_outlined, 'Email', 'salman.af@example.com'),
              _buildInfoTile(Icons.location_city_outlined, 'City', 'Jakarta'),
            ],
          ),

          const SizedBox(height: 20),

          // Section for Office Location
          _buildInfoCard(
            title: 'Work Information',
            children: [
              _buildInfoTile(Icons.work_outline, 'Office Location',
                  'Jl. Jenderal Sudirman Kav. 52-53, Jakarta Selatan'),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// A helper widget to create a styled card for information sections.
  Widget _buildInfoCard(
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  /// A helper widget to create a consistent list tile for profile information.
  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }
}
