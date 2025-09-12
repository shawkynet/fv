import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '/../utils/Extensions/string_extensions.dart';
import '/../models/CityListModel.dart';
import '/../network/RestApis.dart';
import '/../utils/Colors.dart';
import '/../utils/Common.dart';
import '/../utils/Extensions/app_textfield.dart';
import '/../main.dart';
import '/../network/CommonApiCall.dart';
import '/../utils/Constants.dart';
import '/../utils/Extensions/common.dart';
import '/../utils/Extensions/shared_pref.dart';
import '/../utils/Extensions/text_styles.dart';

class AddCityDialog extends StatefulWidget {
  static String tag = '/AddCityDialog';
  final CityData? cityData;
  final Function()? onUpdate;

  AddCityDialog({this.cityData, this.onUpdate});

  @override
  AddCityDialogState createState() => AddCityDialogState();
}

class AddCityDialogState extends State<AddCityDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController cityNameController = TextEditingController();
  TextEditingController fixedChargeController = TextEditingController();
  TextEditingController cancelChargeController = TextEditingController();
  TextEditingController minDistanceController = TextEditingController();
  TextEditingController minWeightController = TextEditingController();
  TextEditingController perDistanceChargeController = TextEditingController();
  TextEditingController perWeightChargeChargeController =
      TextEditingController();

  TextEditingController commissionController = TextEditingController();

  int? selectedCountryId;
  String distanceType = '';
  String weightType = '';

  String commissionType = 'fixed';

  List<String> commissionTypeList = ['fixed', 'percentage'];

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
    await getAllCountryApiCall();
    isUpdate = widget.cityData != null;
    if (isUpdate) {
      cityNameController.text = widget.cityData!.name!;
      fixedChargeController.text = widget.cityData!.fixedCharges.toString();
      cancelChargeController.text = widget.cityData!.cancelCharges.toString();
      minDistanceController.text = widget.cityData!.minDistance.toString();
      minWeightController.text = widget.cityData!.minWeight.toString();
      perDistanceChargeController.text =
          widget.cityData!.perDistanceCharges.toString();
      perWeightChargeChargeController.text =
          widget.cityData!.perWeightCharges.toString();
      appStore.countryList.forEach((element) {
        if (element.id == widget.cityData!.countryId) {
          selectedCountryId = widget.cityData!.countryId;
        }
      });
      commissionType = widget.cityData!.commissionType.isEmptyOrNull
          ? 'fixed'
          : widget.cityData!.commissionType.toString();
      commissionController.text = widget.cityData!.adminCommission.toString();
      getDistanceAndWeightType();
      setState(() {});
    }
    appStore.setLoading(false);
  }

  getDistanceAndWeightType() {
    appStore.countryList.forEach((e) {
      if (e.id == selectedCountryId) {
        distanceType = e.distanceType!;
        weightType = e.weightType!;
      }
    });
  }

  AddCityApi() async {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
      Map req = {
        "id": isUpdate ? widget.cityData!.id : "",
        "country_id": selectedCountryId,
        "name": cityNameController.text,
        "fixed_charges": fixedChargeController.text,
        "cancel_charges": cancelChargeController.text,
        "min_distance": minDistanceController.text,
        "min_weight": minWeightController.text,
        "per_distance_charges": perDistanceChargeController.text,
        "per_weight_charges": perWeightChargeChargeController.text,
        "commission_type": commissionType,
        "admin_commission": commissionController.text.trim()
      };
      appStore.setLoading(true);
      await addCity(req).then((value) {
        appStore.setLoading(false);
        toast(value.message.toString());
        widget.onUpdate!.call();
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.only(right: 16, bottom: 16),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(isUpdate ? language.update_city : language.add_city,
              style: boldTextStyle(color: primaryColor, size: 20)),
          IconButton(
            icon: Icon(Icons.close),
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      content: Observer(builder: (context) {
        return SingleChildScrollView(
          child: Stack(
            children: [
              Visibility(
                visible: !appStore.isLoading,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language.city_name,
                                    style: primaryTextStyle()),
                                SizedBox(height: 8),
                                AppTextField(
                                  controller: cityNameController,
                                  textFieldType: TextFieldType.NAME,
                                  decoration: commonInputDecoration(),
                                  textInputAction: TextInputAction.next,
                                  errorThisFieldRequired:
                                      language.field_required_msg,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language.select_country,
                                    style: primaryTextStyle()),
                                SizedBox(height: 8),
                                DropdownButtonFormField<int>(
                                  dropdownColor: Theme.of(context).cardColor,
                                  value: selectedCountryId,
                                  decoration: commonInputDecoration(),
                                  items: appStore.countryList
                                      .map<DropdownMenuItem<int>>((item) {
                                    return DropdownMenuItem(
                                        value: item.id,
                                        child: Text(item.name!,
                                            style: primaryTextStyle()));
                                  }).toList(),
                                  onChanged: (value) {
                                    selectedCountryId = value;
                                    getDistanceAndWeightType();
                                    setState(() {});
                                  },
                                  validator: (value) {
                                    if (selectedCountryId == null)
                                      return language.field_required_msg;
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language.fixed_charge,
                                    style: primaryTextStyle()),
                                SizedBox(height: 8),
                                AppTextField(
                                  controller: fixedChargeController,
                                  textFieldType: TextFieldType.OTHER,
                                  decoration: commonInputDecoration(),
                                  errorThisFieldRequired:
                                      language.field_required_msg,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9 .]')),
                                  ],
                                  textInputAction: TextInputAction.next,
                                  validator: (s) {
                                    if (s!.trim().isEmpty)
                                      return language.field_required_msg;
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language.cancel_charge,
                                    style: primaryTextStyle()),
                                SizedBox(height: 8),
                                AppTextField(
                                  controller: cancelChargeController,
                                  textFieldType: TextFieldType.OTHER,
                                  decoration: commonInputDecoration(),
                                  textInputAction: TextInputAction.next,
                                  errorThisFieldRequired:
                                      language.field_required_msg,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9 .]')),
                                  ],
                                  validator: (s) {
                                    if (s!.trim().isEmpty)
                                      return language.field_required_msg;
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${language.minimum_distance} ${distanceType.isNotEmpty ? '($distanceType)' : ''}',
                                    style: primaryTextStyle()),
                                SizedBox(height: 8),
                                AppTextField(
                                  controller: minDistanceController,
                                  textFieldType: TextFieldType.OTHER,
                                  decoration: commonInputDecoration(),
                                  textInputAction: TextInputAction.next,
                                  errorThisFieldRequired:
                                      language.field_required_msg,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9 .]')),
                                  ],
                                  validator: (s) {
                                    if (s!.trim().isEmpty)
                                      return language.field_required_msg;
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${language.minimum_weight} ${weightType.isNotEmpty ? '($weightType)' : ''}',
                                    style: primaryTextStyle()),
                                SizedBox(height: 8),
                                AppTextField(
                                  controller: minWeightController,
                                  textFieldType: TextFieldType.OTHER,
                                  decoration: commonInputDecoration(),
                                  textInputAction: TextInputAction.next,
                                  errorThisFieldRequired:
                                      language.field_required_msg,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9 .]')),
                                  ],
                                  validator: (s) {
                                    if (s!.trim().isEmpty)
                                      return language.field_required_msg;
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language.per_distance_charge,
                                    style: primaryTextStyle()),
                                SizedBox(height: 8),
                                AppTextField(
                                  controller: perDistanceChargeController,
                                  textFieldType: TextFieldType.OTHER,
                                  decoration: commonInputDecoration(),
                                  textInputAction: TextInputAction.next,
                                  errorThisFieldRequired:
                                      language.field_required_msg,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9 .]')),
                                  ],
                                  validator: (s) {
                                    if (s!.trim().isEmpty)
                                      return language.field_required_msg;
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language.per_weight_charge,
                                    style: primaryTextStyle()),
                                SizedBox(height: 8),
                                AppTextField(
                                  controller: perWeightChargeChargeController,
                                  textFieldType: TextFieldType.PHONE,
                                  decoration: commonInputDecoration(),
                                  textInputAction: TextInputAction.next,
                                  errorThisFieldRequired:
                                      language.field_required_msg,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9 .]')),
                                  ],
                                  validator: (s) {
                                    if (s!.trim().isEmpty)
                                      return language.field_required_msg;
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language.commissionType,
                                    style: primaryTextStyle()),
                                SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  dropdownColor: Theme.of(context).cardColor,
                                  value: commissionType,
                                  decoration: commonInputDecoration(),
                                  items: commissionTypeList
                                      .map<DropdownMenuItem<String>>((item) {
                                    return DropdownMenuItem(
                                        value: item,
                                        child: Text(item,
                                            style: primaryTextStyle()));
                                  }).toList(),
                                  onChanged: (value) {
                                    commissionType = value.validate();
                                    setState(() {});
                                  },
                                  validator: (value) {
                                    if (commissionType.isEmptyOrNull)
                                      return language.field_required_msg;
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language.adminCommission,
                                    style: primaryTextStyle()),
                                SizedBox(height: 8),
                                AppTextField(
                                  controller: commissionController,
                                  textFieldType: TextFieldType.NAME,
                                  decoration: commonInputDecoration(),
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9 .]')),
                                  ],
                                  errorThisFieldRequired:
                                      language.field_required_msg,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(visible: appStore.isLoading, child: loaderWidget()),
            ],
          ),
        );
      }),
      actions: <Widget>[
        dialogSecondaryButton(language.cancel, () {
          Navigator.pop(context);
        }),
        SizedBox(width: 4),
        dialogPrimaryButton(isUpdate ? language.update : language.add, () {
          if (getStringAsync(USER_TYPE) == DEMO_ADMIN) {
            toast(language.demo_admin_msg);
          } else {
            AddCityApi();
          }
        }),
      ],
    );
  }
}
