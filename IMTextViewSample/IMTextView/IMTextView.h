//
//  IMTextView.h
//  TextImageView
//
//  Created by Jagadeesh on 4/1/15.
//  Copyright (c) 2015 Jagadeesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMTextAttachment.h"
@interface IMTextView : UITextView

@property (nonatomic,readonly) NSString *textContent;
@property (nonatomic,strong) NSString *leftDelimiter;
@property (nonatomic,strong) NSString *rightDelimiter;

- (void)insertICON:(NSString *)imageName;

@end


@interface UIImage (Resizable)

-(id)resizeTo:(CGSize)size;
@end




