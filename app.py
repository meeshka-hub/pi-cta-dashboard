import os
from dotenv import load_dotenv
from datetime import datetime
import json

import requests

import constants

# --- Functional utility ---

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
    

def calculate_eta(run_info):
    est_arr_time = datetime.fromisoformat(run_info['arrT'])
    pred_gen_time = datetime.fromisoformat(run_info['prdt'])

    return str(est_arr_time - pred_gen_time )

def parse_trains(eta_arr):
    current_trains = []
    for run_info in eta_arr:
        current_trains.append(TrainInfo(run_info))

    return current_trains


# --- Train objects --- 

class TrainInfo:
    def __init__(self, run_info):
        for key in run_info:
            setattr(self, key, run_info[key]) 
        self.eta_in_mins = calculate_eta(run_info)
    

# --- Main ---

def main():
    raw_api_response = fetch_updates()
    # Check for in-payload error codes here
    trains = parse_trains(raw_api_response['ctatt']['eta'])
    

    






if __name__ == "__main__":
    main()

