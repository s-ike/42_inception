SRCS		:= srcs/
DC			:= cd $(SRCS) && docker-compose
DB_VOLUME	:= `grep -E "^DB_VOLUME=" ./srcs/.env | sed -e "s/^.*=//"`
WP_VOLUME	:= `grep -E "^WP_VOLUME=" ./srcs/.env | sed -e "s/^.*=//"`
AD_VOLUME	:= `grep -E "^AD_VOLUME=" ./srcs/.env | sed -e "s/^.*=//"`

all:	setup upb

setup:
		./srcs/requirements/tools/setup.sh setup

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
		sudo rm -rf $(WP_VOLUME) ${DB_VOLUME} $(AD_VOLUME)

re:		fclean all

.PHONY:	all clean fclean re up upb down logs ps
