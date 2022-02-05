SRCS		:= srcs/
DC			:= cd $(SRCS) && docker-compose

all:	setup volumes upb

setup:
		./srcs/requirements/tools/setup.sh setup

volumes:
		. ./srcs/.env; \
		sudo mkdir -p $${DB_VOLUME}; \
		sudo mkdir -p $${WP_VOLUME}; \
		sudo mkdir -p $${AD_VOLUME}

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
		./srcs/requirements/tools/setup.sh fclean
		. ./srcs/.env && sudo rm -rf $${DB_VOLUME} $${WP_VOLUME} $${AD_VOLUME}

re:		fclean all

.PHONY:	all clean fclean re up upb down logs ps
