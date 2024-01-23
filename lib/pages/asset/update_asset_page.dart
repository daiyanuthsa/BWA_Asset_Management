import 'dart:convert';
import 'dart:typed_data';

import 'package:bwa_asset_management/config/app_constant.dart';
import 'package:bwa_asset_management/models/asset_model.dart';
import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UpdateAssetPage extends StatefulWidget {
  const UpdateAssetPage({super.key, required this.oldaAsset});
  final AssetModel oldaAsset;

  @override
  State<UpdateAssetPage> createState() => _UpdateAssetPageState();
}

class _UpdateAssetPageState extends State<UpdateAssetPage> {
  final formKey = GlobalKey<FormState>();
  final edtAssetName = TextEditingController();
  List<String> types = ['Clothes', 'Electonics', 'Tools', 'Houses', 'Others'];
  String type = 'Others';
  String? imageName;
  Uint8List? imageByte;

  pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);

    if (picked != null) {
      imageName = picked.name;
      imageByte = await picked.readAsBytes();
      setState(() {});
    }

    DMethod.printBasic('imageName: $imageName');
  }

  save() async {
    bool isValidInput = formKey.currentState!.validate();

    if (!isValidInput) return;

    try {
      Uri url = Uri.parse('${AppConstant.baseUrl}/asset/update.php');
      final response = await http.post(url, body: {
        'id': widget.oldaAsset.id,
        'name': edtAssetName.text,
        'type': type,
        'old_image': widget.oldaAsset.imagePath,
        'new_image': imageName ?? widget.oldaAsset.imagePath,
        'new_base64code': imageName == null ? '' : base64Encode(imageByte!),
      });

      DMethod.printResponse(response);

      Map resBody = jsonDecode(response.body);
      bool saveStatus = resBody['status'] ?? false;

      if (saveStatus) {
        DInfo.toastSuccess('Success update asset');
        Navigator.pop(context);
      } else {
        DInfo.toastError('Failed update asset');
      }
    } catch (e) {
      DInfo.toastError('Something wrong');
      DMethod.printBasic(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    edtAssetName.text = widget.oldaAsset.name;
    type = widget.oldaAsset.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        title: const Text('Update New Asset'),
        centerTitle: true,
      ),
      body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DInput(
                radius: BorderRadius.circular(10),
                controller: edtAssetName,
                fillColor: Colors.white,
                title: 'Asset Name',
                hint: 'Vas Bunga',
                validator: (value) =>
                    value == '' ? "Asset Name must be filled" : null,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Type',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              DropdownButtonFormField(
                icon: const Icon(Icons.keyboard_arrow_down),
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.all(12)),
                value: type,
                items: types.map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    type = value;
                    print(type);
                  }
                },
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: imageByte == null
                      ? Image.network(
                          '${AppConstant.baseUrl}/image/${widget.oldaAsset.imagePath}',
                        )
                      : Image.memory(imageByte!),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          side: const BorderSide(
                            color: Colors
                                .purple, // Ganti warna sesuai keinginan Anda
                            width:
                                1.0, // Ganti lebar border sesuai keinginan Anda
                          ),
                        ),
                        onPressed: () {
                          pickImage(ImageSource.camera);
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera')),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          side: const BorderSide(
                            color: Colors
                                .purple, // Ganti warna sesuai keinginan Anda
                            width:
                                1.0, // Ganti lebar border sesuai keinginan Anda
                          ),
                        ),
                        onPressed: () {
                          pickImage(ImageSource.gallery);
                        },
                        icon: const Icon(Icons.image_rounded),
                        label: const Text('Gallery')),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () => save(),
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white)),
                child: const Text('Save'),
              )
            ],
          )),
    );
  }
}
