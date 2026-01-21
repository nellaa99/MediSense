import 'package:flutter/material.dart';
import 'package:medisense/models/disease_model.dart';
import '../../models/user_model.dart';
import '../../services/disease_service.dart';

class DiseaseInfoScreen extends StatefulWidget {
  const DiseaseInfoScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseInfoScreen> createState() => _DiseaseInfoScreenState();
}

class _DiseaseInfoScreenState extends State<DiseaseInfoScreen> {
  List<DiseaseModel> _diseases = [];
  List<DiseaseModel> _filteredDiseases = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDiseases();
  }

  Future<void> _loadDiseases() async {
  setState(() => _isLoading = true);
  final diseases = await DiseaseService().getAllDiseases();
  setState(() {
    _diseases = diseases.cast<DiseaseModel>();
    _filteredDiseases = diseases.cast<DiseaseModel>();
    _isLoading = false;
  });
}

  void _filterDiseases(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDiseases = _diseases;
      } else {
        _filteredDiseases = _diseases.where((disease) => disease.name.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Informasi Penyakit', style: TextStyle(color: Color(0xFF2C3E50))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: _filterDiseases,
              decoration: InputDecoration(
                hintText: 'Cari penyakit...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF4C9EEB)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF4C9EEB))),
                filled: true,
                fillColor: const Color(0xFFF5F7FA),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredDiseases.length,
                    itemBuilder: (context, index) {
                      final disease = _filteredDiseases[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: const Color(0xFF4C9EEB).withOpacity(0.1), shape: BoxShape.circle),
                            child: Icon(Icons.medical_services, color: _getSeverityColor(disease.severity)),
                          ),
                          title: Text(disease.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2C3E50))),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(disease.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: Color(0xFF7F8C8D))),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: _getSeverityColor(disease.severity).withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                                    child: Text(disease.severity, style: TextStyle(fontSize: 11, color: _getSeverityColor(disease.severity), fontWeight: FontWeight.bold)),
                                  ),
                                  if (disease.isSeasonal) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                                      child: const Text('Musiman', style: TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF4C9EEB), size: 16),
                          onTap: () => _showDiseaseDetail(disease),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Sangat Tinggi': return Colors.red;
      case 'Tinggi': return Colors.orange;
      case 'Sedang': return Colors.yellow[700]!;
      default: return Colors.green;
    }
  }

  void _showDiseaseDetail(DiseaseModel disease) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(disease.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)))),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const Divider(),
                _buildSection('Deskripsi', disease.description),
                _buildListSection('Gejala', disease.symptoms),
                _buildListSection('Pengobatan', disease.treatment),
                _buildListSection('Pencegahan', disease.prevention),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4C9EEB))),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 14, color: Color(0xFF7F8C8D), height: 1.5)),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildListSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4C9EEB))),
        const SizedBox(height: 8),
        ...items.take(5).map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(color: Color(0xFF4C9EEB), fontSize: 16)),
              Expanded(child: Text(item, style: const TextStyle(fontSize: 14, color: Color(0xFF7F8C8D)))),
            ],
          ),
        )).toList(),
        const SizedBox(height: 15),
      ],
    );
  }
}
