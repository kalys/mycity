# language: ru

Функционал: Управление сообщениями
		Как администратор или модератор
		Я хочу иметь возможность управлять сообщениями
		Чтобы менять их статус и иметь возможность удалить

	Предыстория:
	Допустим залогинен модератор с email "moder@moder.ru" и паролем "qweqweqwe"	
	
	Сценарий: Изменение статуса сообщения
		Если он перейдет на страницу с сообщениями чтобы изменить статус сообщения c тесктом "Уникальное сообщение" на done
		То статус сообщения сменится на "done"

	Сценарий: Удаление сообщения
		Если он перейдет на страницу с сообщениями и удалит сообщение "Уникальное сообщение"
		То сообщения "Уникальное сообщение" больше не будет в списке сообщений