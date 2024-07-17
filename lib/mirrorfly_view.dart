import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mirrorfly_plugin/logmessage.dart';

/// The next ID to be assigned to a `MirrorFlyView` instance.
int _nextViewCreationId = 0;

/// Enum representing the different types of scaling that can be applied to a `MirrorFlyView`.
enum ScalingType {
  /// Scale the view to fit the aspect ratio of the video, with black bars on the sides or top and bottom.
  scaleAspectFIT,

  /// Scale the view to fill the aspect ratio of the video, cropping the edges if necessary.
  scaleAspectFILL,

  /// Scale the view to fit the aspect ratio of the video, with black bars on the sides or top and bottom, but with the video centered.
  scaleAspectBALANCED;
}

/// Enum representing the different positions that a profile picture can be aligned to in a `MirrorFlyView`.
enum HorizontalGravity {
  /// Align the profile picture to the top of the view.
  top,

  /// Align the profile picture to the center of the view.
  center,

  /// Align the profile picture to the bottom of the view.
  bottom
}

/// A widget that displays a view for audio/video calls in the MirrorFly application.
///
/// @property [mirror] Whether to mirror the view. Must be a Boolean.
/// @property [userJid] The JID of the call participant.
/// @property [viewBgColor] The color for the view (optional). Random color by default.
/// @property [alignProfilePictureCenter] The alignment of the profile picture in an audio call. Can be CENTER or TOP.
/// @property [profileSize] The size of the profile picture. Default is 60.
/// @property [showSpeakingRipple] Whether to show a ripple effect in the profile view background when the user is speaking.

class MirrorFlyView extends StatefulWidget {
  /// Constructor for the [MirrorFlyView] class.
  const MirrorFlyView(
      {Key? key,
      this.mirror = true,
      this.scalingType = ScalingType.scaleAspectFILL,
      this.viewBgColor,
      this.alignProfilePictureCenter = true,
      // this.horizontalGravity = HorizontalGravity.center,
      // this.profileview,
      this.profileSize = 80,
      this.hideProfileView = false,
      required this.userJid,
      this.showSpeakingRipple = false,
      this.onClick})
      : super(key: key);

  /// Whether to mirror the view. Must be a Boolean.
  final bool mirror;

  /// The scaling type for the view.
  final ScalingType scalingType;

  /// The color for the view.
  final Color? viewBgColor;

  /// The alignment of the profile picture in an audio call.
  final bool? alignProfilePictureCenter;

  // final HorizontalGravity horizontalGravity;
  // final ProfileViewPositioned? profileview;

  /// Whether to hide the profile view.
  final bool? hideProfileView;

  /// Whether to show a ripple effect in the profile view background when the user is speaking.
  final bool? showSpeakingRipple;

  /// The size of the profile picture.
  final int? profileSize;

  /// The JID of the call participant.
  final String userJid;

  /// The function to call when the view is clicked.
  final Function()? onClick;

  @override
  State<MirrorFlyView> createState() => _MirrorFlyViewState();
}

/// The state for a `MirrorFlyView` widget.
class _MirrorFlyViewState extends State<MirrorFlyView> {
  final int _viewId = _nextViewCreationId++;
  final nativeViewType = "mirrorfly_view";
  AndroidViewController? androidViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    LogMessage.d("MirrorFlyView", "setState $fn");
  }

  @override
  void dispose() {
    LogMessage.d("MirrorFlyView", "dispose");
    if (Platform.isAndroid && androidViewController != null) {
      androidViewController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (!widget.isLocalUser && widget.remoteUserJid.isEmpty) {
    if (widget.userJid.isEmpty) {
      throw Exception("remoteUserJid must not be empty");
    }
    return Stack(
      children: [
        buildHybridCompositionView(),
        InkWell(splashColor: Colors.transparent, onTap: widget.onClick)
      ],
    );
  }

  String getScalingType(ScalingType type) {
    switch (type) {
      case ScalingType.scaleAspectFIT:
        return "SCALE_ASPECT_FIT";
      case ScalingType.scaleAspectFILL:
        return "SCALE_ASPECT_FILL";
      case ScalingType.scaleAspectBALANCED:
        return "SCALE_ASPECT_BALANCED";
    }
  }

  int getHorizontalGravity(HorizontalGravity horizontalGravity) {
    switch (horizontalGravity) {
      case HorizontalGravity.top:
        return 48;
      case HorizontalGravity.center:
        return 17;
      case HorizontalGravity.bottom:
        return 80;
    }
  }

  Map<dynamic, dynamic> buildParams() {
    return {
      "scalingType": getScalingType(widget.scalingType),
      "setMirror": widget.mirror,
      'viewId': widget.userJid.trim().toString(),
      'backgroundColor': colorToHex(widget.viewBgColor),
      'alignProfilePictureCenter': widget.alignProfilePictureCenter,
      // 'horizontalGravity': getHorizontalGravity(widget.horizontalGravity),
      'profileSize': widget.profileSize,
      'hideProfileView': widget.hideProfileView,
      'showSpeakingRipple': widget.showSpeakingRipple,
      "userJid": widget.userJid.trim().toString(),
      // "ProfileViewPositioned": widget.profileview?.toMap()
    };
  }

  String colorToHex(Color? color) {
    if (color == null) {
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
            androidViewController = (controller as AndroidViewController);
            return AndroidViewSurface(
              key: widget.key,
              controller: androidViewController!,
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
        // debugPrint("build params ${buildParams()}");
        debugPrint("#Mirrorfly Call iOS Platform");
        return UiKitView(
          key: widget.key,
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

/// An extension on `MirrorFlyView` that provides a method to set the border radius of the view.
extension ExtensionMirrorflyView on MirrorFlyView {
  /// Sets the border radius of the view.
  setBorderRadius(BorderRadiusGeometry radius) {
    return ClipRRect(
        borderRadius: radius,
        child: Align(
          alignment: Alignment.bottomRight,
          child: this,
        ));
  }
}

/// A class that represents the position of a profile view in a `MirrorFlyView`.
///
/// @property [left] The distance from the left edge of the `MirrorFlyView`.
/// @property [top] The distance from the top edge of the `MirrorFlyView`.
/// @property [right] The distance from the right edge of the `MirrorFlyView`.
/// @property [bottom] The distance from the bottom edge of the `MirrorFlyView`.
/// @property [width] The width of the profile view.
/// @property [height] The height of the profile view.
class ProfileViewPositioned {
  /// The distance from the left edge of the `MirrorFlyView`.
  final int? left;

  /// The distance from the top edge of the `MirrorFlyView`.
  final int? top;

  /// The distance from the right edge of the `MirrorFlyView`.
  final int? right;

  /// The distance from the bottom edge of the `MirrorFlyView`.
  final int? bottom;

  /// The width of the profile view.
  final int? width;

  /// The height of the profile view.
  final int? height;

  /// Constructor for the [ProfileViewPositioned] class.
  ProfileViewPositioned(
      {this.left, this.top, this.right, this.bottom, this.width, this.height});

  /// Converts a [ProfileViewPositioned] object into a map.
  Map<String, dynamic> toMap() => {
        "left": left,
        "top": top,
        "right": right,
        "bottom": bottom,
        "width": width,
        "height": height
      };
}
