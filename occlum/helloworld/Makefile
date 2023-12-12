CC ?= gcc

LDFLAGS +=	-L/opt/occlum/toolchains/dcap_lib/glibc \
			-locclum_dcap -lssl -lcrypto
CFLAGS += 	-fPIE -pie -I /opt/intel/sgxsdk/include \
			-I /opt/occlum/toolchains/dcap_lib/inc

.PHONY: all clean

all: helloworld

helloworld: helloworld.c
		$(CC) $^ $(CFLAGS) $(LDFLAGS) -o $@

clean:
		rm -rf helloworld
