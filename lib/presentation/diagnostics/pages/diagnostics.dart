import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/widgets/my_app_bar.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/theme/app_text.dart';

class DiagnosticsPage extends StatefulWidget {
  const DiagnosticsPage({super.key});

  static final errorCodes = [
    {
      'code': 'P0128',
      'description':
          'The engine coolant isn\'t reaching optimal temperature due to a stuck-open thermostat, causing rich fuel mixture, increased fuel consumption, and reduced performance.',
      'causes': [
        'Stuck-open thermostat',
        'Faulty coolant temperature sensor (CTS)',
        'Low coolant level',
        'Air in the cooling system',
      ],
      'solutions': [
        'Check the coolant level: Top up if needed.',
        'Bleed the cooling system. To remove trapped air.',
        'Test the thermostat: Replace if it fails to open and close properly.',
        'Inspect the coolant temperature sensor (CTS): Replace if faulty.',
      ],
      'partsNeeded': [
        {
          'name': 'Replacement thermostat',
          'price': 6.99,
          'vendor': 'AutoZone',
          'link':
              'https://www.autozone.com/cooling-heating-and-climate-control/thermostat/duralast-thermostat-15368/10007_0_0',
        },
        {
          'name': 'Coolant',
          'price': 14.99,
          'vendor': 'NAPA',
          'link': 'https://www.napaonline.com/en/p/ZERCLC1',
        }
      ],
    },
    {
      'code': 'P0420',
      'description':
          'The catalytic converter is not functioning properly, causing increased emissions, reduced fuel economy, and poor engine performance.',
      'causes': [
        'Faulty catalytic converter',
        'Oxygen sensor malfunction',
        'Exhaust leak',
        'Engine misfire',
      ],
      'solutions': [
        'Check the oxygen sensor: Replace if faulty.',
        'Inspect the catalytic converter: Replace if damaged.',
        'Check for exhaust leaks: Repair if found.',
        'Check for engine misfires: Repair if found.',
      ],
      'partsNeeded': [
        {
          'name': 'Replacement catalytic converter',
          'price': 199.99,
          'vendor': 'AutoZone',
          'link':
              'https://www.autozone.com/emission-control-and-exhaust/catalytic-converter/davico-catalytic-converter-18200/10007_0_0',
        },
        {
          'name': 'Oxygen sensor',
          'price': 29.99,
          'vendor': 'NAPA',
          'link': 'https://www.napaonline.com/en/p/NGO25024688',
        }
      ],
    },
  ];

  @override
  State<DiagnosticsPage> createState() => _DiagnosticsPageState();
}

class _DiagnosticsPageState extends State<DiagnosticsPage> {
  late Map<String, Object> selectedError;

  @override
  void initState() {
    super.initState();
    selectedError = DiagnosticsPage.errorCodes[0];
  }

  void _updateSelectedError(Map<String, Object> error) {
    setState(() {
      selectedError = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        actions: true,
        title: Text(
          'Diagnostics',
          style: AppText.pageTitleText.copyWith(color: AppColors.headingText),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: DiagnosticsPage.errorCodes.isEmpty
            ? Center(
                child: Column(
                  children: [
                    const LastUpdated(),
                    const SizedBox(height: 20),
                    Text(
                      'No error codes found.',
                      style: AppText.bodyText.copyWith(
                        color: AppColors.bodyText,
                      ),
                    ),
                  ],
                ),
              )
            : Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ErrorCodeDropdown(
                      errorCodes: DiagnosticsPage.errorCodes,
                      selectedError: selectedError,
                      onChanged: _updateSelectedError,
                    ),
                    const SizedBox(width: 10),
                    const LastUpdated(),
                  ],
                ),
                const SizedBox(height: 10),
                ErrorCodePanel(error: Error.fromMap(selectedError)),
              ]),
      ),
    );
  }
}

class ErrorCodeDropdown extends StatelessWidget {
  final List<Map<String, Object>> errorCodes;
  final Map<String, Object> selectedError;
  final ValueChanged<Map<String, Object>> onChanged;

