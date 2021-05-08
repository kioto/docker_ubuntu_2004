# Docker+Ubuntu 20.04環境

## 1. 起動

以下のコマンド実行すると、Docker環境が構築され、コンテナが起動する。

```bash
$ docker-compose up -d
```

コンテナリストの表示

```bash
$ docker-compose ps
   Name        Command    State   Ports 
----------------------------------------
ubuntu_2004   /bin/bash   Up      22/tcp
```

## 2. コンテナに接続


```
$ docker exec -it ubuntu_2004 bash
```

## 3. 停止と削除

普通に止めるのはstop。

```bash
$ docker-compose stop
```

再び起動する場合はstart。

```bash
$ docker-compose start
```

停止して削除する場合。`docker rm`までやってくれる。

```bash
$ docker-compose down -v
```

以上
