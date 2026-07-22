import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart' show FilePicker, FileType;
import 'package:desktop_drop/desktop_drop.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/feedback/loading_widget.dart';

/// Boîte de téléversement et glisser-déposer de média Luxe avec support Dark Mode.
class MediaUploaderBox extends StatefulWidget {
  final String? initialImageUrl;
  final Function(XFile? file) onFileSelected;
  final double height;

  const MediaUploaderBox({
    super.key,
    this.initialImageUrl,
    required this.onFileSelected,
    this.height = AppDimensions.responsiveCardMainExtent,
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
            return const LoadingWidget();
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
          color: isDark ? AppColors.darkCard : AppColors.white,
          child: const Center(
            child: LoadingWidget(),
          ),
        ),
        errorWidget: (context, url, error) => const Center(
          child: Icon(Icons.broken_image_outlined, color: AppColors.statusError, size: AppDimensions.iconSizeXl),
        ),
      );
    } else {
      previewWidget = const SizedBox.shrink();
    }

    final hasImage = _selectedFile != null || (widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty);

    return DropTarget(
      onDragEntered: (_) => setState(() => _isDragging = true),
      onDragExited: (_) => setState(() => _isDragging = false),
      onDragDone: (detail) {
        if (detail.files.isNotEmpty) {
          setState(() {
            _selectedFile = detail.files.first;
          });
          widget.onFileSelected(_selectedFile);
        }
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        onTap: _pickImage,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: _isDragging
                ? (isDark ? AppColors.darkCard : AppColors.gold.withValues(alpha: 0.1))
                : (isDark ? AppColors.darkCard : AppColors.white),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            border: Border.all(
              color: _isDragging
                  ? AppColors.gold
                  : (isDark ? AppColors.darkBorder : AppColors.mist),
              width: _isDragging ? AppDimensions.borderMedium : AppDimensions.borderThin,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasImage) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  child: previewWidget,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                ),
                Positioned(
                  top: AppDimensions.spacingSm,
                  right: AppDimensions.spacingSm,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.rotate_left, color: AppColors.white, size: AppDimensions.iconSizeLg),
                        onPressed: _pickImage,
                        tooltip: "Remplacer l'image",
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.statusError, size: AppDimensions.iconSizeLg),
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
                      size: AppDimensions.iconSizeXl * 1.25,
                      color: _isDragging ? AppColors.gold : AppColors.inkMuted,
                    ),
                    AppDimensions.vGapSm,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                      child: Text(
                        _isDragging
                            ? "Déposez l'image ici..."
                            : "Glissez-déposez une image ou cliquez pour parcourir",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: _isDragging ? AppColors.gold : AppColors.inkMuted,
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
  }
}
