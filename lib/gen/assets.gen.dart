/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/card.png
  AssetGenImage get card => const AssetGenImage('assets/images/card.png');

  /// File path: assets/images/create card.png
  AssetGenImage get createCard =>
      const AssetGenImage('assets/images/create card.png');

  /// File path: assets/images/hide.png
  AssetGenImage get hide => const AssetGenImage('assets/images/hide.png');

  /// File path: assets/images/home.png
  AssetGenImage get home => const AssetGenImage('assets/images/home.png');

  /// File path: assets/images/more.png
  AssetGenImage get more => const AssetGenImage('assets/images/more.png');

  /// File path: assets/images/nigerian flag.png
  AssetGenImage get nigerianFlag =>
      const AssetGenImage('assets/images/nigerian flag.png');

  /// File path: assets/images/plus.png
  AssetGenImage get plus => const AssetGenImage('assets/images/plus.png');

  /// File path: assets/images/setting.png
  AssetGenImage get setting => const AssetGenImage('assets/images/setting.png');

  /// File path: assets/images/transaction history.png
  AssetGenImage get transactionHistory =>
      const AssetGenImage('assets/images/transaction history.png');

  /// File path: assets/images/transfer.png
  AssetGenImage get transfer =>
      const AssetGenImage('assets/images/transfer.png');

  /// File path: assets/images/uk flag.png
  AssetGenImage get ukFlag => const AssetGenImage('assets/images/uk flag.png');

  /// File path: assets/images/us flag.png
  AssetGenImage get usFlag => const AssetGenImage('assets/images/us flag.png');

  /// File path: assets/images/veiw subcards.png
  AssetGenImage get veiwSubcards =>
      const AssetGenImage('assets/images/veiw subcards.png');

  /// File path: assets/images/view.png
  AssetGenImage get view => const AssetGenImage('assets/images/view.png');

  /// File path: assets/images/withdraw.png
  AssetGenImage get withdraw =>
      const AssetGenImage('assets/images/withdraw.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    card,
    createCard,
    hide,
    home,
    more,
    nigerianFlag,
    plus,
    setting,
    transactionHistory,
    transfer,
    ukFlag,
    usFlag,
    veiwSubcards,
    view,
    withdraw,
  ];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/Google.svg
  SvgGenImage get google => const SvgGenImage('assets/svg/Google.svg');

  /// File path: assets/svg/back arrow.svg
  SvgGenImage get backArrow => const SvgGenImage('assets/svg/back arrow.svg');

  /// File path: assets/svg/card chip.svg
  SvgGenImage get cardChip => const SvgGenImage('assets/svg/card chip.svg');

  /// File path: assets/svg/down arrow.svg
  SvgGenImage get downArrow => const SvgGenImage('assets/svg/down arrow.svg');

  /// File path: assets/svg/notification.svg
  SvgGenImage get notification =>
      const SvgGenImage('assets/svg/notification.svg');

  /// File path: assets/svg/visa.svg
  SvgGenImage get visa => const SvgGenImage('assets/svg/visa.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    google,
    backArrow,
    cardChip,
    downArrow,
    notification,
    visa,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
