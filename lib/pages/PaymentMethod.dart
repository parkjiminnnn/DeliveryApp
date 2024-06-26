import 'package:bootpay/bootpay.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/stat_item.dart';
import 'package:bootpay/model/user.dart';
import 'package:delivery/pages/MyPage.dart';
import 'package:delivery/pages/OrderHistoryPage.dart';
import 'package:delivery/pages/PaymentPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delivery/pages/address/AddressChange.dart';

import 'package:delivery/product/productInfo.dart';
import 'package:delivery/product/productService.dart';

class TotalPayment extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.

  String webApplicationId = '6638af18906692af3376858f';
  String androidApplicationId = '6638af18906692af33768590';
  String iosApplicationId = '6638af18906692af33768591';

  final double payKoreanTotalPrice;
  final String selectedStoreName;

  TotalPayment({required this.payKoreanTotalPrice, required this.selectedStoreName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('통합 결제'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () => bootpayTest(context),
                child: const Text('통합결제 테스트', style: TextStyle(fontSize: 16.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void bootpayTest(BuildContext context) {
    Payload payload = getPayload(context);
    if (kIsWeb) {
      payload.extra?.openType = "iframe";
    }

    Bootpay().requestPayment(
      context: context,
      payload: payload,
      showCloseButton: false,
      // closeButton: Icon(Icons.close, size: 35.0, color: Colors.black54),
      onCancel: (String data) {
        print('------- onCancel: $data');
      },
      onError: (String data) {
        print('------- onError: $data');
      },
      onClose: () {
        print('------- onClose');
        Bootpay().dismiss(context); //명시적으로 부트페이 뷰 종료 호출
        Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage(selectedStoreId: 0, selectedMenus: [], selectedStoreName: '', storeAddress: '', userNumber: '',))
        );
      },
      onIssued: (String data) {
        print('------- onIssued: $data');
      },
      onConfirm: (String data) {
        print('------- onConfirm: $data');
        Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderHistoryPage(userNumber: '',)),
        );
        return true;
      },
      onDone: (String data) {
        print('------- onDone: $data');
        Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderHistoryPage(userNumber: '',)),
        );
      },
    );
  }

  //Payload getPayload() {
  Payload getPayload(BuildContext context) {
    Payload payload = Payload();

    final itemListNotifier =
        Provider.of<ItemListNotifier>(context, listen: false);

    payload.webApplicationId = webApplicationId; // web application id
    payload.androidApplicationId =
        androidApplicationId; // android application id
    payload.iosApplicationId = iosApplicationId; // ios application id

    payload.pg = '나이스페이';

    // 결제수단 설정. 값 안넣으면 통합결제(모든 결제수단)
    // payload.method = '카드';
    // payload.methods = ['card', 'phone', 'vbank', 'bank', 'kakao'];
    payload.orderName = selectedStoreName; //결제할 상품명
    payload.price = payKoreanTotalPrice;

    payload.orderId = DateTime.now()
        .millisecondsSinceEpoch
        .toString(); //주문번호, 개발사에서 고유값으로 지정해야함

    payload.metadata = {
      "callbackParam1": "value12",
      "callbackParam2": "value34",
      "callbackParam3": "value56",
      "callbackParam4": "value78",
    }; // 전달할 파라미터, 결제 후 되돌려 주는 값

    User user = User(); // 구매자 정보
    user.username = "사용자 이름";
    user.email = "user1234@gmail.com";
    user.area = "서울";
    user.phone = "010-4033-4678";
    user.addr = '서울시 동작구 상도로 222';

    Extra extra = Extra(); // 결제 옵션
    extra.appScheme = 'bootpayFlutterExample';
    extra.cardQuota = '3';
    // extra.openType = 'popup';

    // extra.carrier = "SKT,KT,LGT"; //본인인증 시 고정할 통신사명
    // extra.ageLimit = 20; // 본인인증시 제한할 최소 나이 ex) 20 -> 20살 이상만 인증이 가능

    payload.user = user;
    payload.extra = extra;
    return payload;
  }
}