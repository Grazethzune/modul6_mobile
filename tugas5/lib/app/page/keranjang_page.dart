import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_1/app/modules/home/controllers/home_controller.dart';
import 'package:tugas_1/app/page/detail_product.dart';

class CartPage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final HomeController cartController = Get.put(HomeController());
  ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Daftar Keranjang Belanja'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Obx(
        () {
          if (cartController.cartItems.isEmpty) {
            return Center(child: Text('Keranjang masih kosong.'));
          } else {
            return SafeArea(
              child: Stack(
                children: <Widget>[
                  _buildKeranjangList(widthScreen, heightScreen, context),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Container _buildKeranjangList(
      double widthScreen, double heightScreen, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: widthScreen,
      height: heightScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream:
                      firestore.collection('cart').orderBy('Date').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        Map<String, dynamic> task =
                            document.data() as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () async {
                            // Navigate to ProductPage with isEdit set to true
                            bool result = await Get.to(
                              ProductPage(
                                documentId: document.id,
                                isEdit:
                                    true, // Set to true for editing the item
                                name: task['name'],
                                price: task['price'],
                                originalPrice: task['originalPrice'],
                                discount: task['discount'],
                                location: task['location'],
                                index_color: task['color'],
                                index_size: task['size'],
                                image_path: task['image'],
                              ),
                            );
                            if (result != null && result) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Barang telah diupdate')),
                              );
                            }
                          },
                          child: Card(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(task['image']),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(task['name']),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text(
                                              'Rp. ${task['originalPrice']}',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Rp. ${task['price']}',
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text("Color: "),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: task['color'] == "0"
                                                    ? Colors.black
                                                    : Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 2),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Text('Ukuran: ${task['size']}')
                                      ],
                                    )
                                  ],
                                ),
                                IconButton(
                                  onPressed: () async {
                                    bool? confirm = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Hapus Keranjang'),
                                          content: Text(
                                              'Apakah anda yakin ingin menghapus barang ini dari keranjang?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: Text('Hapus'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirm != null && confirm) {
                                      await firestore
                                          .collection('cart')
                                          .doc(document.id)
                                          .delete();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Barang telah dihapus')),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }))
        ],
      ),
    );
  }
}
