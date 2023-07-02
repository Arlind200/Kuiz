import 'package:flutter/material.dart';
import 'package:Kuiz/firebase_options.dart';
import 'package:photo_view/photo_view.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    Key? key,
    required this.question,
    required this.indexAction,
    required this.totalQuestions,
    required this.url,
    required this.photo, // mban bool per te shikuar a ka foto pyetja perkatese
  }) : super(key: key);
  // here we need the question title and the total number of questions, and also the index

  final String question;
  final int indexAction;
  final int totalQuestions;
  final String url;
  final bool photo;
  @override
  Widget build(BuildContext context) {
    return Column(
      //  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      //  alignment: Alignment.centerLeft,
      children: [
        ('Pyetja ${indexAction + 1}/$totalQuestions: $question'.length) < 65 &&
                ((DefaultFirebaseOptions.currentPlatform ==
                    DefaultFirebaseOptions.web) ||
                (DefaultFirebaseOptions.currentPlatform ==
                    DefaultFirebaseOptions.android))
            ? Text(
                'Pyetja ${indexAction + 1}/$totalQuestions: $question',
                style: const TextStyle(
                    fontSize: 24.0, color: Colors.black, fontFamily: 'Raleway'),
              )
            : 
            (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.android ) &&( ('Pyetja ${indexAction + 1}/$totalQuestions: $question'.length) > 65) ?
            Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Text(
                    overflow: TextOverflow.fade,
                    'Pyetja ${indexAction + 1}/$totalQuestions: $question',
                    style: const TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                        fontFamily: 'Raleway'),
                  ),
                ),
              ):const Text(''),
        const Divider(thickness: 1, color: Color.fromARGB(66, 0, 0, 0)),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        photo
            ? SizedBox(
                // width: MediaQuery.of(context).size.width/2,
                //decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.red),
                height: MediaQuery.of(context).size.height * 0.24,
                width: MediaQuery.of(context).size.width,

                child: ClipRect(
                  child: PhotoView(
                    // initialScale: 80,
                    imageProvider: NetworkImage(url),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.contained,
                    //  initialScale:MediaQuery.of(context).size.height ,
                    backgroundDecoration:
                        const BoxDecoration(color: Colors.lime),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
