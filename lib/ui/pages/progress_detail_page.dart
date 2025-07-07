import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gsure/models/survey_app_model.dart';
import 'package:gsure/shared/theme.dart';
import 'package:hive/hive.dart';

class ProgressDetailPage extends StatelessWidget {
  /// Key dari data yang akan ditampilkan, didapat dari halaman list
  final dynamic surveyKey;

  const ProgressDetailPage({
    super.key,
    required this.surveyKey,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil box Hive
    final box = Hive.box<AplikasiSurvey>('survey_apps');
    // Ambil objek survei spesifik menggunakan key
    final AplikasiSurvey? survey = box.get(surveyKey);

    // Tampilan jika karena suatu hal data tidak ditemukan
    if (survey == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Data survey tidak ditemukan.'),
        ),
      );
    }

    // Tampilan utama halaman detail
    return Scaffold(
      appBar: AppBar(
        title: const Text('DETAIL SURVEY'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // --- Bagian Data Dealer ---
            _buildSectionCard(
              title: 'Data Dealer',
              icon: Icons.store,
              children: [
                _buildDetailRow('Kode Dealer', survey.dataDealer?.kddealer),
                _buildDetailRow('Nama Dealer', survey.dataDealer?.namadealer),
                _buildDetailRow(
                    'Alamat',
                    survey.dataDealer?.alamatdealer != null
                        ? '${survey.dataDealer?.alamatdealer} RT ${survey.dataDealer?.rtdealer}/RW ${survey.dataDealer?.rwdealer}, KEL. ${survey.dataDealer?.keldealer}, KEC. ${survey.dataDealer?.kecdealer}, KOTA ${survey.dataDealer?.kotadealer}, ${survey.dataDealer?.provinsidealer} ${survey.dataDealer?.kodeposdealer}'
                        : ''),
                _buildDetailRow('No. Telepon', survey.dataDealer?.telpondealer),
                _buildDetailRow(
                    'Nama Pemilik', survey.dataDealer?.namapemilikdealer),
                _buildDetailRow(
                    'No. HP Pemilik', survey.dataDealer?.nohppemilik),
                _buildDetailRow('PIC', survey.dataDealer?.picdealer),
              ],
            ),

            // --- Bagian Data Kendaraan ---
            _buildSectionCard(
              title: 'Data Kendaraan',
              icon: Icons.directions_car,
              children: [
                _buildDetailRow(
                    'Produk', survey.dataKendaraan?.kondisiKendaraan),
                _buildDetailRow('Merk', survey.dataKendaraan?.merkkendaraan),
                _buildDetailRow('Tipe', survey.dataKendaraan?.typekendaraan),
                _buildDetailRow('Tahun', survey.dataKendaraan?.tahunkendaraan),
                _buildDetailRow(
                    'No. Polisi', survey.dataKendaraan?.nopolisikendaraan),
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),
                _buildDetailRow('Harga Kendaraan',
                    'Rp ${survey.dataKendaraan?.hargakendaraan ?? 0}'),
                _buildDetailRow(
                    'Uang Muka', 'Rp ${survey.dataKendaraan?.uangmuka ?? 0}'),
                _buildDetailRow('Pokok Hutang',
                    'Rp ${survey.dataKendaraan?.pokokhutang ?? 0}'),
              ],
            ),

            // --- Bagian Data Alamat Survey ---
            _buildSectionCard(
              title: 'Data Alamat Survey',
              icon: Icons.location_on,
              children: [
                _buildDetailRow(
                    'Alamat Lengkap',
                    survey.dataAlamatSurvey?.alamatsurvey != null
                        ? '${survey.dataAlamatSurvey?.alamatsurvey} RT ${survey.dataAlamatSurvey?.rtsurvey}/RW ${survey.dataAlamatSurvey?.rwsurvey} KEL. ${survey.dataAlamatSurvey?.kelsurvey} KEC. ${survey.dataAlamatSurvey?.kecsurvey}, KOTA ${survey.dataAlamatSurvey?.kotasurvey} ${survey.dataAlamatSurvey?.provinsisurvey} ${survey.dataAlamatSurvey?.kodepoksurvey}'
                        : ''),
              ],
            ),

            // --- Bagian Data Pemohon ---
            _buildSectionCard(
              title: 'Data Pemohon',
              icon: Icons.person,
              children: [
                _buildDetailRow(
                    'Kategori Pemohon', survey.dataPemohon?.katpemohon),
                _buildDetailRow(
                    'Status Pernikahan', survey.dataPemohon?.statuspernikahan),
                _buildDetailRow('Nama Pemohon', survey.dataPemohon?.nama),
                _buildDetailRow('Agama', survey.dataPemohon?.agamapemohon),
                _buildDetailRow('Pendidikan', survey.dataPemohon?.pendidikan),
                _buildDetailRow(
                    'Kewarganegaraan', survey.dataPemohon?.warganegarapemohon),
                _buildDetailRow(
                    'No. Telepon', survey.dataPemohon?.nomortelepon),
                _buildDetailRow('No. HP', survey.dataPemohon?.nohp),
                _buildDetailRow('Email', survey.dataPemohon?.email),
                _buildDetailRow('SIM', survey.dataPemohon?.sim),
                _buildDetailRow('NPWP', survey.dataPemohon?.npwp),
                _buildDetailRow(
                    'Nama Ibu Kandung', survey.dataPemohon?.namaibu),
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),
                _buildDetailRow('Pekerjaan',
                    survey.dataPemohon?.dataPekerjaan?.jenispekerjaan),
                _buildDetailRow('Nama Perusahaan',
                    survey.dataPemohon?.dataPekerjaan?.namaperusahaan),
                _buildDetailRow(
                    'Jabatan', survey.dataPemohon?.dataPekerjaan?.jabatan),
                _buildDetailRow('Ket. Tambahan Jabatan',
                    survey.dataPemohon?.dataPekerjaan?.ketjabatan),
                _buildDetailRow('Alamat Perusahaan',
                    survey.dataPemohon?.dataPekerjaan?.alamatusaha),
                _buildDetailRow('Kode Pos',
                    survey.dataPemohon?.dataPekerjaan?.kodeposusaha),
                _buildDetailRow('No. Telepon',
                    survey.dataPemohon?.dataPekerjaan?.noteleponusaha),

                // --- Bagian Data Pekerjaan ---
                if (survey.dataPemohon?.dataPekerjaan?.jenispekerjaan ==
                    'WIRASWASTA') ...[
                  // bagian usahawan
                  _buildDetailRow('Bidang Usaha',
                      survey.dataPemohon?.dataPekerjaan?.bidangusahapemohon),
                  _buildDetailRow('Lama Usaha',
                      survey.dataPemohon?.dataPekerjaan?.lamausahapemohon),
                  _buildDetailRow('Omzet Usaha/bulan',
                      survey.dataPemohon?.dataPekerjaan?.omzetusahapemohon),
                  _buildDetailRow('Profit Usaha',
                      survey.dataPemohon?.dataPekerjaan?.profitusahapemohon),
                ] else ...[
                  // bagian karyawan
                  _buildDetailRow('Masa Kerja',
                      survey.dataPemohon?.dataPekerjaan?.masakerjapemohon),
                  _buildDetailRow('Penghasilan/bulan',
                      survey.dataPemohon?.dataPekerjaan?.gajipemohon),
                  _buildDetailRow('Slip Gaji',
                      survey.dataPemohon?.dataPekerjaan?.slipgajipemohon),
                  _buildDetailRow('Penghasilan di Payroll',
                      survey.dataPemohon?.dataPekerjaan?.payrollpemohon),
                ],
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),
                _buildDetailRow('Status Kepemilikan Tempat Tinggal',
                    survey.dataPemohon?.statusrumah),
                _buildDetailRow(
                    'Lokasi Rumah', survey.dataPemohon?.lokasirumah),
                _buildDetailRow('Kategori Tempat Tinggal',
                    survey.dataPemohon?.katrumahpemohon),
                _buildDetailRow('Bukti Kepemilikan Tempat Tinggal',
                    survey.dataPemohon?.buktimilikrumahpemohon),
                _buildDetailRow(
                    'Lama Tinggal', survey.dataPemohon?.lamatinggalpemohon),
              ],
            ),

