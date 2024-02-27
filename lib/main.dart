import 'package:advisorapp/adminforms/centralform.dart';
import 'package:advisorapp/providers/companycategory_provider.dart';
import 'package:advisorapp/providers/drive_providers/driveupload_provider.dart';
import 'package:advisorapp/providers/drive_providers/sharefile_provider.dart';
import 'package:advisorapp/providers/report_provider.dart';
import 'package:advisorapp/providers/report_providers/account_actionitem_provider.dart';
import 'package:advisorapp/providers/report_providers/account_provider.dart';
import 'package:advisorapp/providers/report_providers/accountemployer_provider.dart';
import 'package:advisorapp/providers/report_providers/accountinvitation_provider.dart';
import 'package:advisorapp/providers/companytype_provider.dart';
import 'package:advisorapp/providers/report_providers/empaction_provider.dart';
import 'package:advisorapp/providers/report_providers/employerpartner_provider.dart';
// import 'package:advisorapp/providers/image_provider.dart';
// import 'package:advisorapp/providers/login_provider.dart';
// import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/providers/menu_provider.dart';
import 'package:advisorapp/providers/menuaccess_provider.dart';
import 'package:advisorapp/providers/report_providers/paymentreport_provider.dart';
import 'package:advisorapp/providers/roleform_provider.dart';
import 'package:advisorapp/providers/sidebar_provider.dart';
import 'package:advisorapp/providers/subscription_provider.dart';
import 'package:advisorapp/providers/taxform_provider.dart';
import 'package:advisorapp/providers/report_providers/unpaidinvoice_provider.dart';
import 'package:advisorapp/providers/userform_provider.dart';
// import 'package:advisorapp/route/route_generator.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // final GoogleSignIn googleSignIn = GoogleSignIn();

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //     create: (context) => LoginProvider(googleSignIn)),
        // ChangeNotifierProvider(create: (context) => MasterProvider()),
        ChangeNotifierProvider(create: (context) => CompanyTypeProvider()),
        ChangeNotifierProvider(create: (context) => CompanyCategoryProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ReportProvider()),
        ChangeNotifierProvider(create: (context) => SidebarProvider()),
        // ChangeNotifierProvider(create: (context) => EliteImageProvider()),
        ChangeNotifierProvider(create: (context) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (context) => RoleProvider()),
        ChangeNotifierProvider(create: (context) => MenuProvider()),
        ChangeNotifierProvider(create: (context) => MenuAccessProvider()),
        ChangeNotifierProvider(create: (context) => PaymentReportProvider()),
        ChangeNotifierProvider(create: (context) => TaxProvider()),
        ChangeNotifierProvider(create: (context) => UnpaidInvoiceProvider()),
        ChangeNotifierProvider(create: (context) => AccountEmployerProvider()),
        ChangeNotifierProvider(create: (context) => EmployerPartnerProvider()),
        ChangeNotifierProvider(create: (context) => EmpActionProvider()),
        ChangeNotifierProvider(
            create: (context) => AccountInvitationProvider()),
        ChangeNotifierProvider(
            create: (context) => AccountActionItemProvider()),
        ChangeNotifierProvider(create: (context) => AccountProvider()),
        ChangeNotifierProvider(create: (context) => DriveUploadProvider()),
        ChangeNotifierProvider(create: (context) => ShareFileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await Future.wait([
      // Provider.of<LoginProvider>(context, listen: false).getNaicsCodes(),
      // Provider.of<MasterProvider>(context, listen: false).getRoles(),
      // Provider.of<MasterProvider>(context, listen: false)
      //     .getCompanyCategories(),
      // Provider.of<MasterProvider>(context, listen: false)
      //     .getBaseCompanyCategories(),
      // Provider.of<MasterProvider>(context, listen: false).getCompanyTypes(),
      // Provider.of<MasterProvider>(context, listen: false).getPayments(),
      // Provider.of<MasterProvider>(context, listen: false).getCompanies(),
    ]);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        // onGenerateRoute: RouteGenerator.generateRoute,
        title: 'Advisor Admin App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: AppColors.white,
          fontFamily: 'Poppins',
          tooltipTheme: TooltipThemeData(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        //home: const Home(),
        home: const CentralForm() //LoginScreen(),
        );
  }
}
