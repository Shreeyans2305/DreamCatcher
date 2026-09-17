import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/design_tokens.dart';

class StudentAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final double size;
  final bool showEditBadge;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;

  const StudentAvatar({
    super.key,
    this.avatarUrl,
    required this.name,
    this.size = 56,
    this.showEditBadge = false,
    this.onTap,
    this.backgroundColor,
    this.textColor,
  });

  String _getInitials(String name) {
    final clean = name.trim();
    if (clean.isEmpty) return 'S';
    final parts = clean.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Uint8List? _decodeBase64(String? data) {
    if (data == null || data.isEmpty) return null;
    try {
      if (data.contains('base64,')) {
        final pureBase64 = data.split('base64,').last.trim();
        return base64Decode(pureBase64);
      }
      return base64Decode(data);
    } catch (e) {
      debugPrint('Error decoding avatar base64: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final decodedBytes = _decodeBase64(avatarUrl);
    final isHttpUrl = avatarUrl != null && (avatarUrl!.startsWith('http://') || avatarUrl!.startsWith('https://'));
    final initials = _getInitials(name);
    final badgeSize = (size * 0.32).clamp(20.0, 32.0);

    Widget content;
    if (decodedBytes != null) {
      content = ClipOval(
        child: Image.memory(
          decodedBytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildInitials(initials),
        ),
      );
    } else if (isHttpUrl) {
      content = ClipOval(
        child: Image.network(
          avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildInitials(initials),
        ),
      );
    } else {
      content = _buildInitials(initials);
    }

    Widget avatarWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? DesignTokens.blush200,
        border: Border.all(
          color: Colors.white,
          width: size > 60 ? 3.0 : 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.maroon900.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: content,
    );

    if (showEditBadge) {
      avatarWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          avatarWidget,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: DesignTokens.maroon900,
                border: Border.all(color: Colors.white, width: 2.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                size: badgeSize * 0.56,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }

  Widget _buildInitials(String initials) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? DesignTokens.blush200,
      ),
      child: Text(
        initials,
        style: GoogleFonts.inter(
          fontSize: size * 0.36,
          fontWeight: FontWeight.bold,
          color: textColor ?? DesignTokens.maroon900,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

/// Helper function to display photo picker options (Camera, Gallery, Remove)
Future<void> showAvatarPickerBottomSheet({
  required BuildContext context,
  required ValueChanged<String?> onAvatarSelected,
  bool hasExistingAvatar = false,
}) async {
  final ImagePicker picker = ImagePicker();

  Future<void> pick(ImageSource source) async {
    Navigator.of(context).pop();
    try {
      final XFile? file = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (file != null) {
        final Uint8List bytes = await file.readAsBytes();
        final base64String = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        onAvatarSelected(base64String);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: DesignTokens.slate600.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Profile Photo',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: DesignTokens.blush200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.photo_library_rounded, color: DesignTokens.maroon900),
                ),
                title: Text(
                  'Choose from Gallery',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: DesignTokens.textPrimary,
                  ),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onTap: () => pick(ImageSource.gallery),
              ),
              const SizedBox(height: 6),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: DesignTokens.blush200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.camera_alt_rounded, color: DesignTokens.maroon900),
                ),
                title: Text(
                  'Take Photo with Camera',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: DesignTokens.textPrimary,
                  ),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onTap: () => pick(ImageSource.camera),
              ),
              if (hasExistingAvatar) ...[
                const SizedBox(height: 6),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: DesignTokens.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.delete_outline_rounded, color: DesignTokens.error),
                  ),
                  title: Text(
                    'Remove Photo',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: DesignTokens.error,
                    ),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    onAvatarSelected(null);
                  },
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}
