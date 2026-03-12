import 'dart:async';

import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/data/location_data.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SendLocationScreen extends StatefulWidget {
  const SendLocationScreen({super.key});

  @override
  State<SendLocationScreen> createState() => _SendLocationScreenState();
}

class _SendLocationScreenState extends State<SendLocationScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, key: 'send_location')),
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          spacing(height: 5),
          _buildSearchBar(),
          spacing(height: 15),
          googleMapWidget(),
          _buildListWidget()
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const .symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: .circular(50),
            border: Border.all(color: AppColors.grey30)),
        child: TextFormField(
            decoration: fieldDeco(
                hintText: trans(context, key: 'search_location'),
                isFilled: true,
                prefixIcon: TablerIcons.search)),
      ),
    );
  }

  Widget googleMapWidget() {
    return Container(
      height: 250,
      margin: const .symmetric(horizontal: 15),
      decoration: BoxDecoration(borderRadius: .circular(20)),
      clipBehavior: Clip.hardEdge,
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  Widget _buildListWidget() {
    return Expanded(
      child: ListView(
        children: [
          spacing(height: 10),
          ListTile(
            leading: const Icon(TablerIcons.current_location,
                color: AppColors.primary),
            onTap: () {},
            title: Text(trans(context, key: 'your_current_location'),
                style: StyleHelper.titleMedium(context)),
          ),
          const Divider(),
          _buildLocationList(LocationData.list)
        ],
      ),
    );
  }

  Widget _buildLocationList(List<dynamic> list) {
    return ListView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = list[index];
        return ListTile(
          leading: Container(
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryLight),
                shape: BoxShape.circle),
            padding: const .all(8),
            child: Icon(item['icon'], size: 25, color: AppColors.primary),
          ),
          onTap: () {
            navigateBack(context);
          },
          title: Text('${item['address']}',
              style: StyleHelper.titleMedium(context)),
        );
      },
    );
  }
}
