import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';
import 'package:logininstance/app/data/global.dart';
import 'package:logininstance/app/data/instagram_constant.dart';
import 'package:logininstance/app/models/instagram_model.dart';
import 'package:logininstance/app/modules/home/views/home_view.dart';
import 'package:logininstance/app/modules/signin/controllers/signin_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:instagram_login/home.dart';
// import 'package:instagram_login/instagram_constant.dart';
// import 'package:instagram_login/instagram_model.dart';

class InstagramView extends StatelessWidget {
  SigninController maincontroller = Get.put(SigninController());

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      // final webview = FlutterWebviewPlugin();
      final InstagramModel instagram = InstagramModel();
      final Completer<WebViewController> _controller =
          Completer<WebViewController>();

      // buildRedirectToHome( instagram, context);

      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              'Instagram Login',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.black),
            ),
          ),
          body: WebView(
              initialUrl: InstagramConstant.instance.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onProgress: (int progress) {
                print('WebView is loading (progress : $progress%)');
              },
              navigationDelegate: (url) async {
                if (url.url.contains(InstagramConstant.redirectUri)) {
                  instagram.getAuthorizationCode(url.url);
                  await instagram.getTokenAndUserID().then(
                    (isDone) {
                      if (isDone) {
                        instagram.getUserProfile().then((isDone) async {
                          // await _controller.;

                          print('${instagram.username} logged in!');
                          maincontroller.instagramname =
                              instagram.username.toString();
                          maincontroller.instagramtoken =
                              instagram.authorizationCode.toString();
                          maincontroller.instagramuserid =
                              instagram.userID.toString();
                          box.write('authorizationcode',
                              instagram.authorizationCode.toString());
                          print(instagram.authorizationCode.toString());
                          print(box.read('token'));
                          print(maincontroller.instagramname);
                          Get.offAll(() => HomeView());

                          // await Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => HomeView(
                          //       token: instagram.authorizationCode.toString(),
                          //       name: instagram.username.toString(),
                          //     ),
                          //   ),
                          // );
                        });
                      }
                    },
                  );

                  // return WebviewScaffold(
                  //   url: InstagramConstant.instance.url,
                  //   resizeToAvoidBottomInset: true,
                  //   appBar: buildAppBar(context),
                  // );
                  // return Container();
                }
                return NavigationDecision.navigate;
              }));
    });

    // Future<void> buildRedirectToHome(FlutterWebviewPlugin webview,
    //     InstagramModel instagram, BuildContext context) async {
    //   webview.onUrlChanged.listen((String url) async {
    //     if (url.contains(InstagramConstant.redirectUri)) {
    //       instagram.getAuthorizationCode(url);
    //       await instagram.getTokenAndUserID().then((isDone) {
    //         if (isDone) {
    //           instagram.getUserProfile().then((isDone) async {
    //             await webview.close();

    //             print('${instagram.username} logged in!');
    //             controller.instagramname = instagram.username.toString();
    //             controller.instagramtoken =
    //                 instagram.authorizationCode.toString();
    //             controller.instagramuserid = instagram.userID.toString();
    //             box.write('authorizationcode', instagram.authorizationCode.toString());
    //             print(instagram.authorizationCode.toString());
    //             print(box.read('token'));

    //             Get.offAll(() => HomeView());
    //             // await Navigator.of(context).push(
    //             //   MaterialPageRoute(
    //             //     builder: (context) => HomeView(
    //             //       token: instagram.authorizationCode.toString(),
    //             //       name: instagram.username.toString(),
    //             //     ),
    //             //   ),
    //             // );
    //           });
    //         }
    //       });
    //     }
    //   });
    // }

    // }
  }
}
