import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gsure/blocs/auth/auth_bloc.dart';
import 'package:gsure/services/backup_restore_service.dart';
import 'package:gsure/shared/theme.dart';
import 'package:hive/hive.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _backupService = BackupRestoreService1();

  void _resetDataHiveTEmp() async {
    // await Hive.deleteBoxFromDisk('konsumen');
    // await Hive.deleteFromDisk();
  }

  Future<void> clearAllStorage() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    final data = await storage.readAll();
    print('Storage setelah logout: $data');
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Tutup dialog
              await clearAllStorage(); // Hapus token
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (_) => false);
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  // TERIMA context sebagai parameter
  void _doBackup(BuildContext context) {
    // TODO: Tambahkan logika untuk MEM-BACKUP data Anda di sini
    print('Melakukan proses backup...');

    // Sekarang 'context' sudah terdefinisi dan bisa digunakan
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Backup berhasil!')),
    );
  }

// TERIMA context sebagai parameter
  void _doRestore(BuildContext context) {
    // TODO: Tambahkan logika untuk ME-RESTORE data Anda di sini
    print('Melakukan proses restore...');

    // Sekarang 'context' sudah terdefinisi dan bisa digunakan
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Restore berhasil!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showBackupRestoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text('Manajemen Data', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.cloud_upload_outlined),
                title: const Text('Backup Data'),
                subtitle: const Text('Simpan data ke folder Download'),
                onTap: () async {
                  Navigator.pop(dialogContext); // Tutup dialog dulu

                  // Panggil fungsi backup
                  final bool success = await _backupService.backup(context);

                  // Peringatan: Selalu cek 'mounted' sebelum menggunakan context setelah await
                  if (!context.mounted) return;

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Backup Berhasil!'),
                          backgroundColor: Colors.green),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Backup Gagal! Cek log.'),
                          backgroundColor: Colors.red),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.cloud_download_outlined),
                title: const Text('Restore Data'),
                subtitle: const Text('Pulihkan data dari file backup'),
                onTap: () async {
                  Navigator.pop(dialogContext); // Tutup dialog

                  // Panggil fungsi restore
                  final bool success = await _backupService.restore(context);

                  if (!context.mounted) return;

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Restore Berhasil! Silakan restart aplikasi.'),
                          backgroundColor: Colors.green),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Restore Gagal! Cek log.'),
                          backgroundColor: Colors.red),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

// Ubah fungsi _backupDataHiveTemp menjadi seperti ini
  void _backupDataHiveTemp(BuildContext context) {
    showDialog(
      context: context,
      // Menggunakan barrierDismissible: false agar dialog tidak tertutup saat area luar diketuk
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          // Membuat sudut dialog menjadi membulat
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text(
            'Manajemen Data',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // Menggunakan content untuk meletakkan widget custom
          content: Column(
            // Ukuran dialog akan menyesuaikan kontennya
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(
                color: redColor,
              ), // Garis pemisah
              ListTile(
                leading: Icon(Icons.cloud_upload_outlined,
                    color: Theme.of(context).primaryColor),
                title: const Text('Backup Data'),
                subtitle: const Text('Simpan data Anda ke lokal'),
                onTap: () {
                  Navigator.pop(dialogContext);
                  _doBackup(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.cloud_download_outlined,
                    color: Theme.of(context).colorScheme.secondary),
                title: const Text('Restore Data'),
                subtitle: const Text('Pulihkan data dari lokal'),
                onTap: () {
                  Navigator.pop(dialogContext);
                  _doRestore(context);
                },
              ),
            ],
          ),
          // Anda bisa menambahkan tombol aksi jika perlu
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Menutup dialog
              },
            ),
          ],
        );
      },
    );
  }

  String capitalizeEachWord(String text) {
    return text
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: ListView(
        padding: EdgeInsets.only(top: 40),
        children: [
          SizedBox(
            height: 160,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                // ✅ 2. CEK APAKAH STATE ADALAH AUTHSUCCESS
                if (state is AuthSuccess) {
                  // Jika berhasil, tampilkan data user
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: whiteColor,
                        ),
                        child:
                            Icon(Icons.person, color: primaryColor, size: 30),
                      ),
                      const SizedBox(height: 10),
                      // ✅ 3. AMBIL NAMA DINAMIS DARI STATE
                      Text(
                        capitalizeEachWord(state.user.name ??
                            'Nama Tidak Tersedia'), // Ganti di sini
                        style: whiteTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: semiBold,
                        ),
                      ),
                      // Anda juga bisa mengganti role jika ada di model
                      Text(
                        state.user.role?.toUpperCase() ??
                            'Jabatan', // Ganti juga di sini
                        style: whiteTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: medium,
                        ),
                      ),
                    ],
                  );
                }

                // ✅ 4. TAMPILKAN LOADING JIKA STATE BELUM SIAP
                // Ini akan ditampilkan saat AuthCheckStatus berjalan
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          // SizedBox(height: 20),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 160 - 40 - 70,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "GENERAL",
                    style: greyTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                  // Menu Item: GENERAL
                  listButton(
                    icon: Icons.person_outline,
                    label: 'Profile',
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  // listButton(
                  //   icon: Icons.person_outline,
                  //   label: 'Contoh List',
                  //   onTap: () {
                  //     Navigator.pushNamed(context, '/list-sruvey');
                  //   },
                  // ),
                  listButton(
                    icon: Icons.history,
                    label: 'Log',
                    onTap: () {
                      Navigator.pushNamed(context, '/log');
                    },
                  ),

                  const SizedBox(height: 20),
                  Text(
                    "OTHERS",
                    style: greyTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                  // MENU ITEM : OTHER
                  // listButton(
                  //     icon: Icons.sync,
                  //     label: 'Synchronize',
                  //     onTap: _resetDataHiveTEmp),
                  listButton(
                    icon: Icons.sync,
                    label: 'Backup/Restore',
                    // onTap: () => _backupDataHiveTemp(context),
                    onTap: () => _showBackupRestoreDialog(context),
                  ),
                  listButton(
                    icon: Icons.info_outline,
                    label: 'About',
                    onTap: () {
                      Navigator.pushNamed(context, '/about');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: errorColor,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        color: errorColor,
                        fontWeight: semiBold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: errorColor,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 2),
                    onTap: () {
                      // Navigator.pushNamedAndRemoveUntil(
                      //   context,
                      //   '/login',
                      //   (_) => false,
                      // );
                      _showLogoutDialog(context);
                    }, // Action here
                  ),
                  Divider(height: 1, color: lightBackgorundColor),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget listButton({
    required IconData icon,
    required String label,
    void Function()? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          // leading: Icon(Icons.info_outlined),
          leading: Icon(icon),
          title: Text(label),
          trailing: Icon(Icons.chevron_right),
          contentPadding: EdgeInsets.symmetric(vertical: 2),
          onTap: onTap, // Action here
        ),
        Divider(height: 1, color: lightBackgorundColor),
      ],
    );
  }
}
