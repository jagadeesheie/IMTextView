//
//  IMTextAttachment.h
//  TextImage
//
//  Created by Jagadeesh on 4/1/15.
//  Copyright (c) 2015 Innoppl Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMTextAttachment : NSTextAttachment
{
    NSString *name;
}
@property (nonatomic,strong) NSString *name;
@end
