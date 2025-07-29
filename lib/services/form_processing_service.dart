import 'dart:io';

import 'package:gsure/models/photo_data_model.dart';

class FormProcessingServiceAPI {
  Map<String, dynamic> processFormToAPI(Map<String, dynamic> flatFormAnswers) {
    final Map<String, dynamic> dealerData = {};

    final Map<String, dynamic> pemohonData = {};
    final Map<String, dynamic> pekerjaanData = {};

    final Map<String, dynamic> pasanganData = {};
    final Map<String, dynamic> pasanganPekerjaanData = {};

    final Map<String, dynamic> penjaminData = {};
    final Map<String, dynamic> pekerjaanPenjaminData = {};

    final Map<String, dynamic> pasanganPenjaminData = {};
    final Map<String, dynamic> pasanganPekerjaanPenjaminData = {};

    final Map<String, dynamic> kontakDaruratData = {};

    // ============================================ //
    final Map<String, dynamic> fotoKendaraanData = {};
    final Map<String, dynamic> fotoLegalitasData = {};
    final Map<String, dynamic> fotoTempatTinggalData = {};

    // Mengisi data untuk bagian Dealer
    dealerData['created_by'] = flatFormAnswers['created_by'];
    dealerData['updated_by'] = flatFormAnswers['updated_by'];
    dealerData['application_id'] = flatFormAnswers['application_id'];
    dealerData['nik'] = flatFormAnswers['nik'];
    dealerData['kddealer'] = flatFormAnswers['kddealer'];
    dealerData['namadealer'] = flatFormAnswers['namadealer'];
    dealerData['alamatdealer'] = flatFormAnswers['alamatdealer'];
    dealerData['rtdealer'] = flatFormAnswers['rtdealer'];
    dealerData['rwdealer'] = flatFormAnswers['rwdealer'];
    dealerData['kodeposdealer'] = flatFormAnswers['kodeposdealer'];
    dealerData['keldealer'] = flatFormAnswers['keldealer'];
    dealerData['kecdealer'] = flatFormAnswers['kecdealer'];
    dealerData['kotadealer'] = flatFormAnswers['kotadealer'];
    dealerData['provinsidealer'] = flatFormAnswers['provinsidealer'];
    dealerData['telpondealer'] = flatFormAnswers['telpondealer'];
    dealerData['namapemilikdealer'] = flatFormAnswers['namapemilikdealer'];
    dealerData['nohppemilik'] = flatFormAnswers['nohppemilik'];
    dealerData['picdealer'] = flatFormAnswers['picdealer'];
    // Mengisi data untuk bagian Kendaraan
    dealerData['kondisiKendaraan'] = flatFormAnswers['kondisiKendaraan'];
    dealerData['merkkendaraan'] = flatFormAnswers['merkkendaraan'];
    dealerData['typekendaraan'] = flatFormAnswers['typekendaraan'];
    dealerData['tahunkendaraan'] = flatFormAnswers['tahunkendaraan'];
    dealerData['nopolisikendaraan'] = flatFormAnswers['nopolisikendaraan'];
    // Mengisi data untuk bagian Profil Pembiayaan
    dealerData['hargakendaraan'] = flatFormAnswers['hargakendaraan'];
    dealerData['uangmuka'] = flatFormAnswers['uangmuka'];
    dealerData['pokokhutang'] = flatFormAnswers['pokokhutang'];
    // Mengisi data untuk bagian Alamat Survey
    dealerData['alamatsurvey'] = flatFormAnswers['alamatsurvey'];
    dealerData['rtsurvey'] = flatFormAnswers['rtsurvey'];
    dealerData['rwsurvey'] = flatFormAnswers['rwsurvey'];
    dealerData['kodepoksurvey'] = flatFormAnswers['kodepoksurvey'];
    dealerData['kelsurvey'] = flatFormAnswers['kelsurvey'];
    dealerData['kecsurvey'] = flatFormAnswers['kecsurvey'];
    dealerData['kotasurvey'] = flatFormAnswers['kotasurvey'];
    dealerData['provinsisurvey'] = flatFormAnswers['provinsisurvey'];

    // Data Pemohon
    pemohonData['created_by'] = flatFormAnswers['created_by'];
    pemohonData['updated_by'] = flatFormAnswers['updated_by'];
    pemohonData['application_id'] = flatFormAnswers['application_id'];
    pemohonData['nik'] = flatFormAnswers['nik'];
    pemohonData['katpemohon'] = flatFormAnswers['katpemohon'];
    pemohonData['statuspernikahan'] = flatFormAnswers['statuspernikahan'];
    pemohonData['nama'] = flatFormAnswers['nama'];
    pemohonData['agamapemohon'] = flatFormAnswers['agamapemohon'];
    pemohonData['pendidikan'] = flatFormAnswers['pendidikan'];
    pemohonData['warganegarapemohon'] = flatFormAnswers['warganegarapemohon'];
    pemohonData['nomortelepon'] = flatFormAnswers['nomortelepon'];
    pemohonData['nohp'] = flatFormAnswers['nohp'];
    pemohonData['email'] = flatFormAnswers['email'];
    pemohonData['sim'] = flatFormAnswers['sim'];
    pemohonData['npwp'] = flatFormAnswers['npwp'];
    pemohonData['namaibu'] = flatFormAnswers['namaibu'];
    pemohonData['statusrumah'] = flatFormAnswers['statusrumah'];
    pemohonData['lokasirumah'] = flatFormAnswers['lokasirumah'];
    pemohonData['katrumahpemohon'] = flatFormAnswers['katrumahpemohon'];
    pemohonData['buktimilikrumahpemohon'] =
        flatFormAnswers['buktimilikrumahpemohon'];
    pemohonData['lamatinggalpemohon'] = flatFormAnswers['lamatinggalpemohon'];
    pemohonData['jenispekerjaan'] = flatFormAnswers['jenispekerjaan'];

    // Data pekerjaan/usaha pemohon
    pekerjaanData['created_by'] = flatFormAnswers['created_by'];
    pekerjaanData['updated_by'] = flatFormAnswers['updated_by'];
    pekerjaanData['application_id'] = flatFormAnswers['application_id'];
    pekerjaanData['nik'] = flatFormAnswers['nik'];
    pekerjaanData['namaperusahaan'] = flatFormAnswers['namaperusahaan'];
    pekerjaanData['jabatan'] = flatFormAnswers['jabatan'];
    pekerjaanData['ketjabatan'] = flatFormAnswers['ketjabatan'];
    pekerjaanData['alamatusaha'] = flatFormAnswers['alamatusaha'];
    pekerjaanData['kodeposusaha'] = flatFormAnswers['kodeposusaha'];
    pekerjaanData['noteleponusaha'] = flatFormAnswers['noteleponusaha'];
    pekerjaanData['masakerjapemohon'] = flatFormAnswers['masakerjapemohon'];
    pekerjaanData['gajipemohon'] = flatFormAnswers['gajipemohon'];
    pekerjaanData['slipgajipemohon'] = flatFormAnswers['slipgajipemohon'];
    pekerjaanData['payrollpemohon'] = flatFormAnswers['payrollpemohon'];
    pekerjaanData['bidangusahapemohon'] = flatFormAnswers['bidangusahapemohon'];
    pekerjaanData['lamausahapemohon'] = flatFormAnswers['lamausahapemohon'];
    pekerjaanData['omzetusahapemohon'] = flatFormAnswers['omzetusahapemohon'];
    pekerjaanData['profitusahapemohon'] = flatFormAnswers['profitusahapemohon'];

    // Mengisi data untuk bagian Pasangan Pemohon (termasuk data pekerjaan)
    pasanganData['created_by'] = flatFormAnswers['created_by'];
    pasanganData['updated_by'] = flatFormAnswers['updated_by'];
    pasanganData['application_id'] = flatFormAnswers['application_id'];
    pasanganData['nik'] = flatFormAnswers['nik'];
    pasanganData['namapasangan'] = flatFormAnswers['namapasangan'];
    pasanganData['namapanggilan'] = flatFormAnswers['namapanggilan'];
    pasanganData['ktppasangan'] = flatFormAnswers['ktppasangan'];
    pasanganData['agamapasangan'] = flatFormAnswers['agamapasangan'];
    pasanganData['warganegarapasangan'] =
        flatFormAnswers['warganegarapasangan'];
    pasanganData['notelppasangan'] = flatFormAnswers['notelppasangan'];
    pasanganData['nomortelepon'] = flatFormAnswers['nomortelepon'];
    pasanganData['nohppasangan'] = flatFormAnswers['nohppasangan'];
    pasanganData['pekerjaanpasangan'] = flatFormAnswers['pekerjaanpasangan'];

    // Data pekerjaan/usaha pasangan pemohon
    pasanganPekerjaanData['created_by'] = flatFormAnswers['created_by'];
    pasanganPekerjaanData['updated_by'] = flatFormAnswers['updated_by'];
    pasanganPekerjaanData['application_id'] = flatFormAnswers['application_id'];
    pasanganPekerjaanData['nik'] = flatFormAnswers['nik'];

    pasanganPekerjaanData['namaperusahaanpasangan'] =
        flatFormAnswers['namaperusahaanpasangan'];
    pasanganPekerjaanData['jabatanpasangan'] =
        flatFormAnswers['jabatanpasangan'];
    pasanganPekerjaanData['ketjabatanpasangan'] =
        flatFormAnswers['ketjabatanpasangan'];
    pasanganPekerjaanData['alamatusahapasangan'] =
        flatFormAnswers['alamatusahapasangan'];
    pasanganPekerjaanData['kodeposperusahaanpasangan'] =
        flatFormAnswers['kodeposperusahaanpasangan'];
    pasanganPekerjaanData['noteleponusahapasangan'] =
        flatFormAnswers['noteleponusahapasangan'];
    pasanganPekerjaanData['masakerjapasangan'] =
        flatFormAnswers['masakerjapasangan'];
    pasanganPekerjaanData['gajipasangan'] = flatFormAnswers['gajipasangan'];
    pasanganPekerjaanData['slipgajipasangan'] =
        flatFormAnswers['slipgajipasangan'];
    pasanganPekerjaanData['payrollpasangan'] =
        flatFormAnswers['payrollpasangan'];
    pasanganPekerjaanData['bidangusahapasangan'] =
        flatFormAnswers['bidangusahapasangan'];
    pasanganPekerjaanData['lamausahapasangan'] =
        flatFormAnswers['lamausahapasangan'];
    pasanganPekerjaanData['omzetusahapasangan'] =
        flatFormAnswers['omzetusahapasangan'];
    pasanganPekerjaanData['profitusahapasangan'] =
        flatFormAnswers['profitusahapasangan'];

    // Mengisi data untuk bagian Penjamin (termasuk data pekerjaan)
    penjaminData['created_by'] = flatFormAnswers['created_by'];
    penjaminData['updated_by'] = flatFormAnswers['updated_by'];
    penjaminData['application_id'] = flatFormAnswers['application_id'];
    penjaminData['nik'] = flatFormAnswers['nik'];
    penjaminData['jnspenjamin'] = flatFormAnswers['jnspenjamin'];
    penjaminData['statuspernikahanpenjamin'] =
        flatFormAnswers['statuspernikahanpenjamin'];
    penjaminData['namapenjamin'] = flatFormAnswers['namapenjamin'];
    penjaminData['agamapenjamin'] = flatFormAnswers['agamapenjamin'];
    penjaminData['warganegarapenjamin'] =
        flatFormAnswers['warganegarapenjamin'];
    penjaminData['notelppenjamin'] = flatFormAnswers['notelppenjamin'];
    penjaminData['nowapenjamin'] = flatFormAnswers['nowapenjamin'];
    penjaminData['ktppenjamin'] = flatFormAnswers['ktppenjamin'];
    penjaminData['tglktppenjamin'] = flatFormAnswers['tglktppenjamin'];
    penjaminData['simpenjamin'] = flatFormAnswers['simpenjamin'];
    penjaminData['npwppenjamin'] = flatFormAnswers['npwppenjamin'];
    penjaminData['alamatpenjamin'] = flatFormAnswers['alamatpenjamin'];
    penjaminData['kotapenjamin'] = flatFormAnswers['kotapenjamin'];
    penjaminData['namaibupenjamin'] = flatFormAnswers['namaibupenjamin'];
    penjaminData['statusrumahpenjamin'] =
        flatFormAnswers['statusrumahpenjamin'];
    penjaminData['lokasirumahpenjamin'] =
        flatFormAnswers['lokasirumahpenjamin'];
    penjaminData['katrumahpenjamin'] = flatFormAnswers['katrumahpenjamin'];
    penjaminData['buktimilikrumahpenjamin'] =
        flatFormAnswers['buktimilikrumahpenjamin'];
    penjaminData['lamatinggalpenjamin'] =
        flatFormAnswers['lamatinggalpenjamin'];
    penjaminData['pekerjaanpenjamin'] = flatFormAnswers['pekerjaanpenjamin'];

    // Data pekerjaan/usaha Penjamin
    pekerjaanPenjaminData['created_by'] = flatFormAnswers['created_by'];
    pekerjaanPenjaminData['updated_by'] = flatFormAnswers['updated_by'];
    pekerjaanPenjaminData['application_id'] = flatFormAnswers['application_id'];
    pekerjaanPenjaminData['nik'] = flatFormAnswers['nik'];

    pekerjaanPenjaminData['namaperusahaanpenjamin'] =
        flatFormAnswers['namaperusahaanpenjamin'];
    pekerjaanPenjaminData['jabatanpenjamin'] =
        flatFormAnswers['jabatanpenjamin'];
    pekerjaanPenjaminData['ketjabatanpenjamin'] =
        flatFormAnswers['ketjabatanpenjamin'];
    pekerjaanPenjaminData['alamatusahapenjamin'] =
        flatFormAnswers['alamatusahapenjamin'];
    pekerjaanPenjaminData['kodeposperusahaanpenjamin'] =
        flatFormAnswers['kodeposperusahaanpenjamin'];
    pekerjaanPenjaminData['noteleponusahapenjamin'] =
        flatFormAnswers['noteleponusahapenjamin'];
    pekerjaanPenjaminData['masakerjapenjamin'] =
        flatFormAnswers['masakerjapenjamin'];
    pekerjaanPenjaminData['gajipenjamin'] = flatFormAnswers['gajipenjamin'];
    pekerjaanPenjaminData['slipgajipenjamin'] =
        flatFormAnswers['slipgajipenjamin'];
    pekerjaanPenjaminData['payrollpenjamin'] =
        flatFormAnswers['payrollpenjamin'];
    pekerjaanPenjaminData['bidangusahapenjamin'] =
        flatFormAnswers['bidangusahapenjamin'];
    pekerjaanPenjaminData['lamausahapenjamin'] =
        flatFormAnswers['lamausahapenjamin'];
    pekerjaanPenjaminData['omzetusahapenjamin'] =
        flatFormAnswers['omzetusahapenjamin'];
    pekerjaanPenjaminData['profitusahapenjamin'] =
        flatFormAnswers['profitusahapenjamin'];

    // Mengisi data untuk bagian Pasangan Penjamin (termasuk data pekerjaan)
    pasanganPenjaminData['created_by'] = flatFormAnswers['created_by'];
    pasanganPenjaminData['updated_by'] = flatFormAnswers['updated_by'];
    pasanganPenjaminData['application_id'] = flatFormAnswers['application_id'];
    pasanganPenjaminData['nik'] = flatFormAnswers['nik'];
    pasanganPenjaminData['namapasanganpenjamin'] =
        flatFormAnswers['namapasanganpenjamin'];
    pasanganPenjaminData['agamapasanganpenjamin'] =
        flatFormAnswers['agamapasanganpenjamin'];
    pasanganPenjaminData['warganegarapasanganpenjamin'] =
        flatFormAnswers['warganegarapasanganpenjamin'];
    pasanganPenjaminData['notelponpasanganpenjamin'] =
        flatFormAnswers['notelponpasanganpenjamin'];
    pasanganPenjaminData['nowapasanganpenjamin'] =
        flatFormAnswers['nowapasanganpenjamin'];
    pasanganPenjaminData['pekerjaanpasanganpenjamin'] =
        flatFormAnswers['pekerjaanpasanganpenjamin'];

    // Data pekerjaan/usaha pasangan Penjamin
    pasanganPekerjaanPenjaminData['created_by'] = flatFormAnswers['created_by'];
    pasanganPekerjaanPenjaminData['updated_by'] = flatFormAnswers['updated_by'];
    pasanganPekerjaanPenjaminData['application_id'] =
        flatFormAnswers['application_id'];
    pasanganPekerjaanPenjaminData['nik'] = flatFormAnswers['nik'];

    pasanganPekerjaanPenjaminData['namaperusahaanpasanganpenjamin'] =
        flatFormAnswers['namaperusahaanpasanganpenjamin'];
    pasanganPekerjaanPenjaminData['jabatanpasanganpenjamin'] =
        flatFormAnswers['jabatanpasanganpenjamin'];
    pasanganPekerjaanPenjaminData['ketjabatanpasanganpenjamin'] =
        flatFormAnswers['ketjabatanpasanganpenjamin'];
    pasanganPekerjaanPenjaminData['alamatperusahaanpasanganpenjamin'] =
        flatFormAnswers['alamatperusahaanpasanganpenjamin'];
    pasanganPekerjaanPenjaminData['kodeposperusahaanpasanganpenjamin'] =
        flatFormAnswers['kodeposperusahaanpasanganpenjamin'];
    pasanganPekerjaanPenjaminData['noteleponusahapasanganpenjamin'] =
        flatFormAnswers['noteleponusahapasanganpenjamin'];
    pasanganPekerjaanPenjaminData['masakerjapasanganpenjamin'] =
        flatFormAnswers['masakerjapasanganpenjamin'];
    pasanganPekerjaanPenjaminData['gajipasanganpenjamin'] =
        flatFormAnswers['gajipasanganpenjamin'];
    pasanganPekerjaanPenjaminData['slipgajipasanganpenjamin'] =
        flatFormAnswers['slipgajipasanganpenjamin'];
    pasanganPekerjaanPenjaminData['payrollpasanganpenjamin'] =
        flatFormAnswers['payrollpasanganpenjamin'];
    pasanganPekerjaanPenjaminData['bidangusahapasanganpenjamin'] =
        flatFormAnswers['bidangusahapasanganpenjamin'];
    pasanganPekerjaanPenjaminData['lamausahapasanganpenjamin'] =
        flatFormAnswers['lamausahapasanganpenjamin'];
    pasanganPekerjaanPenjaminData['omzetusahapasanganpenjamin'] =
        flatFormAnswers['omzetusahapasanganpenjamin'];
    pasanganPekerjaanPenjaminData['profitusahapasanganpenjamin'] =
        flatFormAnswers['profitusahapasanganpenjamin'];

    // Mengisi data untuk bagian Kontak Darurat
    kontakDaruratData['created_by'] = flatFormAnswers['created_by'];
    kontakDaruratData['updated_by'] = flatFormAnswers['updated_by'];
    kontakDaruratData['application_id'] = flatFormAnswers['application_id'];
    kontakDaruratData['nik'] = flatFormAnswers['nik'];
    kontakDaruratData['namakontak'] = flatFormAnswers['namakontak'];
    kontakDaruratData['jeniskelaminkontak'] =
        flatFormAnswers['jeniskelaminkontak'];
    kontakDaruratData['hubungankeluarga'] = flatFormAnswers['hubungankeluarga'];
    kontakDaruratData['nohpkontak'] = flatFormAnswers['nohpkontak'];
    kontakDaruratData['alamatkontak'] = flatFormAnswers['alamatkontak'];
    kontakDaruratData['kodeposkontak'] = flatFormAnswers['kodeposkontak'];

    // // Foto Kendaraan
    // fotoKendaraanData['odometer'] = flatFormAnswers['odometer'];
    // // fotoKendaraanData['fotounitdepan'] =
    // //     PhotoData.fromJson(flatFormAnswers['fotounitdepan']!);
    // fotoKendaraanData['fotounitdepan'] = flatFormAnswers['fotounitdepan'];
    // fotoKendaraanData['fotounitbelakang'] = flatFormAnswers['fotounitbelakang'];
    // fotoKendaraanData['fotounitinteriordepan'] =
    //     flatFormAnswers['fotounitinteriordepan'];
    // fotoKendaraanData['fotounitmesinplat'] =
    //     flatFormAnswers['fotounitmesinplat'];
    // fotoKendaraanData['fotomesin'] = flatFormAnswers['fotomesin'];
    // fotoKendaraanData['fotounitselfiecmo'] =
    //     flatFormAnswers['fotounitselfiecmo'];
    // fotoKendaraanData['fotospeedometer'] = flatFormAnswers['fotospeedometer'];
    // fotoKendaraanData['fotogesekannoka'] = flatFormAnswers['fotogesekannoka'];
    // fotoKendaraanData['fotostnk'] = flatFormAnswers['fotostnk'];
    // fotoKendaraanData['fotonoticepajak'] = flatFormAnswers['fotonoticepajak'];
    // fotoKendaraanData['fotobpkb1'] = flatFormAnswers['fotobpkb1'];
    // fotoKendaraanData['fotobpkb2'] = flatFormAnswers['fotobpkb2'];

    // // Foto Legalitas
    // fotoLegalitasData['fotoktppemohon'] = flatFormAnswers['fotoktppemohon'];
    // fotoLegalitasData['fotoktppasangan'] = flatFormAnswers['fotoktppasangan'];
    // fotoLegalitasData['fotokk'] = flatFormAnswers['fotokk'];
    // fotoLegalitasData['fotosima'] = flatFormAnswers['fotosima'];
    // fotoLegalitasData['fotonpwp'] = flatFormAnswers['fotonpwp'];

    // // Foto Legalitas
    // fotoTempatTinggalData['fotorumah'] = flatFormAnswers['fotorumah'];
    // fotoTempatTinggalData['fotorumahselfiecmo'] =
    //     flatFormAnswers['fotorumahselfiecmo'];
    // fotoTempatTinggalData['fotolingkunganselfiecmo'] =
    //     flatFormAnswers['fotolingkunganselfiecmo'];
    // fotoTempatTinggalData['fotobuktimilikrumah'] =
    //     flatFormAnswers['fotobuktimilikrumah'];
    // fotoTempatTinggalData['fotocloseuppemohon'] =
    //     flatFormAnswers['fotocloseuppemohon'];
    // fotoTempatTinggalData['fotopemohonttdfpp'] =
    //     flatFormAnswers['fotopemohonttdfpp'];
    // fotoTempatTinggalData['fotofppdepan'] = flatFormAnswers['fotofppdepan'];
    // fotoTempatTinggalData['fotofppbelakang'] =
    //     flatFormAnswers['fotofppbelakang'];

    final Map<String, dynamic> nestedData = {
      'dealer': dealerData,
      // data pemohon
      'pemohon': pemohonData,
      'pekerjaan_pemohon': pekerjaanData,
      // data Pasangan
      'pasangan_pemohon': pasanganData,
      'pekerjaan_pasangan': pasanganPekerjaanData,
      // data penjamin
      'penjamin': penjaminData,
      'pekerjaan_penjamin': pekerjaanPenjaminData,
      // data pasangan penjamin
      'pasangan_penjamin': pasanganPenjaminData,
      'pekerjaan_pasangan_penjamin': pasanganPekerjaanPenjaminData,
      // data Kontak Darurat
      'kontak_darurat': kontakDaruratData,
      // Foto Dokumen
      // 'fotoKendaraan': fotoKendaraanData,
      // 'fotoLegalitas': fotoLegalitasData,
      // 'fotoTempatTinggal': fotoTempatTinggalData,
    };

    return nestedData;
  }

