# IMTextView
An iOS textview with customized icons.


<table border="0"><tr><td><img src="screenShots/1.png" align="center" width="320" height="568" ></td><td><img src="screenShots/2.png" align="center" width="320" height="568" ></td></tr><tr><td><img src="screenShots/3.png" align="center" width="320" height="568" ></td><td><img src="screenShots/4.png" align="center" width="320" height="568" ></td></tr></table>

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
