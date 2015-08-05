# IMTextView
An iOS textview with customized icons.

# Requirement
iOS 7.0+

# Installation

Add IMTextView.h,IMTextView.m, IMTextAttachment.h,IMTextAttachment.m files to your project.

# Usage

Instead of UITextView, you should use IMTextView. 
For ICON attachment action you should call the below method,

- (void)insertICON:(NSString *)imageName;


The default delimiting characters are  "[" for left and "]" for right. If customization needed, the default 
'PATTERN_STR' should also be changed.

# License
IMTextView is available under the MIT License.