  Map<String, String> processImageFormToAPI(Map<String, dynamic> formAnswers) {
    final Map<String, String> allFiles = {};

    // Helper untuk mengekstrak path dari berbagai kemungkinan tipe data
    String? _extractPath(dynamic value) {
      if (value is Map && value['file'] is File) {
        return (value['file'] as File).path;
      }
      if (value is PhotoData) {
        return value.path;
      }
      return null;
    }

    // Lakukan iterasi pada semua data di formAnswers
    formAnswers.forEach((key, value) {
      // Coba ekstrak path dari setiap value
      final path = _extractPath(value);

      // Jika path valid (tidak null dan tidak kosong), tambahkan ke hasil akhir
      if (path != null && path.isNotEmpty) {
        allFiles[key] = path;
      }
    });

    return allFiles;
  }

  Map<String, List<String>> groupFiles(Map<String, dynamic> formAnswers) {
    final Map<String, List<String>> groupedResult = {};

    final Map<String, String> prefixToGroupKey = {
      'dokpekerjaan': 'docpekerjaanimage',
      'doksimulasi': 'docsimulasiimage',
      'doktambahan': 'doctambahanimage',
    };

    // 1. BUAT FUNGSI HELPER UNTUK EKSTRAK PATH
    //    Fungsi ini bisa menangani berbagai jenis objek file
    String? _extractPath(dynamic value) {
      if (value is Map && value['file'] is File) {
        return (value['file'] as File).path;
      }
      if (value is PhotoData) {
        // Asumsi kelas PhotoData memiliki properti 'path'
        return value.path;
      }
      return null; // Kembalikan null jika bukan tipe data yang dikenal
    }

    // 2. LOOPING PADA SEMUA DATA
    formAnswers.forEach((key, value) {
      // Gunakan helper untuk mendapatkan path, apa pun bentuk datanya
      final String? path = _extractPath(value);

      // 3. JIKA PATH DITEMUKAN, LANJUTKAN LOGIKA GROUPING
      //    Logika di bawah ini tidak perlu diubah sama sekali
      if (path != null && path.isNotEmpty) {
        String? targetGroupKey;

        for (var entry in prefixToGroupKey.entries) {
          if (key.startsWith(entry.key)) {
            targetGroupKey = entry.value;
            break;
          }
        }

        if (targetGroupKey != null) {
          (groupedResult[targetGroupKey] ??= []).add(path);
        } else {
          groupedResult[key] = [path];
        }
      }
    });

    return groupedResult;
  }

