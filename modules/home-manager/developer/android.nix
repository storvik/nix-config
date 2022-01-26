{ config, pkgs, lib, ... }:

with lib;

let

  android = pkgs.androidenv.composeAndroidPackages { };

  tasker-permissions = [
    "DUMP" # check current running services (Context - Application)
    "SET_MEDIA_KEY_LISTENER" # media key press handling (Context - State - Media Button)
    "READ_LOGS" # logacat entries (Context - Event - LogCat Entry)
    "SET_VOLUME_KEY_LONG_PRESS_LISTENER" # colume key long press handling (Context - Event - Hardware - Volume Long Press)
    "WRITE_SECURE_SETTINGS" # write secure settings (Action - Settings - Custom Setting)
    "CHANGE_CONFIGURATION" # change system locale
    "SYSTEM_ALERT_WINDOW" # draw on other apps
    "PACKAGE_USAGE_STATS" # react to app changes and get app info / stats
    "ANSWER_PHONE_CALLS" # answer phone calls
    "CALL_PHONE" # make phone calls
  ];

  storvik-grant-android-permissions = android-package: permissions: (
    strings.concatMapStrings (x: "adb shell pm grant " + android-package + " android.permission." + x + "\n") permissions
  );

  storvik-grant-tasker = pkgs.writeScriptBin "storvik-grant-tasker" ''
    #!${pkgs.bash}/bin/bash

    ${storvik-grant-android-permissions "net.dinglisch.android.taskerm"  tasker-permissions}

    # restart Tasker
    adb shell am force-stop net.dinglisch.android.taskerm


    # enable adb wifi
    adb tcpip 5555
  '';

in

{

  config = mkIf (config.storvik.developer.android.enable || config.storvik.developer.enable)
    {
      home.packages = with pkgs; [
        android.platform-tools
        apktool
        scrcpy
        storvik-grant-tasker
      ];
    };

}
