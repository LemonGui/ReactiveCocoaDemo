//
//  LoginViewController.m
//  ReactiveCocoa Demo
//
//  Created by Lemon on 16/9/20.
//  Copyright © 2016年 Lemon. All rights reserved.
//

#import "LoginViewController.h"
#import <ReactiveCocoa.h>
#import "EMSignInService.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameview;
@property (weak, nonatomic) IBOutlet UITextField *passWordView;
@property (weak, nonatomic) IBOutlet UIButton *loginView;
@property (weak, nonatomic) IBOutlet UILabel *loginFailedView;
@property (nonatomic,strong)  EMSignInService * singnInService;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.singnInService = [EMSignInService new];
    self.loginFailedView.hidden = YES;
    [self signal];
}

-(void)signal{
    RACSignal * validUserNameSignal = [self.userNameview.rac_textSignal  map:^id(NSString * name) {
        return @(name.length>3);
    }];
    RACSignal * validPassWordSignal = [self.passWordView.rac_textSignal  map:^id(NSString * passWord) {
        return @(passWord.length>3);
    }];
    
    RAC(self.userNameview,backgroundColor) = [validUserNameSignal map:^id(NSNumber *nameValid) {
        return [nameValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    RAC(self.passWordView,backgroundColor) = [validPassWordSignal map:^id(NSNumber *passWordValid) {
        return [passWordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    [[RACSignal combineLatest:@[validPassWordSignal,validUserNameSignal]
                       reduce:^id(NSNumber *nameValid , NSNumber * passWordValid){
        return @([nameValid boolValue]&&[passWordValid boolValue]);
    }]
     subscribeNext:^(NSNumber * signUpActive) {
        self.loginView.enabled = [signUpActive boolValue];
    }];

    [[[[self.loginView rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
        self.loginView.enabled = NO;
        self.loginFailedView.hidden = YES;
        // map 映射出的值是 信号本身
        // flattenMap 映射出的值是 信号的值
    }] flattenMap:^RACStream *(id value) {//inner signal convert to outer signal
        return [self signInSignal];     //内部信号向外部信号发送正确的结果
    }] subscribeNext:^(NSNumber * signInSignal) {  //这里flattenMap映射内信号登录是否成功的值，所以是NSNumber * signInSignal，用map则是信号
        self.loginFailedView.hidden = [signInSignal boolValue];
        if ([signInSignal boolValue]) {
            [self performSegueWithIdentifier:@"login" sender:self];
        }
    }];
    
}

//inner signal
-(RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.singnInService signWithName:self.userNameview.text passWord:self.passWordView.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}
@end
