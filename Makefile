
BIN := nginx/objs/nginx
CONF := $(shell pwd)/nginx.conf
WORKDIR := /tmp/nginx_workdir
CFLAGS := 

SOURCES := ngx_http_hash_visitor_module.c

.PHONY: all clean run_local reload restart debug_core

all: $(BIN)

$(BIN): nginx/Makefile $(SOURCES)
	cd nginx && make

nginx/Makefile: 
	cd nginx && ./auto/configure --add-module=.. --with-debug

clean:
	cd nginx && make clean

run_local: $(BIN) $(WORKDIR)
	$(BIN) -c $(CONF) -p $(WORKDIR)

reload: $(BIN)
	$(BIN) -s reload -c $(CONF) -p $(WORKDIR)

restart: $(BIN)
	#$(BIN) -s stop -c $(CONF) -p $(WORKDIR)
	pkill nginx
	sleep 1
	$(MAKE) run_local

debug_core:
	gdb $(BIN) $(WORKDIR)/core
