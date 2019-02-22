//
//  CustomHeadFile.h
//  DNProject
//
//  Created by zjs on 2019/1/14.
//  Copyright © 2019 zjs. All rights reserved.
//

#ifndef CustomHeadFile_h
#define CustomHeadFile_h

// 自定义 NSLog
#ifdef DEBUG
#define DNLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DNLog(...);
#endif

#define weak(name) __weak typeof(name) weakself = name;


#endif /* CustomHeadFile_h */
