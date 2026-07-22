import 'dart:io';
import 'dart:typed_data';

void main() {
  final l10nDir = Directory('lib/l10n');
  if (l10nDir.existsSync()) {
    _processDirectory(l10nDir);
  }

  // Also process .dart_tool/flutter_gen/gen_l10n/ if it exists
  final genDir = Directory('.dart_tool/flutter_gen/gen_l10n');
  if (genDir.existsSync()) {
    _processDirectory(genDir);
  }
}

void _processDirectory(Directory dir) {
  final files = dir.listSync(recursive: true);
  for (final entity in files) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final bytes = entity.readAsBytesSync();
      // Check if it already has UTF-8 BOM: 0xEF, 0xBB, 0xBF
      if (bytes.length >= 3 && bytes[0] == 0xEF && bytes[1] == 0xBB && bytes[2] == 0xBF) {
        // ignore: avoid_print
        print('Skipping (already has BOM): ${entity.path}');
        continue;
      }
      
      final newBytes = BytesBuilder();
      newBytes.add([0xEF, 0xBB, 0xBF]); // Prepend BOM
      newBytes.add(bytes);
      entity.writeAsBytesSync(newBytes.toBytes());
      // ignore: avoid_print
      print('Injected BOM: ${entity.path}');
    }
  }
}
