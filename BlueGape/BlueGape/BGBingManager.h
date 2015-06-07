//
//  BGBingManager.h
//  BlueGape
//
//  Created by Gaurav Kumar Singh on 06/06/15.
//  Copyright (c) 2015 Gaurav Kumar Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

typedef void (^ISSuccessBlock)(NSURLSessionDataTask *, NSArray *);
typedef void (^ISFailureBlock)(NSURLSessionDataTask *, NSError *);


@interface BGBingManager : AFHTTPSessionManager

+ (BGBingManager *)sharedClient;
+ (NSString *)title;

- (void)findImagesForQuery:(NSString *)query withOffset:(int)offset success:(ISSuccessBlock)success failure:(ISFailureBlock)failure;


@end
