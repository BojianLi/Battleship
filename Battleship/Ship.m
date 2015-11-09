//
//  Ship.m
//  Battleship
//
//  Created by Labuser on 11/4/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import "Ship.h"

@implementation Ship

-(instancetype) initWithSize:(int)size withNum:(int)num X:(int)x Y:(int)y image:(NSString*)image destroyedImage:(NSString*)destroyedImage{
    self = [self init];
    self.size = size;
    self.remaining = size;
    self.startX = x;
    self.startY = y;
    self.rotated = NO;
    self.num = num;
    self.image = image;
    self.destroyedImage = destroyedImage;
    self.i = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.image]];
    self.d = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.destroyedImage]];
    return self;
}
@end
