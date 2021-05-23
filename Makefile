SRCS	:= srcs/
DC		:= docker-compose

up:
	$(DC) -f $(SRCS)docker-compose.yml up -d

down:
	$(DC) -f $(SRCS)docker-compose.yml down -v

balus:
	$(DC) -f $(SRCS)docker-compose.yml down --rmi all --volumes --remove-orphans

.PHONY:	up down balus