  // Map<String, List<String>> groupFiles(Map<String, dynamic> formAnswers) {
  //   final Map<String, List<String>> groupedResult = {};

  //   final Map<String, String> prefixToGroupKey = {
  //     'dokpekerjaan': 'docpekerjaanimage',
  //     'doksimulasi': 'docsimulasiimage',
  //     'doktambahan': 'doctambahanimage',
  //   };

  //   formAnswers.forEach((key, value) {
  //     // --- PERUBAHAN DI SINI ---
  //     // Cek apakah value adalah Map dan di dalamnya ada 'file' yang bertipe File
  //     if (value is Map && value['file'] is File) {
  //       // Ambil path dari objek File
  //       final String path = (value['file'] as File).path;

  //       // Sisa logika di bawah ini sama persis, karena kita sudah mendapatkan path-nya
  //       if (path.isNotEmpty) {
  //         String? targetGroupKey;

  //         for (var entry in prefixToGroupKey.entries) {
  //           if (key.startsWith(entry.key)) {
  //             targetGroupKey = entry.value;
  //             break;
  //           }
  //         }

  //         if (targetGroupKey != null) {
  //           (groupedResult[targetGroupKey] ??= []).add(path);
  //         } else {
  //           groupedResult[key] = [path];
  //         }
  //       }
  //     }
  //   });

