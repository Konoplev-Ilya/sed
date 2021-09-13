# -*- coding: utf8 -*-

import argparse

import asyncio
import aiohttp
import json

from config import telegram_token

async def check_and_notify(login, passwd, user_id, telegram_token, region):
    async with aiohttp.ClientSession() as session:
        jar = aiohttp.CookieJar(unsafe=True)
        session = aiohttp.ClientSession(cookie_jar=jar)
        async with session.post(f'http://198.19.0.6/csp/{region}/wui.main.cls', data = {'CacheUserName' : login, 'CachePassword' : passwd}) as response:
            pass
        prev_data = None
        while True:
            async with session.get(f'http://198.19.0.6/csp/{region}/json.doc.cls', data = {'oper':'getPersonalData'}) as response:
                mails = list(map(int, (json.loads(await response.text())).values()))
                if prev_data == None:
                    text_message = f'Инициализация.\nПоступивших: {mails[0]},\nНа исполнении: {mails[1]},\nНа согласовании: {mails[2]},\nНа утверждении: {mails[3]}.\nЕсли количество писем возрастет, я сообщу.'
                    async with session.post(f'https://api.telegram.org/bot{telegram_token}/sendMessage', data = {'chat_id' : user_id, 'text': text_message}) as r:
                        pass
                    prev_data = mails
                elif prev_data != mails:
                    if mails[0] - prev_data[0] > 0:
                        text_message = f'Изменения.\nПоступивших: +{mails[0] - prev_data[0]},\n'
                    if mails[1] - prev_data[1] > 0:
                        text_message += f'Изменения.\nНа исполнении: +{mails[1] - prev_data[1]},\n'
                    if mails[2] - prev_data[2] > 0:
                        text_message += f'Изменения.\nНа согласовании: +{mails[2] - prev_data[2]},\n'
                    if mails[3] - prev_data[3] > 0:
                        text_message += f'Изменения.\nНа утверждении: +{mails[3] - prev_data[3]},\n'

                    #text_message = f'Изменения.\nПоступивших: {mails["0"]},\nНа исполнении: {mails["1"]},\nНа согласовании: {mails["2"]},\nНа утверждении: {mails["3"]}.\n'
                    async with session.post(f'https://api.telegram.org/bot{telegram_token}/sendMessage', data = {'chat_id' : user_id, 'text': text_message}) as r:
                        pass
                    prev_data = mails
                print(login, mails)
                await asyncio.sleep(5)


async def main():
    parser = argparse.ArgumentParser(description='telegram notifications about the arrival of mail to the sed')
    parser.add_argument("-f", required=True, metavar='file name', type=str, help="file with logins, passwords and telegram ID")
    parser.add_argument('-r', required=True, metavar='region', type=str, help='sed base region')
    args = parser.parse_args()

    with open(args.f, "r") as f:
        for line in f.readlines():
            asyncio.create_task(check_and_notify(*line.split(), telegram_token, args.r))

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.create_task(main())
    loop.run_forever()