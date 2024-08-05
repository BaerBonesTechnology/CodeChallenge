import 'package:flutter/material.dart';

Key addGuestButtonKey = const Key('Add Guest Button');
Key backButtonKey = const Key('Back Button');
Key confirmGuestButton = const Key('Confirm Guest Reservation');
Key createGroupButtonKey = const Key('Create Group Button');
Key createGroupRouteButtonKey = const Key('Create Group Screen Button');
Key createGuestButtonKey = const Key('Create a guest');
Key emptyScreenLabelKey = const Key('Empty Screen View');
Key guestGroupItemKey(String groupName) => Key('Guest Group: $groupName');
Key guestItemKey(String groupName) => Key('Guest Group: $groupName');
Key homeHeadingKey = const Key('Home Header');
Key reserveGuestCheckboxKey = const Key('Guest Reserved Checkbox');
Key temporaryGuestItemKey(String guestName) => Key('Guest: $guestName');
