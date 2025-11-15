#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>

uint32_t simple_hash(const char *filename) {
    int fd = open(filename, O_RDONLY);
    if(fd < 0) return 0;
    uint32_t hash = 0;
    char buf[1024];
    ssize_t n;
    while((n = read(fd, buf, sizeof(buf))) > 0) {
        for(ssize_t i=0;i<n;i++) hash += buf[i];
    }
    close(fd);
    return hash;
}

int main(int argc, char *argv[]) {
    if(argc < 2) {
        printf("Usage: %s <file>\n", argv[0]);
        return 1;
    }
    uint32_t h = simple_hash(argv[1]);
    printf("Hash for %s: %u\n", argv[1], h);
    return 0;
}
