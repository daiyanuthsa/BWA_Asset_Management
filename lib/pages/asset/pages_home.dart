import 'dart:convert';

import 'package:bwa_asset_management/config/app_constant.dart';
import 'package:bwa_asset_management/models/asset_model.dart';

import 'package:bwa_asset_management/pages/asset/create_asset_page.dart';
import 'package:bwa_asset_management/pages/asset/update_asset_page.dart';
import 'package:d_info/d_info.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AssetModel> assets = [];

  readAssets() async {
    assets.clear();
    setState(() {});
    try {
      Uri url = Uri.parse('${AppConstant.baseUrl}/asset/read.php');
      final response = await http.get(url);

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
                      )).then((value) => readAssets());
                },
                leading: const Icon(
                  Icons.edit,
                  color: Colors.purple,
                ),
                title: const Text('Update'),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    readAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Asset'),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.purple,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateAssetPage(),
              )).then((value) => readAssets());
        },
        child: const Icon(Icons.add),
      ),
      body: assets.isEmpty
          ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Empty'),
                    IconButton(
                        onPressed: readAssets(),
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.purple,
                        ))
                  ]),
            )
          : RefreshIndicator(
              onRefresh: () async => readAssets(),
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