  //   return groupedResult;
  // }

  // Map<String, dynamic> processImageFormToAPI(
  //     Map<String, dynamic> flatFormAnswers) {
  //   // ✅ GANTI FUNGSI HELPER LAMA DENGAN YANG INI
  //   String? _extractPath(dynamic value) {
  //     // Kasus 1: Value adalah Map (dari file picker baru)
  //     if (value is Map) {
  //       final fileObject = value['file'];
  //       if (fileObject is File) {
  //         // Ambil properti .path dari objek File
  //         return fileObject.path;
  //       }
  //     }
  //     // Kasus 2: Value adalah objek PhotoData (dari draft yang dimuat)
  //     else if (value is PhotoData) {
  //       return value.path;
  //     }
  //     // Jika null atau tipe lain, kembalikan null
  //     return null;
  //   }

  //   final Map<String, dynamic> fotoKendaraanData = {
  //     // odometer mungkin bukan path, jadi kita ambil nilainya langsung
  //     'odometer': flatFormAnswers['odometer'],

  //     // ✅ PANGGIL HELPER UNTUK SEMUA FIELD FOTO
  //     'fotounitdepan': _extractPath(flatFormAnswers['fotounitdepan']),
  //     'fotounitbelakang': _extractPath(flatFormAnswers['fotounitbelakang']),
  //     'fotounitinteriordepan':
  //         _extractPath(flatFormAnswers['fotounitinteriordepan']),
  //     'fotounitmesinplat': _extractPath(flatFormAnswers['fotounitmesinplat']),
  //     'fotomesin': _extractPath(flatFormAnswers['fotomesin']),
  //     'fotounitselfiecmo': _extractPath(flatFormAnswers['fotounitselfiecmo']),
  //     'fotospeedometer': _extractPath(flatFormAnswers['fotospeedometer']),
  //     'fotogesekannoka': _extractPath(flatFormAnswers['fotogesekannoka']),
  //     'fotostnk': _extractPath(flatFormAnswers['fotostnk']),
  //     'fotonoticepajak': _extractPath(flatFormAnswers['fotonoticepajak']),
  //     'fotobpkb1': _extractPath(flatFormAnswers['fotobpkb1']),
  //     'fotobpkb2': _extractPath(flatFormAnswers['fotobpkb2']),
  //   };

