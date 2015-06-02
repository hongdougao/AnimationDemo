//
//  ViewController.m
//  AnimationDemo
//
//  Created by Yangyue on 15/6/1.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *cloud1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)beginAnimation{

    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeIn setFromValue:[NSNumber numberWithFloat:0.0]];
    [fadeIn setToValue: [NSNumber numberWithFloat:1.0]];
    [fadeIn setDuration:0.5];
 
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
}

@end
