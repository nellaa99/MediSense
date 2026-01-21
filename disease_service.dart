// services/disease_service.dart
import 'package:medisense/models/complaint_model.dart';
import 'package:medisense/models/disease_model.dart';
import 'package:medisense/models/news_model.dart';
import 'package:medisense/models/symptom_track_model.dart';

import '../models/user_model.dart';
import 'storage_service.dart';

class DiseaseService {
  static final DiseaseService _instance = DiseaseService._internal();
  factory DiseaseService() => _instance;
  DiseaseService._internal();

  final StorageService<DiseaseModel> _diseaseStorage = StorageService<DiseaseModel>();
  final StorageService<NewsModel> _newsStorage = StorageService<NewsModel>();
  final StorageService<ComplaintModel> _complaintStorage = StorageService<ComplaintModel>();
  final StorageService<SymptomTrackModel> _symptomTrackStorage = StorageService<SymptomTrackModel>();

  bool _isInitialized = false;

  // Future method untuk inisialisasi data
  Future<void> initializeData() async {
    if (_isInitialized) return;

    await _loadDiseases();
    await _loadNews();
    _isInitialized = true;
  }

  // Load data penyakit
  Future<void> _loadDiseases() async {
    final diseases = [
      DiseaseModel(
        id: '1',
        name: 'Demam Berdarah Dengue (DBD)',
        symptoms: [
          'Demam tinggi mendadak (39-40°C)',
          'Sakit kepala hebat',
          'Nyeri di belakang mata',
          'Nyeri otot dan sendi',
          'Mual dan muntah',
          'Ruam kemerahan pada kulit',
          'Mimisan atau gusi berdarah',
          'Bintik merah di kulit',
          'Kelelahan ekstrem',
        ],
        description: 'DBD adalah penyakit yang disebabkan oleh virus dengue yang ditularkan melalui gigitan nyamuk Aedes aegypti. Penyakit ini dapat berkembang menjadi kondisi yang mengancam jiwa jika tidak ditangani dengan cepat.',
        treatment: [
          'Istirahat total di tempat tidur',
          'Minum banyak cairan (minimal 2-3 liter per hari)',
          'Konsumsi parasetamol untuk menurunkan demam',
          'Hindari aspirin dan ibuprofen',
          'Monitor tanda vital secara berkala',
          'Segera ke rumah sakit jika kondisi memburuk',
          'Transfusi darah jika diperlukan',
        ],
        prevention: [
          'Menguras bak mandi seminggu sekali',
          'Menutup tempat penampungan air',
          'Mengubur barang bekas yang dapat menampung air',
          'Menggunakan obat nyamuk',
          'Memasang kawat kasa pada jendela',
          'Menaburkan bubuk abate pada penampungan air',
          'Memelihara ikan pemakan jentik',
        ],
        severity: 'Tinggi',
        isSeasonal: true,
      ),
      DiseaseModel(
        id: '2',
        name: 'Tuberkulosis (TBC)',
        symptoms: [
          'Batuk berkepanjangan (lebih dari 3 minggu)',
          'Batuk berdarah',
          'Sesak napas',
          'Demam terutama malam hari',
          'Keringat malam',
          'Penurunan berat badan drastis',
          'Kehilangan nafsu makan',
          'Kelelahan kronis',
          'Nyeri dada saat bernapas',
        ],
        description: 'TBC adalah penyakit infeksi bakteri Mycobacterium tuberculosis yang menyerang paru-paru. Penyakit ini menular melalui udara dan dapat menjadi berbahaya jika tidak diobati.',
        treatment: [
          'Konsumsi obat anti-TBC selama 6-9 bulan',
          'Kombinasi obat: Rifampicin, Isoniazid, Pirazinamid, Etambutol',
          'Minum obat secara teratur tanpa putus',
          'Kontrol rutin ke dokter',
          'Istirahat cukup',
          'Konsumsi makanan bergizi tinggi protein',
          'Isolasi pada fase awal pengobatan',
        ],
        prevention: [
          'Vaksinasi BCG pada bayi',
          'Hindari kontak dengan penderita TBC aktif',
          'Gunakan masker saat berdekatan dengan penderita',
          'Jaga daya tahan tubuh',
          'Ventilasi ruangan yang baik',
          'Jemur kasur dan pakaian di bawah sinar matahari',
          'Pola hidup sehat',
        ],
        severity: 'Tinggi',
        isSeasonal: false,
      ),
      DiseaseModel(
        id: '3',
        name: 'Stroke',
        symptoms: [
          'Wajah terlihat turun sebelah',
          'Kelemahan pada satu sisi tubuh',
          'Sulit berbicara atau pelo',
          'Kesulitan memahami pembicaraan',
          'Gangguan penglihatan mendadak',
          'Pusing dan kehilangan keseimbangan',
          'Sakit kepala hebat mendadak',
          'Mati rasa pada wajah, lengan, atau kaki',
          'Kebingungan mendadak',
        ],
        description: 'Stroke terjadi ketika aliran darah ke otak terganggu, baik karena penyumbatan (stroke iskemik) atau pendarahan (stroke hemoragik). Ini adalah kondisi darurat medis yang memerlukan penanganan segera.',
        treatment: [
          'Segera ke IGD rumah sakit (Golden Period: 3-4.5 jam)',
          'Pemberian obat pengencer darah (untuk stroke iskemik)',
          'Operasi pengangkatan bekuan darah jika diperlukan',
          'Terapi fisik untuk pemulihan',
          'Terapi bicara',
          'Terapi okupasi',
          'Kontrol faktor risiko (hipertensi, diabetes, kolesterol)',
        ],
        prevention: [
          'Kontrol tekanan darah secara rutin',
          'Diet rendah garam dan lemak jenuh',
          'Olahraga teratur minimal 30 menit setiap hari',
          'Berhenti merokok',
          'Batasi konsumsi alkohol',
          'Kelola diabetes dengan baik',
          'Kurangi stres',
          'Cek kesehatan berkala',
        ],
        severity: 'Sangat Tinggi',
        isSeasonal: false,
      ),
      DiseaseModel(
        id: '4',
        name: 'Kanker Paru-paru',
        symptoms: [
          'Batuk yang tidak kunjung sembuh',
          'Batuk berdarah',
          'Sesak napas',
          'Nyeri dada yang konstan',
          'Suara serak',
          'Penurunan berat badan tanpa sebab',
          'Kelelahan ekstrem',
          'Kehilangan nafsu makan',
          'Infeksi paru berulang',
        ],
        description: 'Kanker paru-paru adalah pertumbuhan sel abnormal yang tidak terkendali di jaringan paru-paru. Ini adalah salah satu jenis kanker paling mematikan, terutama pada perokok aktif.',
        treatment: [
          'Pembedahan pengangkatan tumor',
          'Kemoterapi',
          'Terapi radiasi',
          'Terapi target',
          'Imunoterapi',
          'Kombinasi beberapa terapi',
          'Perawatan paliatif untuk stadium lanjut',
        ],
        prevention: [
          'Berhenti merokok dan hindari asap rokok',
          'Hindari paparan zat karsinogenik',
          'Gunakan masker di lingkungan berpolusi',
          'Konsumsi makanan kaya antioksidan',
          'Olahraga teratur',
          'Skrining rutin untuk kelompok berisiko tinggi',
          'Hindari radiasi berlebihan',
        ],
        severity: 'Sangat Tinggi',
        isSeasonal: false,
      ),
      DiseaseModel(
        id: '5',
        name: 'Chikungunya',
        symptoms: [
          'Demam tinggi mendadak',
          'Nyeri sendi hebat (terutama lutut, pergelangan)',
          'Pembengkakan sendi',
          'Ruam kulit',
          'Sakit kepala',
          'Nyeri otot',
          'Kelelahan',
          'Mual',
          'Mata merah',
        ],
        description: 'Chikungunya adalah penyakit virus yang ditularkan melalui gigitan nyamuk Aedes. Penyakit ini ditandai dengan nyeri sendi yang dapat berlangsung berminggu-minggu hingga berbulan-bulan.',
        treatment: [
          'Istirahat yang cukup',
          'Minum banyak cairan',
          'Konsumsi parasetamol untuk demam dan nyeri',
          'Hindari aspirin dan NSAID',
          'Kompres dingin pada sendi yang nyeri',
          'Fisioterapi untuk nyeri sendi berkepanjangan',
        ],
        prevention: [
          'Mencegah gigitan nyamuk dengan repelen',
          'Menggunakan kelambu saat tidur',
          'Menguras tempat penampungan air',
          'Menutup rapat tempat penyimpanan air',
          'Menggunakan obat anti nyamuk',
          'Memakai pakaian lengan panjang',
        ],
        severity: 'Sedang',
        isSeasonal: true,
      ),
      DiseaseModel(
        id: '6',
        name: 'Diabetes Mellitus',
        symptoms: [
          'Sering merasa haus',
          'Sering buang air kecil',
          'Penurunan berat badan tanpa sebab',
          'Kelelahan kronis',
          'Penglihatan kabur',
          'Luka yang lambat sembuh',
          'Sering merasa lapar',
          'Kesemutan di tangan atau kaki',
          'Kulit kering dan gatal',
        ],
        description: 'Diabetes adalah penyakit metabolik yang ditandai dengan kadar gula darah tinggi. Terbagi menjadi diabetes tipe 1 (autoimun) dan tipe 2 (gaya hidup).',
        treatment: [
          'Kontrol gula darah secara teratur',
          'Insulin untuk diabetes tipe 1',
          'Obat hipoglikemik oral untuk tipe 2',
          'Diet rendah gula dan karbohidrat',
          'Olahraga teratur',
          'Monitor komplikasi',
          'Perawatan kaki secara rutin',
        ],
        prevention: [
          'Jaga berat badan ideal',
          'Diet seimbang rendah gula',
          'Olahraga minimal 150 menit per minggu',
          'Hindari makanan olahan dan fast food',
          'Cek gula darah berkala',
          'Kelola stres dengan baik',
          'Tidur cukup 7-8 jam',
        ],
        severity: 'Tinggi',
        isSeasonal: false,
      ),
      DiseaseModel(
        id: '7',
        name: 'Malaria',
        symptoms: [
          'Demam tinggi dan menggigil',
          'Berkeringat banyak',
          'Sakit kepala',
          'Mual dan muntah',
          'Diare',
          'Nyeri otot',
          'Kelelahan',
          'Anemia',
          'Kulit dan mata menguning (pada kasus berat)',
        ],
        description: 'Malaria adalah penyakit yang disebabkan oleh parasit Plasmodium yang ditularkan melalui gigitan nyamuk Anopheles betina.',
        treatment: [
          'Obat anti-malaria sesuai jenis plasmodium',
          'Artemisinin Combination Therapy (ACT)',
          'Klorokuin untuk P. vivax',
          'Istirahat total',
          'Minum banyak cairan',
          'Rawat inap untuk kasus berat',
        ],
        prevention: [
          'Gunakan kelambu berinsektisida',
          'Obat anti-malaria untuk daerah endemis',
          'Semprotkan insektisida di rumah',
          'Gunakan lotion anti nyamuk',
          'Pakai pakaian tertutup',
          'Hindari keluar malam di daerah endemis',
        ],
        severity: 'Tinggi',
        isSeasonal: true,
      ),
      DiseaseModel(
        id: '8',
        name: 'Pneumonia',
        symptoms: [
          'Batuk berdahak (kuning, hijau, atau berdarah)',
          'Demam tinggi',
          'Sesak napas',
          'Nyeri dada saat bernapas',
          'Menggigil',
          'Kelelahan',
          'Kehilangan nafsu makan',
          'Napas cepat dan dangkal',
          'Kebingungan (pada lansia)',
        ],
        description: 'Pneumonia adalah infeksi yang menyebabkan peradangan pada kantung udara di satu atau kedua paru-paru. Dapat disebabkan oleh bakteri, virus, atau jamur.',
        treatment: [
          'Antibiotik untuk pneumonia bakterial',
          'Antiviral untuk pneumonia virus',
          'Istirahat yang cukup',
          'Minum banyak cairan',
          'Obat pereda demam dan nyeri',
          'Terapi oksigen jika diperlukan',
          'Rawat inap untuk kasus berat',
        ],
        prevention: [
          'Vaksinasi pneumokokus',
          'Vaksinasi influenza tahunan',
          'Cuci tangan secara teratur',
          'Hindari merokok',
          'Jaga sistem kekebalan tubuh',
          'Hindari kontak dengan orang sakit',
        ],
        severity: 'Tinggi',
        isSeasonal: true,
      ),
    ];

    for (var disease in diseases) {
      await _diseaseStorage.add(disease);
    }
  }

