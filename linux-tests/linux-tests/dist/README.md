## Описание утилиты

Goart (go-atomicredteam) - утилита для изолированного
тестирования техник MITRE ATT&CK на основе Atomic Red Team.

## Описание включенного набора тестов

```
1. Запуск linpeas - утилиты для поиска возможностей повышения привилегий

3. Набор тестов, включающий использование стандартных утилит для доступа к приватным файлам, поиска, сбора информации об окружении и обфускации.
4. Инъекция кода в процесс при помощи переменной окружения LD_PRELOAD
5. Запуск LaZagne - утилиты для дампа учетных записей и ключей доступа, а также копирование приватного ssh ключа. 
6. Попытка использования CVE_2021_4034 для повышения привилегий. 
7. Создание systemd сервисов и cron задач. С учетом выбранных техник закрепления, тест должен выполняться от пользователя root.
8. Обфускация командной строки, очистка файла истории для усложнения криминалистического анализа, обнаружение среды виртуализации для уклона от песочниц. 
9. Кейлоггер на основе PAM правила
11. [Требуется Docker] Запуск tmux сессии и двух контейнеров. В контейнере атакующего разворачивается Metasploit и хендлер реверс шеллов, который при подключении клиента выполняет набор команд. В контейнере жертвы происходит запуск реверс шелла, подключающегося к атакующему. В файле эмуляции можно заменить этот тест на аналогичный, использующий staged reverse shell. 
12. Включены тесты для запуска шелла с командной строкой, полученной из пайпа, а также обфусцированной base64 командной строки. 
13. Демонстрация обнаружения ВПО на основе файловых IOC'в за счет создания файла eicar.

```

## Установка

- Для некоторых atomic тестов могут потребоваться дополнительные
  утилиты или компиляция мини-программ. Скрипт `./install.sh`
  произведет установку необходимых пакетов (поддерживает Ubuntu-based и RHEL-based дистрибутивы),
  а также скопирует `goart` в папку `/usr/bin`.

```bash
sudo ./install.sh
```

## Использование

### Запуск включенных тестов

- Запуск всех тестов из файла эмуляции
  - флаг `-l` указывает на локальную папку с тестами


```
goart -l $PWD/atomics -E ./emulations/1-linpeas.yml
goart -l $PWD/atomics -E ./emulations/3-lolbin.yml
goart -l $PWD/atomics -E ./emulations/4-process-injection.yml
goart -l $PWD/atomics -E ./emulations/5-credential-dumping.yml
goart -l $PWD/atomics -E ./emulations/6-privilege-escalation.yml
goart -l $PWD/atomics -E ./emulations/7-persistence.yml
goart -l $PWD/atomics -E ./emulations/8-evasion.yml
goart -l $PWD/atomics -E ./emulations/9-keylogger.yml
goart -l $PWD/atomics -E ./emulations/10-server_exploits.yml
goart -l $PWD/atomics -E ./emulations/12-pipes.yml
goart -l $PWD/atomics -E ./emulations/13-iocs.yml
```



- Запуск отдельного теста

```bash
goart -t "T1548.001" -n "Set a SetUID flag on file"
```

- Информация о включенных тестах

```bash
# Вывести список доступных команд
goart --help
# Вывести список вшитых тестов 
goart  
```

### Файлы эмуляции

Файлы эмуляции содержат список сгрупированных по MITRE техникам тестов, а также названия сигнатур, покрывающих каждую из них.
Находятся в папке emulations. 

```yaml
atomics:
  - attack_technique: T1548.001
    atomic_tests:
      - name: Set a SetUID flag on file
        auto_generated_guid: 759055b3-3885-4582-a8ec-c00c9d64dd79
        signatures: t1548_001_abuse_elevation_control_mechanism_setuid_and_setgid_chmod
      - name: Set a SetGID flag on file
        auto_generated_guid: db55f666-7cba-46c6-9fe6-205a05c3242c
        signatures: t1548_001_abuse_elevation_control_mechanism_setuid_and_setgid_chmod
```

### Тестирование сигнатур

После запуска тестов из файла эмуляции необходимо
1. Зайти в веб интерфейс в раздел `Расследования -> События с хостов`
2. Найти событие, соответствующее сработке сигнатуры в папке alerts вручную или при помощи фильтра `Marks.Marks.Name: "<signature_name>"`, например `Marks.Marks.Name: "sigma_generic_cred_search"`
