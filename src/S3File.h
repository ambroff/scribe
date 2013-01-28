// Copyright (c) 2013 Jawbone
// Distributed under the Scribe Software License
//
// See accompanying file LICENSE or visit the Scribe site at:
// http://developers.facebook.com/scribe/
//
#ifndef SCRIBE_S3FILE_H
#define SCRIBE_S3FILE_H

#include "file.h"

class S3File : public FileInterface {
public:
    S3File(const std::string& name);
    virtual ~S3File();

    virtual bool openRead();
    virtual bool openWrite();
    virtual bool openTruncate();
    virtual bool isOpen();
    virtual void close();
    virtual bool write(const std::string& data);
    virtual void flush();
    virtual long unsigned int fileSize();
    virtual long int readNext(std::string&);
    virtual void deleteFile();
    virtual void listImpl(
        const std::string& path,
        std::vector<std::string>& _return);
    virtual bool createDirectory(std::string path);
    virtual bool createSymlink(std::string oldpath, std::string newpath);

private:
  // disallow copy, assignment, and empty construction
  S3File();
  S3File(S3File& rhs);
  S3File& operator=(S3File& rhs);
};

#endif // SCRIBE_S3FILE_H
