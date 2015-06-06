//
//  ImageModel.h
//  BlueGape
//
//  Created by Gaurav Kumar Singh on 06/06/15.
//  Copyright (c) 2015 Gaurav Kumar Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ImageModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *details;

@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, assign) CGSize thumbnailSize;

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, assign) CGSize imageSize;

@end