  // Load data berita
  Future<void> _loadNews() async {
    final news = [
      NewsModel(
        id: '1',
        title: 'Kasus DBD Meningkat di Musim Hujan',
        content:
        'Kementerian Kesehatan melaporkan peningkatan kasus Demam Berdarah Dengue (DBD) hingga 35% di berbagai wilayah Indonesia selama musim hujan ini. Masyarakat diimbau untuk melakukan 3M Plus.',
        imageUrl: 'assets/images/dbd.png',
        publishedDate: DateTime.now().subtract(const Duration(days: 2)),
        category: 'Penyakit Musiman',
      ),
      NewsModel(
        id: '2',
        title: 'Pentingnya Deteksi Dini Kanker',
        content:
        'Penelitian terbaru menunjukkan bahwa deteksi dini kanker dapat meningkatkan tingkat kesembuhan hingga 90%.',
        imageUrl: 'assets/images/kanker.png',
        publishedDate: DateTime.now().subtract(const Duration(days: 5)),
        category: 'Kesehatan',
      ),
      NewsModel(
        id: '3',
        title: 'Tips Mencegah Stroke di Usia Muda',
        content:
        'Kasus stroke pada usia muda meningkat akibat gaya hidup tidak sehat. Olahraga dan diet seimbang sangat penting.',
        imageUrl: 'assets/images/stroke.png',
        publishedDate: DateTime.now().subtract(const Duration(days: 7)),
        category: 'Pencegahan',
      ),
      NewsModel(
        id: '4',
        title: 'Program Vaksinasi TBC Gratis',
        content:
        'Pemerintah meluncurkan program vaksinasi TBC gratis untuk anak-anak dan kelompok rentan.',
        imageUrl: 'assets/images/tbc.png',
        publishedDate: DateTime.now().subtract(const Duration(days: 10)),
        category: 'Program Kesehatan',
      ),
    ];

    for (var item in news) {
      await _newsStorage.add(item);
    }
  }