  const ErrorCodeDropdown({
    super.key,
    required this.errorCodes,
    required this.selectedError,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(left: 15),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: DropdownButton<Map<String, Object>>(
        dropdownColor: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
        iconEnabledColor: AppColors.surface,
        value: selectedError,
        onChanged: (error) {
          onChanged(error!);
        },
        items: errorCodes
            .map(
              (error) => DropdownMenuItem<Map<String, Object>>(
                value: error,
                child: Text(
                  error['code'] as String,
                  style: AppText.bodyText.copyWith(color: AppColors.surface),
                ),
              ),
            )
            .toList(),
        underline: const SizedBox(),
      ),
    );
  }
}

class LastUpdated extends StatelessWidget {
  const LastUpdated({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last Updated',
            style: AppText.bodyText.copyWith(
              fontSize: 12,
              color: AppColors.darkGrayLight,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'July 27, 2024',
                    style: AppText.bodyText.copyWith(
                      color: AppColors.bodyText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '02:30 PM',
                    style: AppText.bodyText.copyWith(
                      color: AppColors.bodyText,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () => {},
                icon: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.darkGrayDarkest,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    AppIcons.broken['rotate-right']!,
                    width: 18,
                    colorFilter: const ColorFilter.mode(
                      AppColors.surface,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Error {
  final String code;
  final String description;
  final List<String> causes;
  final List<String> solutions;
  final List<Map<String, dynamic>> partsNeeded;

  const Error({
    required this.code,
    required this.description,
    required this.causes,
    required this.solutions,
    required this.partsNeeded,
  });

  factory Error.fromMap(Map<String, dynamic> map) {
    return Error(
      code: map['code'],
      description: map['description'],
      causes: List<String>.from(map['causes']),
      solutions: List<String>.from(map['solutions']),
      partsNeeded: List<Map<String, dynamic>>.from(map['partsNeeded']),
    );
  }
}

class ErrorCodePanel extends StatelessWidget {
  final Error error;

  const ErrorCodePanel({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          title: Text(
            'Error Description',
            style: AppText.headingText.copyWith(color: AppColors.headingText),
          ),
          initiallyExpanded: true,
          shape: const Border(
            bottom: BorderSide(
              color: Color(0xFFA1A1A1),
              width: 0.5,
            ),
          ),
          children: [
            ListTile(
              subtitle: Text(
                error.description,
                style: AppText.bodyText.copyWith(color: AppColors.bodyText),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            'Possible Cause(s)',
            style: AppText.headingText.copyWith(color: AppColors.headingText),
          ),
          shape: const Border(
            bottom: BorderSide(
              color: Color(0xFFA1A1A1),
              width: 0.5,
            ),
          ),
          children: [
            ListTile(
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: error.causes
                    .map((cause) => Text(
                          '\u2022 $cause',
                          style: AppText.bodyText
                              .copyWith(color: AppColors.bodyText),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            'How To Fix',
            style: AppText.headingText.copyWith(color: AppColors.headingText),
          ),
          shape: const Border(
            bottom: BorderSide(
              color: Color(0xFFA1A1A1),
              width: 0.5,
            ),
          ),
          children: [
            ListTile(
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: error.solutions
                    .asMap()
                    .entries
                    .map(
                      (entry) => Text(
                        '${entry.key + 1}. ${entry.value}',
                        style: AppText.bodyText
                            .copyWith(color: AppColors.bodyText),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            'Parts Needed',
            style: AppText.headingText.copyWith(color: AppColors.headingText),
          ),
          shape: const Border(
            bottom: BorderSide(
              color: Color(0xFFA1A1A1),
              width: 0.5,
            ),
          ),
          children: error.partsNeeded
              .map(
                (part) => ListTile(
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          part['name'],
                          style: AppText.bodyText.copyWith(
                            color: AppColors.bodyText,
                          ),
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () async {
                          if (await canLaunchUrl(Uri.parse(part['link']))) {
                            await launchUrl(
                              part['link'],
                              mode: LaunchMode.inAppBrowserView,
                              browserConfiguration:
                                  const BrowserConfiguration(showTitle: true),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              '\$${part['price']} on ${part['vendor']}',
                              style: AppText.bodyText.copyWith(
                                color: AppColors.bodyText,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.link,
                              color: AppColors.bodyText,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        )
      ],
    );
  }
}
