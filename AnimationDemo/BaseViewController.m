//
//  BaseViewController.m
//  AnimationDemo
//
//  Created by Yangyue on 15/6/1.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "BaseViewController.h"
typedef  void(^completionBlock)(void);
 void delay (double seconds  ,void (^completionBlock)()){
    dispatch_time_t  popTime =  dispatch_time(DISPATCH_TIME_NOW, (int64_t)( NSEC_PER_SEC  *seconds));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        completionBlock();
    });
}

void tintBackgroundColor(CALayer * layer, UIColor *toColor){
    CABasicAnimation *tint = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    tint.fromValue = (__bridge id)(layer.backgroundColor);
    tint.toValue = (__bridge id)(toColor.CGColor);
    tint.duration = 1.0;
    [layer addAnimation:tint forKey:nil];
    [layer setBackgroundColor:toColor.CGColor];
}

void roundCorner(CALayer *layer, CGFloat toRadius){
    CABasicAnimation *round = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    [round setFromValue: [NSNumber numberWithDouble:layer.cornerRadius]]  ;
    [round setToValue: [NSNumber numberWithDouble: toRadius]];
    [round setDuration:0.33];
    [layer addAnimation:round forKey:nil];
    layer.cornerRadius = toRadius;

}

@interface BaseViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UIImageView *status;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic ) CGPoint  statusPosition;
@property (nonatomic, strong) UILabel *info;
@property (weak, nonatomic) IBOutlet UIImageView *cloud1;
@property (weak, nonatomic) IBOutlet UIImageView *cloud2;
@property (weak, nonatomic) IBOutlet UIImageView *cloud3;
@property (weak, nonatomic) IBOutlet UIImageView *cloud4;
@property (weak, nonatomic) IBOutlet UILabel *heading;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation BaseViewController

