/* This file is a hack. It's just a hack to make CMake automatically run if any
   of the libraries in the cmake directory change. It's also here to debug your
   developer setup. If you can't build this hello world program, something is
   horribly wrong. */

#include <iostream>

int main(int argc, char **argv)
{
        std::cout << "Hello, World!" << std::endl;
        return 0;
}
