import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_widgets.dart';

class PdfPage extends StatelessWidget{
  final String title;
  final String urlStr;
  PdfPage(this.title, this.urlStr);
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
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CommonWidgets.commonHeader(context, title),
              ),
              const SizedBox(height: 10.0,),
              Container(
                height: CommonMethods.deviceHeight(context)*0.9,
                width: CommonMethods.deviceWidth(context),
                child: SfPdfViewer.network(
                  urlStr,
                  controller: _pdfViewerController,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}