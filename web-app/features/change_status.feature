# language: ru

Функционал: Фильтрация сообщений по статусам
    Как администратор или модератор
    Я хочу иметь возможность просматривать сообщения только с определенным статусом

  Предыстория:
    Допустим залогинен администратор с email "admin@admin.ru" и паролем "qweqweqwe"

  Сценарий: Фильтрация сообщений по статусу "На мадерацию"
    Допутим он находится на главной странице
    Если он перейдет по ссылке "Ожидают модерации" в верхней панели страницы
    То на странице будут отображены только сообщения со статусом "for_moderation"

  Сценарий: Фильтрация сообщений по статусу "Выполненные"
    Допутим он находится на главной странице
    Если он перейдет по ссылке "Выполненные" в верхней панели страницы
    То на странице будут отображены только сообщения со статусом "done"

  Сценарий: Фильтрация сообщений по статусу "Актуальные"
    Допутим он находится на главной странице
    Если он перейдет по ссылке "Актуальные" в верхней панели страницы
    То на странице будут отображены только сообщения со статусом "actual"

  Сценарий: Фильтрация сообщений по статусу "Неактуальные"
    Допутим он находится на главной странице
    Если он перейдет по ссылке "Неактуальные" в верхней панели страницы
    То на странице будут отображены только сообщения со статусом "not_relevant"
