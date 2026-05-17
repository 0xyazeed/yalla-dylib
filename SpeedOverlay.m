#import <UIKit/UIKit.h>

// حالة السرعة
static BOOL speedEnabled = NO;

// الزر العائم
static UIWindow *overlayWindow = nil;
static UIButton *speedButton = nil;

static void updateButtonState() {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (speedEnabled) {
            [speedButton setTitle:@"⚡ السرعة شغالة" forState:UIControlStateNormal];
            speedButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:0.9];
        } else {
            [speedButton setTitle:@"⚡ تفعيل السرعة" forState:UIControlStateNormal];
            speedButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.8 alpha:0.9];
        }
    });
}

static void toggleSpeed() {
    speedEnabled = !speedEnabled;
    updateButtonState();
}

static void showOverlay() {
    // سوي نافذة فوق كل شي
    overlayWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 200, 130, 110)];
    overlayWindow.windowLevel = UIWindowLevelAlert + 1;
    overlayWindow.backgroundColor = [UIColor clearColor];
    overlayWindow.hidden = NO;
    overlayWindow.userInteractionEnabled = YES;

    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor clearColor];
    overlayWindow.rootViewController = vc;

    // زر السرعة
    speedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    speedButton.frame = CGRectMake(5, 5, 120, 45);
    speedButton.layer.cornerRadius = 12;
    speedButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    speedButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.8 alpha:0.9];
    [speedButton setTitle:@"⚡ تفعيل السرعة" forState:UIControlStateNormal];
    [speedButton addTarget:nil action:NSSelectorFromString(@"toggleSpeedAction") forControlEvents:UIControlEventTouchUpInside];
    [speedButton addTarget:[NSBlockOperation blockOperationWithBlock:^{ toggleSpeed(); }] 
                   action:@selector(main) 
         forControlEvents:UIControlEventTouchUpInside];
    [vc.view addSubview:speedButton];

    // زر تلقرام
    UIButton *tgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tgButton.frame = CGRectMake(5, 58, 120, 45);
    tgButton.layer.cornerRadius = 12;
    tgButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    tgButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.8 alpha:0.9];
    [tgButton setTitle:@"📩 تلقرامي" forState:UIControlStateNormal];
    [tgButton addTarget:[NSBlockOperation blockOperationWithBlock:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/LJFNQ"] options:@{} completionHandler:nil];
    }] action:@selector(main) forControlEvents:UIControlEventTouchUpInside];
    [vc.view addSubview:tgButton];

    [overlayWindow makeKeyAndVisible];
}

__attribute__((constructor))
static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
            showOverlay();
        });
}
