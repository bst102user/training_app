import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_widgets.dart';

class PdfPage extends StatelessWidget{
  final String title;
  final String urlStr;
  final String fileType;
  PdfPage(this.title, this.urlStr, this.fileType);
  PdfViewerController? _pdfViewerController = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage(
              "assets/images/cycle_blur.png",
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    const SizedBox(height: 15.0,),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: CommonWidgets.commonHeader(context, title),
                    ),
                    const SizedBox(height: 10.0,),
                  ],
                ),
              ),
              Flexible(
                flex: 10,
                child: fileType=='.pdf'?SfPdfViewer.network(
                  urlStr,
                  controller: _pdfViewerController,
                ):Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.9,
                  color: Colors.white,
                  child: Image.network(
                      urlStr,
                  // fit: BoxFit.cover,
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}