            // --- Bagian Data Pasangan ---
            if (survey.dataPemohon?.statuspernikahan == 'MENIKAH')
              _buildSectionCard(
                title: 'Data Pasangan',
                icon: Icons.person,
                children: [
                  _buildDetailRow(
                      'Nama Pasangan', survey.dataPasangan?.namapasangan),
                  _buildDetailRow(
                      'Nama Panggilan', survey.dataPasangan?.namapanggilan),
                  _buildDetailRow('KTP', survey.dataPasangan?.ktppasangan),
                  _buildDetailRow('Agama', survey.dataPasangan?.agamapasangan),
                  _buildDetailRow('Kewarganegaraan',
                      survey.dataPasangan?.warganegarapasangan),
                  _buildDetailRow(
                      'No. Telepon', survey.dataPasangan?.notelppasangan),
                  _buildDetailRow('No. HP', survey.dataPasangan?.nohppasangan),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                      'Pekerjaan', survey.dataPasangan?.pekerjaanpasangan),
                  _buildDetailRow('Nama Perusahaan',
                      survey.dataPasangan?.namaperusahaanpasangan),
                  _buildDetailRow(
                      'Jabatan', survey.dataPasangan?.jabatanpasangan),
                  _buildDetailRow('Ket. Tambahan Jabatan',
                      survey.dataPasangan?.ketjabatanpasangan),
                  _buildDetailRow('Alamat Perusahaan',
                      survey.dataPasangan?.alamatusahapasangan),
                  _buildDetailRow('Kode Pos',
                      survey.dataPasangan?.kodeposperusahaanpasangan),
                  _buildDetailRow('No. Telepon',
                      survey.dataPasangan?.noteleponusahapasangan),

                  // --- Bagian Data Pekerjaan ---
                  if (survey.dataPasangan?.pekerjaanpasangan ==
                      'WIRASWASTA') ...[
                    // bagian usahawan
                    _buildDetailRow('Bidang Usaha',
                        survey.dataPasangan?.bidangusahapasangan),
                    _buildDetailRow(
                        'Lama Usaha', survey.dataPasangan?.lamausahapasangan),
                    _buildDetailRow('Omzet Usaha/bulan',
                        survey.dataPasangan?.omzetusahapasangan),
                    _buildDetailRow('Profit Usaha',
                        survey.dataPasangan?.profitusahapasangan),
                  ] else ...[
                    // bagian karyawan
                    _buildDetailRow(
                        'Masa Kerja', survey.dataPasangan?.masakerjapasangan),
                    _buildDetailRow(
                        'Penghasilan/bulan', survey.dataPasangan?.gajipasangan),
                    _buildDetailRow(
                        'Slip Gaji', survey.dataPasangan?.slipgajipasangan),
                    _buildDetailRow('Penghasilan di Payroll',
                        survey.dataPasangan?.payrollpasangan),
                  ],
                ],
              ),

            // --- Bagian Data Kontak Darurat ---
            _buildSectionCard(
              title: 'Data Kontak Darurat',
              icon: Icons.emergency,
              children: [
                _buildDetailRow('Nama', survey.dataKontakDarurat?.namakontak),
                _buildDetailRow('Jenis Kelamin',
                    survey.dataKontakDarurat?.jeniskelaminkontak),
                _buildDetailRow(
                    'Hubungan', survey.dataKontakDarurat?.hubungankeluarga),
                _buildDetailRow('No. HP', survey.dataKontakDarurat?.nohpkontak),
                _buildDetailRow(
                    'Alamat', survey.dataKontakDarurat?.alamatkontak),
                _buildDetailRow(
                    'Kode Pos', survey.dataKontakDarurat?.kodeposkontak),
              ],
            ),

            // --- Bagian Data Penjamin ---
            if (survey.isPenjaminExist == 'Ya')
              _buildSectionCard(
                title: 'Data Penjamin',
                icon: Icons.person,
                children: [
                  _buildDetailRow(
                      'Kategori Penjamin', survey.dataPenjamin?.jnspenjamin),
                  _buildDetailRow('Status Pernikahan',
                      survey.dataPenjamin?.statuspernikahanpenjamin),
                  _buildDetailRow(
                      'Nama Penjamin', survey.dataPenjamin?.namapenjamin),
                  _buildDetailRow('Agama', survey.dataPenjamin?.agamapenjamin),
                  _buildDetailRow('Kewarganegaraan',
                      survey.dataPenjamin?.warganegarapenjamin),
                  _buildDetailRow(
                      'No. Telepon', survey.dataPenjamin?.notelppenjamin),
                  _buildDetailRow('No. HP', survey.dataPenjamin?.nowapenjamin),
                  _buildDetailRow('KTP', survey.dataPenjamin?.ktppenjamin),
                  _buildDetailRow(
                      'Tanggal KTP', survey.dataPenjamin?.tglktppenjamin),
                  _buildDetailRow('SIM', survey.dataPenjamin?.simpenjamin),
                  _buildDetailRow('NPWP', survey.dataPenjamin?.npwppenjamin),
                  _buildDetailRow(
                      'Alamat', survey.dataPenjamin?.alamatpenjamin),
                  _buildDetailRow('Kota', survey.dataPenjamin?.kotapenjamin),
                  _buildDetailRow(
                      'Nama Ibu Kandung', survey.dataPenjamin?.namaibupenjamin),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                      'Pekerjaan',
                      survey.dataPenjamin?.dataPekerjaanPenjamin
                          ?.pekerjaanpenjamin),
                  _buildDetailRow(
                      'Nama Perusahaan',
                      survey.dataPenjamin?.dataPekerjaanPenjamin
                          ?.namaperusahaanpenjamin),
                  _buildDetailRow(
                      'Jabatan',
                      survey.dataPenjamin?.dataPekerjaanPenjamin
                          ?.jabatanpenjamin),
                  _buildDetailRow(
                      'Ket. Tambahan Jabatan',
                      survey.dataPenjamin?.dataPekerjaanPenjamin
                          ?.ketjabatanpenjamin),
                  _buildDetailRow(
                      'Alamat Perusahaan',
                      survey.dataPenjamin?.dataPekerjaanPenjamin
                          ?.alamatusahapenjamin),
                  _buildDetailRow(
                      'Kode Pos',
                      survey.dataPenjamin?.dataPekerjaanPenjamin
                          ?.kodeposperusahaanpenjamin),
                  _buildDetailRow(
                      'No. Telepon',
                      survey.dataPenjamin?.dataPekerjaanPenjamin
                          ?.noteleponusahapenjamin),

                  // --- Bagian Data Pekerjaan ---
                  if (survey.dataPenjamin?.dataPekerjaanPenjamin
                          ?.pekerjaanpenjamin ==
                      'WIRASWASTA') ...[
                    // bagian usahawan
                    _buildDetailRow(
                        'Bidang Usaha',
                        survey.dataPenjamin?.dataPekerjaanPenjamin
                            ?.bidangusahapenjamin),
                    _buildDetailRow(
                        'Lama Usaha',
                        survey.dataPenjamin?.dataPekerjaanPenjamin
                            ?.lamausahapenjamin),
                    _buildDetailRow(
                        'Omzet Usaha/bulan',
                        survey.dataPenjamin?.dataPekerjaanPenjamin
                            ?.omzetusahapenjamin),
                    _buildDetailRow(
                        'Profit Usaha',
                        survey.dataPenjamin?.dataPekerjaanPenjamin
                            ?.profitusahapenjamin),
                  ] else ...[
                    // bagian karyawan
                    _buildDetailRow(
                        'Masa Kerja',
                        survey.dataPenjamin?.dataPekerjaanPenjamin
                            ?.masakerjapenjamin),
                    _buildDetailRow(
                        'Penghasilan/bulan',
                        survey
                            .dataPenjamin?.dataPekerjaanPenjamin?.gajipenjamin),
                    _buildDetailRow(
                        'Slip Gaji',
                        survey.dataPenjamin?.dataPekerjaanPenjamin
                            ?.slipgajipenjamin),
                    _buildDetailRow(
                        'Penghasilan di Payroll',
                        survey.dataPenjamin?.dataPekerjaanPenjamin
                            ?.payrollpenjamin),
                  ],
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  _buildDetailRow('Status Kepemilikan Tempat Tinggal',
                      survey.dataPenjamin?.statusrumahpenjamin),
                  _buildDetailRow(
                      'Lokasi Rumah', survey.dataPenjamin?.lokasirumahpenjamin),
                  _buildDetailRow('Kategori Tempat Tinggal',
                      survey.dataPenjamin?.katrumahpenjamin),
                  _buildDetailRow('Bukti Kepemilikan Tempat Tinggal',
                      survey.dataPenjamin?.buktimilikrumahpenjamin),
                  _buildDetailRow(
                      'Lama Tinggal', survey.dataPenjamin?.lamatinggalpenjamin),
                ],
              ),

            // --- Bagian Data Pasangan Penjamin ---
            if (survey.isPenjaminExist == 'Ya' &&
                survey.dataPenjamin?.statuspernikahanpenjamin == 'MENIKAH')
              _buildSectionCard(
                title: 'Data Pasangan Penjamin',
                icon: Icons.person,
                children: [
                  _buildDetailRow('Nama ',
                      survey.dataPasanganPenjamin?.namapasanganpenjamin),
                  _buildDetailRow('Agama',
                      survey.dataPasanganPenjamin?.agamapasanganpenjamin),
                  _buildDetailRow('Kewarganegaraan',
                      survey.dataPasanganPenjamin?.warganegarapasanganpenjamin),
                  _buildDetailRow('No. Telepon',
                      survey.dataPasanganPenjamin?.notelponpasanganpenjamin),
                  _buildDetailRow('No. Whatsapp',
                      survey.dataPasanganPenjamin?.nowapasanganpenjamin),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  _buildDetailRow('Pekerjaan',
                      survey.dataPasanganPenjamin?.pekerjaanpasanganpenjamin),
                  _buildDetailRow(
                      'Nama Perusahaan',
                      survey.dataPasanganPenjamin
                          ?.namaperusahaanpasanganpenjamin),
                  _buildDetailRow('Jabatan',
                      survey.dataPasanganPenjamin?.jabatanpasanganpenjamin),
                  _buildDetailRow('Ket. Tambahan Jabatan',
                      survey.dataPasanganPenjamin?.ketjabatanpasanganpenjamin),
                  _buildDetailRow(
                      'Alamat Perusahaan',
                      survey.dataPasanganPenjamin
                          ?.alamatperusahaanpasanganpenjamin),
                  _buildDetailRow(
                      'Kode Pos',
                      survey.dataPasanganPenjamin
                          ?.kodeposperusahaanpasanganpenjamin),
                  _buildDetailRow(
                      'No. Telepon',
                      survey.dataPasanganPenjamin
                          ?.noteleponusahapasanganpenjamin),

                  // --- Bagian Data Pekerjaan ---
                  if (survey.dataPasanganPenjamin?.pekerjaanpasanganpenjamin ==
                      'WIRASWASTA') ...[
                    // bagian usahawan
                    _buildDetailRow(
                        'Bidang Usaha',
                        survey
                            .dataPasanganPenjamin?.bidangusahapasanganpenjamin),
                    _buildDetailRow('Lama Usaha',
                        survey.dataPasanganPenjamin?.lamausahapasanganpenjamin),
                    _buildDetailRow(
                        'Omzet Usaha/bulan',
                        survey
                            .dataPasanganPenjamin?.omzetusahapasanganpenjamin),
                    _buildDetailRow(
                        'Profit Usaha',
                        survey
                            .dataPasanganPenjamin?.profitusahapasanganpenjamin),
                  ] else ...[
                    // bagian karyawan
                    _buildDetailRow('Masa Kerja',
                        survey.dataPasanganPenjamin?.masakerjapasanganpenjamin),
                    _buildDetailRow('Penghasilan/bulan',
                        survey.dataPasanganPenjamin?.gajipasanganpenjamin),
                    _buildDetailRow('Slip Gaji',
                        survey.dataPasanganPenjamin?.slipgajipasanganpenjamin),
                    _buildDetailRow('Penghasilan di Payroll',
                        survey.dataPasanganPenjamin?.payrollpasanganpenjamin),
                  ],
                ],
              ),

            // --- Bagian Analisa CMO ---
            _buildSectionCard(
              title: 'Catatan Analisa CMO',
              icon: Icons.analytics,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    survey.analisacmo == null || survey.analisacmo!.isEmpty
                        ? '-'
                        : survey.analisacmo!,
                    style: const TextStyle(
                        fontSize: 14, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),

            // _buildSectionCard(
            //   title: 'ADa penjamin CMO',
            //   icon: Icons.analytics,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.symmetric(
            //           horizontal: 16.0, vertical: 8.0),
            //       child: Text(
            //         survey.isPenjaminExist!,
            //         style: const TextStyle(
            //             fontSize: 14, fontStyle: FontStyle.italic),
            //         textAlign: TextAlign.justify,
            //       ),
            //     ),
            //   ],
            // ),

            // --- Bagian Foto Kendaraan ---
            _buildSectionCard(
              title: 'Foto Kendaraan',
              icon: Icons.image,
              children: [
                _buildDetailRow(
                    'Odometer', '${survey.fotoKendaraan?.odometer} KM'),
                _buildPhotoItem(
                    'Foto Unit Depan', survey.fotoKendaraan?.fotounitdepan),
                _buildPhotoItem('Foto Unit Belakang',
                    survey.fotoKendaraan?.fotounitbelakang),
                _buildPhotoItem('Foto Unit Interior Depan',
                    survey.fotoKendaraan?.fotounitinteriordepan),
                _buildPhotoItem('Foto Unit Mesin & Plat Nomor',
                    survey.fotoKendaraan?.fotounitmesinplat),
                _buildPhotoItem('Foto Mesin', survey.fotoKendaraan?.fotomesin),
                _buildPhotoItem('Foto Unit Selfie CMO',
                    survey.fotoKendaraan?.fotounitselfiecmo),
                _buildPhotoItem(
                    'Foto Speedometer', survey.fotoKendaraan?.fotospeedometer),
                _buildPhotoItem('Foto Hasil Gesekan Noka Nosin',
                    survey.fotoKendaraan?.fotogesekannoka),
                _buildPhotoItem('Foto STNK', survey.fotoKendaraan?.fotostnk),
                _buildPhotoItem(
                    'Foto Notice Pajak', survey.fotoKendaraan?.fotonoticepajak),
                _buildPhotoItem('Foto BPKB 1', survey.fotoKendaraan?.fotobpkb1),
                _buildPhotoItem('Foto BPKB 2', survey.fotoKendaraan?.fotobpkb2),
              ],
            ),

            // --- Bagian Foto Legalitas ---
            _buildSectionCard(
              title: 'Foto & Dokumen Legalitas',
              icon: Icons.image,
              children: [
                _buildPhotoItem('Foto KTP Asli Pemohon',
                    survey.fotoLegalitas?.fotoktppemohon),
                _buildPhotoItem(
                    'Foto KTP Pasangan', survey.fotoLegalitas?.fotoktppasangan),
                _buildPhotoItem(
                    'Foto Kartu Keluarga', survey.fotoLegalitas?.fotokk),
                _buildPhotoItem('Foto SIM-A Pemohon / Pasangan',
                    survey.fotoLegalitas?.fotosima),
                _buildPhotoItem('Foto NPWP Pemohon / Pasangan',
                    survey.fotoLegalitas?.fotonpwp),
              ],
            ),

            // --- Bagian Foto & Dokumen Tempat Tinggal ---
            _buildSectionCard(
              title: 'Foto & Dokumen Tempat Tinggal',
              icon: Icons.image,
              children: [
                _buildPhotoItem(
                    'Foto Rumah', survey.fotoTempatTinggal?.fotorumah),
                _buildPhotoItem('Foto Rumah Selfie CMO',
                    survey.fotoTempatTinggal?.fotorumahselfiecmo),
                _buildPhotoItem('Foto Cek Lingkungan Selfie CMO',
                    survey.fotoTempatTinggal?.fotolingkunganselfiecmo),
                _buildPhotoItem('Foto Bukti Kepemilikan Tempat Tinggal',
                    survey.fotoTempatTinggal?.fotobuktimilikrumah),
                _buildPhotoItem('Foto Close-Up Pemohon',
                    survey.fotoTempatTinggal?.fotocloseuppemohon),
                _buildPhotoItem('Foto Pemohon TTD FPP',
                    survey.fotoTempatTinggal?.fotopemohonttdfpp),
                _buildPhotoItem('Foto FPP Tampak Depan',
                    survey.fotoTempatTinggal?.fotofppdepan),
                _buildPhotoItem('Foto FPP Tampak Belakang',
                    survey.fotoTempatTinggal?.fotofppbelakang),
              ],
            ),

            // --- Bagian Foto & Dokumen Pekerjaan / Usaha ---
            _buildSectionCard(
              title: 'Foto & Dokumen Pekerjaan / Usaha',
              icon: Icons.image,
              children: [
                _buildDetailRow('Foto & Dokumen 1', '-'),
              ],
            ),

            // --- Bagian Foto & Dokumen Simulasi Perhitungan ---
            _buildSectionCard(
              title: 'Foto & Dokumen Simulasi Perhitungan',
              icon: Icons.image,
              children: [
                _buildDetailRow('Foto & Dokumen 1', '-'),
              ],
            ),

            // --- Bagian Foto & Dokumen Tambahan ---
            _buildSectionCard(
              title: 'Foto & Dokumen Tambahan',
              icon: Icons.image,
              children: [
                _buildDetailRow('Foto & Dokumen 1', '-'),
              ],
            ),

            // Anda bisa menambahkan Card lain untuk section lainnya dengan pola yang sama
          ],
        ),
      ),
    );
  }

  /// Helper widget untuk membuat satu baris detail (Label & Value)
  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2, // Lebar untuk label
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3, // Lebar untuk value
            child: Text(
              value == null || value.isEmpty
                  ? '-'
                  : value, // Handle data kosong
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper widget untuk membuat satu Card section
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Icon(icon, color: primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Masukkan semua baris detail ke sini
          ...children,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// Helper widget baru untuk menampilkan satu item foto
  Widget _buildPhotoItem(String label, String? path) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          // Cek apakah path ada dan tidak kosong
          (path != null && path.isNotEmpty)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(0.0),
                  child: Image.file(
                    File(path),
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.contain,
                    // alignment: Alignment.centerLeft,
                    // Tambahkan error builder untuk menangani jika file tidak ditemukan
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Text('Gagal memuat gambar'));
                    },
                  ),
                )
              : Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Text(
                      'Tidak ada foto',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
