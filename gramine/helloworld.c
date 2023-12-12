#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdlib.h>
#include <sgx_arch.h>

#define SGX_QUOTE_MAX_SIZE 2048
#define SGX_REPORT_DATA_SIZE 64

int main(void) {
    uint8_t g_quote[SGX_QUOTE_MAX_SIZE];
    sgx_report_data_t user_report_data = {0};
    memcpy(&user_report_data, "some-dummy-data", sizeof("some-dummy-data"));

    if (access("/dev/attestation/quote", R_OK) != -1) {
        printf("/dev/attestation/quote exists and is readable\n");

        // Write to user report data
        int fd1 = open("/dev/attestation/user_report_data", O_WRONLY);
        if (fd1 < 0) {
            perror("Failed to open user_report_data");
            return 1;
        }
        write(fd1, &user_report_data, SGX_REPORT_DATA_SIZE);
        close(fd1);

        // Read the quote
        int fd2 = open("/dev/attestation/quote", O_RDONLY);
        if (fd2 < 0) {
            perror("Failed to open quote");
            return 1;
        }
        read(fd2, g_quote, SGX_QUOTE_MAX_SIZE);
        close(fd2);

        // Parse and display parts of the quote
        printf("ATTRIBUTES.FLAGS: %02x\n", g_quote[96]);
        printf("ATTRIBUTES.XFRM: ");
        for (int i = 104; i < 112; ++i) printf("%02x", g_quote[i]);
        printf("\n");
        printf("MRENCLAVE: ");
        for (int i = 112; i < 144; ++i) printf("%02x", g_quote[i]);
        printf("\nMRSIGNER: ");
        for (int i = 176; i < 208; ++i) printf("%02x", g_quote[i]);
        printf("\n");
        printf("ISVPRODID: ");
        for (int i = 304; i < 306; ++i) printf("%02x", g_quote[i]);
        printf("\n");
        printf("ISVSVN: ");
        for (int i = 306; i < 308; ++i) printf("%02x", g_quote[i]);
        printf("\n");
        printf("REPORTDATA: ");
        for (int i = 368; i < 400; ++i) printf("%02x", g_quote[i]);
        printf("\n");

        } else {
         printf("/dev/attestation/quote does not exist or is not readable\n");
        }

    return 0;
}
