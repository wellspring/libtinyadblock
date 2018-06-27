#include <stdio.h>
#include "tinyadblock.h"

#define OK(x)        printf("\x1b[32m [+] Testing %20s ... Passed.\x1b[0m\n", x);
#define FAIL(x)      printf("\x1b[31m [-] Testing %20s ... < FAIL >\x1b[0m\n", x); err++;
#define TEST_IF(e,x) { if(e) { OK(x) } else { FAIL(x) } }

static const char *test_domains_good[] = { "localhost", "www.google.com", "infra.dev" };
static const char *test_domains_bad[]  = { "analytics.google.com", "doubleclick.com", "optimizely.com" };


int main(int argc, char *argv[])
{
    int err = 0;
    int i;

    printf("Testing HOSTS filtering:\n");

    for(i=0; i<sizeof(test_domains_good)/sizeof(void*); i++)
        TEST_IF(host_blocked(test_domains_good[i]) == 0, test_domains_good[i]);

    for(i=0; i<sizeof(test_domains_bad)/sizeof(void*); i++)
        TEST_IF(host_blocked(test_domains_bad[i]) != 0, test_domains_bad[i]);

    return err;
}

