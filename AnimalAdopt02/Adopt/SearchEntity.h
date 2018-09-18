//
//  UserEntity.h
//  PassValueByDelegate
//
//  Created by 唐韧 on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchEntity : NSObject
{
    NSString *search_type;
    NSString *search_sex;
    NSString *search_hair;
    NSString *search_age;
    NSString *search_size;
    NSString *search_area;
    
    //By Richard 2017.01.11
    NSString *search_name;
    
}

@property(nonatomic,strong) NSString *search_type;
@property(nonatomic,strong) NSString *search_sex;
@property(nonatomic,strong) NSString *search_hair;
@property(nonatomic,strong) NSString *search_age;
@property(nonatomic,strong) NSString *search_size;
@property(nonatomic,strong) NSString *search_area;

//By Richard 2017.01.11
@property(nonatomic,strong) NSString *search_name;

//By Richard 2017.02.14
@property(nonatomic,strong) NSString *search_acceptnum;

@end
