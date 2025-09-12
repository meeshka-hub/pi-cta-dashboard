import os
from dotenv import load_dotenv
from datetime import datetime

import sys
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Property, Signal, Slot, QAbstractListModel, Qt, QModelIndex

import requests

import constants as constants

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
    for run_info in eta_arr:
        run_info['eta_in_mins'] = calculate_eta(run_info)
    return eta_arr


# --- Train objects --- 

# Exposes item level properties 
class TrainInfoModel(QAbstractListModel):
    modelUpdated = Signal()

    _LINE_COLORS = {
        "Brn": "#62361b",
        "Red": "#c60c30",
        "Blue": "#00a1de",
        "G": "#009b3a",
        "Org": "#f9461c",
        "P": "#522398",
        "Pink": "#e27ea6",
        "Y": "#f9e300",
    }
        
    DestNameRole = Qt.UserRole + 1
    EtaRole = Qt.UserRole + 2
    IsAppRole = Qt.UserRole + 3
    RouteNumRole = Qt.UserRole + 4
    ColorCodeRole = Qt.UserRole + 5
    StationNameRole = Qt.UserRole + 6

    def __init__(self, train_runs):
        super().__init__()
        self._data = train_runs

    def rowCount(self, parent=QModelIndex()):
        return len(self._data)
    
    def data(self, index, role):
        if not index.isValid():
            return None
        train = self._data[index.row()]

        if role == self.DestNameRole:
            return train["destNm"]
        if role == self.EtaRole:
            return train["eta_in_mins"]
        if role == self.IsAppRole:
            return train["isApp"]
        if role == self.RouteNumRole:
            return train['rn']
        if role == self.StationNameRole:
            return train['staNm']
        if role == self.ColorCodeRole:
            return self._color_for_line(train['rt'])
        return None
    
    def getAllTrains(self):
        return self._data

    def roleNames(self):
        return {
            self.DestNameRole: b"dest_station_name",
            self.EtaRole: b"eta_in_mins",
            self.IsAppRole: b"is_app",
            self.RouteNumRole: b"rn",
            self.StationNameRole: b"station_name",
            self.ColorCodeRole: b"color_code"
        }
    
    def _color_for_line(self, line: str) -> str:
        return self._LINE_COLORS.get(line, "565a5c")
    
    @Slot("QVariantList")
    def updateTrains(self, new_trains):
        self.beginResetModel()
        self._data = new_trains
        self.endResetModel()
        self.modelUpdated.emit()


# Exposes summary/aggregate info, computed lists, or derived data
class Backend(QObject):
    uniqueColorsChanged = Signal()
    lineChanged = Signal()

    def __init__(self, train_model):
        super().__init__()
        self._line = "Brown Line"
        self._train_model = train_model
        self._unique_colors = self._aggregate_unique_colors()

        # Connect to model updates
        self._train_model.modelUpdated.connect(self.on_model_updated)

    def getLine(self):
        return self._line
    line = Property(str, getLine, notify=lineChanged)

    def aggregate_unique_colors(self):
        seen_colors = set()
        for train in self._train_model.getAllTrains():
            line = train["rt"]
            color = TrainInfoModel._LINE_COLORS.get(line, "565a5c")
            seen_colors.add(color)
        return list(seen_colors)
    
    @Property("QVariantList", notify=uniqueColorsChanged)
    def uniqueTrainColors(self):
        return self._unique_colors
    
    def on_model_updated(self):
        new_colors = self._aggregate_unique_colors()
        if new_colors != self._unique_colors:
            self._unique_colors = new_colors
            self.uniqueColorsChanged.emit()

# --- Main ---

def main():
    raw_api_response = fetch_updates()
    # Check for in-payload error codes here
    trains = parse_trains(raw_api_response['ctatt']['eta'])

    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    model = TrainInfoModel(trains)
    backend = Backend(model)

    engine.rootContext().setContextProperty("trainModel", model)
    engine.rootContext().setContextProperty("backend", backend)


    engine.load("./ui/CTA_TrackerContent/App.qml")
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
    

    




if __name__ == "__main__":
    main()

