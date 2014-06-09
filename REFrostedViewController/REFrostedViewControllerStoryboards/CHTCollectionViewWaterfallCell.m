//
//  UICollectionViewWaterfallCell.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "CHTCollectionViewWaterfallCell.h"

@implementation CHTCollectionViewWaterfallCell

#pragma mark - Accessors
- (UILabel *)displayLabel {
	if (!_displayLabel) {
		_displayLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
		_displayLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_displayLabel.backgroundColor = [UIColor lightGrayColor];
		_displayLabel.textColor = [UIColor whiteColor];
		_displayLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _displayLabel;
}

- (UIImageView *)displayImage{
    if(!_displayImage){
        _displayImage = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _displayImage.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _displayImage.backgroundColor = [UIColor clearColor];
        _displayImage.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _displayImage;
}


- (void)setDisplayString:(NSString *)displayString {
	if (![_displayString isEqualToString:displayString]) {
		_displayString = [displayString copy];
		self.displayLabel.text = _displayString;
        IMMeniorManager * data = [[IMMeniorManager alloc] init];
        [data openDatabase];
        NSString * imgRef = [data getObjectFromIndex:[displayString intValue]];
        NSLog(@"SET: %@",imgRef);
        _displayImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",imgRef]];
        [data closeDatabase];
        
	}
}

#pragma mark - Life Cycle
- (void)dealloc {
	[_displayLabel removeFromSuperview];
	_displayLabel = nil;
    
    [_displayImage removeFromSuperview];
    _displayImage = nil;
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		//[self.contentView addSubview:self.displayLabel];
        [self.contentView addSubview:self.displayImage];
	}
	return self;
}

@end
