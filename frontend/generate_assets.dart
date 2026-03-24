import 'dart:io';

void main() {
  final dir = Directory('assets/images');
  if (!dir.existsSync()) {
    print("ERROR: Folder 'assets/images' not found!");
    return;
  }

  final files = dir.listSync().map((f) => f.path.replaceFirst('assets/', '')).toList();
  print('const List<String> kAllAssets = [');
  for (var file in files) {
    print("  '$file',");
  }
  print('];');
}