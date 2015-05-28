//
//  DetailViewController.h
//  RestKitTest
//
//  Created by Christopher Winstanley on 28/05/2015.
//  Copyright (c) 2015 Winstanley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

