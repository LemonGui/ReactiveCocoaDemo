//
//  EMSignInService.h
//  ReactiveCocoa Demo
//
//  Created by Lemon on 16/9/20.
//  Copyright © 2016年 Lemon. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SignInResponse)(BOOL);

@interface EMSignInService : NSObject

-(void)signWithName:(NSString *)name passWord:(NSString*)password complete:(SignInResponse)completeBlock;

@end
