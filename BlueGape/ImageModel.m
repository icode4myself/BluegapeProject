//
//  ImageModel.m
//  BlueGape
//
//  Created by Gaurav Kumar Singh on 06/06/15.
//  Copyright (c) 2015 Gaurav Kumar Singh. All rights reserved.
//

#import "ImageModel.h"
#import "AppDelegate.h"

@implementation ImageModel

- (id)init
{
    self = [super init];
    if (self) {
        _title = @"";
        _details = @"";
    }

    return self;
}

@end
