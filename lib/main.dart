import 'dart:async';
import 'dart:io';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/core/env_config.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/core/global_variables.dart';
import 'package:reachx_embed/core/helper/cloudMessaging.dart';
import 'package:reachx_embed/core/helper/networkChecker.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/core/navigation/navigationController.dart';
import 'package:reachx_embed/data/data_source/local/hive/localuserDatabse.dart';
import 'package:reachx_embed/domain/signUp/signUpUsecase.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/bloc/signBloc.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/signUpScreen.dart';
import 'package:reachx_embed/presentation/splashScreen/splashScreen.dart';
import 'package:reachx_embed/theme/theme.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha.dart';
import 'firebase_options.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform,);

  await LocalUserDatabase.init();


  final appCheckActivate = FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttestWithDeviceCheckFallback,
    webProvider: ReCaptchaV3Provider('6LfYlRorAAAAAAQNjXgLqKTTyfcuCpOfmV_efEwS'),
  );

  // final uri = Uri.base;
  // final clientId = uri.queryParameters['clientId'];
  // debugPrint(clientId);
  //
  // globalInstitutionId.value = clientId ?? '';

  final id =  globalContext['REACHX_INST_ID'];
  debugPrint("InstitutionId + $id");
  globalInstitutionId.value = id?.toString() ?? '';
  debugPrint("InstitutionId after + ${globalInstitutionId.value}");

  if(!kIsWeb) {
    final siteKey = Platform.isAndroid
        ? '6LcS3NQrAAAAAM2hK8WddDUdx0TPPZ95hawAaaCZ'
        : '6Lc-29QrAAAAANSjKTiKYfiRG719mL426Cfdp036';

    client = await Recaptcha.fetchClient(siteKey);
  }

  final initialMsgHandler = FirebaseMessaging.instance.getInitialMessage().then((message) {
    if( message != null) {
      handleNotification(message);
    }
  });



  await Future.wait([
    appCheckActivate,
    initialMsgHandler
  ]);



  await initInjection();

  await initNotifications();

  Get.put(NavigationController());


  final ImagePickerPlatform implementation = ImagePickerPlatform.instance;

  if(implementation is ImagePickerAndroid) {
    implementation.useAndroidPhotoPicker = true;
  }

  runApp(
      const ReachEx()
  );

  fetchData();
}

class ReachEx extends StatefulWidget {
  const ReachEx({super.key});

  @override
  State<ReachEx> createState() => _ReachExState();
}

class _ReachExState extends State<ReachEx> {


  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleNotification(message);
    });

    return bloc.MultiBlocProvider(
      providers: [
        bloc.BlocProvider(create: (context) => SignBloc(SignUpUsecase())),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        theme: AppTheme.lightTheme,
        scaffoldMessengerKey: scaffoldMessengerKey,
        navigatorKey: globalNavigatorKey,
        getPages: [
          GetPage(
            name: SignUpScreen.route,
            page: () {
              final AuthenticationType type = Get.arguments["type"] ?? AuthenticationType.signup;
              final String name = Get.arguments["name"] ?? '';
              bool? isHomeFlow = Get.arguments["isHomeFlow"];

              return SignUpScreen(arguments: {
               "type": type,
               "name": name,
               "isHomeFlow": isHomeFlow
              });
            },
          ),
        ],
      ),
    );
  }
}
