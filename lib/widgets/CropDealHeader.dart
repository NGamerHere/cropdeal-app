import 'package:cropdeal/stateNotifiers/AppConfigNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CropDealHeader extends ConsumerStatefulWidget {
  const CropDealHeader({
    super.key,
    this.onMenuTap,
    this.onNotificationTap,
    this.onProfileTap,
  });

  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  @override
  ConsumerState<CropDealHeader> createState() => _CropDealHeaderState();
}

class _CropDealHeaderState extends ConsumerState<CropDealHeader> {

  @override
  Widget build(BuildContext context) {

    final appConfig = ref.watch(appConfigProvider);

    final user = appConfig.user;
    final int notificationCount = 3;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                /// Menu
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: widget.onMenuTap,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.menu,
                      size: 32,
                    ),
                  ),
                ),

                const Spacer(),

                /// Logo
                Image.asset(
                  "assets/images/crop_deal_logo.png",
                  height: 42,
                ),

                const Spacer(),

                /// Notification
                Stack(
                  clipBehavior: Clip.none,
                  children: [

                    IconButton(
                      onPressed: widget.onNotificationTap,
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        size: 30,
                      ),
                    ),

                    if (notificationCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              notificationCount.toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 6),

                /// Profile
                InkWell(
                  onTap: widget.onProfileTap,
                  borderRadius: BorderRadius.circular(30),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,

                    backgroundImage:
                    (user?.profilePhoto != null &&
                        user!.profilePhoto!.isNotEmpty)
                        ? NetworkImage(user.profilePhoto!)
                        : null,

                    child:
                    (user?.profilePhoto == null ||
                        user!.profilePhoto!.isEmpty)
                        ? const Icon(Icons.person)
                        : null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [

                const Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: Colors.black87,
                ),

                const SizedBox(width: 5),

                Expanded(
                  child: Text(
                    user?.city ?? "Select Location",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}