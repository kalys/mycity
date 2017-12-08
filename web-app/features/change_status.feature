# language: ru

Функционал: Смена статусов у сообщений
    Как администратор или модератор
    Я хочу иметь возможность управлять статусами сообщений

  Предыстория:
  Допустим залогинен администратор с email "admin@admin.ru" и паролем "qweqweqwe"
  @vip
  Сценарий: Фильтрация сообщений по статусу "Done"
    Если он отфильтрует сообщения по статусу "Done"
    То на странице отображены только сообщения с этим статусом

  Сценарий: Отображение всех сообщений
    Если он захочет посмотреть все сообщения
    То на странице отображены все сообщения с любыми статусами
