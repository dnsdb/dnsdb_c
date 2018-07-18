CURLINCL = `curl-config --cflags` 
JANSINCL = -I/usr/local/include

CURLLIBS = `[ ! -z "$$(curl-config --libs)" ] && curl-config --libs || curl-config --static-libs`
JANSLIBS = -L/usr/local/lib -ljansson

CWARN =-W -Wall -Wextra -Wcast-qual -Wpointer-arith -Wwrite-strings \
	-Wmissing-prototypes  -Wbad-function-cast -Wnested-externs \
	-Wunused -Wshadow -Wmissing-noreturn -Wswitch-enum -Wconversion \
	-Wformat-nonliteral
# try shipping without any warnings
CWARN   +=-Werror

CGPROF =
CDEBUG = -g
CFLAGS += $(CGPROF) $(CDEBUG) $(CWARN)

TOOL = dnsdbq
TOOL_OBJ = $(TOOL).o ns_ttl.o

all: $(TOOL)

install: all
	rm -f /usr/local/bin/$(TOOL)
	mkdir -p /usr/local/bin
	cp $(TOOL) /usr/local/bin/$(TOOL)
	rm -f /usr/local/share/man/man1/$(TOOL).1
	mkdir -p /usr/local/share/man/man1
	cp $(TOOL).man /usr/local/share/man/man1/$(TOOL).1

clean:
	rm -f $(TOOL)
	rm -f $(TOOL_OBJ)

dnsdbq: $(TOOL_OBJ) Makefile
	$(CC) $(CDEBUG) -o $(TOOL) $(CGPROF) $(TOOL_OBJ) $(CURLLIBS) $(JANSLIBS)

.c.o:
	$(CC) $(CFLAGS) $(CURLINCL) $(JANSINCL) -c $<