- (UIActivityIndicatorView *)spinner{
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _spinner.frame = CGRectMake(-20.0, 6.0, 20.0, 20.0);
        
    }
    return _spinner;
}
- (UIImageView *)status{
    if (!_status) {
        _status =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banner"]];
    }
    return _status;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self beginAnimation];
    [self showTitleAndDetail];
    [self customGroupAnimation];
    [self beginPutView];
}
- (void)beginPutView{
    [self.loginButton.layer setCornerRadius:8.0];
    [self.loginButton.layer setMasksToBounds:YES];
    
    [self.spinner startAnimating];
    [self.spinner setAlpha:0.0];
    [self.loginButton addSubview:self.spinner];
    
    self.status.hidden = YES;
    self.status.center = self.loginButton.center;
    [self.view addSubview:self.status];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0,CGRectGetWidth( self.status.frame), CGRectGetHeight(self.status.frame))];
    self.label.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    self.label.textColor = [UIColor colorWithRed:0.89 green:0.38 blue:0.0 alpha:1.0];
    [self.label setTextAlignment:NSTextAlignmentCenter];
    [self.status addSubview:self.label];
    
    self.info =[[UILabel alloc]initWithFrame:CGRectMake(0.0,self.loginButton.center.y + 60
                                                        , CGRectGetWidth( self.view.frame), 30)];
    [self.info setBackgroundColor:[UIColor clearColor]];
    [self.info setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.info setTextAlignment:NSTextAlignmentCenter];
    [self.info setTextColor:[UIColor whiteColor]];
    [self.info setText:@"Tap on a field and enter username and password"];
    [self.view insertSubview:self.info belowSubview:self.loginButton];
    
    self.messages = @[@"Connecting ...", @"Authorizing ...", @"Sending credentials ...", @"Failed"];
    
    self. statusPosition =self. status.center;


}
-(void)beginAnimation{
    /*当你创建一个 CABasicAnimation 时,你需要通过-setFromValue 和-setToValue 来指定一个开始值和结束值。 
     当你增加基础动画到层中的时候,它开始运行。
     当用属性做动画完成时,例如用位置属性做动画,层就会立刻 返回到它的初始位置 */
    
    /*这句话声明了一个 CABasicAnimation，注意到里面填写的参数没，填的是 opacity，就是透明度的意思，这里头还能填写很多其他值，比如position，*/

    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    [fadeIn setFromValue:[NSNumber numberWithFloat:0.0]];/*对动画的初始值进行设定，也就是透明度最开始为0.*/
    [fadeIn setToValue: [NSNumber numberWithFloat:1.0]];/*对动画的最终值进行设定，也就是透明度为1。*/
    [fadeIn setDuration:0.5];/*动画持续时间，我们设定为0.5秒。和前面三句合起来，就表达了这么一个意思：这个动画是对对象的透明度进行改变，在0.5秒内，透明度从0变化为1.*/
    
    /*kCAFillModeRemoved 这个是默认值,也就是说当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢复到之前的状态
     kCAFillModeForwards 当动画结束后,layer会一直保持着动画最后的状态
     kCAFillModeBackwards 这个和kCAFillModeForwards是相对的,就是在动画开始前,你只要将动画加入了一个layer,layer便立即进入动画的初始状态并等待动画开始.你可以这样设定测试代码,将一个动画加入一个layer的时候延迟5秒执行.然后就会发现在动画没有开始的时候,只要动画被加入了layer,layer便处于动画初始状态
     kCAFillModeBoth 理解了上面两个,这个就很好理解了,这个其实就是上面两个的合成.动画加入后开始之前,layer便处于动画初始状态,动画结束后layer保持动画最后的状态.*/
    
    /*kCAFillModeBackwards的意思是显示动画的初始状态，同时还有其他两个值kCAFillModeForwards可以显示对象动画之后的效果，kCAFillModeBoth则是兼顾以上两个效果。*/
    [fadeIn setFillMode:kCAFillModeBackwards];
    
    
    [fadeIn setBeginTime:CACurrentMediaTime() + 0.5];
    [_cloud1.layer addAnimation:fadeIn forKey:nil];
    [fadeIn setBeginTime:CACurrentMediaTime() + 0.7];
    [_cloud2.layer addAnimation:fadeIn forKey:nil];
    [fadeIn setBeginTime:CACurrentMediaTime() + 0.9];
    [_cloud3.layer addAnimation:fadeIn forKey:nil];
    [fadeIn setBeginTime:CACurrentMediaTime() +1.1];
    [_cloud4.layer addAnimation:fadeIn forKey:nil];
    
}

