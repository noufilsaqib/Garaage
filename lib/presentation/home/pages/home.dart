import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/config/assets/app_images.dart';
import '../../../common/widgets/my_app_bar.dart';
import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';
import '../../../core/error/error_handler.dart';
import '../../../domain/entities/user.dart';
import '../../connect/bloc/vehicle_cubit.dart';
import '../../profile/bloc/profile_cubit.dart';
import '../widgets/fuel_consumption_card.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/vehicle_stats_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> vehicle = {};

  @override
  void initState() {
    super.initState();
    final vehicleData = context.read<VehicleCubit>().state;
    if (vehicleData == null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user?.uid != null) {
        try {
          context.read<VehicleCubit>().fetchVehicleData(user!.uid);
        } catch (e) {
          ErrorHandler.handleError(context, e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().getCurrentUser();
    return Scaffold(
      appBar: MyAppBar(
        actions: true,
        title: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            UserEntity? user;
            state.result?.fold(
              (l) {
                user = l;
              },
              (r) {
                Future(() {
                  ErrorHandler.handleError(context, r);
                });
              },
            );
            String? firstName = "";
            if (user != null) {
              firstName = user?.firstName;
            }
            return Text(
              'Welcome $firstName',
              style:
                  AppText.pageTitleText.copyWith(color: AppColors.headingText),
            );
          },
        ),
      ),
      body: BlocBuilder<VehicleCubit, Map<String, dynamic>?>(
        builder: (context, vehicleState) {
          final vehicle = vehicleState ?? {};
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: vehicle.isEmpty
                ? const Center(child: Text('Hmm... No vehicle data found'))
                : Column(
                    children: [
                      VehicleCard(
                        name: vehicle['name'] as String,
                        description: vehicle['description'] as String,
                        image: Image.network(
                          vehicle['image'] as String,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              AppImages.sampleVehicle,
                              fit: BoxFit.contain,
                            );
                          },
                        ),
                        errors: vehicle['errors'] as int,
                        transmission: vehicle['transmission'] as String,
                        numSeats: vehicle['numSeats'] as int,
                        status: vehicle['status'] as String,
                      ),
                      const SizedBox(height: 10),
                      FuelConsumptionCard(
                        currentConsumed: vehicle['status'] == 'Disconnected'
                            ? 0
                            : vehicle['fuelConsumed'] as int,
                        totalConsumed: vehicle['totalFuel'] as int,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 4,
                            child: VehicleStatsCard(
                              value: vehicle['speed'] as int,
                              icon: AppIcons.broken['speed']!,
                              mainLabel: 'Speed',
                              subLabel: 'km/h',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 6,
                            child: VehicleStatsCard(
                              value: vehicle['rpm'] as int,
                              icon: AppIcons.broken['rpm']!,
                              mainLabel: 'Engine RPM',
                              fixAlignment: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 6,
                            child: VehicleStatsCard(
                              value: vehicle['battery'] as int,
                              icon: AppIcons.broken['battery']!,
                              mainLabel: 'Car Battery',
                              postfix: '%',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 4,
                            child: VehicleStatsCard(
                              value: vehicle['oil'] as int,
                              icon: AppIcons.broken['drop']!,
                              mainLabel: 'Oil',
                              postfix: '%',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      VehicleStatsCard(
                        value: vehicle['coolantCurrent'] as int,
                        valueAlt: vehicle['coolantDesired'] as int,
                        icon: AppIcons.broken['coolant']!,
                        mainLabel: 'Coolant Temp',
                        subLabel: 'current',
                        subLabelAlt: 'desired',
                        postfix: '°C',
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
