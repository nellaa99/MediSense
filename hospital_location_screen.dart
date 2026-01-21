import 'package:flutter/material.dart';
import '../../utils/url_launcher_helper.dart';

class HospitalLocationScreen extends StatefulWidget {
  const HospitalLocationScreen({Key? key}) : super(key: key);

  @override
  State<HospitalLocationScreen> createState() => _HospitalLocationScreenState();
}

class _HospitalLocationScreenState extends State<HospitalLocationScreen> {
  String _selectedCity = 'Semua';
  final _urlHelper = UrlLauncherHelper();


  final List<Map<String, String>> _allHospitals = [
    // PANGKALPINANG
    {
      'name': 'RSUD Depati Hamzah',
      'address': 'Jl. Soekarno Hatta No.1, Bukit Intan, Pangkalpinang',
      'city': 'Pangkalpinang',
      'distance': '2.5 km',
      'phone': '0717-421022',
      'specialist': 'Rumah Sakit Umum Daerah',
      'rating': '4.3',
      'lat': '-2.143622694784082',
      'lng': '106.12470584417689',
    },
    {
      'name': 'RS Bakti Timah',
      'address': 'Jl. Jend. Ahmad Yani No.22, Bukit Intan, Pangkalpinang',
      'city': 'Pangkalpinang',
      'distance': '3.1 km',
      'phone': '0717-422871',
      'specialist': 'RS Swasta, Bedah, Penyakit Dalam',
      'rating': '4.2',
      'lat': '-2.114372720098832',
      'lng': '106.11108977116461',
    },
    {
      'name': 'RS Primaya Hospital Pangkalpinang',
      'address': 'Jl. Jend. Sudirman No.16, Bukit Intan, Pangkalpinang',
      'city': 'Pangkalpinang',
      'distance': '1.8 km',
      'phone': '0717-9330999',
      'specialist': 'RS Swasta, Semua Spesialis',
      'rating': '4.5',
      'lat': '-2.1436917521415237',
      'lng': '106.09816738650612',
    },
    {
      'name': 'RS Siloam Pangkalpinang',
      'address': 'Jl. Raya Koba KM 8, Bukit Intan, Pangkalpinang',
      'city': 'Pangkalpinang',
      'distance': '8.2 km',
      'phone': '0717-9393999',
      'specialist': 'RS Swasta, Kardiologi, Neurologi, Onkologi',
      'rating': '4.6',
      'lat': '-2.1532037385805327',
      'lng': '106.12908222883537',
    },
    {
      'name': 'RS Bhayangkara Pangkalpinang',
      'address': 'Jl. Raya Pangkalpinang, Taman Bunga, Pangkalpinang',
      'city': 'Pangkalpinang',
      'distance': '4.0 km',
      'phone': '0717-422100',
      'specialist': 'RS Kepolisian, Umum',
      'rating': '4.1',
      'lat': '-2.1635713245689807',
      'lng': '106.16637711349387',
    },
    {
      'name': 'Prodia Pangkal Pinang',
      'address': 'Jl. Abdurrahman Siddik No.176, RT.02/RW.01, Gedung Nasional, Kec. Taman Sari, Kota Pangkal Pinang, Kepulauan Bangka Belitung 33127',
      'city': 'Pangkalpinang',
      'distance': '2.2 km',
      'phone': '1 500 830',
      'specialist': 'Klinik Umum, Laboratorium',
      'rating': '4.0',
      'lat': '-2.111047758819078',
      'lng': '106.11335369681359',
    },
    {
      'name': 'Klinik Pratama Dan Apotek Pku Muhammadiyah Pangkalpinang',
      'address': 'Jl. Sudirman, Taman Bunga, Pangkalpinang',
      'city': 'Pangkalpinang',
      'distance': '3.5 km',
      'phone': '0717-425678',
      'specialist': 'Klinik Pratama, Rawat Jalan',
      'rating': '3.9',
      'lat': '-2.114777640209327',
      'lng': '106.11215673652933',
    },
    {
      'name': 'Puskesmas Air Itam',
      'address': 'Jl. Masjid Jamik, Bukit Intan, Pangkalpinang',
      'city': 'Pangkalpinang',
      'distance': '2.8 km',
      'phone': '(0717) 4256085',
      'specialist': 'Puskesmas, Pelayanan Kesehatan Dasar',
      'rating': '4.0',
      'lat': '-2.1233646454339072',
      'lng': '106.15994033652933',
    },


    {
      'name': 'RSUD Provinsi Dr. Ir. H. Soekarno Bangka Belitung',
      'address': 'Jl. Zipur Desa Air Anyir Kec, Riding Panjang, Kec. Merawang, Kabupaten Bangka, Kepulauan Bangka Belitung 33172',
      'city': 'PangkalPinang',
      'distance': '1.5 km',
      'phone': '(0717) 9106754',
      'specialist': 'Rumah Sakit Umum Daerah',
      'rating': '4.2',
      'lat': '-2.0067931661729324',
      'lng': '106.14358909815236',
    },
    {
      'name': 'RS Medika Stannia Sungailiat',
      'address': 'Jl. Jend. Sudirman, Sungailiat, Bangka',
      'city': 'Sungailiat',
      'distance': '2.0 km',
      'phone': '0717-92345',
      'specialist': 'RS Swasta, Penyakit Dalam, Bedah',
      'rating': '4.3',
      'lat': '-1.8578267433091558',
      'lng': '106.11767244232924',
    },
    {
      'name': 'RS. ARSANI',
      'address': 'Jl. raya Air, Kenanga, Sungai Liat, Kabupaten Bangka, Kepulauan Bangka Belitung 33251',
      'city': 'Sungailiat',
      'distance': '1.2 km',
      'phone': '(0717) 4297825',
      'specialist': 'RS Swasta',
      'rating': '4.4',
      'lat': '-1.9126856514203983',
      'lng': '106.1195990441769',
    },
    {
      'name': 'RSUD Dr. H. Marsidi Judono',
      'address': 'Jl. Jend. Sudirman No.KM 5, RW.5, Aik Rayak, Kec. Tj. Pandan, Kabupaten Belitung, Kepulauan Bangka Belitung 33411',
      'city': 'Belitung',
      'distance': '50 km',
      'phone': '(0719) 22190',
      'specialist': 'RS Umum',
      'rating': '4.0',
      'lat': '-2.748727970183168',
      'lng': '107.67828278650613',
    },
    {
      'name': 'RSUD SJAFRIE RACHMAN KABUPATEN BANGKA',
      'address': '2W2R+224, Jl. Raya Sungailiat, Mentok, Kec. Puding Besar, Kabupaten Bangka, Kepulauan Bangka Belitung 33179',
      'city': 'Sungailiat',
      'distance': '20 km',
      'phone': '0813-9843-0909',
      'specialist': 'RS Umum, Rawat Jalan',
      'rating': '3.8',
      'lat': '-1.9998234654885565',
      'lng': '105.94009938650612',
    },
    {
      'name': 'Puskesmas Pariwisata Sungailiat',
      'address': 'Jl. Jenderal Sudirman No.1, Sri Menanti, Sungai Liat, Kabupaten Bangka, Kepulauan Bangka Belitung 33211',
      'city': 'Sungailiat',
      'distance': '1.0 km',
      'phone': '(0717) 94443',
      'specialist': 'Puskesmas, Pelayanan Kesehatan Dasar',
      'rating': '3.9',
      'lat': '-1.8712094189325181',
      'lng': '106.11557557282312',
    },
    {
      'name': 'RSUD Depati Bahrin',
      'address': 'Jl. Jenderal Sudirman No.195, Parit Padang, Sungai Liat, Kabupaten Bangka, Kepulauan Bangka Belitung 33215',
      'city': 'Sungailiat',
      'distance': '52 km',
      'phone': '(0717) 92489',
      'specialist': 'Rumah Sakit Umum Daerah',
      'rating': '4.1',
      'lat': '-1.8818624620737385',
      'lng': '106.11445328650615',
    },
  ];

