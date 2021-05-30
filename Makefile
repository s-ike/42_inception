SRCS	:= srcs/
DC_YML	:= docker-compose.yml
DC		:= docker-compose

all:	up

up:
		$(DC) -f $(SRCS)$(DC_YML) up -d

upb:
		$(DC) -f $(SRCS)$(DC_YML) up -d --build

down:
		$(DC) -f $(SRCS)$(DC_YML) down -v

logs:
		$(DC) -f $(SRCS)$(DC_YML) logs -f

ps:
		$(DC) -f $(SRCS)$(DC_YML) ps

clean:	down

fclean:
		$(DC) -f $(SRCS)$(DC_YML) down --rmi all --volumes --remove-orphans

re:		fclean all

.PHONY:	all clean fclean re up upb down logs ps
