//
//  IMArtPiece.h
//  InteractiveMuseum
//
//  Created by Ian Perry on 4/1/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMArtPiece : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *collection;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSMutableArray *descriptions;
@property (strong, nonatomic) NSMutableArray *wikipediaDescriptions;
@property (strong, nonatomic) NSString *audioFileName;
@end
