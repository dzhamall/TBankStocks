# TinkoffStock
Test task at Tinkoff fintech

1. Список популярных акций в pickerView.
2. Отдельные запросы по каждой ации
3. График цен акции, за некоторые периоды, предложенными в iexcloud.io/docs/api/
4. Обработка ошибок
5. Алерты если возникают ошибки при работе с сетью
6. Обработка недоступного интернета при входе и каждом запросе
7. Аватарка с анимацией изменения ценыф

## Скриншоты 

![photo_2021-01-31 22 19 10](https://user-images.githubusercontent.com/31774902/106395650-7c273580-6414-11eb-9644-cde20ef18ca8.jpeg)
![photo_2021-01-31 22 19 15](https://user-images.githubusercontent.com/31774902/106395652-7d586280-6414-11eb-9ec4-7a4eb645a531.jpeg)
![photo_2021-01-31 22 19 23](https://user-images.githubusercontent.com/31774902/106395623-4eda8780-6414-11eb-9ff0-d981105248b0.jpeg)

## Примечания 

Старался максимально придерживаться высланного гайда. 
Не использовал сторонних фреймворков, старался пользовать только нативными и обходить костыли.
Сетевой слой пока решает только поставленные задачи, но легко масштабируем. Написал базовые unit test'ы на сетевой слой, немного не успевал покрыть все тестами (хотя очень хотелось). Я немного переживаю, что протухнет токен, если что он вшит в Bundle :)

Минимальная версия - 12
Тестировал на 5s - iOS12, 8 - iOS12 и iOS14 симуляторах. Так же на устройстве c 14 iOS.
Джамалдинов Артемий --- https://github.com/dzhamall

## Feedback & Questions

t.me/dzhamall
