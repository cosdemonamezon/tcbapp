import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tcbapp/constants.dart';
import 'package:tcbapp/home/widgets/CardItem.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundColor3,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('ประวัติการรักษา', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            CircleAvatar(),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.065,
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: kBackgroundColor2,
                    ),
                  ),
                  padding: EdgeInsets.all(8),
                  child: DropdownSearch<String>(
                    selectedItem: selectedValue,
                    items: items,
                    itemAsString: (item) => item,
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      constraints: BoxConstraints(maxHeight: 450),
                      fit: FlexFit.loose,
                      menuProps: MenuProps(
                        backgroundColor: Colors.white,
                      ),
                      itemBuilder: (context, item, isSelected) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item,
                              style: TextStyle(
                                color: isSelected ? Colors.blue : Colors.black,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onChanged: (String? va) {
                      setState(() {
                        selectedValue = va;
                      });
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      baseStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Prompt',
                      ),
                      dropdownSearchDecoration: InputDecoration(
                        hintText: 'เลือกผู้รับบุคลากรภายใน',
                        hintStyle: TextStyle(
                          color: Colors.black45,
                        ),
                        border: InputBorder.none,
                        suffixIconColor: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cardItems.length,
              itemBuilder: (context, index) {
                final item = cardItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: CardItem(
                    date: item['date'] ?? '',
                    hospital: item['hospital'] ?? '',
                    diagnosis: item['diagnosis'] ?? '',
                    size: size,
                    rectum: item['rectum'] ?? '',
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