  //   final Map<String, dynamic> fotoLegalitasData = {
  //     'fotoktppemohon': _extractPath(flatFormAnswers['fotoktppemohon']),
  //     'fotoktppasangan': _extractPath(flatFormAnswers['fotoktppasangan']),
  //     'fotokk': _extractPath(flatFormAnswers['fotokk']),
  //     'fotosima': _extractPath(flatFormAnswers['fotosima']),
  //     'fotonpwp': _extractPath(flatFormAnswers['fotonpwp']),
  //   };

  //   final Map<String, dynamic> fotoTempatTinggalData = {
  //     'fotorumah': _extractPath(flatFormAnswers['fotorumah']),
  //     'fotorumahselfiecmo': _extractPath(flatFormAnswers['fotorumahselfiecmo']),
  //     'fotolingkunganselfiecmo':
  //         _extractPath(flatFormAnswers['fotolingkunganselfiecmo']),
  //     'fotobuktimilikrumah':
  //         _extractPath(flatFormAnswers['fotobuktimilikrumah']),
  //     'fotocloseuppemohon': _extractPath(flatFormAnswers['fotocloseuppemohon']),
  //     'fotopemohonttdfpp': _extractPath(flatFormAnswers['fotopemohonttdfpp']),
  //     'fotofppdepan': _extractPath(flatFormAnswers['fotofppdepan']),
  //     'fotofppbelakang': _extractPath(flatFormAnswers['fotofppbelakang']),
  //   };

  //   // Gabungkan semua map menjadi satu map datar
  //   final Map<String, dynamic> flatApiData = {
  //     ...fotoKendaraanData,
  //     ...fotoLegalitasData,
  //     ...fotoTempatTinggalData,
  //   };

  //   return flatApiData;
  // }
}

