#import <UIKit/UIKit.h>

// حالة السرعة
static BOOL speedEnabled = NO;
static BOOL menuOpen = NO;
static UIWindow *overlayWindow = nil;
static UIButton *flyButton = nil;
static UIButton *speedButton = nil;
static UIButton *tgButton = nil;

// تفعيل السرعة فعلياً
static void applySpeed() {
    // تسريع كل الانميشن بالتطبيق
    [UIApplication sharedApplication].windows.firstObject.layer.speed = speedEnabled ? 2.0 : 1.0;
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            for (UIWindow *w in ((UIWindowScene *)scene).windows) {
                w.layer.speed = speedEnabled ? 2.0 : 1.0;
            }
        }
    }
}

static void toggleMenu() {
    menuOpen = !menuOpen;
    [UIView animateWithDuration:0.3 animations:^{
        speedButton.alpha = menuOpen ? 1.0 : 0.0;
        tgButton.alpha = menuOpen ? 1.0 : 0.0;
        speedButton.hidden = !menuOpen;
        tgButton.hidden = !menuOpen;
    }];
}

static void hideMenu() {
    menuOpen = NO;
    speedButton.hidden = YES;
    tgButton.hidden = YES;
}

static void showOverlay() {
    overlayWindow = [[UIWindow alloc] initWithFrame:CGRectMake(10, 200, 160, 160)];
    overlayWindow.windowLevel = UIWindowLevelAlert + 1;
    overlayWindow.backgroundColor = [UIColor clearColor];
    overlayWindow.hidden = NO;
    overlayWindow.userInteractionEnabled = YES;

    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor clearColor];
    overlayWindow.rootViewController = vc;

    // زر ⌗ Fly الصغير
    flyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    flyButton.frame = CGRectMake(0, 0, 80, 35);
    flyButton.layer.cornerRadius = 10;
    flyButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.9];
    flyButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [flyButton setTitle:@"⌗ Fly .." forState:UIControlStateNormal];
    [flyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [flyButton addTarget:[NSBlockOperation blockOperationWithBlock:^{
        toggleMenu();
    }] action:@selector(main) forControlEvents:UIControlEventTouchUpInside];
    [vc.view addSubview:flyButton];

    // زر السرعة
    speedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    speedButton.frame = CGRectMake(0, 45, 150, 45);
    speedButton.layer.cornerRadius = 12;
    speedButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    speedButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.8 alpha:0.9];
    [speedButton setTitle:@"⚡ تفعيل السرعة" forState:UIControlStateNormal];
    [speedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    speedButton.hidden = YES;
    speedButton.alpha = 0;
    [speedButton addTarget:[NSBlockOperation blockOperationWithBlock:^{
        speedEnabled = !speedEnabled;
        applySpeed();
        if (speedEnabled) {
            [speedButton setTitle:@"تراك تعدي بسرعة 🚀" forState:UIControlStateNormal];
            speedButton.backgroundColor = [UIColor blackColor];
        } else {
            [speedButton setTitle:@"⚡ تفعيل السرعة" forState:UIControlStateNormal];
            speedButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.8 alpha:0.9];
        }
    }] action:@selector(main) forControlEvents:UIControlEventTouchUpInside];
    [vc.view addSubview:speedButton];

    // زر تلقرام
    tgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tgButton.frame = CGRectMake(0, 100, 150, 45);
    tgButton.layer.cornerRadius = 12;
    tgButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    tgButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.8 alpha:0.9];
    [tgButton setTitle:@"📩 التواصل مع المبرمج" forState:UIControlStateNormal];
    [tgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tgButton.hidden = YES;
    tgButton.alpha = 0;
    [tgButton addTarget:[NSBlockOperation blockOperationWithBlock:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/LJFNQ"] options:@{} completionHandler:nil];
    }] action:@selector(main) forControlEvents:UIControlEventTouchUpInside];
    [vc.view addSubview:tgButton];

    [overlayWindow makeKeyAndVisible];

    // مراقبة دخول الروم
    [[NSNotificationCenter defaultCenter] addObserverForName:@"RoomDidEnterNotification"
        object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            hideMenu();
        }];
}

__attribute__((constructor))
static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
            showOverlay();
        });
}
