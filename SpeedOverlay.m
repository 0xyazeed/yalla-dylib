#import <UIKit/UIKit.h>

static BOOL speedEnabled = NO;
static BOOL menuOpen = NO;
static UIButton *flyButton = nil;
static UIButton *speedButton = nil;
static UIButton *tgButton = nil;
static UIView *menuView = nil;

static void applySpeed() {
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
        menuView.alpha = menuOpen ? 1.0 : 0.0;
    }];
}

static void hideMenu() {
    menuOpen = NO;
    [UIView animateWithDuration:0.3 animations:^{
        menuView.alpha = 0.0;
    }];
}

static void setupOverlay(UIWindow *keyWindow) {
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(10, 200, 170, 175)];
    container.backgroundColor = [UIColor clearColor];
    container.userInteractionEnabled = YES;
    [keyWindow addSubview:container];

    // زر ⌗ 10th battalión الأزرق
    flyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    flyButton.frame = CGRectMake(0, 0, 150, 35);
    flyButton.layer.cornerRadius = 10;
    flyButton.layer.masksToBounds = YES;
    flyButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.85 alpha:0.95];
    flyButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [flyButton setTitle:@"⌗ 10th battalión" forState:UIControlStateNormal];
    [flyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [flyButton addTarget:[NSBlockOperation blockOperationWithBlock:^{
        toggleMenu();
    }] action:@selector(main) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:flyButton];

    // القائمة
    menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 165, 125)];
    menuView.backgroundColor = [UIColor clearColor];
    menuView.alpha = 0;
    menuView.userInteractionEnabled = YES;
    [container addSubview:menuView];

    // زر السرعة
    speedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    speedButton.frame = CGRectMake(0, 0, 165, 55);
    speedButton.layer.cornerRadius = 12;
    speedButton.layer.masksToBounds = YES;
    speedButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    speedButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.85 alpha:0.95];
    [speedButton setTitle:@"⚡ تفعيل السرعة" forState:UIControlStateNormal];
    [speedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [speedButton addTarget:[NSBlockOperation blockOperationWithBlock:^{
        speedEnabled = !speedEnabled;
        applySpeed();
        if (speedEnabled) {
            [speedButton setTitle:@"✅ تم تفعيل السبيد" forState:UIControlStateNormal];
            speedButton.backgroundColor = [UIColor blackColor];
        } else {
            [speedButton setTitle:@"⚡ تفعيل السرعة" forState:UIControlStateNormal];
            speedButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.85 alpha:0.95];
        }
    }] action:@selector(main) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:speedButton];

    // زر تلقرام
    tgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tgButton.frame = CGRectMake(0, 63, 165, 55);
    tgButton.layer.cornerRadius = 12;
    tgButton.layer.masksToBounds = YES;
    tgButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    tgButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.48 blue:0.75 alpha:0.95];
    [tgButton setTitle:@"📩 التواصل مع المبرمج" forState:UIControlStateNormal];
    [tgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tgButton addTarget:[NSBlockOperation blockOperationWithBlock:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/LJFNQ"]
                                           options:@{}
                                 completionHandler:nil];
    }] action:@selector(main) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:tgButton];

    // مراقبة دخول الروم
    [[NSNotificationCenter defaultCenter] addObserverForName:@"RoomDidEnterNotification"
        object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            hideMenu();
        }];
}

__attribute__((constructor))
static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
            UIWindow *keyWindow = nil;
            for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    for (UIWindow *w in ((UIWindowScene *)scene).windows) {
                        if (w.isKeyWindow) { keyWindow = w; break; }
                    }
                }
            }
            if (keyWindow) setupOverlay(keyWindow);
        });
}
