SRCS	:= srcs/
DC		:= docker-compose

up:
	$(DC) -f $(SRCS)docker-compose.yml up -d

down:
	$(DC) -f $(SRCS)docker-compose.yml down -v

.PHONY:	up down