  // Get all diseases
  Future<List<DiseaseModel>> getAllDiseases() async {
    return await _diseaseStorage.getAll();
  }

  // Search disease by symptoms
  Future<List<Map<String, dynamic>>> searchDiseaseBySymptoms(
      List<String> selectedSymptoms) async {
    final diseases = await _diseaseStorage.getAll();
    List<Map<String, dynamic>> results = [];

    for (var disease in diseases) {
      int matchCount = 0;
      for (var symptom in selectedSymptoms) {
        if (disease.symptoms.any((s) =>
        s.toLowerCase().contains(symptom.toLowerCase()) ||
            symptom.toLowerCase().contains(s.toLowerCase()))) {
          matchCount++;
        }
      }

      if (matchCount > 0) {
        double percentage = (matchCount / disease.symptoms.length) * 100;
        results.add({
          'disease': disease,
          'matchCount': matchCount,
          'percentage': percentage,
        });
      }
    }

    results.sort((a, b) => b['percentage'].compareTo(a['percentage']));
    return results;
  }

  // Get all news
  Future<List<NewsModel>> getAllNews() async {
    return await _newsStorage.getAll();
  }

  // Add news (admin)
  Future<void> addNews(NewsModel news) async {
    await _newsStorage.add(news);
  }

  // Update news (admin)
  Future<bool> updateNews(String id, NewsModel news) async {
    return await _newsStorage.update((n) => n.id == id, news);
  }

  // Delete news (admin)
  Future<bool> deleteNews(String id) async {
    return await _newsStorage.delete((n) => n.id == id);
  }

  // Add complaint
  Future<void> addComplaint(ComplaintModel complaint) async {
    await _complaintStorage.add(complaint);
  }

  // Get all complaints
  Future<List<ComplaintModel>> getAllComplaints() async {
    return await _complaintStorage.getAll();
  }

  // Track symptoms
  Future<void> trackSymptom(SymptomTrackModel track) async {
    await _symptomTrackStorage.add(track);
  }

  // Get symptom history
  Future<List<SymptomTrackModel>> getSymptomHistory(String userId) async {
    final allTracks = await _symptomTrackStorage.getAll();
    return allTracks.where((t) => t.userId == userId).toList();
  }
}