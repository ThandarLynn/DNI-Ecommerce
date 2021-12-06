import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PrivacyPolicyView extends StatefulWidget {
  const PrivacyPolicyView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _PrivacyPolicyViewState createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: widget.animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    widget.animationController.forward();
    return AnimatedBuilder(
      animation: widget.animationController,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space10),
        child: SingleChildScrollView(
          child: HtmlWidget(
            '<p><strong>Privacy Policy<\/strong><\/p>\r\n\r\n<p>Kool Communications LLC built the DailyAdss app as a Free app. This SERVICE is provided by Kool Communications LLC at no cost and is intended for use as is.<\/p>\r\n\r\n<p>This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.<\/p>\r\n\r\n<p>If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. we will not use or share your information with anyone except as described in this Privacy Policy.<\/p>\r\n\r\n<p>The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at DailyAdss unless otherwise defined in this Privacy Policy.<\/p>\r\n\r\n<p><strong>Information Collection and Use<\/strong><\/p>\r\n\r\n<p>For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to Personal information refers to anything that can be used to identify an individual. including names, phone numbers, email, address, device IDs, and locations.. The information that we request will be retained by us and used as described in this privacy policy.<\/p>\r\n\r\n<p>The app does use third party services that may collect information used to identify you.<\/p>\r\n\r\n<p>Link to privacy policy of third party service providers used by the app<\/p>\r\n\r\n<p><a href=\"https:\/\/www.google.com\/policies\/privacy\/\" target=\"_blank\">Google Play Services<\/a><\/p>\r\n\r\n<p><a href=\"https:\/\/support.google.com\/admob\/answer\/6128543?hl=en\" target=\"_blank\">AdMob<\/a><\/p>\r\n\r\n<p><a href=\"https:\/\/www.facebook.com\/about\/privacy\/update\/printable\" target=\"_blank\">Facebook<\/a><\/p>\r\n\r\n<p><strong>Log Data<\/strong><\/p>\r\n\r\n<p>we want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (&ldquo;IP&rdquo;) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.<\/p>\r\n\r\n<p><strong>Cookies<\/strong><\/p>\r\n\r\n<p>Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device&#39;s internal memory.<\/p>\r\n\r\n<p>This Service does not use these &ldquo;cookies&rdquo; explicitly. However, the app may use third party code and libraries that use &ldquo;cookies&rdquo; to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.<\/p>\r\n\r\n<p><strong>Service Providers<\/strong><\/p>\r\n\r\n<p>we may employ third-party companies and individuals due to the following reasons:<\/p>\r\n\r\n<p>To facilitate our Service;<\/p>\r\n\r\n<p>To provide the Service on our behalf;<\/p>\r\n\r\n<p>To perform Service-related services; or<\/p>\r\n\r\n<p>To assist us in analyzing how our Service is used.<\/p>\r\n\r\n<p>we want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.<\/p>\r\n\r\n<p><strong>Security<\/strong><\/p>\r\n\r\n<p>we value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.<\/p>\r\n\r\n<p><strong>Links to Other Sites<\/strong><\/p>\r\n\r\n<p>This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. we have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.<\/p>\r\n\r\n<p><strong>Children&rsquo;s Privacy<\/strong><\/p>\r\n\r\n<p>These Services do not address anyone under the age of 13. we do not knowingly collect personally identifiable information from children under 13. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do necessary actions.<\/p>\r\n\r\n<p><strong>Changes to This Privacy Policy<\/strong><\/p>\r\n\r\n<p>we may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. we will notify you of any changes by posting the new Privacy Policy on this page.<\/p>\r\n\r\n<p>This policy is effective as of 2020-05-29<\/p>\r\n\r\n<p><strong>Contact Us<\/strong><\/p>\r\n\r\n<p>If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at info@dailyadss.com.<\/p>',
          ),
        ),
      ),
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 100 * (1.0 - animation.value), 0.0),
              child: child),
        );
      },
    );
  }
}
