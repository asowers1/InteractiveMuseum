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
        _displayImage.backgroundColor = [UIColor whiteColor];
        //_displayImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _displayImage;
}


- (void)setDisplayString:(NSString *)displayString {
	if (![_displayString isEqualToString:displayString]) {
		_displayString = [displayString copy];
		self.displayLabel.text = _displayString;
        if([displayString isEqual:@"0"]){
            _displayImage.image = [UIImage imageNamed:@"0.jpg"];
        }else if([displayString isEqual:@"1"]){
            _displayImage.image = [UIImage imageNamed:@"1.jpg"];
        }else if([displayString isEqual:@"2"]){
            _displayImage.image = [UIImage imageNamed:@"2.jpg"];
        }else if([displayString isEqual:@"3"]){
            _displayImage.image = [UIImage imageNamed:@"3.jpg"];
        }else if([displayString isEqual:@"4"]){
            _displayImage.image = [UIImage imageNamed:@"4.jpg"];
        }else if([displayString isEqual:@"5"]){
            _displayImage.image = [UIImage imageNamed:@"5.jpg"];
        }else if([displayString isEqual:@"6"]){
            _displayImage.image = [UIImage imageNamed:@"6.jpg"];
        }else if([displayString isEqual:@"7"]){
            _displayImage.image = [UIImage imageNamed:@"7.jpg"];
        }else if([displayString isEqual:@"8"]){
            _displayImage.image = [UIImage imageNamed:@"8.jpg"];
        }
        
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
