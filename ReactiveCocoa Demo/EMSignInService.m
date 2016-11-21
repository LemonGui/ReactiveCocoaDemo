//
//  EMSignInService.m
//  ReactiveCocoa Demo
//
//  Created by Lemon on 16/9/20.
//  Copyright © 2016年 Lemon. All rights reserved.
//

#import "EMSignInService.h"

@implementation EMSignInService
-(void)signWithName:(NSString *)name passWord:(NSString*)password complete:(SignInResponse)completeBlock{
    
    double delaySeconds = 2.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySeconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        BOOL success = [name isEqualToString:@"user"] && [password isEqualToString:@"123456"];
        completeBlock(success);
    });
    
}
@end
