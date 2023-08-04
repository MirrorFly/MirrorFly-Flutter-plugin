import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

int _nextViewCreationId = 0;

enum ScalingType {
  scaleAspectFIT,
  scaleAspectFILL,
  scaleAspectBALANCED;
}

class MirrorFlyView extends StatefulWidget {
  /// MirrorFly View for Audio/Video View
  /// * @property [mirror] - Mirror the view Must be a Boolean
  /// * @property [userJid] - Call participant JID
  /// * @property [viewBgColor] - Color for the View (optional). Random Color by Default
  /// * @property [alignProfilePictureCenter] - Alignment of the profile Picture in Audio Call [CENTER or TOP]
  /// * @property [profileSize] - Size of the profile picture. 60 by Default
  const MirrorFlyView(
      {Key? key,
      this.mirror = true,
      this.scalingType = ScalingType.scaleAspectFILL,
        this.viewBgColor,
        this.alignProfilePictureCenter,
        this.profileSize,
        this.hideProfileView,
      required this.userJid})
      : super(key: key);

  final bool mirror;
  final ScalingType scalingType;
  final Color? viewBgColor;
  final bool? alignProfilePictureCenter;
  final bool? hideProfileView;
  final int? profileSize;
  final String userJid;

  @override
  State<MirrorFlyView> createState() => _MirrorFlyViewState();
}

class _MirrorFlyViewState extends State<MirrorFlyView> {
  final int _viewId = _nextViewCreationId++;
  final nativeViewType = "mirrorfly_view";
  late AndroidViewController androidViewController;
  @override
  void initState() {
    super.initState();
  }
  @override
  Future<void> dispose() async {
    if (Platform.isAndroid) {
      androidViewController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (!widget.isLocalUser && widget.remoteUserJid.isEmpty) {
    if (widget.userJid.isEmpty) {
      throw Exception("remoteUserJid must not be empty");
    }
    return buildHybridCompositionView();
  }

  String getScalingType(ScalingType type) {
    if (type == ScalingType.scaleAspectFILL) {
      return "SCALE_ASPECT_FILL";
    } else if (type == ScalingType.scaleAspectFIT) {
      return "SCALE_ASPECT_FIT";
    } else {
      return "SCALE_ASPECT_BALANCED";
    }
  }

  Map<dynamic, dynamic> buildParams() {
    return {
      "scalingType": getScalingType(widget.scalingType),
      "setMirror": widget.mirror,
      'viewId': widget.userJid.trim().toString(),
      'backgroundColor' : colorToHex(widget.viewBgColor),
      'alignProfilePictureCenter': widget.alignProfilePictureCenter,
      'profileSize': widget.profileSize,
      'hideProfileView': widget.hideProfileView,
      "userJid": widget.userJid.trim().toString()
    };
  }

  String colorToHex(Color? color) {
    if (color == null){
      return "";
    }
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  Widget buildHybridCompositionView() {
    debugPrint("#Mirrorfly Call buildHybridCompositionView");
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        debugPrint("#Mirrorfly Call Android Platform");
        return PlatformViewLink(
          viewType: nativeViewType,
          surfaceFactory:
              (BuildContext context, PlatformViewController controller) {
                androidViewController=(controller as AndroidViewController);
            return AndroidViewSurface(
              controller: androidViewController,
              gestureRecognizers: const <Factory<
                  OneSequenceGestureRecognizer>>{},
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            );
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            return PlatformViewsService.initSurfaceAndroidView(
              id:_viewId,
              viewType: nativeViewType,
              layoutDirection: TextDirection.rtl,
              creationParams: buildParams(),
              creationParamsCodec: const StandardMessageCodec(),
            )
              ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
              ..create();
          },
        );
      case TargetPlatform.iOS:
        debugPrint("build params ${buildParams()}");
        debugPrint("#Mirrorfly Call iOS Platform");
        return UiKitView(
          viewType: nativeViewType,
          layoutDirection: TextDirection.ltr,
          creationParams: buildParams(),
          creationParamsCodec: const StandardMessageCodec(),
        );

      default:
        throw UnsupportedError('Unsupported platform view');
    }
  }

  // Widget buildVirtualDisplayView(Map<String, dynamic> creationParams) {
  //   return AndroidView(
  //     viewType: nativeViewType,
  //     hitTestBehavior: PlatformViewHitTestBehavior.transparent,
  //     creationParamsCodec: const StandardMessageCodec(),
  //     creationParams: creationParams,
  //     onPlatformViewCreated: (value) {
  //       debugPrint("onPlatformViewCreated $value");
  //     },
  //   );
  // }
}

extension ExtensionMirrorflyView on MirrorFlyView {
  setBorderRadius(BorderRadiusGeometry radius) {
    return ClipRRect(
        borderRadius: radius,
        child: Align(
          alignment: Alignment.bottomRight,
          child: this,
        ));
  }
}
