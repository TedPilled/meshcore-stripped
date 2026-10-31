import 'package:flutter/material.dart';
import '../services/node_banner_service.dart';

class GetNodeBanner extends StatelessWidget {
  final Future<NodeBannerConfig?> Function()? loadConfig;

  const GetNodeBanner({super.key, this.loadConfig});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
