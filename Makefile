SRCS	:= srcs/
DC		:= cd $(SRCS) && docker-compose

all:	setup up

setup:
		echo '127.0.0.1 sikeda.42.fr' | sudo tee -a /etc/hosts

up:
		$(DC) up -d

upb:
		$(DC) up -d --build

down:
		$(DC) down -v

logs:
		$(DC) logs -f

ps:
		$(DC) ps

clean:	down

fclean:
		$(DC) down --rmi all --volumes --remove-orphans

re:		fclean all

.PHONY:	all clean fclean re up upb down logs ps
