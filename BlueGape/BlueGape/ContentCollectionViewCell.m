//
//  ContentCollectionViewCell.m
//  BlueGape
//
//  Created by Gaurav Kumar Singh on 06/06/15.
//  Copyright (c) 2015 Gaurav Kumar Singh. All rights reserved.
//

#import "ContentCollectionViewCell.h"

@implementation ContentCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        
        _contentImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _contentImageView.clipsToBounds = YES;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _contentImageView.layer.cornerRadius = 5.0f;
        
        [self.contentView addSubview:_contentImageView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.contentImageView.image = nil;
}


@end