class FormProcessingService {
  /// Mengubah Map datar dari form menjadi Map bertingkat yang sesuai dengan
  /// struktur model AplikasiSurvey.
  Map<String, dynamic> processFormToNestedMap(
      Map<String, dynamic> flatFormAnswers) {
    // --- GANTI BLOK LOGIKA LAMA DENGAN YANG BARU INI ---
    final Map<String, dynamic> processedAnswers = {};
    flatFormAnswers.forEach((key, value) {
      if (value is PhotoData) {
        // Kasus 1: Value adalah objek PhotoData (dari data lama/draft).
        // Ubah menjadi Map JSON.
        processedAnswers[key] = value.toJson();
      } else if (value is Map && value['file'] is File) {
        // Kasus 2: Value adalah Map dari file picker (dari data baru).
        // Ekstrak datanya dan ubah File menjadi String path.
        final File file = value['file'];
        final DateTime? timestamp = value['timestamp'];

        processedAnswers[key] = {
          'path': file.path, // <-- Kunci utamanya di sini
          'timestamp': timestamp?.toIso8601String(),
          'latitude': value['latitude'],
          'longitude': value['longitude'],
        };
      } else {
        // Kasus 3: Value adalah tipe lain (String, int, dll).
        // Gunakan value aslinya.
        processedAnswers[key] = value;
      }
    });
    // --- SELESAI ---

    // 1. Inisialisasi map untuk setiap bagian logis
    final Map<String, dynamic> dealerData = {};
    final Map<String, dynamic> kendaraanData = {};
    final Map<String, dynamic> alamatSurveyData = {};
    final Map<String, dynamic> pemohonData = {};
    final Map<String, dynamic> pekerjaanData = {};

    final Map<String, dynamic> pasanganData = {};
    final Map<String, dynamic> kontakDaruratData = {};

    final Map<String, dynamic> penjaminData = {};
    final Map<String, dynamic> pekerjaanPenjaminData = {};
    final Map<String, dynamic> pasanganPenjaminData = {};

    final Map<String, dynamic> fotoKendaraanData = {};
    final Map<String, dynamic> fotoLegalitasData = {};
    final Map<String, dynamic> fotoTempatTinggalData = {};

    // --- BAGIAN BARU: Logika untuk mengumpulkan foto dinamis ---
    final List<Map<String, dynamic>> fotoPekerjaanList = [];
    final List<Map<String, dynamic>> fotoSimulasiList = [];
    final List<Map<String, dynamic>> fotoTambahanList = [];

    processedAnswers.forEach((key, value) {
      // Cek jika key berawalan 'dokpekerjaan' dan valuenya adalah Map
      if (key.startsWith('dokpekerjaan') && value is Map<String, dynamic>) {
        fotoPekerjaanList.add(value);
      } else if (key.startsWith('doksimulasi') &&
          value is Map<String, dynamic>) {
        fotoSimulasiList.add(value);
      } else if (key.startsWith('doktambahan') &&
          value is Map<String, dynamic>) {
        fotoTambahanList.add(value);
      }
    });
    // Mengisi data untuk bagian Dealer
    dealerData['kddealer'] = processedAnswers['kddealer'];
    dealerData['namadealer'] = processedAnswers['namadealer'];
    dealerData['alamatdealer'] = processedAnswers['alamatdealer'];
    dealerData['rtdealer'] = processedAnswers['rtdealer'];
    dealerData['rwdealer'] = processedAnswers['rwdealer'];
    dealerData['kodeposdealer'] = processedAnswers['kodeposdealer'];
    dealerData['keldealer'] = processedAnswers['keldealer'];
    dealerData['kecdealer'] = processedAnswers['kecdealer'];
    dealerData['kotadealer'] = processedAnswers['kotadealer'];
    dealerData['provinsidealer'] = processedAnswers['provinsidealer'];
    dealerData['telpondealer'] = processedAnswers['telpondealer'];
    dealerData['namapemilikdealer'] = processedAnswers['namapemilikdealer'];
    dealerData['nohppemilik'] = processedAnswers['nohppemilik'];
    dealerData['picdealer'] = processedAnswers['picdealer'];

    // Mengisi data untuk bagian Kendaraan
    kendaraanData['kondisiKendaraan'] = processedAnswers['kondisiKendaraan'];
    kendaraanData['merkkendaraan'] = processedAnswers['merkkendaraan'];
    kendaraanData['typekendaraan'] = processedAnswers['typekendaraan'];
    kendaraanData['tahunkendaraan'] = processedAnswers['tahunkendaraan'];
    kendaraanData['nopolisikendaraan'] = processedAnswers['nopolisikendaraan'];
    // Mengisi data untuk bagian Profil Pembiayaan
    kendaraanData['hargakendaraan'] = processedAnswers['hargakendaraan'];
    kendaraanData['uangmuka'] = processedAnswers['uangmuka'];
    kendaraanData['pokokhutang'] = processedAnswers['pokokhutang'];

    // Mengisi data untuk bagian Alamat Survey
    alamatSurveyData['alamatsurvey'] = processedAnswers['alamatsurvey'];
    alamatSurveyData['rtsurvey'] = processedAnswers['rtsurvey'];
    alamatSurveyData['rwsurvey'] = processedAnswers['rwsurvey'];
    alamatSurveyData['kodepoksurvey'] = processedAnswers['kodepoksurvey'];
    alamatSurveyData['kelsurvey'] = processedAnswers['kelsurvey'];
    alamatSurveyData['kecsurvey'] = processedAnswers['kecsurvey'];
    alamatSurveyData['kotasurvey'] = processedAnswers['kotasurvey'];
    alamatSurveyData['provinsisurvey'] = processedAnswers['provinsisurvey'];

    // Mengisi data untuk bagian Pemohon (termasuk data pekerjaan)
    pemohonData['katpemohon'] = processedAnswers['katpemohon'];
    pemohonData['statuspernikahan'] = processedAnswers['statuspernikahan'];
    pemohonData['nama'] = processedAnswers['nama'];
    pemohonData['agamapemohon'] = processedAnswers['agamapemohon'];
    pemohonData['pendidikan'] = processedAnswers['pendidikan'];
    pemohonData['warganegarapemohon'] = processedAnswers['warganegarapemohon'];
    pemohonData['nomortelepon'] = processedAnswers['nomortelepon'];
    pemohonData['nohp'] = processedAnswers['nohp'];
    pemohonData['email'] = processedAnswers['email'];
    pemohonData['sim'] = processedAnswers['sim'];
    pemohonData['npwp'] = processedAnswers['npwp'];
    pemohonData['namaibu'] = processedAnswers['namaibu'];
    pemohonData['statusrumah'] = processedAnswers['statusrumah'];
    pemohonData['lokasirumah'] = processedAnswers['lokasirumah'];
    pemohonData['katrumahpemohon'] = processedAnswers['katrumahpemohon'];
    pemohonData['buktimilikrumahpemohon'] =
        processedAnswers['buktimilikrumahpemohon'];
    pemohonData['lamatinggalpemohon'] = processedAnswers['lamatinggalpemohon'];
    // Data pekerjaan/usaha pemohon
    pekerjaanData['jenispekerjaan'] = processedAnswers['jenispekerjaan'];
    pekerjaanData['namaperusahaan'] = processedAnswers['namaperusahaan'];
    pekerjaanData['jabatan'] = processedAnswers['jabatan'];
    pekerjaanData['ketjabatan'] = processedAnswers['ketjabatan'];
    pekerjaanData['alamatusaha'] = processedAnswers['alamatusaha'];
    pekerjaanData['kodeposusaha'] = processedAnswers['kodeposusaha'];
    pekerjaanData['noteleponusaha'] = processedAnswers['noteleponusaha'];
    pekerjaanData['masakerjapemohon'] = processedAnswers['masakerjapemohon'];
    pekerjaanData['gajipemohon'] = processedAnswers['gajipemohon'];
    pekerjaanData['slipgajipemohon'] = processedAnswers['slipgajipemohon'];
    pekerjaanData['payrollpemohon'] = processedAnswers['payrollpemohon'];
    pekerjaanData['bidangusahapemohon'] =
        processedAnswers['bidangusahapemohon'];
    pekerjaanData['lamausahapemohon'] = processedAnswers['lamausahapemohon'];
    pekerjaanData['omzetusahapemohon'] = processedAnswers['omzetusahapemohon'];
    pekerjaanData['profitusahapemohon'] =
        processedAnswers['profitusahapemohon'];
    pemohonData['dataPekerjaan'] = pekerjaanData;

    // Mengisi data untuk bagian Pasangan Pemohon (termasuk data pekerjaan)
    pasanganData['namapasangan'] = processedAnswers['namapasangan'];
    pasanganData['namapanggilan'] = processedAnswers['namapanggilan'];
    pasanganData['ktppasangan'] = processedAnswers['ktppasangan'];
    pasanganData['agamapasangan'] = processedAnswers['agamapasangan'];
    pasanganData['warganegarapasangan'] =
        processedAnswers['warganegarapasangan'];
    pasanganData['notelppasangan'] = processedAnswers['notelppasangan'];
    pasanganData['nomortelepon'] = processedAnswers['nomortelepon'];
    pasanganData['nohppasangan'] = processedAnswers['nohppasangan'];
    // Data pekerjaan/usaha pasangan pemohon
    pasanganData['pekerjaanpasangan'] = processedAnswers['pekerjaanpasangan'];
    pasanganData['namaperusahaanpasangan'] =
        processedAnswers['namaperusahaanpasangan'];
    pasanganData['jabatanpasangan'] = processedAnswers['jabatanpasangan'];
    pasanganData['ketjabatanpasangan'] = processedAnswers['ketjabatanpasangan'];
    pasanganData['alamatusahapasangan'] =
        processedAnswers['alamatusahapasangan'];
    pasanganData['kodeposperusahaanpasangan'] =
        processedAnswers['kodeposperusahaanpasangan'];
    pasanganData['noteleponusahapasangan'] =
        processedAnswers['noteleponusahapasangan'];
    pasanganData['masakerjapasangan'] = processedAnswers['masakerjapasangan'];
    pasanganData['gajipasangan'] = processedAnswers['gajipasangan'];
    pasanganData['slipgajipasangan'] = processedAnswers['slipgajipasangan'];
    pasanganData['payrollpasangan'] = processedAnswers['payrollpasangan'];
    pasanganData['bidangusahapasangan'] =
        processedAnswers['bidangusahapasangan'];
    pasanganData['lamausahapasangan'] = processedAnswers['lamausahapasangan'];
    pasanganData['omzetusahapasangan'] = processedAnswers['omzetusahapasangan'];
    pasanganData['profitusahapasangan'] =
        processedAnswers['profitusahapasangan'];

    // Mengisi data untuk bagian Kontak Darurat
    kontakDaruratData['namakontak'] = processedAnswers['namakontak'];
    kontakDaruratData['jeniskelaminkontak'] =
        processedAnswers['jeniskelaminkontak'];
    kontakDaruratData['hubungankeluarga'] =
        processedAnswers['hubungankeluarga'];
    kontakDaruratData['nohpkontak'] = processedAnswers['nohpkontak'];
    kontakDaruratData['alamatkontak'] = processedAnswers['alamatkontak'];
    kontakDaruratData['kodeposkontak'] = processedAnswers['kodeposkontak'];

    // Mengisi data untuk bagian Penjamin (termasuk data pekerjaan)
    penjaminData['jnspenjamin'] = processedAnswers['jnspenjamin'];
    penjaminData['statuspernikahanpenjamin'] =
        processedAnswers['statuspernikahanpenjamin'];
    penjaminData['namapenjamin'] = processedAnswers['namapenjamin'];
    penjaminData['agamapenjamin'] = processedAnswers['agamapenjamin'];
    penjaminData['warganegarapenjamin'] =
        processedAnswers['warganegarapenjamin'];
    penjaminData['notelppenjamin'] = processedAnswers['notelppenjamin'];
    penjaminData['nowapenjamin'] = processedAnswers['nowapenjamin'];
    penjaminData['ktppenjamin'] = processedAnswers['ktppenjamin'];
    penjaminData['tglktppenjamin'] = processedAnswers['tglktppenjamin'];
    penjaminData['simpenjamin'] = processedAnswers['simpenjamin'];
    penjaminData['npwppenjamin'] = processedAnswers['npwppenjamin'];
    penjaminData['alamatpenjamin'] = processedAnswers['alamatpenjamin'];
    penjaminData['kotapenjamin'] = processedAnswers['kotapenjamin'];
    penjaminData['namaibupenjamin'] = processedAnswers['namaibupenjamin'];
    penjaminData['statusrumahpenjamin'] =
        processedAnswers['statusrumahpenjamin'];
    penjaminData['lokasirumahpenjamin'] =
        processedAnswers['lokasirumahpenjamin'];
    penjaminData['katrumahpenjamin'] = processedAnswers['katrumahpenjamin'];
    penjaminData['buktimilikrumahpenjamin'] =
        processedAnswers['buktimilikrumahpenjamin'];
    penjaminData['lamatinggalpenjamin'] =
        processedAnswers['lamatinggalpenjamin'];
    // Data pekerjaan/usaha Penjamin
    pekerjaanPenjaminData['pekerjaanpenjamin'] =
        processedAnswers['pekerjaanpenjamin'];
    pekerjaanPenjaminData['namaperusahaanpenjamin'] =
        processedAnswers['namaperusahaanpenjamin'];
    pekerjaanPenjaminData['jabatanpenjamin'] =
        processedAnswers['jabatanpenjamin'];
    pekerjaanPenjaminData['ketjabatanpenjamin'] =
        processedAnswers['ketjabatanpenjamin'];
    pekerjaanPenjaminData['alamatusahapenjamin'] =
        processedAnswers['alamatusahapenjamin'];
    pekerjaanPenjaminData['kodeposperusahaanpenjamin'] =
        processedAnswers['kodeposperusahaanpenjamin'];
    pekerjaanPenjaminData['noteleponusahapenjamin'] =
        processedAnswers['noteleponusahapenjamin'];
    pekerjaanPenjaminData['masakerjapenjamin'] =
        processedAnswers['masakerjapenjamin'];
    pekerjaanPenjaminData['gajipenjamin'] = processedAnswers['gajipenjamin'];
    pekerjaanPenjaminData['slipgajipenjamin'] =
        processedAnswers['slipgajipenjamin'];
    pekerjaanPenjaminData['payrollpenjamin'] =
        processedAnswers['payrollpenjamin'];
    pekerjaanPenjaminData['bidangusahapenjamin'] =
        processedAnswers['bidangusahapenjamin'];
    pekerjaanPenjaminData['lamausahapenjamin'] =
        processedAnswers['lamausahapenjamin'];
    pekerjaanPenjaminData['omzetusahapenjamin'] =
        processedAnswers['omzetusahapenjamin'];
    pekerjaanPenjaminData['profitusahapenjamin'] =
        processedAnswers['profitusahapenjamin'];
    penjaminData['dataPekerjaanPenjamin'] = pekerjaanPenjaminData;

    // Mengisi data untuk bagian Pasangan Penjamin (termasuk data pekerjaan)
    pasanganPenjaminData['namapasanganpenjamin'] =
        processedAnswers['namapasanganpenjamin'];
    pasanganPenjaminData['agamapasanganpenjamin'] =
        processedAnswers['agamapasanganpenjamin'];
    pasanganPenjaminData['warganegarapasanganpenjamin'] =
        processedAnswers['warganegarapasanganpenjamin'];
    pasanganPenjaminData['notelponpasanganpenjamin'] =
        processedAnswers['notelponpasanganpenjamin'];
    pasanganPenjaminData['nowapasanganpenjamin'] =
        processedAnswers['nowapasanganpenjamin'];
    // Data pekerjaan/usaha pasangan Penjamin
    pasanganPenjaminData['pekerjaanpasanganpenjamin'] =
        processedAnswers['pekerjaanpasanganpenjamin'];
    pasanganPenjaminData['namaperusahaanpasanganpenjamin'] =
        processedAnswers['namaperusahaanpasanganpenjamin'];
    pasanganPenjaminData['jabatanpasanganpenjamin'] =
        processedAnswers['jabatanpasanganpenjamin'];
    pasanganPenjaminData['ketjabatanpasanganpenjamin'] =
        processedAnswers['ketjabatanpasanganpenjamin'];
    pasanganPenjaminData['alamatperusahaanpasanganpenjamin'] =
        processedAnswers['alamatperusahaanpasanganpenjamin'];
    pasanganPenjaminData['kodeposperusahaanpasanganpenjamin'] =
        processedAnswers['kodeposperusahaanpasanganpenjamin'];
    pasanganPenjaminData['noteleponusahapasanganpenjamin'] =
        processedAnswers['noteleponusahapasanganpenjamin'];
    pasanganPenjaminData['masakerjapasanganpenjamin'] =
        processedAnswers['masakerjapasanganpenjamin'];
    pasanganPenjaminData['gajipasanganpenjamin'] =
        processedAnswers['gajipasanganpenjamin'];
    pasanganPenjaminData['slipgajipasanganpenjamin'] =
        processedAnswers['slipgajipasanganpenjamin'];
    pasanganPenjaminData['payrollpasanganpenjamin'] =
        processedAnswers['payrollpasanganpenjamin'];
    pasanganPenjaminData['bidangusahapasanganpenjamin'] =
        processedAnswers['bidangusahapasanganpenjamin'];
    pasanganPenjaminData['lamausahapasanganpenjamin'] =
        processedAnswers['lamausahapasanganpenjamin'];
    pasanganPenjaminData['omzetusahapasanganpenjamin'] =
        processedAnswers['omzetusahapasanganpenjamin'];
    pasanganPenjaminData['profitusahapasanganpenjamin'] =
        processedAnswers['profitusahapasanganpenjamin'];

    //==============================================//
    // Helper untuk mengekstrak path dari value yang mungkin berupa Map file
    String? getFilePath(dynamic value) {
      if (value is Map && value.containsKey('file') && value['file'] is File) {
        return (value['file'] as File).path;
      }
      // Jika value sudah berupa string (misalnya dari data yang sudah ada)
      if (value is String) {
        return value;
      }
      return null;
    }

    // Foto Kendaraan
    fotoKendaraanData['odometer'] = processedAnswers['odometer'];
    fotoKendaraanData['fotounitdepan'] = processedAnswers['fotounitdepan'];
    fotoKendaraanData['fotounitbelakang'] =
        processedAnswers['fotounitbelakang'];
    fotoKendaraanData['fotounitinteriordepan'] =
        processedAnswers['fotounitinteriordepan'];
    fotoKendaraanData['fotounitmesinplat'] =
        processedAnswers['fotounitmesinplat'];
    fotoKendaraanData['fotomesin'] = processedAnswers['fotomesin'];
    fotoKendaraanData['fotounitselfiecmo'] =
        processedAnswers['fotounitselfiecmo'];
    fotoKendaraanData['fotospeedometer'] = processedAnswers['fotospeedometer'];
    fotoKendaraanData['fotogesekannoka'] = processedAnswers['fotogesekannoka'];
    fotoKendaraanData['fotostnk'] = processedAnswers['fotostnk'];
    fotoKendaraanData['fotonoticepajak'] = processedAnswers['fotonoticepajak'];
    fotoKendaraanData['fotobpkb1'] = processedAnswers['fotobpkb1'];
    fotoKendaraanData['fotobpkb2'] = processedAnswers['fotobpkb2'];

    // Foto Legalitas
    fotoLegalitasData['fotoktppemohon'] = processedAnswers['fotoktppemohon'];
    fotoLegalitasData['fotoktppasangan'] = processedAnswers['fotoktppasangan'];
    fotoLegalitasData['fotokk'] = processedAnswers['fotokk'];
    fotoLegalitasData['fotosima'] = processedAnswers['fotosima'];
    fotoLegalitasData['fotonpwp'] = processedAnswers['fotonpwp'];

    // Foto Legalitas
    fotoTempatTinggalData['fotorumah'] = processedAnswers['fotorumah'];
    fotoTempatTinggalData['fotorumahselfiecmo'] =
        processedAnswers['fotorumahselfiecmo'];
    fotoTempatTinggalData['fotolingkunganselfiecmo'] =
        processedAnswers['fotolingkunganselfiecmo'];
    fotoTempatTinggalData['fotobuktimilikrumah'] =
        processedAnswers['fotobuktimilikrumah'];
    fotoTempatTinggalData['fotocloseuppemohon'] =
        processedAnswers['fotocloseuppemohon'];
    fotoTempatTinggalData['fotopemohonttdfpp'] =
        processedAnswers['fotopemohonttdfpp'];
    fotoTempatTinggalData['fotofppdepan'] = processedAnswers['fotofppdepan'];
    fotoTempatTinggalData['fotofppbelakang'] =
        processedAnswers['fotofppbelakang'];

    // 3. Gabungkan semua map bagian menjadi satu map akhir yang bertingkat
    final Map<String, dynamic> nestedData = {
      // foto array
      'fotoPekerjaan': fotoPekerjaanList,
      'fotoSimulasi': fotoSimulasiList,
      'fotoTambahan': fotoTambahanList,
      'fotoKendaraan': fotoKendaraanData,
      'fotoLegalitas': fotoLegalitasData,
      'fotoTempatTinggal': fotoTempatTinggalData,
      // field form
      'application_id': processedAnswers['application_id'],
      'nik': processedAnswers['nik'],
      'dataDealer': dealerData,
      'dataKendaraan': kendaraanData,
      'dataAlamatSurvey': alamatSurveyData,
      'dataPemohon': pemohonData,
      'dataPasangan': pasanganData,
      'dataKontakDarurat': kontakDaruratData,
      'dataPenjamin': penjaminData,
      'dataPasanganPenjamin': pasanganPenjaminData,
      'isPenjaminExist': processedAnswers['isPenjaminExist'],
      'analisacmo': processedAnswers['analisacmo'],

      // Anda bisa menambahkan bagian lain seperti dataPasangan, dataPenjamin, dll. dengan pola yang sama
    };

    return nestedData;
  }
}
