//
// load2dump.c ... load eq-format and dump it as C-array
// 2025-3-29  Norihiro Kumagai
//

#include <stdio.h>
#include <ctype.h>

#define MAX_MEM 65536

typedef unsigned int uint_t;
typedef unsigned char uchar_t;

uchar_t mem[MAX_MEM];

int to_hex(void)
{
    int ch = getchar();
    if (ch == EOF)
        return -1;
    if (isdigit(ch))
        return ch - '0';
    if ('A' <= ch && ch <= 'F')
        return ch - 'A' + 10;
    if ('a' <= ch && ch <= 'f')
        return ch - 'a' + 10;
    ungetc(ch, stdin);
    return -2;
}

int read_hex(void)
{
    static int col = 0;
    int ch;
    uint_t data = 0;
    while ((ch = to_hex()) >= 0) {
        data *= 16;
        data += ch;
    }
#if 0
    if (ch == -2)
        fprintf(stderr, "%04x ", data);
        if (col++ >= 16) {
            fprintf(stderr, "\n");
            col = 0;
        }
    else if (ch == -1)
        fprintf(stderr, "EOF\n");
#endif
    return ch == -1 ? EOF : data;
}

int main(int ac, char **av)
{
    int bolflag = 1;
    int boerror_flag = 0;
    int ch, addr, byte;
    int max_addr = 0, min_addr = MAX_MEM - 1;

    for (addr = 0; addr < MAX_MEM; ++addr)
        mem[addr] = 0xff;

    while ((ch = getchar()) != EOF) {
        if (bolflag && ch == '=') {
            // address format
            if ((addr = read_hex()) == EOF)
                break;
            bolflag = 0;
            boerror_flag = 0;   // clear it
            //fprintf(stderr, "addr = %04X\n", addr);
            goto end_of_field;
        } else {
            ungetc(ch, stdin);
        }
        // read a byte
        if ((byte = read_hex()) == EOF)
            break;
        if (0 <= addr && addr < MAX_MEM) {
            //fprintf(stderr, "mem[%04X] = %02X\n", addr, (byte & 0xff));
            mem[addr] = byte & 0xff;
            if (addr > max_addr)
                max_addr = addr;
            if (min_addr > addr)
                min_addr = addr;
            addr++;
            goto end_of_field;
        } else {
            if (boerror_flag == 0) {
                fprintf(stderr, "out of range: addr = %X\n", addr);
                boerror_flag = 1;
            }
            goto end_of_field;
        }
    end_of_field:
        // skip whitespaces
        while ((ch = getchar()) != EOF) {
            if (ch != ' ' && ch != '\r' && ch != '\n') {
                ungetc(ch, stdin);
                break;
            }
            if (ch == '\n') {
                bolflag = 1;
            }
        }
        if (ch == EOF) {
            fprintf(stderr, "end-of-file\n");
            break;
        }
    }
    // load finished, dump mem
    fprintf(stderr, "min: %X, max: %X\n", min_addr, max_addr);
    for (addr = min_addr; addr <= max_addr; ++addr) {
        if (addr == min_addr || (addr & 0x7) == 0)
            printf("%04x", addr);
        printf(" 0x%02x,", mem[addr]);
        if ((addr & 0x7) == 0x7)
            printf("\n");
    }
}