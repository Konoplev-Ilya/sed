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
        data = None
        while True:
            async with session.get(f'http://198.19.0.6/csp/{region}/json.doc.cls', data = {'oper':'getPersonalData'}) as response:
                mails = json.loads(await response.text())
                if data == None:
                    text_message = f'Инициализация.\nПослупивших: {mails["pcrec"]},\nНа исполнении: {mails["pcexe"]},\nНа согласовании: {mails["pcagree"]},\nНа утверждении: {mails["pcapprove"]}.\nЕсли количество писем возрастет, я сообщу.'
                    async with session.post(f'https://api.telegram.org/bot{telegram_token}/sendMessage', data = {'chat_id' : user_id, 'text': text_message}) as r:
                        pass
                    data = mails
                elif data != mails:
                    text_message = f'Изменения.\nПослупивших: {mails["pcrec"]},\nНа исполнении: {mails["pcexe"]},\nНа согласовании: {mails["pcagree"]},\nНа утверждении: {mails["pcapprove"]}.\n'
                    async with session.post(f'https://api.telegram.org/bot{telegram_token}/sendMessage', data = {'chat_id' : user_id, 'text': text_message}) as r:
                        pass
                    data = mails
                print(login, mails)
                await asyncio.sleep(5)


async def main():
    parser = argparse.ArgumentParser(description='telegram notifications about the arrival of mail to the sed')
    parser.add_argument("-f", required=True, metavar='file name', type=str, help="file with logins, passwords and telegram ID")
    parser.add_argument('-r', required=True, metavar='region', type=str, help='sed base region')
    args = parser.parse_args()

    #create_task
    ioloop = asyncio.get_running_loop()
    # tasks = []
    # wait_tasks = asyncio.wait(ioloop.create_task(bar()))
    

    with open(args.f, "r") as f:
        for line in f.readlines():
            asyncio.create_task(check_and_notify(*line.split(), telegram_token, args.r))
            # asyncio.wait(check_and_notify(*line.split(), telegram_token, args.r))

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.create_task(main())
    loop.run_forever()
