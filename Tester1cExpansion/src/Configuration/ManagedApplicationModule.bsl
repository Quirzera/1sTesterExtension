//https://tnsoft.ru/blog/naznachenie-rasshireniya-konfiguratsii-pravilnyj-vybor-varianta/

//По умолчанию платформа устанавливает значение Адаптация. 
//Назначение расширения конфигурации должно соответствовать той функциональности, которую реализует расширение конфигурации и назначение 
//определяет порядок применения расширений конфигурации при запуске 1С:Предприятие. Давайте разберем варианты назначения, доступные при создании расширения конфигурации:

//Исправление — этот вариант означает, что расширение вносит исправления в конфигурацию.
//Адаптация — этот вариант означает, что расширение настраивает существующее решение (конфигурацию) с учетом специфики отдельного предприятия.
//Дополнение — расширение вносит новый функционал.
//Выбор назначение влияет на порядок применения расширения конфигурации при запуске 1С:Предприятие — в первую очередь
//применяются расширения с назначением Исправление, после этого Адаптация и самыми последними — Дополнение. 
//Более подробно о взаимодействии нескольких расширений конфигурации с разными значениями назначения можно прочитать 
//в нашей статье — Особенности взаимодействия нескольких расширений конфигурации.

//https://tnsoft.ru/blog/osobennosti-vzaimodejstviya-neskolkih-rasshirenij-konfiguratsii/
//Исходя из сообщений — первым применилось расширение Расширение2 т.к. его назначение мы определили как Исправление. 
//Вторым применилось расширение Расширение1 с назначением Адаптация. При этом при добавлении декораций на форме происходила вставка элементов 
//в порядке применения расширений конфигурации — таким образом декорация расширения Расширение2 оказалась ниже декорации расширения Расширение1.

//Как Вы смогли увидеть, проблем взаимодействия между расширениями, использующих один и тот же объект — нет. Главное верно назначить вариант назначения 
//расширения конфигурации и таким образом можно определять порядок применения расширений конфигурации.