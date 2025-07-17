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

    // Data pekerjaan/usaha pemohon
    pekerjaanData['application_id'] = flatFormAnswers['application_id'];
    pekerjaanData['nik'] = flatFormAnswers['nik'];
    pekerjaanData['jenispekerjaan'] = flatFormAnswers['jenispekerjaan'];
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

    // Data pekerjaan/usaha pasangan pemohon
    pasanganPekerjaanData['application_id'] = flatFormAnswers['application_id'];
    pasanganPekerjaanData['nik'] = flatFormAnswers['nik'];
    pasanganPekerjaanData['pekerjaanpasangan'] =
        flatFormAnswers['pekerjaanpasangan'];
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

    // Data pekerjaan/usaha Penjamin
    pekerjaanPenjaminData['application_id'] = flatFormAnswers['application_id'];
    pekerjaanPenjaminData['nik'] = flatFormAnswers['nik'];
    pekerjaanPenjaminData['pekerjaanpenjamin'] =
        flatFormAnswers['pekerjaanpenjamin'];
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

    // Data pekerjaan/usaha pasangan Penjamin
    pasanganPekerjaanPenjaminData['application_id'] =
        flatFormAnswers['application_id'];
    pasanganPekerjaanPenjaminData['nik'] = flatFormAnswers['nik'];
    pasanganPekerjaanPenjaminData['pekerjaanpasanganpenjamin'] =
        flatFormAnswers['pekerjaanpasanganpenjamin'];
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
    kontakDaruratData['application_id'] = flatFormAnswers['application_id'];
    kontakDaruratData['nik'] = flatFormAnswers['nik'];
    kontakDaruratData['namakontak'] = flatFormAnswers['namakontak'];
    kontakDaruratData['jeniskelaminkontak'] =
        flatFormAnswers['jeniskelaminkontak'];
    kontakDaruratData['hubungankeluarga'] = flatFormAnswers['hubungankeluarga'];
    kontakDaruratData['nohpkontak'] = flatFormAnswers['nohpkontak'];
    kontakDaruratData['alamatkontak'] = flatFormAnswers['alamatkontak'];
    kontakDaruratData['kodeposkontak'] = flatFormAnswers['kodeposkontak'];

    // Foto Kendaraan
    fotoKendaraanData['odometer'] = flatFormAnswers['odometer'];
    // fotoKendaraanData['fotounitdepan'] =
    //     PhotoData.fromJson(flatFormAnswers['fotounitdepan']!);
    fotoKendaraanData['fotounitdepan'] = flatFormAnswers['fotounitdepan'];
    fotoKendaraanData['fotounitbelakang'] = flatFormAnswers['fotounitbelakang'];
    fotoKendaraanData['fotounitinteriordepan'] =
        flatFormAnswers['fotounitinteriordepan'];
    fotoKendaraanData['fotounitmesinplat'] =
        flatFormAnswers['fotounitmesinplat'];
    fotoKendaraanData['fotomesin'] = flatFormAnswers['fotomesin'];
    fotoKendaraanData['fotounitselfiecmo'] =
        flatFormAnswers['fotounitselfiecmo'];
    fotoKendaraanData['fotospeedometer'] = flatFormAnswers['fotospeedometer'];
    fotoKendaraanData['fotogesekannoka'] = flatFormAnswers['fotogesekannoka'];
    fotoKendaraanData['fotostnk'] = flatFormAnswers['fotostnk'];
    fotoKendaraanData['fotonoticepajak'] = flatFormAnswers['fotonoticepajak'];
    fotoKendaraanData['fotobpkb1'] = flatFormAnswers['fotobpkb1'];
    fotoKendaraanData['fotobpkb2'] = flatFormAnswers['fotobpkb2'];

    // Foto Legalitas
    fotoLegalitasData['fotoktppemohon'] = flatFormAnswers['fotoktppemohon'];
    fotoLegalitasData['fotoktppasangan'] = flatFormAnswers['fotoktppasangan'];
    fotoLegalitasData['fotokk'] = flatFormAnswers['fotokk'];
    fotoLegalitasData['fotosima'] = flatFormAnswers['fotosima'];
    fotoLegalitasData['fotonpwp'] = flatFormAnswers['fotonpwp'];

    // Foto Legalitas
    fotoTempatTinggalData['fotorumah'] = flatFormAnswers['fotorumah'];
    fotoTempatTinggalData['fotorumahselfiecmo'] =
        flatFormAnswers['fotorumahselfiecmo'];
    fotoTempatTinggalData['fotolingkunganselfiecmo'] =
        flatFormAnswers['fotolingkunganselfiecmo'];
    fotoTempatTinggalData['fotobuktimilikrumah'] =
        flatFormAnswers['fotobuktimilikrumah'];
    fotoTempatTinggalData['fotocloseuppemohon'] =
        flatFormAnswers['fotocloseuppemohon'];
    fotoTempatTinggalData['fotopemohonttdfpp'] =
        flatFormAnswers['fotopemohonttdfpp'];
    fotoTempatTinggalData['fotofppdepan'] = flatFormAnswers['fotofppdepan'];
    fotoTempatTinggalData['fotofppbelakang'] =
        flatFormAnswers['fotofppbelakang'];

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
}

