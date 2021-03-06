import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        setupAppearance()
        Settings.registerDefaults()

        let userDefaults = NSUserDefaults.groupUserDefaults()
        if (!userDefaults.boolForKey(Constants.General.OnboardingShown.key())) {
            loadOnboardingInterface()
        } else {
            loadMainInterface()
            checkVersion()
        }

        return true
    }

    /**
    Check the app version and perform required tasks when upgrading
    */
    func checkVersion() {
        let userDefaults = NSUserDefaults.groupUserDefaults()
        let current = userDefaults.integerForKey("BUNDLE_VERSION")
        if let versionString = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String, let version = Int(versionString) {
            if current < 13 {
                NotificationHelper.rescheduleNotifications()
            }
            userDefaults.setInteger(version, forKey: "BUNDLE_VERSION")
            userDefaults.synchronize()
        }
    }

    /**
    Sets the main appearance of the app
    */
    func setupAppearance() {
        Globals.actionSheetAppearance()

        UITabBar.appearance().tintColor = .mainColor()

        let font = UIFont(name: "KaushanScript-Regular", size: 22)
        if let font = font {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        
        UINavigationBar.appearance().barTintColor = .mainColor()
        UINavigationBar.appearance().tintColor = .whiteColor()

        window?.backgroundColor = .whiteColor()
    }

    /**
    Present the onboarding controller if needed
    */
    func loadOnboardingInterface() {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let controller = storyboard.instantiateInitialViewController() {
            self.window?.rootViewController = controller
        }
    }

    /**
    Present the main interface
    */
    func loadMainInterface() {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateInitialViewController() {
            self.window?.rootViewController = controller
        }
    }

    // MARK: - Notification handler

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        if let identifier = identifier {
            NotificationHelper.handleNotification(notification, identifier: identifier)
        }
        completionHandler()
    }

    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if (UIApplication.sharedApplication().scheduledLocalNotifications?.count == 0) {
            NotificationHelper.registerNotifications()
        }
    }

    // MARK: - 3D Touch shortcut

    enum ShortcutType: String {
        case Big = "it.fancypixel.gulps.big"
        case Small = "it.fancypixel.gulps.small"
    }

    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        handleShortcutItem(shortcutItem)
        completionHandler(true)
    }

    @available(iOS 9.0, *)
    func handleShortcutItem(item: UIApplicationShortcutItem) {
        if let type = ShortcutType(rawValue: item.type) {
            if (type == .Small) {
                EntryHandler.sharedHandler.addGulp(NSUserDefaults.groupUserDefaults().doubleForKey(Constants.Gulp.Small.key()))
            } else if (type == .Big) {
                EntryHandler.sharedHandler.addGulp(NSUserDefaults.groupUserDefaults().doubleForKey(Constants.Gulp.Big.key()))
            }
        }
    }
}
