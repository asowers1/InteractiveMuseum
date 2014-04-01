//
//  IMAudioPlayerView.h
//  InteractiveMuseum
//
//  Created by Ian Perry on 4/1/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMAudioPlayerView : UIView
- (id)initWithFrame:(CGRect)frame audioFile:(NSString *)fileName andImageFile:(NSString *)imageFileName;
@end