class FormProcessingService {
  /// Mengubah Map datar dari form menjadi Map bertingkat yang sesuai dengan
  /// struktur model AplikasiSurvey.
  Map<String, dynamic> processFormToNestedMap(
      Map<String, dynamic> flatFormAnswers) {
    // --- TAMBAHKAN BLOK LOGIKA INI DI PALING ATAS ---
    final Map<String, dynamic> processedAnswers = {};
    flatFormAnswers.forEach((key, value) {
      if (value is PhotoData) {
        // Jika value adalah PhotoData, ubah jadi Map via toJson()
        processedAnswers[key] = value.toJson();
      } else {
        // Jika bukan, gunakan value aslinya (String, int, Map dari file picker, dll.)
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

    // Lakukan iterasi pada semua entri di map datar
    flatFormAnswers.forEach((key, value) {
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
    kendaraanData['kondisiKendaraan'] = flatFormAnswers['kondisiKendaraan'];
    kendaraanData['merkkendaraan'] = flatFormAnswers['merkkendaraan'];
    kendaraanData['typekendaraan'] = flatFormAnswers['typekendaraan'];
    kendaraanData['tahunkendaraan'] = flatFormAnswers['tahunkendaraan'];
    kendaraanData['nopolisikendaraan'] = flatFormAnswers['nopolisikendaraan'];
    // Mengisi data untuk bagian Profil Pembiayaan
    kendaraanData['hargakendaraan'] = flatFormAnswers['hargakendaraan'];
    kendaraanData['uangmuka'] = flatFormAnswers['uangmuka'];
    kendaraanData['pokokhutang'] = flatFormAnswers['pokokhutang'];

    // Mengisi data untuk bagian Alamat Survey
    alamatSurveyData['alamatsurvey'] = flatFormAnswers['alamatsurvey'];
    alamatSurveyData['rtsurvey'] = flatFormAnswers['rtsurvey'];
    alamatSurveyData['rwsurvey'] = flatFormAnswers['rwsurvey'];
    alamatSurveyData['kodepoksurvey'] = flatFormAnswers['kodepoksurvey'];
    alamatSurveyData['kelsurvey'] = flatFormAnswers['kelsurvey'];
    alamatSurveyData['kecsurvey'] = flatFormAnswers['kecsurvey'];
    alamatSurveyData['kotasurvey'] = flatFormAnswers['kotasurvey'];
    alamatSurveyData['provinsisurvey'] = flatFormAnswers['provinsisurvey'];

    // Mengisi data untuk bagian Pemohon (termasuk data pekerjaan)
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
    // Data pekerjaan/usaha pemohon
    pekerjaanData['jenispekerjaan'] = flatFormAnswers['jenispekerjaan'];
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
    pemohonData['dataPekerjaan'] = pekerjaanData;

    // Mengisi data untuk bagian Pasangan Pemohon (termasuk data pekerjaan)
    pasanganData['namapasangan'] = flatFormAnswers['namapasangan'];
    pasanganData['namapanggilan'] = flatFormAnswers['namapanggilan'];
    pasanganData['ktppasangan'] = flatFormAnswers['ktppasangan'];
    pasanganData['agamapasangan'] = flatFormAnswers['agamapasangan'];
    pasanganData['warganegarapasangan'] =
        flatFormAnswers['warganegarapasangan'];
    pasanganData['notelppasangan'] = flatFormAnswers['notelppasangan'];
    pasanganData['nomortelepon'] = flatFormAnswers['nomortelepon'];
    pasanganData['nohppasangan'] = flatFormAnswers['nohppasangan'];
    // Data pekerjaan/usaha pasangan pemohon
    pasanganData['pekerjaanpasangan'] = flatFormAnswers['pekerjaanpasangan'];
    pasanganData['namaperusahaanpasangan'] =
        flatFormAnswers['namaperusahaanpasangan'];
    pasanganData['jabatanpasangan'] = flatFormAnswers['jabatanpasangan'];
    pasanganData['ketjabatanpasangan'] = flatFormAnswers['ketjabatanpasangan'];
    pasanganData['alamatusahapasangan'] =
        flatFormAnswers['alamatusahapasangan'];
    pasanganData['kodeposperusahaanpasangan'] =
        flatFormAnswers['kodeposperusahaanpasangan'];
    pasanganData['noteleponusahapasangan'] =
        flatFormAnswers['noteleponusahapasangan'];
    pasanganData['masakerjapasangan'] = flatFormAnswers['masakerjapasangan'];
    pasanganData['gajipasangan'] = flatFormAnswers['gajipasangan'];
    pasanganData['slipgajipasangan'] = flatFormAnswers['slipgajipasangan'];
    pasanganData['payrollpasangan'] = flatFormAnswers['payrollpasangan'];
    pasanganData['bidangusahapasangan'] =
        flatFormAnswers['bidangusahapasangan'];
    pasanganData['lamausahapasangan'] = flatFormAnswers['lamausahapasangan'];
    pasanganData['omzetusahapasangan'] = flatFormAnswers['omzetusahapasangan'];
    pasanganData['profitusahapasangan'] =
        flatFormAnswers['profitusahapasangan'];

    // Mengisi data untuk bagian Kontak Darurat
    kontakDaruratData['namakontak'] = flatFormAnswers['namakontak'];
    kontakDaruratData['jeniskelaminkontak'] =
        flatFormAnswers['jeniskelaminkontak'];
    kontakDaruratData['hubungankeluarga'] = flatFormAnswers['hubungankeluarga'];
    kontakDaruratData['nohpkontak'] = flatFormAnswers['nohpkontak'];
    kontakDaruratData['alamatkontak'] = flatFormAnswers['alamatkontak'];
    kontakDaruratData['kodeposkontak'] = flatFormAnswers['kodeposkontak'];

    // Mengisi data untuk bagian Penjamin (termasuk data pekerjaan)
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
    // Data pekerjaan/usaha Penjamin
    pekerjaanPenjaminData['pekerjaanpenjamin'] =
        flatFormAnswers['pekerjaanpenjamin'];
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
    penjaminData['dataPekerjaanPenjamin'] = pekerjaanPenjaminData;

    // Mengisi data untuk bagian Pasangan Penjamin (termasuk data pekerjaan)
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
    // Data pekerjaan/usaha pasangan Penjamin
    pasanganPenjaminData['pekerjaanpasanganpenjamin'] =
        flatFormAnswers['pekerjaanpasanganpenjamin'];
    pasanganPenjaminData['namaperusahaanpasanganpenjamin'] =
        flatFormAnswers['namaperusahaanpasanganpenjamin'];
    pasanganPenjaminData['jabatanpasanganpenjamin'] =
        flatFormAnswers['jabatanpasanganpenjamin'];
    pasanganPenjaminData['ketjabatanpasanganpenjamin'] =
        flatFormAnswers['ketjabatanpasanganpenjamin'];
    pasanganPenjaminData['alamatperusahaanpasanganpenjamin'] =
        flatFormAnswers['alamatperusahaanpasanganpenjamin'];
    pasanganPenjaminData['kodeposperusahaanpasanganpenjamin'] =
        flatFormAnswers['kodeposperusahaanpasanganpenjamin'];
    pasanganPenjaminData['noteleponusahapasanganpenjamin'] =
        flatFormAnswers['noteleponusahapasanganpenjamin'];
    pasanganPenjaminData['masakerjapasanganpenjamin'] =
        flatFormAnswers['masakerjapasanganpenjamin'];
    pasanganPenjaminData['gajipasanganpenjamin'] =
        flatFormAnswers['gajipasanganpenjamin'];
    pasanganPenjaminData['slipgajipasanganpenjamin'] =
        flatFormAnswers['slipgajipasanganpenjamin'];
    pasanganPenjaminData['payrollpasanganpenjamin'] =
        flatFormAnswers['payrollpasanganpenjamin'];
    pasanganPenjaminData['bidangusahapasanganpenjamin'] =
        flatFormAnswers['bidangusahapasanganpenjamin'];
    pasanganPenjaminData['lamausahapasanganpenjamin'] =
        flatFormAnswers['lamausahapasanganpenjamin'];
    pasanganPenjaminData['omzetusahapasanganpenjamin'] =
        flatFormAnswers['omzetusahapasanganpenjamin'];
    pasanganPenjaminData['profitusahapasanganpenjamin'] =
        flatFormAnswers['profitusahapasanganpenjamin'];

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
    fotoKendaraanData['odometer'] = flatFormAnswers['odometer'];
    fotoKendaraanData['fotounitdepan'] = flatFormAnswers['fotounitdepan'];
    fotoKendaraanData['fotounitbelakang'] = flatFormAnswers['fotounitbelakang'];
    fotoKendaraanData['fotounitinteriordepan'] =
        flatFormAnswers['fotounitinteriordepan'];
    fotoKendaraanData['fotounitmesinplat'] =
        flatFormAnswers['fotounitmesinplat'];
    fotoKendaraanData['fotomesin'] = flatFormAnswers['fotomesin'];
    fotoKendaraanData['fotounitselfiecmo'] =
        flatFormAnswers['fotounitselfiecmo'];
    fotoKendaraanData['fotospeedometer'] = flatFormAnswers['fotospeedometer'];
    fotoKendaraanData['fotogesekannoka'] = flatFormAnswers['fotogesekannoka'];
    fotoKendaraanData['fotostnk'] = flatFormAnswers['fotostnk'];
    fotoKendaraanData['fotonoticepajak'] = flatFormAnswers['fotonoticepajak'];
    fotoKendaraanData['fotobpkb1'] = flatFormAnswers['fotobpkb1'];
    fotoKendaraanData['fotobpkb2'] = flatFormAnswers['fotobpkb2'];

    // Foto Legalitas
    fotoLegalitasData['fotoktppemohon'] = flatFormAnswers['fotoktppemohon'];
    fotoLegalitasData['fotoktppasangan'] = flatFormAnswers['fotoktppasangan'];
    fotoLegalitasData['fotokk'] = flatFormAnswers['fotokk'];
    fotoLegalitasData['fotosima'] = flatFormAnswers['fotosima'];
    fotoLegalitasData['fotonpwp'] = flatFormAnswers['fotonpwp'];

    // Foto Legalitas
    fotoTempatTinggalData['fotorumah'] = flatFormAnswers['fotorumah'];
    fotoTempatTinggalData['fotorumahselfiecmo'] =
        flatFormAnswers['fotorumahselfiecmo'];
    fotoTempatTinggalData['fotolingkunganselfiecmo'] =
        flatFormAnswers['fotolingkunganselfiecmo'];
    fotoTempatTinggalData['fotobuktimilikrumah'] =
        flatFormAnswers['fotobuktimilikrumah'];
    fotoTempatTinggalData['fotocloseuppemohon'] =
        flatFormAnswers['fotocloseuppemohon'];
    fotoTempatTinggalData['fotopemohonttdfpp'] =
        flatFormAnswers['fotopemohonttdfpp'];
    fotoTempatTinggalData['fotofppdepan'] = flatFormAnswers['fotofppdepan'];
    fotoTempatTinggalData['fotofppbelakang'] =
        flatFormAnswers['fotofppbelakang'];

    // 3. Gabungkan semua map bagian menjadi satu map akhir yang bertingkat
    final Map<String, dynamic> nestedData = {
      'application_id': flatFormAnswers['application_id'],
      'nik': flatFormAnswers['nik'],
      'fotoKendaraan': fotoKendaraanData,
      'fotoLegalitas': fotoLegalitasData,
      'fotoTempatTinggal': fotoTempatTinggalData,
      'fotoPekerjaan': fotoPekerjaanList,
      'fotoSimulasi': fotoSimulasiList,
      'fotoTambahan': fotoTambahanList,
      'dataDealer': dealerData,
      'dataKendaraan': kendaraanData,
      'dataAlamatSurvey': alamatSurveyData,
      'dataPemohon': pemohonData,
      'dataPasangan': pasanganData,
      'dataKontakDarurat': kontakDaruratData,
      'dataPenjamin': penjaminData,
      'dataPasanganPenjamin': pasanganPenjaminData,
      'isPenjaminExist': flatFormAnswers['isPenjaminExist'],
      'analisacmo': flatFormAnswers['analisacmo'],

      // Anda bisa menambahkan bagian lain seperti dataPasangan, dataPenjamin, dll. dengan pola yang sama
    };

    return nestedData;
  }
}
