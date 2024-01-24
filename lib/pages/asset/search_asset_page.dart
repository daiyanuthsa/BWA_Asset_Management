import 'dart:convert';

import 'package:bwa_asset_management/config/app_constant.dart';
import 'package:bwa_asset_management/models/asset_model.dart';

import 'package:bwa_asset_management/pages/asset/update_asset_page.dart';
import 'package:d_info/d_info.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<AssetModel> assets = [];

  final edtSearch = TextEditingController();

  searchAssets() async {
    if (edtSearch.text.isEmpty) {
      DMethod.printBasic('APAKEK');
      return;
    }
    assets.clear();
    setState(() {});
    try {
      Uri url = Uri.parse('${AppConstant.baseUrl}/asset/search.php');
      final response = await http.post(url, body: {
        'search' : edtSearch.text
      });

      DMethod.printResponse(response);

      Map resBody = jsonDecode(response.body);
      bool saveStatus = resBody['status'] ?? false;

      if (saveStatus) {
        List data = resBody['data'];
        assets = data.map((item) => AssetModel.fromJson(item)).toList();
      }
      setState(() {});
    } catch (e) {
      DInfo.toastError('Something wrong');
      DMethod.printBasic(e.toString());
    }
  }

  showMenuItem(AssetModel item) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(item.name),
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateAssetPage(
                          oldaAsset: item,
                        ),
                      )).then((value) => searchAssets());
                },
                leading: const Icon(
                  Icons.edit,
                  color: Colors.purple,
                ),
                title: const Text('Update'),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  deleteAsset(item);
                },
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: const Text('Delete'),
              ),
            ],
          );
        });
  }

  Future<void> deleteAsset(AssetModel item) async {
    bool? isYes = await DInfo.dialogConfirmation(
      context,
      'Delete',
      'You sure wan to delete ${item.name}?',
    );
    if (isYes ?? false) {
      try {
        Uri url = Uri.parse('${AppConstant.baseUrl}/asset/delete.php');
        final response = await http
            .post(url, body: {'id': item.id, 'image': item.imagePath});

        DMethod.printResponse(response);

        Map resBody = jsonDecode(response.body);
        bool deleteStatus = resBody['status'] ?? false;

        if (deleteStatus) {
          DInfo.toastSuccess('Success delete asset');
          searchAssets(); // Atau navigasi ke halaman lain setelah penghapusan sukses
        } else {
          DInfo.toastError('Failed delete asset');
        }
      } catch (e) {
        DInfo.toastError('Something wrong');
        DMethod.printBasic(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.purple[100],
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: edtSearch,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Search here...',
              isDense: true,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.purple,
        actions: [IconButton(onPressed: () {
          searchAssets();
        }, icon: const Icon(Icons.search))],
      ),
      body: assets.isEmpty
          ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Empty'),
                    IconButton(
                        onPressed: () {
                          searchAssets();
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.purple,
                        ))
                  ]),
            )
          : RefreshIndicator(
              onRefresh: () async => searchAssets(),
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemCount: assets.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8),
                itemBuilder: (context, index) {
                  AssetModel item = assets[index];
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadiusDirectional.circular(8),
                            child: Image.network(
                              '${AppConstant.baseUrl}/image/${item.imagePath}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    item.type,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                            Material(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              color: Color(0xFFF2D0F2),
                              child: InkWell(
                                onTap: () {
                                  showMenuItem(item);
                                },
                                borderRadius: BorderRadius.circular(4),
                                splashColor: Colors.purpleAccent,
                                child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    child: Icon(Icons.more_vert)),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
