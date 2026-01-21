import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Helper class untuk URL Launcher
/// Menerapkan Encapsulation dan Error Handling
class UrlLauncherHelper {
  // Singleton pattern
  static final UrlLauncherHelper _instance = UrlLauncherHelper._internal();
  factory UrlLauncherHelper() => _instance;
  UrlLauncherHelper._internal();

  /// Buka Google Maps dengan koordinat
  /// Parameter: latitude, longitude, dan nama tempat
  Future<bool> openGoogleMaps({
    required String latitude,
    required String longitude,
    required String placeName,
    BuildContext? context,
  }) async {
    try {
      // URL untuk membuka Google Maps dengan directions
      final url = 'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&destination_place_id=$placeName';
      
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Buka di aplikasi eksternal
        );
        return true;
      } else {
        _showError(context, 'Tidak dapat membuka Google Maps');
        return false;
      }
    } catch (e) {
      _showError(context, 'Error: ${e.toString()}');
      return false;
    }
  }

  /// Buka Google Maps hanya dengan koordinat (lebih simple)
  Future<bool> openMaps({
    required String latitude,
    required String longitude,
    BuildContext? context,
  }) async {
    try {
      // URL geo untuk membuka maps
      final url = 'geo:$latitude,$longitude?q=$latitude,$longitude';
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        // Fallback ke browser
        return await openGoogleMaps(
          latitude: latitude,
          longitude: longitude,
          placeName: '',
          context: context,
        );
      }
    } catch (e) {
      _showError(context, 'Error: ${e.toString()}');
      return false;
    }
  }

  /// Buka aplikasi telepon
  Future<bool> makePhoneCall({
    required String phoneNumber,
    BuildContext? context,
  }) async {
    try {
      // Bersihkan nomor telepon dari karakter yang tidak perlu
      final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      final url = 'tel:$cleanNumber';
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      } else {
        _showError(context, 'Tidak dapat membuka aplikasi telepon');
        return false;
      }
    } catch (e) {
      _showError(context, 'Error: ${e.toString()}');
      return false;
    }
  }

  /// Buka WhatsApp
  Future<bool> openWhatsApp({
    required String phoneNumber,
    String message = '',
    BuildContext? context,
  }) async {
    try {
      final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      final encodedMessage = Uri.encodeComponent(message);
      final url = 'https://wa.me/$cleanNumber?text=$encodedMessage';
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        _showError(context, 'WhatsApp tidak terinstall');
        return false;
      }
    } catch (e) {
      _showError(context, 'Error: ${e.toString()}');
      return false;
    }
  }

  /// Buka email client
  Future<bool> sendEmail({
    required String email,
    String subject = '',
    String body = '',
    BuildContext? context,
  }) async {
    try {
      final encodedSubject = Uri.encodeComponent(subject);
      final encodedBody = Uri.encodeComponent(body);
      final url = 'mailto:$email?subject=$encodedSubject&body=$encodedBody';
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      } else {
        _showError(context, 'Tidak dapat membuka email client');
        return false;
      }
    } catch (e) {
      _showError(context, 'Error: ${e.toString()}');
      return false;
    }
  }

  /// Buka URL website
  Future<bool> openWebsite({
    required String url,
    BuildContext? context,
  }) async {
    try {
      // Pastikan URL memiliki scheme
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$url';
      }
      
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        return true;
      } else {
        _showError(context, 'Tidak dapat membuka website');
        return false;
      }
    } catch (e) {
      _showError(context, 'Error: ${e.toString()}');
      return false;
    }
  }

  /// Private method untuk menampilkan error
  void _showError(BuildContext? context, String message) {
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
