//
//  BGBingManager.m
//  BlueGape
//
//  Created by Gaurav Kumar Singh on 06/06/15.
//  Copyright (c) 2015 Gaurav Kumar Singh. All rights reserved.
//

#import "BGBingManager.h"

#import "ImageModel.h"

// https://api.datamarket.azure.com/Bing/Search/v1/Composite?Sources=%27image%27&Query=%27kevin%20durant%27
static NSString * const kBGBingAPIBaseURLString = @"https://api.datamarket.azure.com/Bing/Search/v1/";

static NSString * const kBGBingAPIPrimaryAccountKey = @"/ejDupeWazY5xpSuGa//OCc9Dssea01UCw9Ld+yRHSo";

@implementation BGBingManager

+ (NSString *)title
{
    return @"Bing Images";
}

+ (BGBingManager *)sharedClient
{
    static BGBingManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[BGBingManager alloc] initWithBaseURL:[NSURL URLWithString:kBGBingAPIBaseURLString]];
    });

    return _sharedClient;
}

- (BGBingManager *)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        // Set the authentication header
        [self.requestSerializer setAuthorizationHeaderFieldWithUsername:@""
                                                               password:kBGBingAPIPrimaryAccountKey];
    }
    return self;
}


- (void)findImagesForQuery:(NSString *)query withOffset:(int)offset success:(ISSuccessBlock)success failure:(ISFailureBlock)failure
{
    NSDictionary *parameterDict = @{ @"Query": [NSString stringWithFormat:@"'%@'", query],
                                     @"$format": @"JSON",
                                     @"$skip": [@(offset) stringValue] };
    
    [[BGBingManager sharedClient] GET:@"Image" parameters:parameterDict
        success:^(NSURLSessionDataTask *operation, id responseObject) {
            NSArray *jsonObjects = [responseObject valueForKeyPath:@"d.results"];
            NSLog(@"Found %lu objects...", (unsigned long)[jsonObjects count]);
            
            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:jsonObjects.count];
            for (NSDictionary *jsonDict in jsonObjects) {
                ImageModel *imageRecord = [[ImageModel alloc] init];
                
                imageRecord.title = [jsonDict valueForKeyPath:@"Title"];
                if ((NSNull *)imageRecord.title == [NSNull null]) {
                    imageRecord.title = @"";
                }
                
                imageRecord.details = [jsonDict valueForKey:@"DisplayUrl"];
                if ((NSNull *)imageRecord.details == [NSNull null]) {
                    imageRecord.details = @"";
                }
                
                imageRecord.thumbnailURL = [NSURL URLWithString:[jsonDict valueForKeyPath:@"Thumbnail.MediaUrl"]];
                imageRecord.thumbnailSize = CGSizeMake([[jsonDict valueForKeyPath:@"Thumbnail.Width"] floatValue],
                                                       [[jsonDict valueForKeyPath:@"Thumbnail.Height"] floatValue]);
                imageRecord.imageURL = [NSURL URLWithString:[jsonDict valueForKeyPath:@"MediaUrl"]];
                imageRecord.imageSize = CGSizeMake([[jsonDict valueForKeyPath:@"Width"] floatValue],
                                                   [[jsonDict valueForKeyPath:@"Height"] floatValue]);
                
                [imageArray addObject:imageRecord];
            }
            
            success(operation, imageArray);
        }
        failure:^(NSURLSessionDataTask *operation, NSError *error) {
            failure(operation, error);
        }];
}

@end
