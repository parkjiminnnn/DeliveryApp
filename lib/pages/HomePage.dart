import 'package:delivery/category/CategorySelect.dart';
import 'package:delivery/pages/SearchPage.dart';
import 'package:delivery/service/sv_homeAddress.dart';
import 'package:flutter/material.dart';
import 'package:delivery/pages/address/AddressRegisterPage.dart';
import 'package:delivery/service/sv_ExchangeRate.dart';
import 'package:delivery/pages/address/AddressChange.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final String userNumber;
  const HomePage({
    Key? key,
    required this.userNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromARGB(255, 216, 214, 214),
        fontFamily: "MangoDdobak",
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false, // 키보드로 인한 화면 크기 조정 방지
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: HomeScreen(selectedIndex: 0, userNumber: userNumber),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final int selectedIndex;
  final String userNumber;
  const HomeScreen(
      {Key? key, required this.selectedIndex, required this.userNumber})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isExpanded = true;
  late List<Map<String, dynamic>> _selectedAddresses = [];
  @override
  void initState() {
    super.initState();
    _fetchAddressData(); // 비동기 함수 호출
  }

  Future<void> _fetchAddressData() async {
    List<Map<String, dynamic>> allAddresses =
        await getAddressListByuser(widget.userNumber);

    // 선택된 주소 목록 중에서 selectAddress 값이 true인 주소들만 필터링
    List<Map<String, dynamic>> selectedAddresses = allAddresses
        .where((address) => address['addressSelect'] == true)
        .toList();

    // 필터링된 주소 목록을 상태에 반영
    setState(() {
      _selectedAddresses = selectedAddresses;
    });
    allAddresses.forEach((address) {
      print(
          'Address: ${address['address']}, SelectAddress: ${address['addressSelect']}');
    });
  }

  Widget _appBar() {
    String? addressType = Provider.of<ItemListNotifier>(context).addressType;

    return SafeArea(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.all(8), // 좌측에 여백 추가
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft, // 왼쪽 정렬
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressRegisterPage(
                        userNumber: widget.userNumber,
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      _selectedAddresses.isNotEmpty
                          ? (_selectedAddresses[0]['address'].length > 13
                              ? _selectedAddresses[0]['address']
                                      .substring(0, 16) +
                                  '...' // 13글자 넘어가면 생략 부호를 붙입니다.
                              : _selectedAddresses[0]['address'])
                          : '', // 첫 번째 주소 표시
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: Color(0xFF0892D0)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8), // 주소와 검색창 사이 간격 추가
            Container(
              height: 60,
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.3),
                    offset: const Offset(0, 3),
                    blurRadius: 5.0,
                  )
                ],
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextField(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchPage(
                                  userNumber: widget.userNumber,
                                ),
                              ),
                            );
                          },
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "  검색어를 입력해주세요",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontSize: 18,
                                    fontFamily:
                                        "MangoDdobak"), // Pretendard 글꼴 설정 // 힌트 텍스트의 글씨 크기 조절
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundedContainer(String image, String title, VoidCallback onTap) {
    double squareSize = (MediaQuery.of(context).size.width - 60) / 4;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30), // 컨테이너의 모서리를 둥글게 설정
              ),
              width: squareSize,
              height: squareSize,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  image,
                  width: squareSize,
                  height: squareSize,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget exchangeRateImage(String imagePath, String firstText,
      String secondText, double screenHeight, double screenWidth) {
    return Container(
      height: screenHeight * 0.1,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Container(
              height: screenHeight * 0.07,
              width: screenWidth * 0.25,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: screenWidth * 0.025,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  firstText,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  secondText,
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _exchangeRateContents(double screenHeight, double screenWidth) {
    return FutureBuilder<List<ExchangeRate>>(
      future: getExchangeRate(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          final exchangeRates = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true, // 부모의 크기에 맞춰 스크롤 크기를 조정
            itemCount: exchangeRates.length,
            itemBuilder: (context, index) {
              final exchangeRate = exchangeRates[index];
              return exchangeRateImage(
                'assets/images/country/${exchangeRate.curUnit}.png',
                '${exchangeRate.curUnit}-${exchangeRate.curName}',
                '1${exchangeRate.curUnit} - ${exchangeRate.ttb}원',
                screenHeight,
                screenWidth,
              );
            },
          );
        }
      },
    );
  }

  Widget _contents() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _roundedContainer(
                                  'assets/images/bibimbap.png', '한식', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CategorySelect(
                                            CategoryName: '한식',
                                            userNumber: widget.userNumber,
                                          )),
                                );
                              }),
                              SizedBox(width: 8),
                              _roundedContainer(
                                  'assets/images/Japanese.png', '일식', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CategorySelect(
                                            CategoryName: '일식',
                                            userNumber: widget.userNumber,
                                          )),
                                );
                              }),
                              SizedBox(width: 8),
                              _roundedContainer(
                                  'assets/images/Chinese.jpg', '중국집', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CategorySelect(
                                            CategoryName: '중국집',
                                            userNumber: widget.userNumber,
                                          )),
                                );
                              }),
                              SizedBox(width: 8),
                              _roundedContainer(
                                  'assets/images/Chicken.png', '치킨', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CategorySelect(
                                            CategoryName: '치킨',
                                            userNumber: widget.userNumber,
                                          )),
                                );
                              }),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              _roundedContainer('assets/images/Pizza.png', '피자',
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CategorySelect(
                                            CategoryName: '피자',
                                            userNumber: widget.userNumber,
                                          )),
                                );
                              }),
                              SizedBox(width: 8),
                              _roundedContainer(
                                  'assets/images/Hamburger.png', '햄버거', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CategorySelect(
                                            CategoryName: '햄버거',
                                            userNumber: widget.userNumber,
                                          )),
                                );
                              }),
                              SizedBox(width: 8),
                              _roundedContainer('assets/images/tteok.png', '분식',
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CategorySelect(
                                            CategoryName: '분식',
                                            userNumber: widget.userNumber,
                                          )),
                                );
                              }),
                              SizedBox(width: 8),
                              _roundedContainer(
                                  'assets/images/Jokbal.jpg', '족발', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CategorySelect(
                                            CategoryName: '족발',
                                            userNumber: widget.userNumber,
                                          )),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03), //카테고리랑 환율 간격
                    ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      children: [
                        ExpansionPanel(
                          backgroundColor: Colors.white,
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return Container(
                              alignment: Alignment.centerLeft, // 제목을 화면 왼쪽에 정렬
                              padding: const EdgeInsets.all(16),
                              color: Colors.white, // 패널의 배경색을 흰색으로 설정
                              child: Text(
                                '실시간 환율(KRW)',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                          body: Container(
                            height: screenHeight * 0.6,
                            color: Colors.white, // 패널의 내용 영역의 배경색을 흰색으로 설정
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                              child: _exchangeRateContents(
                                  screenHeight, screenWidth),
                            ),
                          ),
                          isExpanded: _isExpanded, // 패널이 확장된 상태로 시작
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _appBar(),
          _contents(),
        ],
      ),
    );
  }
}
