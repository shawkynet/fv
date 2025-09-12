import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../components/Admin/BodyCornerWidget.dart';
import '../../models/NotificationModel.dart';
import '../../network/RestApis.dart';
import '../../utils/Colors.dart';
import '../../utils/Common.dart';
import '../../main.dart';
import '../../utils/Extensions/common.dart';
import '../../utils/Extensions/constants.dart';
import '../../utils/Extensions/text_styles.dart';
import 'AdminOrderDetailScreen.dart';

class NotificationViewAllScreen extends StatefulWidget {
  static String route = '/admin/notifications';

  @override
  NotificationViewAllScreenState createState() => NotificationViewAllScreenState();
}

class NotificationViewAllScreenState extends State<NotificationViewAllScreen> {
  ScrollController scrollController = ScrollController();
  int currentPage = 1;

  bool mIsLastPage = false;
  List<NotificationData> notificationData = [];

  @override
  void initState() {
    super.initState();
    afterBuildCreated(init);
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!mIsLastPage) {
          appStore.setLoading(true);
          currentPage++;
          setState(() {});
          init();
        }
      }
    });
  }

  void init() async {
    appStore.setLoading(true);
    getNotification(page: currentPage).then((value) {
      appStore.setLoading(false);
      appStore.setAllUnreadCount(value.all_unread_count ?? 0);
      mIsLastPage = value.notification_data!.length < currentPage;
      if (currentPage == 1) {
        notificationData.clear();
      }
      notificationData.addAll(value.notification_data!);
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      log(error);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return BodyCornerWidget(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 60),
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(language.notification, style: boldTextStyle(size: 22, color: primaryColor)),
                    backButton(context),
                  ],
                ),
                SizedBox(height: 16),
                notificationData.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(color: appStore.isDarkMode ? scaffoldColorDark : Colors.white, borderRadius: BorderRadius.circular(defaultRadius), boxShadow: commonBoxShadow()),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: getBodyWidth(context) - 48),
                            child: DataTable(
                              headingTextStyle: boldTextStyle(size: 14),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius)),
                              dataTextStyle: primaryTextStyle(),
                              headingRowColor: MaterialStateColor.resolveWith((states) => primaryColor.withOpacity(0.1)),
                              showCheckboxColumn: false,
                              dataRowHeight: 45,
                              headingRowHeight: 45,
                              horizontalMargin: 16,
                              columns: [
                                DataColumn(label: Text(language.subject)),
                                DataColumn(label: Text(language.type)),
                                DataColumn(label: Text(language.message)),
                                DataColumn(label: Text(language.created)),
                                DataColumn(label: Text(language.actions)),
                              ],
                              rows: notificationData.map((e) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Row(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(shape: BoxShape.circle, color: e.read_at == null ? primaryColor : null),
                                            width: 10,
                                            height: 10,
                                          ),
                                          SizedBox(width: 8),
                                          Text(e.data!.subject ?? '-'),
                                        ],
                                      ),
                                    ),
                                    DataCell(Text((e.data!.type ?? '-').replaceAll('_', ' '))),
                                    DataCell(Text(e.data!.message ?? '-')),
                                    DataCell(Text(e.created_at ?? '-')),
                                    DataCell(
                                      outlineActionIcon(Icons.visibility, primaryColor, language.view, () async {
                                        var res = await Navigator.pushNamed(context, AdminOrderDetailScreen.route + "?order_Id=${e.data!.id!}");
                                        if (res != null) {
                                          currentPage = 1;
                                          init();
                                        }
                                      }),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          Observer(builder: (context) => appStore.isLoading ? loaderWidget() : SizedBox()),
        ],
      ),
    );
  }
}
