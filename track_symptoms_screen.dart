import 'package:flutter/material.dart';
import 'package:medisense/models/symptom_track_model.dart';
import '../../services/auth_service.dart';
import '../../services/symptom_service.dart';
import '../../utils/extensions.dart';

class TrackSymptomsScreen extends StatefulWidget {
  const TrackSymptomsScreen({Key? key}) : super(key: key);

  @override
  State<TrackSymptomsScreen> createState() => _TrackSymptomsScreenState();
}

class _TrackSymptomsScreenState extends State<TrackSymptomsScreen> {
  List<SymptomTrackModel> _history = [];
  bool _isLoading = true;
  final SymptomService _symptomService = SymptomService();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final history = await _symptomService.getSymptomCheckHistory();
      if (mounted) {
        setState(() {
          _history = history;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading history: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // FIX: Method untuk menambah track baru dengan callback
  void _addNewTrack() {
    showDialog(
      context: context,
      builder: (context) => _AddTrackDialog(
        onSaved: (newTrack) {
          // FIX: Langsung tambahkan ke list tanpa perlu reload dari Firebase
          if (mounted) {
            setState(() {
              _history.insert(0, newTrack); // Insert di posisi paling atas
            });
            
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Gejala berhasil dicatat'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Track Gejala Harian',
          style: TextStyle(color: Color(0xFF2C3E50)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 20),
                      Text(
                        'Belum ada riwayat gejala',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Mulai catat gejala Anda hari ini',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadHistory,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final track = _history[index];
                      final severity = track.results['severity']?.toString() ?? 'Ringan';

                      return Dismissible(
                        key: Key(track.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white, size: 30),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Hapus Riwayat'),
                              content: const Text('Apakah Anda yakin ingin menghapus riwayat ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) async {
                          // Simpan track yang akan dihapus untuk undo
                          final deletedTrack = track;
                          final deletedIndex = index;

                          // Hapus dari list
                          setState(() {
                            _history.removeAt(deletedIndex);
                          });

                          // Hapus dari Firebase
                          final success = await _symptomService.deleteSymptomCheck(track.id);

                          if (mounted) {
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Riwayat berhasil dihapus'),
                                  backgroundColor: Colors.green,
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    textColor: Colors.white,
                                    onPressed: () async {
                                      // Restore ke list
                                      setState(() {
                                        _history.insert(deletedIndex, deletedTrack);
                                      });
                                      // Restore ke Firebase
                                      await _symptomService.saveSymptomCheck(deletedTrack);
                                    },
                                  ),
                                ),
                              );
                            } else {
                              // Jika gagal hapus, restore ke list
                              setState(() {
                                _history.insert(deletedIndex, deletedTrack);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Gagal menghapus riwayat'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(15),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDate(track.createdAt),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getSeverityColor(severity).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      severity,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _getSeverityColor(severity),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: track.symptoms.map((symptom) {
                                  return Chip(
                                    label: Text(symptom, style: const TextStyle(fontSize: 12)),
                                    backgroundColor: const Color(0xFF4C9EEB).withOpacity(0.1),
                                    labelStyle: const TextStyle(color: Color(0xFF4C9EEB)),
                                  );
                                }).toList(),
                              ),
                              if (track.notes.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                Text(
                                  'Catatan: ${track.notes}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF7F8C8D),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewTrack,
        backgroundColor: const Color(0xFF4C9EEB),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  // Helper method untuk format tanggal
  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    
    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    
    return '$day $month $year, $hour:$minute';
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'berat':
        return Colors.red;
      case 'sedang':
        return Colors.orange;
      case 'ringan':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _AddTrackDialog extends StatefulWidget {
  final Function(SymptomTrackModel) onSaved;
  const _AddTrackDialog({required this.onSaved});

  @override
  State<_AddTrackDialog> createState() => _AddTrackDialogState();
}

class _AddTrackDialogState extends State<_AddTrackDialog> {
  final List<String> _symptoms = [
    'Demam',
    'Batuk',
    'Pilek',
    'Sakit kepala',
    'Nyeri otot',
    'Mual',
    'Lelah',
    'Sesak napas',
    'Sakit tenggorokan',
    'Diare'
  ];
  final List<String> _selectedSymptoms = [];
  String _selectedSeverity = 'Ringan';
  final _notesController = TextEditingController();
  final SymptomService _symptomService = SymptomService();
  bool _isSaving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveTrack() async {
    if (_selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal 1 gejala'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final currentUser = AuthService().currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Create track model
      final track = SymptomTrackModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: currentUser.id,
        userName: currentUser.fullName ?? 'Unknown',
        symptoms: _selectedSymptoms,
        results: {
          'severity': _selectedSeverity,
          'symptomCount': _selectedSymptoms.length,
        },
        createdAt: DateTime.now(),
        notes: _notesController.text.trim(),
      );

      print('💾 Saving track to Firebase...');
      final success = await _symptomService.saveSymptomCheck(track);

      if (!mounted) return;

      if (success) {
        print('✅ Track saved successfully!');
        
        // FIX: Close dialog first
        Navigator.pop(context);
        
        // FIX: Call callback to update parent widget
        widget.onSaved(track);
        
      } else {
        print('❌ Failed to save track');
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan gejala'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ Error saving track: $e');
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C9EEB).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.calendar_today, color: Color(0xFF4C9EEB)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Catat Gejala Hari Ini',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Pilih Gejala:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C9EEB),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _symptoms.map((symptom) {
                  final isSelected = _selectedSymptoms.contains(symptom);
                  return FilterChip(
                    label: Text(symptom),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedSymptoms.add(symptom);
                        } else {
                          _selectedSymptoms.remove(symptom);
                        }
                      });
                    },
                    selectedColor: const Color(0xFF4C9EEB),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF2C3E50),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Tingkat Keparahan:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C9EEB),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: ['Ringan', 'Sedang', 'Berat'].map((severity) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(
                          severity,
                          style: TextStyle(
                            color: _selectedSeverity == severity
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: _selectedSeverity == severity,
                        onSelected: (selected) {
                          setState(() => _selectedSeverity = severity);
                        },
                        selectedColor: const Color(0xFF4C9EEB),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Catatan (opsional)',
                  hintText: 'Tambahkan catatan tambahan...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF4C9EEB)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF7F8C8D)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: Color(0xFF7F8C8D)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveTrack,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C9EEB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Simpan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}