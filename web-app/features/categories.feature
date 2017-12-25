# language: ru

Функционал: Управление категориями
		Как администратор
		Я хочу иметь возможность создавать, обновлять и архивировать категории
		Чтобы выставлять категории

	Предыстория:
		Допустим залогинен администратор с email "admin@admin.ru" и паролем "qweqweqwe"

	Сценарий: Создание категории
		Если он создает категорию с данными:
			| title 			 |
			| Тестовая категория |
		То категория "Тестовая категория" видна в списке категорий

	Сценарий: Проверка валидации на создание категории
		Если он создает категорию с пустыми данными:
			| title |
			|       |
		То его выкинет на страницу категорий

	Сценарий: Обновление категории
		Если он обновляет категорию "Тестовая категория" на:
			| title |
			| asd   |
		То категория "zxcqwe" меняет название на asd

	Сценарий: Удаление(архивация) категории
		Если он удаляет категорию "Тестовая категория"
		То категории больше нет в списке категорий
		И она появляется в списке архивированных категорий

	Сценарий: Восстановление категории из архива
		Если он восстанавливает категорию "Тестовая категория"
		То категория пропадает в списке архивированных и появляется в списке активных категорий

	Сценарий: Проверка валидации на обновление категории
		Если он обновляет категорию "Тестовая категория" c пустыми данными:
			| title |
			|       |
		То его выкинет на страницу категорий где "Тестовая категория" не изменится

	Сценарий: Листинг сообщений в категории
		Если он нажимает на категорию "default"
		То отображены только сообщения этой категории

	Сценарий: Создание категории без названия
		Если модератор попытается создать категорию с пустым названием
		То на экране появится фраза "Пожалуйста, исправьте следующие ошибки:", а под ней "Название" и в самом низу "не может быть пустым"

