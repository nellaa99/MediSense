
// Extension: Menambahkan fungsi pada class yang sudah ada

// ==================== STRING EXTENSION ====================
extension StringExtension on String {
  // Capitalize huruf pertama
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  // Capitalize semua kata
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  // Validasi email
  bool isValidEmail() {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  // Mendapatkan inisial dari nama
  String toInitials() {
    if (isEmpty) return '';
    final words = split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return this[0].toUpperCase();
  }

  // Cek apakah string adalah angka
  bool isNumeric() {
    return double.tryParse(this) != null;
  }

  // Truncate string dengan max length
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  // Remove semua whitespace
  String removeAllWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  // Reverse string
  String reverse() {
    return split('').reversed.join('');
  }

  // Check if contains
  bool containsIgnoreCase(String other) {
    return toLowerCase().contains(other.toLowerCase());
  }

  // To title case
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }
}

// ==================== DATETIME EXTENSION ====================
extension DateTimeExtension on DateTime {
  // Format ke string dd/MM/yyyy
  String toFormattedString() {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  // Format ke string dengan nama bulan
  String toFormattedStringWithMonth() {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${day.toString().padLeft(2, '0')} ${months[month - 1]} $year';
  }

  // Format ke string waktu HH:mm
  String toTimeString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  // Format ke string lengkap dengan waktu
  String toFullString() {
    return '${toFormattedString()} ${toTimeString()}';
  }

  // Cek apakah hari ini
  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  // Cek apakah kemarin
  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  // Cek apakah besok
  bool isTomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  // Mendapatkan nama hari
  String getDayName() {
    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    return days[weekday - 1];
  }

  // Mendapatkan selisih hari dari sekarang
  int daysFromNow() {
    final now = DateTime.now();
    return difference(now).inDays;
  }

  // Add days
  DateTime addDays(int days) {
    return add(Duration(days: days));
  }

  // Subtract days
  DateTime subtractDays(int days) {
    return subtract(Duration(days: days));
  }

  // Get start of day
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  // Get end of day
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59);
  }

  // Is same day
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  // Is weekend
  bool isWeekend() {
    return weekday == DateTime.saturday || weekday == DateTime.sunday;
  }

  // Age from date
  int ageFromDate() {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }
}

// ==================== LIST EXTENSION ====================
extension ListExtension<T> on List<T> {
  // Find first atau return null
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  // Paginate list
  List<T> paginate(int page, int itemsPerPage) {
    final start = page * itemsPerPage;
    final end = start + itemsPerPage;
    if (start >= length) return [];
    if (end > length) return sublist(start);
    return sublist(start, end);
  }

  // Chunk list menjadi sub-lists
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      final end = (i + size < length) ? i + size : length;
      chunks.add(sublist(i, end));
    }
    return chunks;
  }

  // Remove duplicates
  List<T> removeDuplicates() {
    return toSet().toList();
  }

  // Shuffle list (return new list)
  List<T> shuffled() {
    final newList = List<T>.from(this);
    newList.shuffle();
    return newList;
  }

  // Take first n items
  List<T> takeFirst(int n) {
    if (n >= length) return this;
    return sublist(0, n);
  }

  // Take last n items
  List<T> takeLast(int n) {
    if (n >= length) return this;
    return sublist(length - n);
  }

  // Sum for numeric lists
  num sum() {
    if (isEmpty) return 0;
    if (T == int || T == double || T == num) {
      return fold(0, (prev, element) => prev + (element as num));
    }
    return 0;
  }

  // Average for numeric lists
  double average() {
    if (isEmpty) return 0;
    return sum() / length;
  }

  // Is empty or null
  bool get isNullOrEmpty => isEmpty;

  // Is not empty
  bool get isNotNullOrEmpty => isNotEmpty;

  // Safe get at index
  T? safeGet(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
}

// ==================== INT EXTENSION ====================
extension IntExtension on int {
  // Format ke currency (Rupiah)
  String toRupiah() {
    return 'Rp ${toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  // Cek apakah genap
  bool get isEven => this % 2 == 0;

  // Cek apakah ganjil
  bool get isOdd => this % 2 != 0;

  // To ordinal (1st, 2nd, 3rd, etc)
  String toOrdinal() {
    if (this >= 11 && this <= 13) return '${this}th';
    switch (this % 10) {
      case 1: return '${this}st';
      case 2: return '${this}nd';
      case 3: return '${this}rd';
      default: return '${this}th';
    }
  }

  // Is positive
  bool get isPositive => this > 0;

  // Is negative
  bool get isNegative => this < 0;

  // Is zero
  bool get isZero => this == 0;

  // To duration in days
  Duration get days => Duration(days: this);

  // To duration in hours
  Duration get hours => Duration(hours: this);

  // To duration in minutes
  Duration get minutes => Duration(minutes: this);

  // To duration in seconds
  Duration get seconds => Duration(seconds: this);
}

// ==================== DOUBLE EXTENSION ====================
extension DoubleExtension on double {
  // Format ke currency (Rupiah)
  String toRupiah() {
    return 'Rp ${toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  // Round to decimal places
  double roundToDecimal(int places) {
    final mod = 10.0 * places;
    return (this * mod).round() / mod;
  }

  // To percentage string
  String toPercentage({int decimals = 0}) {
    return '${toStringAsFixed(decimals)}%';
  }

  // Is positive
  bool get isPositive => this > 0;

  // Is negative
  bool get isNegative => this < 0;

  // Is zero
  bool get isZero => this == 0;

  // Clamp between min and max
  double clampValue(double min, double max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }
}

// ==================== BOOL EXTENSION ====================
extension BoolExtension on bool {
  // To int (1 or 0)
  int toInt() => this ? 1 : 0;

  // To string (Yes or No)
  String toYesNo() => this ? 'Yes' : 'No';

  // To string (Ya or Tidak)
  String toYaTidak() => this ? 'Ya' : 'Tidak';

  // Toggle
  bool toggle() => !this;
}

// ==================== MAP EXTENSION ====================
extension MapExtension<K, V> on Map<K, V> {
  // Safe get
  V? safeGet(K key) {
    return containsKey(key) ? this[key] : null;
  }

  // Get or default
  V getOrDefault(K key, V defaultValue) {
    return containsKey(key) ? this[key]! : defaultValue;
  }

  // Is null or empty
  bool get isNullOrEmpty => isEmpty;

  // Is not empty
  bool get isNotNullOrEmpty => isNotEmpty;
}