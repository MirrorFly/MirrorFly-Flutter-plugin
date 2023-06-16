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
  const MirrorFlyView(
      {Key? key,
      this.mirror = true,
      this.scalingType = ScalingType.scaleAspectFILL,
      required this.isLocalUser,
      this.remoteUserJid = ""})
      : super(key: key);
  // final Map<dynamic, dynamic> creationParams;

  final bool mirror;
  final ScalingType scalingType;
  final bool isLocalUser;
  final String remoteUserJid;

  @override
  State<MirrorFlyView> createState() => _MirrorFlyViewState();
}

class _MirrorFlyViewState extends State<MirrorFlyView> {
  final int _viewId = _nextViewCreationId++;
  final nativeViewType = "mirrorfly_view";
  @override
  Widget build(BuildContext context) {
    if (!widget.isLocalUser && widget.remoteUserJid.isEmpty) {
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
      if (widget.isLocalUser) "isLocal": widget.isLocalUser,
      if (!widget.isLocalUser) "isRemote": true,
      if (!widget.isLocalUser) "userJid": widget.remoteUserJid.trim().toString()
    };
  }

  Widget buildHybridCompositionView() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return PlatformViewLink(
          viewType: nativeViewType,
          surfaceFactory:
              (BuildContext context, PlatformViewController controller) {
            return AndroidViewSurface(
              controller: (controller as AndroidViewController),
              gestureRecognizers: const <Factory<
                  OneSequenceGestureRecognizer>>{},
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            );
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            return PlatformViewsService.initSurfaceAndroidView(
              id: _viewId,
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
