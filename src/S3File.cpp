// Copyright (c) 2013 Jawbone
// Distributed under the Scribe Software License
//
// See accompanying file LICENSE or visit the Scribe site at:
// http://developers.facebook.com/scribe/
//

#include "S3File.h"

S3File::S3File(const std::string& name) : FileInterface(name, false)
{
    LOG_OPER("[s3] Opened S3File(%s)", name.c_str());
}

// virtual
S3File::~S3File()
{
    LOG_OPER("[s3] Destructor");
}

// virtual
bool S3File::openRead()
{
    LOG_OPER("[s3] openRead()");
}

// virtual
bool S3File::openWrite()
{
    LOG_OPER("[s3] openWrite()");
}

// virtual
bool S3File::openTruncate()
{
    LOG_OPER("[s3] openTruncate()");
}

// virtual
bool S3File::isOpen()
{
    LOG_OPER("[s3] isOpen()");
}


// virtual
void S3File::close()
{
    LOG_OPER("[s3] close()");
}

// virtual
bool S3File::write(const std::string& data)
{
    LOG_OPER("[s3] write('%s')", data.c_str());
    return false;
}

// virtual
void S3File::flush()
{
    LOG_OPER("[s3] flush()");
}

// virtual
long unsigned int S3File::fileSize()
{
    LOG_OPER("[s3] fileSize()");
    return 0;
}

// virtual
long int S3File::readNext(std::string& _return)
{
    LOG_OPER("[s3] readNext()");
    return 0;
}

// virtual
void S3File::deleteFile()
{
    LOG_OPER("[s3] deleteFile()");
}

// virtual
void S3File::listImpl(
    const std::string& path,
    std::vector<std::string>& _return)
{
    std::cout << "KWA TODO: S3File::listImpl(" << path << ")" << std::endl;
}

// virtual
bool S3File::createDirectory(std::string path)
{
    // This isn't necessary on S3, since it's just a key value store.
    return true;
}

// virtual
bool S3File::createSymlink(std::string oldpath, std::string newpath)
{
    std::cout << "KWA TODO: S3File::createSymlink(" << oldpath << ", "
              << newpath << ")" << std::endl;
    return false;
}
