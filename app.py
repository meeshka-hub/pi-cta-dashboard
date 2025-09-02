import os
from dotenv import load_dotenv
import json

import requests

import constants

def is_northbound(w):
    return w['trDr'] == '1'

def is_southbound(w):
    return w['trDr'] == '5'


def fetch_updates():
    load_dotenv()
    base_url = f'http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key={os.getenv("EL_API_KEY")}&mapid=40530&outputType=JSON'
    try:

        response = requests.get(base_url)

        if response.status_code == 200:
            posts = response.json()
            return posts
        else:
            print("Error:", response.status_code)
            return None

    except requests.exceptions.RequestException as e:
        print("Error:", e)
        return None
    
def parse_response(response): 
    eta_array = response['ctatt']['eta']
    northbound = list(filter(is_northbound, eta_array))
    southbound = list(filter(is_southbound, eta_array))
    return {
        "north": northbound, 
        "south": southbound
    }
    
def main():
    response = fetch_updates()
    grouped_responses = parse_response(response)

    
    






if __name__ == "__main__":
    main()