- (void)showTitleAndDetail{
    CABasicAnimation *flyRight = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [flyRight setToValue:[NSNumber numberWithFloat:self.view.bounds.size.width / 2]];
    [flyRight setFromValue:[NSNumber numberWithFloat: - self.view.bounds.size.width /2]];
    flyRight.duration = 0.5;
    [self.heading.layer addAnimation:flyRight forKey:nil];
    
    [flyRight setBeginTime:CACurrentMediaTime() + 0.3];
    [flyRight setFillMode:kCAFillModeBackwards];
    [self.username.layer addAnimation:flyRight forKey:nil];
    
    [flyRight setBeginTime:CACurrentMediaTime() + 0.4];
    [flyRight setFillMode:kCAFillModeBackwards];
    [self.password.layer addAnimation:flyRight forKey:nil];
 

}
- (void)customGroupAnimation{
    /*注意动画时间并不是一个结束后执行另一个！*/
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    [groupAnimation setBeginTime:CACurrentMediaTime()  + 0.5];
    [groupAnimation setDuration:0.5];
    [groupAnimation setFillMode:kCAFillModeBackwards];
    /*kCAMediaTimingFunctionLinear：
     默认的就是这个值，这个值就是速度保持一定。*/
    [groupAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    CABasicAnimation *scaleDown = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scaleDown setFromValue:[NSNumber numberWithFloat:3.5]];
    [scaleDown setToValue:[NSNumber numberWithFloat:1.0]];
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [rotate setFromValue:[NSNumber numberWithFloat:M_PI_4]];
    [rotate setToValue:[NSNumber numberWithFloat:0.0]];
    
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fade setFromValue:[NSNumber numberWithFloat:0.0]];
    [fade setToValue:[NSNumber numberWithFloat:1.0]];
    
    groupAnimation.animations = @[scaleDown,rotate,fade];
    [self.loginButton.layer addAnimation:groupAnimation forKey:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
- (void)showMessage :(int)index{
    self.label.text = self.messages[index];
   [ UIView transitionWithView:self.status duration:0.33 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.status.hidden = NO;
    } completion:^(BOOL finished) {
        delay(2.0,^{
            if (index < self.messages.count - 1) {
                [self removeMessage : index];
            }else{
                [self resetForm];
            }
        });
    }];

}
- (void)resetForm{
    CAKeyframeAnimation *wobble = [CAKeyframeAnimation animationWithKeyPath:@"transform.totation"];
    wobble.duration = 0.25;
    wobble.repeatCount = 4;
    wobble.values = @[ @0.0, @0.25, @0.5, @0.75 , @1.0];
    [self.heading.layer addAnimation:wobble forKey:nil];
}
- (void)removeMessage:(int )index{
    self.label.text = self.messages[index];
    [UIView transitionWithView:self.status duration:0.33 options:UIViewAnimationOptionCurveEaseOut |  UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [self.status setCenter:CGPointMake(self.status.center.x + CGRectGetWidth(self.view.frame), self.status.center.y)];
    } completion:^(BOOL finished) {
        self.status .hidden = YES;
        self.status.center = self.statusPosition;
        [self showMessage:index +1];
    }];
}
- (IBAction)login:(id)sender {
    /*一共七个参数：
     duration
     表示动画执行时间。
     delay
     动画延迟时间。
     usingSpringWithDamping
     表示弹性属性。
     initialSpringVelocity
     初速度。
     options
     可选项，一些可选的动画效果，包括重复等。
     animations
     表示执行的动画内容，包括透明度的渐变，移动，缩放。
     completion
     表示执行完动画后执行的内容。*/
    
//    [UIView animateWithDuration:0.5
//                          delay:0.5
//         usingSpringWithDamping:0.5
//          initialSpringVelocity:0.0
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         [self.loginButton setCenter:CGPointMake(self.loginButton.center.x  , -30.0)];
//         self.loginButton.alpha = 1.0;
//    } completion:nil];
    
    [UIView animateWithDuration:1.5 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.loginButton setBounds:CGRectMake(0, 0, CGRectGetWidth(self.loginButton.bounds)+80.0, CGRectGetHeight(self.loginButton.bounds))];
    } completion:
     ^(BOOL finished) {     }];
    
    [UIView animateWithDuration:0.33 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.loginButton setCenter:CGPointMake(self.loginButton.center.x, self.loginButton.center.y + 60.0)];
        [self.spinner setCenter:CGPointMake(40, self.loginButton.frame.size.height/2)];
        self.spinner.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self showMessage:0];
    }];
    
    UIColor *tintColor = [UIColor colorWithRed:0.85 green:0.83 blue:0.45 alpha:1.0];
    tintBackgroundColor(self.loginButton.layer, tintColor);
    roundCorner(self.loginButton.layer, 25.0);
    
    CALayer *balloon  = [CALayer layer ];
    balloon.contents = (__bridge id)([UIImage imageNamed:@"balloon"].CGImage);
    balloon.frame = CGRectMake(-50.0, 0.0, 50.0, 65.0);
    [self.view.layer insertSublayer:balloon above:self.username.layer];
    
    CAKeyframeAnimation *flight = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    flight.duration = 12.0;
    
    flight.values = @[
                     [NSValue valueWithCGPoint:CGPointMake(-50.0, 0.0)] ,
                      [NSValue valueWithCGPoint: CGPointMake(self.view.frame.size.width + 50.0, 160)],
                      [NSValue valueWithCGPoint: CGPointMake(-50.0, self.loginButton.center.y)]
                       ];
    [flight setKeyTimes:@[@0.0, @0.5, @1.0]];
    
    [balloon addAnimation:flight forKey:nil];
    [balloon setPosition:CGPointMake(-50.0, self.loginButton.center.y
                                     )];
    
}

@end
