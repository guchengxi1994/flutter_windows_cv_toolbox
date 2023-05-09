import 'package:file_picker/file_picker.dart';

Future<String?> pickAnImage() async {
  return FilePicker.platform.pickFiles(
      dialogTitle: 'Pick an image',
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ["jpg", "png"]).then((v) => v?.files.first.path);
}
