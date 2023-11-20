import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class _LinkTextSpan extends TextSpan {
  // Beware!
  //
  // This class is only safe because the TapGestureRecognizer is not
  // given a deadline and therefore never allocates any resources.
  //
  // In any other situation -- setting a deadline, using any of the less trivial
  // recognizers, etc -- you would have to manage the gesture recognizer's
  // lifetime and call dispose() when the TextSpan was no longer being rendered.
  //
  // Since TextSpan itself is @immutable, this means that you would have to
  // manage the recognizer from outside the TextSpan, e.g. in the State of a
  // stateful widget that then hands the recognizer to the TextSpan.

  _LinkTextSpan({required TextStyle style, required String url, required String text})
      : super(
            style: style,
            text: text,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrl(Uri.parse(url));
              });
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle? aboutTextStyle = themeData.textTheme.bodyMedium;
    const TextStyle linkStyle = TextStyle(
        decoration: TextDecoration.underline,
        color: Colors.blue,
        fontSize: 13.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tentang Kami"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          style: aboutTextStyle,
                          text:
                              'Aplikasi ini merupakan aplikasi gratis yang dibuat '
                              'secara suka rela tanpa memiliki hubungan kerja dengan pihak '
                              ),
                      
                      _LinkTextSpan(
                        style: linkStyle,
                        url:
                            'https://bdnaash.com',
                        text:
                            'bdnaash.com',
                      ),
                      TextSpan(
                        style: aboutTextStyle,
                        text: '\n\nSelain data yang tersedia di website bdnaash.com kami juga berusaha mengupdate database produk di Indonesia yang berelasi dengan brand utama secara berkala.\n',
                      ),
                      TextSpan(
                        style: aboutTextStyle,
                        text: '\nJika ingin membantu silahkan hubungi kami.\n',
                      ),
                      TextSpan(
                        style: aboutTextStyle,
                        text: '\n\n\nChunkz Tech\n',
                      ),
                      _LinkTextSpan(
                        style: linkStyle,
                        url: 'mailto:chunkz.ring@gmail.com',
                        text: 'chunkz.ring@gmail.com',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
