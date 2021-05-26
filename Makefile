SRCS	:= srcs/
DC_YML	:= docker-compose.yml
DC		:= docker-compose

up:
	$(DC) -f $(SRCS)$(DC_YML) up -d

down:
	$(DC) -f $(SRCS)$(DC_YML) down -v

logs:
	$(DC) -f $(SRCS)$(DC_YML) logs -f

balus:
	$(DC) -f $(SRCS)$(DC_YML) down --rmi all --volumes --remove-orphans

.PHONY:	up down logs balus
