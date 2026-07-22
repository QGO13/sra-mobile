import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart' show FilePicker, FileType;
import 'package:desktop_drop/desktop_drop.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

class MediaUploaderBox extends StatefulWidget {
  final String? initialImageUrl;
  final Function(XFile? file) onFileSelected;
  final double height;

  const MediaUploaderBox({
    super.key,
    this.initialImageUrl,
    required this.onFileSelected,
    this.height = 180,
  });

  @override
  State<MediaUploaderBox> createState() => _MediaUploaderBoxState();
}

class _MediaUploaderBoxState extends State<MediaUploaderBox> {
  XFile? _selectedFile;
  bool _isDragging = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        // Use FilePicker on Web/Desktop for better stability
        final result = await FilePicker.pickFiles(
          type: FileType.image,
        );
        if (result != null && result.files.isNotEmpty) {
          final file = result.files.first;
          final XFile xFile;
          if (kIsWeb) {
            final bytes = await file.readAsBytes();
            xFile = XFile.fromData(
              bytes,
              name: file.name,
              length: file.size,
            );
          } else {
            xFile = XFile(
              file.path ?? '',
              name: file.name,
              length: file.size,
            );
          }
          setState(() {
            _selectedFile = xFile;
          });
          widget.onFileSelected(_selectedFile);
        }
      } else {
        // Use ImagePicker on Mobile
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );
        if (image != null) {
          setState(() {
            _selectedFile = image;
          });
          widget.onFileSelected(_selectedFile);
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _clearImage() {
    setState(() {
      _selectedFile = null;
    });
    widget.onFileSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget previewWidget;
    if (_selectedFile != null) {
      if (kIsWeb) {
        previewWidget = FutureBuilder<Uint8List>(
          future: _selectedFile!.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.memory(snapshot.data!, fit: BoxFit.cover);
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      } else {
        previewWidget = Image.file(
          File(_selectedFile!.path),
          fit: BoxFit.cover,
        );
      }
    } else if (widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty) {
      previewWidget = CachedNetworkImage(
        imageUrl: widget.initialImageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: isDark ? AppColors.darkCard : AppColors.surfaceLight,
          child: const Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold),
            ),
          ),
        ),
        errorWidget: (context, url, error) => const Center(
          child: Icon(Icons.broken_image_outlined, color: AppColors.statusError),
        ),
      );
    } else {
      previewWidget = const SizedBox();
    }

    final hasImage = _selectedFile != null || (widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty);

    Widget content = DropTarget(
      onDragEntered: (detail) => setState(() => _isDragging = true),
      onDragExited: (detail) => setState(() => _isDragging = false),
      onDragDone: (detail) {
        if (detail.files.isNotEmpty) {
          setState(() {
            _selectedFile = detail.files.first;
          });
          widget.onFileSelected(_selectedFile);
        }
      },
      child: InkWell(
        onTap: _pickImage,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: _isDragging
                ? (isDark ? AppColors.darkCard.withValues(alpha: 0.8) : AppColors.gold.withValues(alpha: 0.1))
                : (isDark ? AppColors.darkCard : AppColors.surfaceLight),
            border: Border.all(
              color: _isDragging
                  ? AppColors.gold
                  : (isDark ? AppColors.overlayDark : AppColors.mist),
              width: _isDragging ? 2.0 : 1.0,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasImage) ...[
                previewWidget,
                Container(
                  color: AppColors.ink.withValues(alpha: 0.35),
                ),
                Positioned(
                  top: AppDimensions.spacingSm,
                  right: AppDimensions.spacingSm,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.rotate_left, color: AppColors.white),
                        onPressed: _pickImage,
                        tooltip: "Remplacer l'image",
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.statusError),
                        onPressed: _clearImage,
                        tooltip: "Supprimer l'image",
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 40,
                      color: _isDragging ? AppColors.gold : AppColors.inkMuted,
                    ),
                    const SizedBox(height: AppDimensions.spacingSm),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                      child: Text(
                        _isDragging
                            ? "Déposez l'image ici..."
                            : "Glissez-déposez une image ou cliquez pour parcourir",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _isDragging ? AppColors.gold : AppColors.inkMuted,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );

    return content;
  }
}
