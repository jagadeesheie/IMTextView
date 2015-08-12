//
//  IMTextView.m
//  TextImageView
//
//  Created by Jagadeesh on 4/1/15.
//  Copyright (c) 2015 Jagadeesh. All rights reserved.
//



#import "IMTextView.h"
#define PATTERN_STR         @"\\[[^\\[\\]]*\\]"

@implementation IMTextView

@synthesize textContent;
NSMutableArray *imArray;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

NSMutableAttributedString *pasteString;
UIFont *font;
-(id) init {
   
    self = [super init];
    if(self)
    {
        imArray = [[NSMutableArray alloc] init];
    }
    [self settingDelimiters];
    

    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        imArray = [[NSMutableArray alloc] init];
    }
    [self settingDelimiters];
    

    
    return self;
}



-(void)settingDelimiters{
    self.leftDelimiter = @"[";
    self.rightDelimiter = @"]";
}
- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender
{
    BOOL result = NO;
    if(@selector(copy:) == action) {
        
        result = YES;
    }
    else if(@selector(paste:) == action && [[UIPasteboard generalPasteboard] numberOfItems] > 0 ) {
        result = YES;
    }
    return result;
}


- (void)insertICON:(NSString *)iconName
{
    
    NSMutableAttributedString *attr= [[NSMutableAttributedString alloc ]
                                      initWithAttributedString:self.attributedText];
   
    font = [self font];
    
    IMTextAttachment *att = [[IMTextAttachment alloc] init];
    
    att.image = [UIImage imageNamed:iconName];
    att.image = [att.image resizeTo:CGSizeMake(14, 14)];
    att.name = iconName;
    [attr insertAttributedString:[NSAttributedString attributedStringWithAttachment:att]
                         atIndex:self.selectedRange.location ];
    
    self.attributedText = attr;
    self.font = font;

    
}


-(void) setText:(NSString *)text {
    
    self.attributedText= [[NSAttributedString alloc] initWithString:@""];
    
    
    pasteString = [[NSMutableAttributedString alloc] initWithString:text];
    [self pasteContent];
}


-(NSString*)textContent {
    
    
    NSMutableString *str =[[NSMutableString alloc] initWithString:self.text];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    
    
    [textStorage enumerateAttribute:NSAttachmentAttributeName
                            inRange:NSMakeRange(0, textStorage.length)
                            options:0
                         usingBlock:^(id value, NSRange range, BOOL *stop)
     {
         IMTextAttachment* attachment = (IMTextAttachment*)value;
         
         if(attachment.image&&[attachment respondsToSelector:@selector(name)]){
             
             
             [imArray addObject:@{@"position":[NSNumber numberWithLong:range.location],@"icon":attachment.name}];
             
         }
         
         
     }];
    
    NSEnumerator *en= [imArray reverseObjectEnumerator];
    
    for(NSDictionary *dict in en)
    {
        
        
        [str insertString:[NSString stringWithFormat:@"%@%@%@",
                           [self leftDelimiter],
                           [dict valueForKey:@"icon" ],
                           [self rightDelimiter]] atIndex:[[dict objectForKey:@"position"] longValue]];
    }
    
    [imArray removeAllObjects];
    return str;
}


-(NSString*)textContentFrom:(NSAttributedString *)selectedString {
    
    
    NSMutableString *str =[[NSMutableString alloc] initWithString:selectedString.string];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:selectedString];
    
    

    
    [textStorage enumerateAttribute:NSAttachmentAttributeName
                            inRange:NSMakeRange(0, textStorage.length)
                            options:0
                         usingBlock:^(id value, NSRange range, BOOL *stop)
     {
         IMTextAttachment* attachment = (IMTextAttachment*)value;
         
         if(attachment.image&&[attachment respondsToSelector:@selector(name)]){
             
             
             [imArray addObject:@{@"position":[NSNumber numberWithLong:range.location],@"icon":attachment.name}];
             
         }
         
         
     }];
    
    NSEnumerator *en= [imArray reverseObjectEnumerator];
    
    for(NSDictionary *dict in en)
    {
        
        
        [str insertString:[NSString stringWithFormat:@"%@%@%@",[self leftDelimiter],
                           [dict valueForKey:@"icon" ],
                           [self rightDelimiter]] atIndex:[[dict objectForKey:@"position"] longValue]];
    }
  
    [imArray removeAllObjects];
    return str;
}





- (void)copy:(id)sender {
    
    
    
        [[UIPasteboard generalPasteboard] setString:[self
                                                     textContentFrom:[self.attributedText
                                                                      attributedSubstringFromRange:self.selectedRange]]];
}


- (void)paste:(id)sender {
    
    if([[UIPasteboard generalPasteboard] string]){
       
    pasteString = [[NSMutableAttributedString alloc] initWithString:[[UIPasteboard generalPasteboard] string]];
    
    [self pasteContent];
    }
    
}


- (NSDictionary *)recursivelyParseImage {
    
    
    NSString *string = pasteString.string;
    
    
    
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:PATTERN_STR
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil];
    NSArray* chunks = [regex matchesInString:string
                                     options:0
                                       range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult *result in chunks) {
        
        NSString *resultStr = [string substringWithRange:[result range]];
        
        if ([resultStr hasPrefix:self.leftDelimiter] && [resultStr hasSuffix:self.rightDelimiter]) {
            
            
                NSString *name = [resultStr substringWithRange:NSMakeRange(1, [resultStr length]-2)];
            
            if(![UIImage imageNamed:name])continue;
                
               return @{@"name":name,@"range":[NSString stringWithFormat:@"{%lu,%lu}",
                                               (unsigned long)result.range.location,
                                               (unsigned long)result.range.length]};

            
        }
    }

    return nil;

}


- (void)pasteContent{
    
    NSDictionary *dict;
    
    do{
        
    dict= [self recursivelyParseImage];
    
    
    IMTextAttachment *att = [[IMTextAttachment alloc] init];
    
    att.image =[UIImage imageNamed:dict[@"name"]];
    att.image = [att.image resizeTo:CGSizeMake(14, 14)];
    att.name = dict[@"name"];
    

    [pasteString replaceCharactersInRange:NSRangeFromString(dict[@"range"])
                     withAttributedString:[NSAttributedString attributedStringWithAttachment:att]];
    
    } while (dict);
    
    NSMutableAttributedString *attributedText =[[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    [attributedText replaceCharactersInRange:self.selectedRange withAttributedString:pasteString];
    
    
    
    
   
    font = [self font];
    
    self.attributedText = attributedText;
    self.font =font;

}




@end


@implementation UIImage(Resizable)


-(id)resizeTo:(CGSize)size {
    
    UIImage *img;
    UIGraphicsBeginImageContext(size);
    
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
    
}
@end
