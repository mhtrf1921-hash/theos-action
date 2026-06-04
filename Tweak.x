#import <UIKit/UIKit.h>

@interface R8RJSplashViewController : UIViewController
@end

@implementation R8RJSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. إعداد الخلفية المتدرجة (بنفسجي متدرج فخم)
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = @[
        (id)[UIColor colorWithRed:0.38 green:0.18 blue:0.62 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.12 green:0.04 blue:0.22 alpha:1.0].CGColor
    ];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    // 2. إضافة الشعار الدائري (لوجو آبل أو شعارك الخاص)
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    logoView.center = CGPointMake(self.view.bounds.size.width / 2, 190);
    logoView.layer.cornerRadius = 65;
    logoView.clipsToBounds = YES;
    logoView.layer.borderWidth = 2.0;
    logoView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    
    // يحاول النظام أولاً قراءة صورة اسمها logo.png إذا أضفتها للتطبيق، أو يضع صورة افتراضية
    if ([UIImage imageNamed:@"logo.png"]) {
        logoView.image = [UIImage imageNamed:@"logo.png"];
    } else {
        logoView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://apple.com/favicon.ico"]]];
    }
    [self.view addSubview:logoView];
    
    // 3. النص الرئيسي (العنوان)
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 280, self.view.bounds.size.width - 40, 40)];
    titleLabel.text = @" IPA DEV R8RJ ";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:25];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:titleLabel];
    
    // العنوان الفرعي
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 320, self.view.bounds.size.width - 40, 30)];
    subTitleLabel.text = @"القناة الرسمية للتطبيقات @R8RIJ";
    subTitleLabel.textColor = [UIColor colorWithRed:0.85 green:0.80 blue:0.95 alpha:1.0];
    subTitleLabel.font = [UIFont systemFontOfSize:16];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:subTitleLabel];
    
    // 4. مصفوفة الأزرار والروابط
    NSArray *buttonTitles = @[@"القناة Channel", @"الجروب Group", @"المطور R8RJ", @"دخول ~ Entry"];
    CGFloat startY = 390;
    
    for (int i = 0; i < buttonTitles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(45, startY + (i * 65), self.view.bounds.size.width - 90, 52);
        [btn setTitle:buttonTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        btn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.14];
        btn.layer.cornerRadius = 14;
        btn.layer.borderWidth = 1.0;
        btn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.1].CGColor;
        btn.tag = i;
        
        [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

// 5. التحكم بضغطات الأزرار والروابط وتوجيهها لحساباتك
- (void)buttonTapped:(UIButton *)sender {
    NSURL *url = nil;
    if (sender.tag == 0) {
        url = [NSURL URLWithString:@"https://t.me/R8RIJ"]; 
    } else if (sender.tag == 1) {
        url = [NSURL URLWithString:@"https://t.me/R8RIJ"]; // يمكنك تعديل رابط الجروب هنا لاحقاً
    } else if (sender.tag == 2) {
        url = [NSURL URLWithString:@"https://instagram.com/r8rj"]; 
    } else if (sender.tag == 3) {
        // زر الدخول لإغلاق شاشة الترحيب والدخول للتطبيق المحقون
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

// منع تدوير الشاشة للحفاظ على أبعاد التصميم ثابتة
- (BOOL)shouldAutorotate {
    return NO;
    }
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end

// 6. خطوة الحقن التلقائي (Hooking) لتظهر الشاشة عند فتح التطبيق مباشرة
%hook UIApplication

- (void)setDelegate:(id)delegate {
    %orig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIWindow *keyWindow = nil;
            if (@available(iOS 13.0, *)) {
                for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                    if (scene.activationState == UISceneActivationStateForegroundActive) {
                        for (UIWindow *window in scene.windows) {
                            if (window.isKeyWindow) {
                                keyWindow = window;
                                break;
                            }
                        }
                    }
                }
            }
            if (!keyWindow) {
                keyWindow = [UIApplication sharedApplication].keyWindow;
            }
            
            if (keyWindow && keyWindow.rootViewController) {
                R8RJSplashViewController *splashVC = [[R8RJSplashViewController alloc] init];
                splashVC.modalPresentationStyle = UIModalPresentationFullScreen;
                splashVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [keyWindow.rootViewController presentViewController:splashVC animated:YES completion:nil];
            }
        });
    });
}

%end
