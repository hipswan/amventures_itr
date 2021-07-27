import 'package:flutter/material.dart';

class SearchHistoryPage extends StatelessWidget {
  const SearchHistoryPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blue[50]!.withAlpha(75),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(
          30.0,
          10.0,
          30.0,
          30.0,
        ),
        decoration: BoxDecoration(
          color: Colors.blue[50]!.withAlpha(75),
        ),
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(
                      0,
                      5,
                    ),
                    blurRadius: 10.0,
                    color: Colors.grey.withAlpha(60),
                    spreadRadius: 8.0,
                  )
                ],
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                50.0,
                              ),
                              bottomRight: Radius.circular(
                                50.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: Icon(
                        Icons.search,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width - 60 - 50,
                    child: TextField(
                      cursorColor: Colors.green[800],
                      cursorHeight: 20.0,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12.0,
                        ),
                        hintText: 'Enter Pan Card Details',
                        fillColor: Colors.blue[50],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            50.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(
                        0,
                        5,
                      ),
                      blurRadius: 10.0,
                      color: Colors.grey.withAlpha(60),
                      spreadRadius: 8.0,
                    )
                  ],
                  color: Colors.blue.shade50,
                  border: Border.all(
                    width: 2.0,
                    color: Colors.blueGrey.withAlpha(
                      100,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
                padding: EdgeInsets.all(
                  8.0,
                ),
                child: ListView(
                  children: List.generate(
                    100,
                    (index) => Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                50.0,
                              ),
                              color: Colors.greenAccent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('${index + 1}'),
                                Text(
                                  'FXSSSSSSSS',
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              CircleBorder(),
                            ),
                          ),
                          onPressed: () {},
                          child: Icon(
                            Icons.download,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