  List<Map<String, String>> get _filteredHospitals {
    if (_selectedCity == 'Semua') {
      return _allHospitals;
    }
    return _allHospitals.where((h) => h['city'] == _selectedCity).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Rumah Sakit Terdekat',
          style: TextStyle(color: Color(0xFF2C3E50)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Color(0xFF4C9EEB)),
            onSelected: (value) {
              setState(() {
                _selectedCity = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Semua', child: Text('Semua Lokasi')),
              const PopupMenuItem(value: 'Pangkalpinang', child: Text('Pangkalpinang')),
              const PopupMenuItem(value: 'Sungailiat', child: Text('Sungailiat')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMapPlaceholder(),
          _buildFilterInfo(),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _filteredHospitals.length,
              itemBuilder: (context, index) {
                final hospital = _filteredHospitals[index];
                return _buildHospitalCard(hospital);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.map, size: 80, color: Colors.grey[500]),
          const Positioned(
            top: 15,
            left: 15,
            child: Text(
              '📍 Bangka Belitung',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF4C9EEB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.my_location, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    _selectedCity == 'Semua' ? 'Semua Lokasi' : _selectedCity,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Ditemukan ${_filteredHospitals.length} fasilitas kesehatan',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF7F8C8D),
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF4C9EEB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _selectedCity,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF4C9EEB),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalCard(Map<String, String> hospital) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(15),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4C9EEB).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getHospitalIcon(hospital['specialist']!),
                color: const Color(0xFF4C9EEB),
                size: 28,
              ),
            ),
            title: Text(
              hospital['name']!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildInfoRow(Icons.location_on, hospital['address']!),
                const SizedBox(height: 5),
                _buildInfoRow(Icons.phone, hospital['phone']!),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.medical_services, size: 14, color: Color(0xFF7F8C8D)),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        hospital['specialist']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4C9EEB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildTags(hospital),
              ],
            ),
          ),
          _buildActionButtons(hospital),
        ],
      ),
    );
  }

  IconData _getHospitalIcon(String specialist) {
    if (specialist.contains('Klinik')) {
      return Icons.local_pharmacy;
    } else if (specialist.contains('Puskesmas')) {
      return Icons.health_and_safety;
    } else {
      return Icons.local_hospital;
    }
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF7F8C8D)),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
          ),
        ),
      ],
    );
  }

  Widget _buildTags(Map<String, String> hospital) {
    return Row(
      children: [
        _buildTag(
          Icons.navigation,
          hospital['distance']!,
          const Color(0xFF4CAF50),
        ),
        const SizedBox(width: 10),
        _buildTag(
          Icons.star,
          hospital['rating']!,
          const Color(0xFFFF9800),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF9C27B0).withOpacity(0.1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            hospital['city']!,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9C27B0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTag(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Map<String, String> hospital) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () async {
                await _urlHelper.makePhoneCall(
                  phoneNumber: hospital['phone']!,
                  context: context,
                );
              },
              icon: const Icon(Icons.phone, size: 18),
              label: const Text('Hubungi'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF4C9EEB),
                side: const BorderSide(color: Color(0xFF4C9EEB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () async {
                await _urlHelper.openGoogleMaps(
                  latitude: hospital['lat']!,
                  longitude: hospital['lng']!,
                  placeName: hospital['name']!,
                  context: context,
                );
              },
              icon: const Icon(Icons.directions, size: 18, color: Colors.white),
              label: const Text('Rute', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C9EEB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}